class WebNotificationSerializer < ActiveModel::Serializer
  attributes :id, :message

  def message
    JSON.parse(object.message)
  end
end
