class UserSerializer < ActiveModel::Serializer
  attributes :first_name, :last_name, :email, :mobile_number, :username
end