class LimoCompanySerializer < ActiveModel::Serializer
  attributes :id, :name, :logo_url, :email, :primary_phone_number, :secondary_phone_number, :fax
end
