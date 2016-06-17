require 'grape-swagger'
require 'custom_formatter'
require 'custom_error_formatter'

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

    def decode_base64_image(filename, base64)
          in_content_type, encoding, string = base64.split(/[:;,]/)[1..3]
          # filename = filename.split(".")[0]

          tempfile = Tempfile.new(filename)
          tempfile.binmode
          tempfile.write Base64.decode64(string)

          # for security we want the actual content type, not just what was passed in
          content_type = `file --mime -b #{tempfile.path}`.split(";")[0]

          # we will also add the extension ourselves based on the above
          # if it's not gif/jpeg/png, it will fail the validation in the upload model
          # extension = content_type.match(/gif|jpeg|png|jpg/).to_s
          # filename += ".#{extension}" if extension

          ActionDispatch::Http::UploadedFile.new({
            tempfile: tempfile,
            content_type: content_type,
            filename: filename
          })
        end



  end

  mount V1::Root

  add_swagger_documentation
end