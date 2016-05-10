class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :mobile_number

  has_one :limo_company,  serializer: LimoCompanySerializer
end