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
end
