class DriverSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :mobile_number, :email, :company, :license_number, :license_expiry_date,
  :license_image, :insurance_image, :badge_number, :badge_expiry_date, :ara_image, :ara_expiry_date, :insurance_company,
  :insurance_policy_number, :insurance_expiry_date, :channel, :toll_credit, :status

  has_one :address

  def license_image
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

  def insurance_image
    {
      name: object.insurance_image_url.split("/").last,
      image: object.insurance_image_url
    }
  end
end