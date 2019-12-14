class AttendancesController < ApplicationController
  
  before_action :admin_or_correct_user, only:[:edit, :update]
  before_action :logged_in_user, only:[:edit_overtime_work, :update_overtime_work]
  
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
    @attendance = @user.attendances.find_by(worked_on: @day)
    @youbi = params[:youbi]
    @superiors = User.where.not(id: current_user.id).where(superior: true)
  end
  
  def update_overtime
    @user = User.find(params[:attendance][:user_id])
    @attendance = @user.attendances.find(params[:attendance][:id])
    # binding.pry
    if params[:attendance][:scheduled_end_time].blank? || params[:attendance][:instructor_sign].blank?
      flash[:danger] = "必須箇所が空欄です。"
      redirect_to @user
    else
      @attendance.update_attributes(overtime_params)
      flash[:success] = "残業申請が完了しました。"
      redirect_to @user and return
    end
  end
  
  def edit_overtime_info
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    @users = User.all
  end
  
  def update_overtime_info
    @user = User.find(params[:user_id])
    ActiveRecord::Base.transaction do
      overtimes_params.each do |id, item|
        attendance = Attendance.find(id)
        attendance.update_attributes!(item)
      end
    end
      flash[:success] = "残業申請の変更を送信しました。"
      redirect_to user_url(current_user)
  rescue ActiveRecord::RecordInvalid
      flash[:danger] = "変更にチェックを入れてください。"
      redirect_to user_url(current_user)
  end
  
  private
  
    def attendances_params
      params.permit(attendances: [:started_at, :finished_at, :note])[:attendances]
    end
    
    def overtime_params
      params.require(:attendance).permit(:scheduled_end_time, :next_day, :business_description, :instructor_sign, :overtime_status, :overtime_change)
    end
    
    def overtimes_params
      params.require(:user).permit(attendances: [:overtime_status, :overtime_change])[:attendances]
    end
end
