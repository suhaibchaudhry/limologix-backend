class CustomerSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :mobile_number, :full_name, :organisation

  def full_name
    object.full_name
  end
end