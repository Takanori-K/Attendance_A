class AttendancesController < ApplicationController
  
  before_action :admin_or_correct_user, only:[ :edit, :update]
  
  def create
    @user = User.find(params[:user_id])
    @attendance = @user.attendances.find_by(worked_on: Date.today)
    if @attendance.started_at.nil?
      @attendance.update_attributes(started_at: current_time)
      flash[:info] = 'おはようございます。'
    elsif @attendance.started_at.present?
      @attendance.update_attributes(finished_at: current_time)
      flash[:info] = 'おつかれさまでした'
    else
      flash[:danger] = 'トラブルがあり、登録出来ませんでした。'
    end
    redirect_to @user
  end
  
  def edit
    @user = User.find(params[:id])
    @first_day = first_day(params[:date]) #ヘルパー
    @last_day = @first_day.end_of_month
    @dates = user_attendances_month_date #ヘルパー
  end
  
  def update
    @user = User.find(params[:id])
    if attendances_invalid?
      attendances_params.each do |id, item|
        attendance = Attendance.find(id)
        attendance.update_attributes(item)
      end
      flash[:success] = '勤怠情報を更新しました。'
      redirect_to user_path(@user, params:{first_day: params[:date]})
    else
      flash[:danger] = "不正な時間入力がありました、再入力してください。"
      redirect_to edit_attendances_path(@user, params[:date])
    end
  end
  
  def edit_overtime
    @user = User.find(params[:id])
    @day = Date.parse(params[:day])
    @youbi = $days_of_the_week[@day.wday]
  end
  
  def update_overtime
  end
  
  private
  
    def attendances_params
      params.permit(attendances: [:started_at, :finished_at, :note])[:attendances]
    end
end
