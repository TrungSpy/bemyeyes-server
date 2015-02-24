class ThreeStrikesAndYouAreOut
  def abuse_report_filed(payload)
    request = payload[:request]
    reporter = payload[:reporter]

    if reporter == "blind"
      check(request.helper)
    else
      check(request.blind)
    end
  end

  def check user
    if user.nil?
      return
    end
    no_of_abuses = user.abuse_reports.count
    if no_of_abuses == 1
      user.blocked = true
      user.save!
    end
  end
end
