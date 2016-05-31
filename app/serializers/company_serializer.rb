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
      helpers = ActionController::Base.helpers
      {
        name: 'Limo_logix.png',
        image: helpers.image_path('Limo_logix.png')
      }
    end
  end
end