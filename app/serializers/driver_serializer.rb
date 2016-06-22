class DriverSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :mobile_number, :email, :license_number, :license_expiry_date,
  :license_image, :badge_number, :badge_expiry_date, :ara_image, :ara_expiry_date, :insurance_company,
  :insurance_policy_number, :insurance_expiry_date

  has_one :address

  def license_number
    {
      name: object.license_image_url.split("/").last,
      image: object.license_image_url
    }
  end

  def ara_image
    {
      name: object.ara_image_url.split("/").last,
      image: object.ara_image_url
    }
  end
end