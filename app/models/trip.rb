class Trip < ActiveRecord::Base
  validates :start_destination, :end_destination, :pick_up_at, presence: true

end
