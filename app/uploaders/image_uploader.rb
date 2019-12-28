class ImageUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick

  # minimagic使用のため
  include CarrierWave::MiniMagick
  
  # show-page用リサイズ
  version :thumb do
    process resize_to_fit: [150,150]
  end
  # navibar用リサイズ
  version :thumb40 do
    process resize_to_fit: [40,40]
  end
  # table用リサイズ
  version :thumb25 do
    process resize_to_fit: [25,25]
  end

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

end
