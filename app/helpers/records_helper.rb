module RecordsHelper
  def get_ordered_records(user_ids)
    user_hash = Record.where(user_id: user_ids).group(:user_id).maximum(:created_at)
    Record.includes(:user, :comments).where(user_id: user_hash.keys, created_at: user_hash.values).order(created_at: "DESC")
  end
end
