class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i(facebook twitter google_oauth2)

  has_many :records, dependent: :destroy

  # 通知モデルの関連付け
  has_many(
    :active_notifications,
    class_name: 'Notification',
    foreign_key: 'visitor_id',
    dependent: :destroy
  )

  has_many(
    :passive_notifications,
    class_name: 'Notification',
    foreign_key: 'visited_id',
    dependent: :destroy
  )

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

  validates :name, presence: true, length: { maximum: 30 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :email, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }

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

  def avatar_url
    url = image.url || "/assets/no_user.png"
    url
  end

  def display_height
    if height.blank?
      "―"
    else
      "#{height} cm"
    end
  end

  # 過去30日の最高体重を返す
  def display_max
    if has_record_in30?
      "#{ records.
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
    if has_record_in30?
      "#{ records.where('created_at >= ?', 30.days.ago).
            pluck('weight').
            min.
            round(Constants::NUM_OF_DECIMAL_IN_WEIGHT) } kg"
    else
      "―"
    end
  end

  # 最後に記録した体重を返す
  def latest_weight
    if has_record?
      records.
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
    last_datas = records.where(created_at: Date.today.last_month.all_month)
    last_avg = last_datas.pluck('weight').sum / last_datas.count
    (((latest_weight - last_avg) / last_avg) * 100).
      round(Constants::NUM_OF_DECIMAL_IN_CHANGE_RATE)
  rescue ZeroDivisionError, NoMethodError
    0
  end

  def display_change
    if weight_change_rate >= 0
      "+#{weight_change_rate}%"
    else
      "#{weight_change_rate}%"
    end
  end

  # change_rateの値でcssのclass名を返す
  def change_class
    if weight_change_rate >= 0
      "pluscolor"
    else
      "minuscolor"
    end
  end

  def bmi
    if records.present? && height.present?
      # 身長 cm -> m
      height_m = height / 100
      (latest_weight / (height_m**2)).
        round(Constants::NUM_OF_DECIMAL_IN_HEIGHT)
    else
      "―"
    end
  end

  def has_record?
    !!records.first
  end

  def has_record_in30?
    !!records.where('created_at >= ?', 30.days.ago).first
  end

  # ゲストユーザーであればtrue
  def guest?
    self == User.find_by(email: 'guest@example.com')
  end

  # omniauthのコールバック時に呼ばれるメソッド
  def self.find_for_oauth(auth)
    user = User.find_or_initialize_by(uid: auth.uid, provider: auth.provider)
    if user.new_record?
      user.update_attributes!(
        name: auth.info.name,
        email: User.dumy_email(auth),
        password: Devise.friendly_token[0, 20]
      )
    end
    user
  end

  def self.dumy_email(auth)
    "#{auth.uid}-#{auth.provider}@example.com"
  end

  # フォロー時の通知メソッド(アクセプターはfollowされるuser)
  def create_notification_follow!(current_user)
    # すでに同じ通知がないか確認（連打対策）
    temp = Notification.where([
      "visitor_id = ? and visited_id = ? and action = ? ",
      current_user.id,
      self.id,
      'follow',
    ])

    if temp.blank?
      notification = current_user.active_notifications.new(
        visited_id: self.id,
        action: 'follow'
      )
      notification.save if notification.valid?
    end
  end
end
