# Give an error
def give_error(status_code, code, message)
  TheLogger.log.error(message)
  halt(status_code, {"Content-Type" => "application/json"}, create_error_hash(code, message).to_json)
end

# Create error
def create_error_hash(code, message)
  return { "error" => {
             "code" => code,
             "message" => message
           } }
end
