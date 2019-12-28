class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[facebook twitter google_oauth2]

  has_many :records

  # ========================================================フォローしているユーザー視点
  # 中間テーブルと関係. 外部キーはfollowing_id
  has_many(
    :active_relationships,
    class_name: "Relationship",
    foreign_key: :following_id,
    dependent: :destroy
  )
  # followerテーブルとの関係. ただしacitve_relationshipsテーブルのfollowerカラムを介して
  has_many :followings, through: :active_relationships, source: :follower
  # =====================================================================================
  # ======================================================フォローされているユーザー視点
  # 中間テーブルと関係. 外部キーはfollower_id
  has_many(
    :passive_relationships,
    class_name: "Relationship",
    foreign_key: :follower_id,
    dependent: :destroy
  )
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

  def display_height
    if self.height.blank?
      "―"
    else
      "#{self.height} cm" 
    end
  end

  # 過去30日の最高体重を返す
  def display_max
    if self.has_record?
      "#{ self.records.
            where('created_at >= ?', 30.days.ago).
            pluck('weight').
            max.
            round(Constants::NUM_OF_DECIMAL_IN_WEIGHT) } kg"
    else
      "―"
    end
  end

  # 過去30日の最小体重を返す
  def display_min
    if self.has_record?
      "#{ self.records.where('created_at >= ?', 30.days.ago).
            pluck('weight').
            min.
            round(Constants::NUM_OF_DECIMAL_IN_WEIGHT) } kg"
    else
      "―"
    end
  end

  # 最後に記録した体重を返す
  def latest_weight
    if self.has_record?
      self.records.
          order(created_at: :DESC).
          first.
          weight.
          round(Constants::NUM_OF_DECIMAL_IN_WEIGHT)
    end
  end

  def display_latest
    if latest_weight.present?
      "#{latest_weight} kg"
    else
      "―"
    end
  end

  def weight_change_rate
    last_datas = self.records.where(created_at: Date.today.last_month.all_month)
    last_avg = last_datas.pluck('weight').sum / last_datas.count
    ((( self.latest_weight - last_avg ) / last_avg )*100).
      round(Constants::NUM_OF_DECIMAL_IN_CHANGE_RATE)
  rescue ZeroDivisionError
    0
  end

  def display_change
    if self.weight_change_rate >= 0
      "+#{self.weight_change_rate}%"
    else
      "#{self.weight_change_rate}%"
    end
  end

  # change_rateの値でcssのclass名を返す
  def change_class
    if self.weight_change_rate >= 0
      "pluscolor"
    else
      "minuscolor"
    end
  end

  def bmi
    if self.records.present? && self.height.present?
      # 身長 cm -> m
      height_m = self.height / 100
      (self.latest_weight / (height_m * height_m) ).
        round(Constants::NUM_OF_DECIMAL_IN_HEIGHT)
    else
      "―"
    end
  end

  def has_record?
    !!self.records.first
  end

  # omniauthのコールバック時に呼ばれるメソッド
  def self.find_for_oauth(auth)
    user = User.where(uid: auth.uid, provider: auth.provider).first
    unless user
      user = User.create(
        name: auth.info.name,
        email: User.dumy_email(auth),
        uid: auth.uid,
        provider: auth.provider,
        password: Devise.friendly_token[0, 20]
      )
    end
    user
  end

  private
  def self.dumy_email(auth)
    "#{auth.uid}-#{auth.provider}@example.com"
  end
end