class API < Grape::API

  require 'grape-swagger'
  require 'custom_formatter'
  require 'custom_error_formatter'
  include Grape::Kaminari

  format :json
  formatter :json, CustomFormatter
  error_formatter :json, CustomErrorFormatter

  rescue_from CanCan::AccessDenied do |e|
    error!('Access denied.', 403)
  end


  mount V1::Base

  add_swagger_documentation
end