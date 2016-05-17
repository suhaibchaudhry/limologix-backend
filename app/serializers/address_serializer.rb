class AddressSerializer < ActiveModel::Serializer
  attributes :street, :city, :zipcode, :state, :country

  def state
    CS.states(object.country_code.upcase.to_sym)[object.state_code.upcase.to_sym] if object.country_code.present? && object.state_code.present?
  end

  def country
    CS.countries[object.country_code.upcase.to_sym] if object.country_code.present?
  end

end