module ActiveModel
  class Errors
    def full_messages
      messages_arr = self.map{|attribute, message| "#{@base.class.name} #{attribute} #{message}"}
      message = messages_arr.join(', ')
      message = message.gsub(/_/, ' ')
    end
  end
end