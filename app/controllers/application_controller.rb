class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper #sessionコントローラーでヘルパーが使用できる。
  include AttendancesHelper #attendancesコントローラーでヘルパーが使用できる。
  $days_of_the_week = %w{日 月 火 水 木 金 土}
  
  def admin_or_correct_user
    @user = User.find(params[:id])
      unless current_user?(@user) || current_user.admin?
        redirect_to(root_url)
      end  
  end
  
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user) #current_user?(@user):sessions_ヘルパーメソッド
  end
  
  # ログイン済みユーザーか確認
  def logged_in_user
    unless logged_in?
    store_location #sessions_ヘルパー, URLとページの記憶
    flash[:danger] = "ログインしてください。"
    redirect_to login_url
    end
  end
  
  # 管理者かどうか確認
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
