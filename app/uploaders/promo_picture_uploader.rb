# encoding: utf-8

class PromoPictureUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :small do
    process resize_to_fit: [128, 72]
  end

  version :medium do
    process resize_to_fit: [200, 113]
  end

  version :large do
    process resize_to_fit: [400, 225]
  end

  version :extra_large do
    process resize_to_fit: [720, 405]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  protected
  def secure_token
    var = :"@#{mounted_as}_secure_token"

    model.instance_variable_get(var) or model.instance_variable_set(var,
    Digest::SHA2.hexdigest("#{SecureRandom.uuid}Nower#{Time.now}"))
  end

end
