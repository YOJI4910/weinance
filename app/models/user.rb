class User < ApplicationRecord
  has_secure_password

  validates :name, :height, presence: true
  validates :email, presence: true, uniqueness: true

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
end