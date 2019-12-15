class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
           
  before_save { self.email = email.downcase }

  validates :name, presence: true, length: { maximum: 50 }
  validates :height, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },  format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }

  has_many :records

  # ========================================================フォローしているユーザー視点
  # 中間テーブルと関係. 外部キーはfollowing_id
  has_many :active_relationships, class_name: "Relationship",
                                  foreign_key: :following_id, dependent: :destroy
  # followerテーブルとの関係. ただしacitve_relationshipsテーブルのfollowerカラムを介して
  has_many :followings, through: :active_relationships, source: :follower
  # =====================================================================================

  # ======================================================フォローされているユーザー視点
  # 中間テーブルと関係. 外部キーはfollower_id
  has_many :passive_relationships, class_name: "Relationship",
                                  foreign_key: :follower_id, dependent: :destroy
  # followerテーブルとの関係. ただしacitve_relationshipsテーブルのfollowerカラムを介して
  has_many :followers, through: :passive_relationships, source: :following
  # ====================================================================================

  mount_uploader :image, ImageUploader


  def follow(other_user)
    active_relationships.create(follower_id: other_user.id)
  end

  def unfollow(other_user)
    active_relationships.find_by(follower_id: other_user.id).destroy
  end

  # current_userがフォローしていたらtrue
  def following?(other_user)
    followings.include?(other_user)
  end

  # 過去30日の最小体重を返す
  def min_weight
    self.records.where('created_at >= ?', 30.days.ago).
         pluck('weight').
         min.
         round(Constants::NUM_OF_DECIMAL_IN_WEIGHT)
  end

  # 過去30日の最高体重を返す
  def max_weight
    self.records.
         where('created_at >= ?', 30.days.ago).
         pluck('weight').
         max.
         round(Constants::NUM_OF_DECIMAL_IN_WEIGHT)
  end

  # 最後に記録した体重を返す
  def lastest_weight
    self.records.
         order(created_at: :DESC).
         first.
         weight.
         round(Constants::NUM_OF_DECIMAL_IN_WEIGHT)
  end

  def weight_change_rate
    last_datas = self.records.where(created_at: Date.today.last_month.all_month)
    last_avg = last_datas.pluck('weight').sum / last_datas.count
    ((( self.lastest_weight - last_avg ) / last_avg )*100).
      round(Constants::NUM_OF_DECIMAL_IN_CHANGE_RATE)
  rescue ZeroDivisionError
    0
  end

  def bmi
    if self.records.present?
      # 身長 cm -> m
      height_m = self.height / 100
      (self.lastest_weight / (height_m * height_m) ).
        round(Constants::NUM_OF_DECIMAL_IN_HEIGHT)
    else
      "-"
    end
  end
end