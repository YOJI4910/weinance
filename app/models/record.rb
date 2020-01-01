class Record < ApplicationRecord
  belongs_to :user

  def display_weight
    "#{self.weight.round(Constants::NUM_OF_DECIMAL_IN_WEIGHT)} kg"
  end

  def display_bmi
    h = self.user.height
    if h
      # 身長 cm -> m
      h_m = h / 100
      (self.weight / (h_m * h_m)).
        round(Constants::NUM_OF_DECIMAL_IN_HEIGHT)
    else
      "―"
    end
  end
end
