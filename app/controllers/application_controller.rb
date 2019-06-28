class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper #sessionコントローラーでヘルパーが使用できる。
  include AttendancesHelper #attendancesコントローラーでヘルパーが使用できる。
  $days_of_the_week = %w{日 月 火 水 木 金 土}
  
end
