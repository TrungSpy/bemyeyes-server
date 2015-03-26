require_relative '../helpers/requests_helper'
require_relative '../helpers/i_find_helpers_for_request'
require_relative '../helpers/requests_helper_factory'

class App < Sinatra::Base
  register Sinatra::Namespace

  # Begin requests namespace
  namespace '/requests' do
    # Create new request
    post '/?' do

      if current_user.blocked
        halt 200, {'Content-Type' => 'application/json'}, {status:"blocked"}.to_json
      end

      begin
        session = OpenTokSDK.create_session media_mode: :relayed
        session_id = session.session_id
        token = OpenTokSDK.generate_token session_id
      rescue Exception => e
        give_error(500, ERROR_REQUEST_SESSION_NOT_CREATED, "The session could not be created. #{e}")
      end

      # Store request in database
      request = Request.create
      request.short_id_salt = settings.config["short_id_salt"]
      request.session_id = session_id
      request.token = token
      request.blind = current_user
      request.answered = false
      request.save!

      i_find_helpers_for_requests.start request

      TheLogger.log.info "request started #{request}"
      EventBus.announce(:request_created, request_id: request.id)
      return request.to_json
    end

    # Get a request
    get '/:short_id' do
      TheLogger.log.info("get request, shortId:  " + params[:short_id] )
      return request_from_short_id(params[:short_id]).to_json
    end

    # Answer a request
    put '/:short_id/answer' do
      unless current_user
        TheLogger.log.error "Trying to answer request, but no user"
        # TODO: right now telling the user that the request is stopped is the best we can do.
        give_error(400, ERROR_REQUEST_STOPPED, "The request has been stopped.").to_json
      end

      request = request_from_short_id(params[:short_id])

      if request.answered?
        EventBus.announce(:try_answer_request_but_already_answered, request_id: request.id, helper:current_helper)
        give_error(400, ERROR_REQUEST_ALREADY_ANSWERED, "The request has already been answered.").to_json
      elsif request.stopped?
        EventBus.announce(:try_answer_request_but_already_stopped, request_id: request.id, helper:current_helper)
        give_error(400, ERROR_REQUEST_STOPPED, "The request has been stopped.").to_json
      else
        request.answered = true
        request.helper = current_helper
        request.save!
        EventBus.announce(:request_answered, request_id: request.id, helper:current_helper)

        return request.to_json
      end
    end

    # A helper can cancel his own answer. This should only be done if the session has not already started.
    put '/:short_id/answer/cancel' do
      request = request_from_short_id(params[:short_id])

      if request.helper.nil?
        give_error(400, ERROR_USER_NOT_FOUND, "No helper attached to request - it cant be cancelled").to_json
      end
      if request.stopped?
        give_error(400, ERROR_REQUEST_STOPPED, "The request has been stopped.").to_json
      elsif request.helper._id != current_user._id
        give_error(400, ERROR_NOT_PERMITTED, "This action is not permitted for the user.").to_json
      end

      EventBus.announce(:request_cancelled, request_id: request.id, helper_id: current_user.id)

      return request.to_json
    end

    # The blind or a helper can disconnect from a started session thereby stopping the session.
    put '/:short_id/disconnect' do
      request = request_from_short_id(params[:short_id])

      if request.stopped?
        give_error(400, ERROR_REQUEST_STOPPED, "The request has been stopped.").to_json
      elsif request.blind._id != current_user._id && request.helper._id != current_user._id
        give_error(400, ERROR_NOT_PERMITTED, "This action is not permitted for the user.").to_json
      end

      EventBus.announce(:request_stopped, request_id: request.id)

      return request.to_json
    end

    # Rate a request
    put '/:short_id/rate' do
      begin
        rating = body_params["rating"]
      rescue Exception => e
        give_error(400, ERROR_INVALID_BODY, "The body is not valid. #{e}").to_json
      end

      request = request_from_short_id(params[:short_id])

      if request.answered?
        if current_user.role == "blind"
          request.blind_rating = rating
          request.save!
        elsif current_user.role == "helper"
          request.helper_rating = rating
          request.save!
        end
      else
        give_error(400, ERROR_REQUEST_NOT_ANSWERED, "The request has not been answered and can therefore not be rated.").to_json
      end
    end
  end # End namespace /request

  def i_find_helpers_for_requests
    requests_helper ||= RequestsHelperFactory.create settings
    BME::IFindHelpersForRequest.new requests_helper
  end

  # Find a request from a short ID
  def request_from_short_id(short_id)
    request = Request.with_read_preference(:primary) {Request.first(short_id: short_id)}
    if request.nil?
      give_error(400, ERROR_REQUEST_NOT_FOUND, "Request not found.").to_json
    end

    return request
  end
end
