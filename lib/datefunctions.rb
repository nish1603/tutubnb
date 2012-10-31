class Date
	def calculate_days_weeks_months(end_date)
    days = end_date.day - self.day
    months = end_date.month - self.month
    years = end_date.year - self.year

    months = self.adjust_months(end_date, months, years)
    months, weeks, days = self.adjust_weeks_and_days(end_date, months, weeks, days)
    return months, weeks, days
  end

  def adjust_months(end_date, months, years)
    if(end_date.month < (self.month))
      years -= 1
      months = (12 - self.month) + end_date.month
    end
    months += years * 12
    return months
  end

  def adjust_weeks_and_days(end_date, months, weeks, days)
    if(end_date.day < (self.day-1))
      months -= 1 
      days = self.end_of_month.day - self.day
      days += end_date.day
    end

    weeks = (days + 1) / 7
    days = (days + 1) % 7
    return months, weeks, days
  end

  def calculate_weekdays_weekends(days)
    weekdays = 0
    weekends = 0

    (self...(self+days)).to_a.each do |date|
      if(date.sunday? or date.saturday?)
        weekends += 1
      else
        weekdays += 1
      end
    end
    return weekdays, weekends
  end
end