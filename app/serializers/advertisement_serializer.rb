class AdvertisementSerializer < ActiveModel::Serializer
  attributes :id, :poster
  def poster
    {
      name: object.poster_url.split("/").last,
      image: object.poster_url
    }
  end
end
