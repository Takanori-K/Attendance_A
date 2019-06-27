class User < ApplicationRecord
  
  has_many :attendances, dependent: :destroy #dependent: :destroy:ユーザー削除でAttendanceモデルのデータも削除
  attr_accessor :remember_token # 「remember_token」という仮想の属性を作成する
  before_save { self.email = email.downcase } #downcase:小文字に変換, self:現在のユーザー
  validates :name,  presence: true, length: { maximum: 50 } #maximum:最大文字数
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false } # :unqueオプション, 一意性の検証, case_sensitive: 大文字と小文字の区別
  validates :department, length: { in: 3..50 }, allow_blank: true #allow_blank: nil以外に""も対応                  
  validates :basic_time, presence: true
  validates :work_time, presence: true 
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true #minimum:最小文字数, allow_nil:パスワード更新と未入力の場合は検証スルーして更新

  # 渡された文字列のハッシュ値を返します。
  def User.digest(string)
    cost = 
      if ActiveModel::SecurePassword.min_cost
        BCrypt::Engine::MIN_COST
      else
        BCrypt::Engine.cost
      end
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返します。
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # 永続セッションのためハッシュ化したトークンをデータベースに記憶します。
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # トークンがダイジェストと一致すればtrueを返します。
  def authenticated?(remember_token)
    # ダイジェストが存在しない場合はfalseを返して終了します。
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # ユーザーのログイン情報を破棄します。
  def forget
    update_attribute(:remember_digest, nil)
  end
  
  #検索フォームメソッド
  def self.search(search) #ここでのself.はUser.を意味する
    if search
      where(['name LIKE ?', "%#{search}%"]) #検索とnameの部分一致を表示。User.は省略
    else
      all #全て表示。User.は省略
    end
  end
end
