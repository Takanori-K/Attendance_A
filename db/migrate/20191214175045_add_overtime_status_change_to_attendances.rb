class AddOvertimeStatusChangeToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :overtime_status, :integer, default: 0
    add_column :attendances, :overtime_change, :string
  end
end
