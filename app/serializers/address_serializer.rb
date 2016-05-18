class AddressSerializer < ActiveModel::Serializer
  attributes :street, :city, :zipcode, :state, :country

  def state
    if object.country_code.present? && object.state_code.present?
      {
        code: object.state_code ,
        name: CS.states(object.country_code.upcase.to_sym)[object.state_code.upcase.to_sym]
      }
    end
  end

  def country
    if object.country_code.present?
      {
        code: object.country_code ,
        name: CS.countries[object.country_code.upcase.to_sym]
      }
    end
  end

end