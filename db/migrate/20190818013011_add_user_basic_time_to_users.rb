class AddUserBasicTimeToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :basic_work_time, :datetime, default: Time.zone.parse("2019/02/20 07:30")
    add_column :users, :designated_work_start_time, :datetime, default: Time.zone.parse("2019/02/20 07:30")
    add_column :users, :designated_work_end_time, :datetime, default: Time.zone.parse("2019/02/20 07:30")
  end
end
