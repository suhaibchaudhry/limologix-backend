class API < Grape::API

  require 'grape-swagger'
  require 'custom_formatter'
  require 'custom_error_formatter'
  include Grape::Kaminari

  format :json
  formatter :json, CustomFormatter
  error_formatter :json, CustomErrorFormatter


  mount V1::Base

  add_swagger_documentation
end