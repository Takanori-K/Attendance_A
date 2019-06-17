class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper #sessionコントローラーでヘルパーが使用できる。
  include AttendancesHelper #attendancesコントローラーでヘルパーが使用できる。
end
