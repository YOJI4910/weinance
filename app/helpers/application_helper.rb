module ApplicationHelper
  # 過去1ヶ月のレコードをハッシュで返す
  def record_last30(records)
    records.
      where('created_at >= ?', 1.month.ago).
      reorder(:created_at).
      # 同日複数レコードをくくる（ハッシュ） "10/04" => [some Records]
      group_by { |p| p.created_at.strftime('%m/%d') }.
      # レコードから体重を抽出  "10/04" => 体重の平均値
      to_h { |k, v| [k, v.map(&:weight).sum / v.count] }
  end
end
