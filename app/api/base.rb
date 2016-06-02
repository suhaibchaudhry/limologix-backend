class Base < Grape::API
  require 'custom_formatter'
  require 'custom_error_formatter'

  include Grape::Kaminari
  format :json
  formatter :json, CustomFormatter
  error_formatter :json, CustomErrorFormatter

  helpers do
    def serialize_model_object(resource)
      serializer  = Grape::Formatter::ActiveModelSerializers.fetch_serializer(resource,env)
      return resource unless serializer.present?

      if(serializer.is_a?(ActiveModel::ArraySerializer))
        serializer.serializable_array
      else
        serializer.serializable_hash
      end
    end

    def error_formatter(resource)
      message = ""
      model_name = resource.class.name
      resource.errors.messages.each do |attribute, arr|
        arr.each do |error|
          message = message + "#{model_name} #{attribute.to_s} #{error}, "
        end
      end
      message.gsub(/, $/, "")
    end
  end

  mount V1::Root

  add_swagger_documentation
end