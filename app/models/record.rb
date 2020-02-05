class Record < ApplicationRecord
  belongs_to :user
  has_many :notifications, dependent: :destroy
  has_many :comments

  def display_weight
    "#{weight.round(Constants::NUM_OF_DECIMAL_IN_WEIGHT)} kg"
  end

  def display_bmi
    height = user.height
    if height
      # 身長 cm -> m
      height_m = height / 100
      (weight / (height_m**2)).round(Constants::NUM_OF_DECIMAL_IN_HEIGHT)
    else
      "―"
    end
  end

    # コメント通知メソッド
    def create_notification_comment!(current_user, comment_id)
      # 投稿者に対して通知を送る
      notification = current_user.active_notifications.new(
        record_id: self.id, # 実際は必要ないが一応保存
        comment_id: comment_id,
        visited_id: self.user_id,
        action: 'comment'
      )
      # 自分の投稿に対するコメントの場合は、通知済みとする
      if notification.visitor_id == notification.visited_id
        notification.checked = true # 破壊的変更（多分）
      end
      notification.save if notification.valid?
    end
end
