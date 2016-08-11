class WebNotificationSerializer < ActiveModel::Serializer
  attributes :id, :message, :created_at

  def message
    JSON.parse(object.message)
  end
end
