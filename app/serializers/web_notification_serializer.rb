class WebNotificationSerializer < ActiveModel::Serializer
  attributes :id, :message, :created_at, :kind, :notifiable_id, :notifiable_type

  def message
    JSON.parse(object.message)
  end
end
