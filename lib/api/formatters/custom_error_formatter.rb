module CustomErrorFormatter
  def self.call message, backtrace, options, env
    if message.is_a?(Hash)
      { status: 'error', message: message[:message], data: message[:data]}.to_json
    else
      message = message.gsub(/\[|_|\.|^\, /, ' ')
      message = message.gsub(']', '')
      { status: 'error', message: message}.to_json
    end
  end
end