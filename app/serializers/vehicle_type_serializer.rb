class VehicleTypeSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :capacity, :image

  def image
    if object.image.present?
      object.image_url
    end
  end
end
