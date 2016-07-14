module CustomFormatter
  def self.call object, env
    ({status: 'success'}.merge(object)).to_json
  end
end