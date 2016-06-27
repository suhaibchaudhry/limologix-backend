class TripNotification < ActiveRecord::Base
  KINDS = ['request', 'cancel']
  scope :request, -> { where(kind: 'request') }
  scope :cancel, -> { where(kind: 'cancel') }

  belongs_to :driver
  belongs_to :trip


  # def send
  #   puts "<<<notification has been send"
  # end
end
