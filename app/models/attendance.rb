class Attendance < ApplicationRecord
  belongs_to :user
  
  validates :worked_on, presence: true
  validate :finished_at_is_invalid_without_a_started_at
  validate :finished_at_is_earlier_than_started_at
  
  #退社時間を保存するには出勤時間が存在しなければならない  
  def finished_at_is_invalid_without_a_started_at
    errors.add(:started_at, "が必要です") if started_at.blank? && finished_at.present?
  end
  
  #退社時間より出勤時間が早い場合
  def finished_at_is_earlier_than_started_at
    if started_at.present? && finished_at.present?
      errors.add(:started_at, "より早い退勤時間は無効です") if started_at > finished_at
    end
  end
end
