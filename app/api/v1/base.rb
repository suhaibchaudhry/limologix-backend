module V1
  class Base < API
    version 'v1'

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

    mount Users::Root
    mount Drivers::Root
    mount ClearDispatch
    mount MasterDataEndpoint
  end
end