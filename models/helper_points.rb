class HelperPoint
  include MongoMapper::Document
  key :user_id, ObjectId
  key :log_time, Time
  key :point, Integer
  key :message, String

  belongs_to :user, :class_name => "User"
  before_create :generate_time

  def initialize(point, message, log_time = generate_time())
    self.point = point
    self.message = message
    self.log_time = log_time
  end
  
  class << self

    def point_type_exists? point_name
    @points.has_key? point_name
  end

  @points ={
    "signup" => 50,
    "answer_push_message" => 5,
    "answer_push_message_technical_error" => 10,
    "finish_helping_request" => 30,
    "finish_10_helping_request_in_a_week" => 30,
    "finish_5_high_fives_in_a_week" => 30,
    "share_on_twitter" => 10,
    "share_on_facebook" => 10,
    "watch_video" => 10,
  }
    def method_missing(meth, *args, &block)
      method_as_string = meth.to_s
      if @points.has_key? method_as_string
        return HelperPoint.new(@points[method_as_string], @method_as_string)
      else
        super # You *must* call super if you don't handle the
        # method, otherwise you'll mess up Ruby's method lookup.
      end
    end

    def respond_to?(meth, include_private = false)
      method_as_string = meth.to_s
      @points.has_key? method_as_string || super(meth, include_private)
    end
  end

  def to_json()
    return { "point" => self.point, "log_time" => self.log_time.utc.iso8601 }.to_json
  end

  private

  def generate_time()
    self.log_time = Time.now
  end
end
