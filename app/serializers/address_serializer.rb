class AddressSerializer < ActiveModel::Serializer
  attributes :street, :city, :zipcode, :state, :country

  def state
    CS.states(object.country_code.upcase.to_sym)[object.state_code.upcase.to_sym]
  end

  def country
    CS.countries[object.country_code.upcase.to_sym]
  end

end