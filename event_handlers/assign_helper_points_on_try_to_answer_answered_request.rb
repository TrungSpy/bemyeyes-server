class AssignHelperPointsOnTryAnswerAnsweredRequest < EventHandlerBase
  def answer_request(payload)
    @payload = payload

    point = HelperPoint.answer_push_message
    helper.helper_points.push point
    helper.save
  end
end
