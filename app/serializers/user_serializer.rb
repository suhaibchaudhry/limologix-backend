class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :mobile_number

  has_one :company,  serializer: CompanySerializer
end