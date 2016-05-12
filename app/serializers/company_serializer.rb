class CompanySerializer < ActiveModel::Serializer
  attributes :id, :name, :logo, :email, :primary_phone_number, :secondary_phone_number, :fax, :address
  has_one :address

  def logo
    object.logo_url
  end
end