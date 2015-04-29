class Blind < User
  many  :request, foreign_key: :request_id, class_name: "Request"
  key :role, String

  before_create :set_role

  def set_role()
    self.role = "blind"
  end

end
