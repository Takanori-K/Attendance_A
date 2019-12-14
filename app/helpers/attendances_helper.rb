module AttendancesHelper
  
  def current_time
    Time.new(
      Time.now.year,
      Time.now.month,
      Time.now.day,
      Time.now.hour,
      Time.now.min, 0
      )
  end
  
  def working_times(started_at, finished_at)
    format("%.2f", (((finished_at - started_at) / 60) / 60.0)) #計算結果は秒数で返ってくるから秒数を２度６０で割る
  end
  
  def working_times_tomorrow(start, finish)
    format("%.2f", (((finish - start) / 60) / 60.0) + 24 )
  end
  
  def overwork_times(scheduled, designated)
    format("%.2f", format_basic_time(scheduled).to_i - format_basic_time(designated).to_i)
  end
  
  def overwork_time(scheduled, designated)
    format("%.2f", (((scheduled - designated) / 60) / 60.0))
  end
  
  def overwork_time_tomorrow(scheduled, designated)
    format("%.2f", (((scheduled - designated) / 60) / 60.0) + 24 )
  end
    
  def overwork_times_tomorrow(scheduled, designated)
    format("%.2f", (format_basic_time(scheduled).to_i - format_basic_time(designated).to_i) + 24.0 )
  end
  
  def working_times_sum(seconds)
    format("%.2f", seconds / 60 / 60.0)
  end
  
  def first_day(date) #月の初日
    !date.nil? ? Date.parse(date) : Date.current.beginning_of_month
  end
  
  def user_attendances_month_date
    @user.attendances.where('worked_on >= ? and worked_on <= ?', @first_day, @last_day).order('worked_on')
  end
  
  def attendances_invalid?
    attendances = true
    attendances_params.each do |id, item|
      if item[:started_at].blank? && item[:finished_at].blank?
        next
      elsif item[:started_at].blank? || item[:finished_at].blank?
        attendances = false
        break
      elsif item[:started_at] > item[:finished_at]
        attendances = false
        break
      end
    end
    return attendances
  end
end
