class UsersController < ApplicationController
  
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy] #ログイン済み
  before_action :correct_user,   only: [:edit, :update] #正しいユーザーのみ
  before_action :admin_user,     only: [:destroy, :edit_basic_info, :update_basic_info] #管理者のみ
  
  def index
    @users = User.paginate(page: params[:page]) #paginate: ページネーション
  end
  
  def show
    @user = User.find(params[:id])
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
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to @user
    else
      render 'edit'
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
    if @user.update_attributes(basic_info_params)
      flash[:success] = "基本情報を更新しました。"
      redirect_to @user   
    else
      render 'edit_basic_info'
    end
  end
    
    
  private
    
    def user_params
      params.require(:user).permit(:name, :email, :department, :password, :password_confirmation)
    end
    
    def basic_info_params
      params.require(:user).permit(:basic_time, :work_time)
    end
    
    #beforeアクション
    
    # ログイン済みユーザーか確認
    def logged_in_user
      unless logged_in?
      store_location #sessions_ヘルパー, URLとページの記憶
      flash[:danger] = "ログインしてください。"
      redirect_to login_url
      end
    end
    
    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user) #current_user?(@user):sessions_ヘルパーメソッド
    end
    
    # 管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
