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
    attendances = true #不正な値はない状態でのスタート
    attendances_params.each do |id, item|
      #制御構造と呼ばれる式
      if item[:started_at].blank? && item[:finished_at].blank? #どちらも空欄
        next #次の繰り返し処理が続行される
      elsif item[:started_at].blank? || item[:finished_at].blank? #どちらか空欄
        attendances = false
        break #繰り返し処理を終了
      elsif item[:started_at] > item[:finished_at] #出勤時間が退勤時間より大きい場合
        attendances = false
        break
      end
    end
    return attendances
  end
end
