class User < ApplicationRecord
  
  before_save { self.email = email.downcase } #downcase:小文字に変換, self:現在のユーザー
  validates :name,  presence: true, length: { maximum: 50 } #maximum:最大文字数
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false } # :unqueオプション, 一意性の検証, case_sensitive: 大文字と小文字の区別
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 } #minimum:最小文字数
end
