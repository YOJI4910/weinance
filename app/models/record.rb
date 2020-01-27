class Record < ApplicationRecord
  belongs_to :user

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
end
