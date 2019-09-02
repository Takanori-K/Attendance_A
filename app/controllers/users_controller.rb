class UsersController < ApplicationController
  
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :edit_basic_info, :update_basic_info] #ログイン済み
  #before_action :correct_user,   only: [:edit, :update] #正しいユーザーのみ
  before_action :admin_user,     only: [:index, :destroy, :edit_basic_info, :update_basic_info, :import, :employees_on_duty] #管理者のみ
  before_action :admin_or_correct_user, only:[:show, :edit, :update]
  
  def index
    @users = User.paginate(page: params[:page]).search(params[:search]) #paginate: ページネーション, search: 検索
    @user = User.new
  end
  
  def import
    if params[:file].blank?
      flash[:danger] = "CSVファイルを選択して下さい。"
      redirect_to users_url
    else
      User.import(params[:file])
      flash[:success] = "CSVファイルをインポートしました。"
      redirect_to users_url
    end
  end
  
  def show
    @user = User.find(params[:id])
    @first_day = first_day(params[:first_day]) #ヘルパー
    @last_day = @first_day.end_of_month
    (@first_day..@last_day).each do |day|
      unless @user.attendances.any? {|attendance| attendance.worked_on == day}
        record = @user.attendances.build(worked_on: day) #buildメソッド:あるモデルに関連づいたモデルのデータを生成する
        record.save
      end
    end
    @dates = user_attendances_month_date
    @worked_sum = @dates.where.not(started_at: nil).count #where.not:nil以外を取得, count:条件に合った要素の数だけを取得
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params) #private: user_params
    
    if @user.save
      log_in @user #sessions_helper
      redirect_to @user
      flash[:success] = "ユーザーの新規作成に成功しました。"  
    else
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    @users = User.all
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to @user
    else
      render action: :index
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "削除しました。"
    redirect_to users_url
  end
  
  def edit_basic_info
    @user = User.find(params[:id])
  end
  
  def update_basic_info
    @user = User.find(params[:id])
    @users = User.all
    @users.each do |user|
      if user.update_attributes(basic_info_params)
        flash[:success] = "基本情報を更新しました。"
        redirect_to @user and return
      end
    end
    render 'edit_basic_info'
  end
  
  def employees_on_duty
  @users = {}
    User.all.each do |user|
      if user.attendances.any?{|day|
                          ( day.worked_on == Date.today &&
                            !day.started_at.blank? &&
                            day.finished_at.blank? )}
    @users.merge!(user.name => user.employee_number)
      end
    end
  end
    
    
  private
    
    def user_params
      params.require(:user).permit(:name, :email, :affiliation, :password, :password_confirmation, :employee_number, :uid,
                                   :basic_work_time, :designated_work_start_time, :designated_work_end_time)
    end
    
    def basic_info_params
      params.require(:user).permit(:basic_time, :work_time)
    end
    
    #beforeアクション
    
    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user) #current_user?(@user):sessions_ヘルパーメソッド
    end
    
end
