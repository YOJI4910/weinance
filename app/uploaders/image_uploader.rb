class ImageUploader < CarrierWave::Uploader::Base
  # minimagic使用のため
  include CarrierWave::MiniMagick

  # show-page用リサイズ
  version :thumb do
    process resize_to_fit: [150, 150]
  end

  # navibar用リサイズ
  version :thumb40 do
    process resize_to_fit: [40, 40]
  end

  # table用リサイズ
  version :thumb25 do
    process resize_to_fit: [25, 25]
  end

  # Choose what kind of storage to use for this uploader:
  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
end
