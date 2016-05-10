module CustomErrorFormatter
  def self.call message, backtrace, options, env
    if message.is_a?(Hash)
      { status: 'error', message: message[:message], data: message[:data]}.to_json
    else
      { status: 'error', message: message}.to_json
    end
  end
end

module CustomFormatter
  def self.call object, env
    ({status: 'success'}.merge(object)).to_json
  end
end

class Base < Grape::API
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
  end

  mount V1::Root

  add_swagger_documentation
end