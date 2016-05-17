class CompanySerializer < ActiveModel::Serializer
  attributes :id, :name, :logo, :email, :primary_phone_number, :secondary_phone_number, :fax, :address
  has_one :address

  def logo
    if object.logo.present?
      {
        name: object.logo_url.split("/").last,
        image: object.logo_url
      }
    else
      {
        name: 'Limo_logix.png',
        image: '/assets/Limo_logix.png'
      }
    end
  end
end