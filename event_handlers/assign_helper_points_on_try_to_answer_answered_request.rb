class AssignHelperPointsOnTryAnswerAnsweredRequest
  def answer_request(payload)
    helper = payload[:helper]

    helper.reload
    point = HelperPoint.answer_push_message
    helper.helper_points.push point
    helper.save
  end
end
