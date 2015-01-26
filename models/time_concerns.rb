module ModelAddOns
  module TimeConcerns
    def time_to_seconds_since_midnight time, utc_offset
      #the utc offset should actually be subtracted - look at a map if in doubt
      hour_in_utc = time.hour - utc_offset
      hour_in_utc * 3600 + time.min * 60
    end
  end
end

