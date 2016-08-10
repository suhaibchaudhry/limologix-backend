class TripGroup < ActiveRecord::Base
  belongs_to :trip
  belongs_to :group
end
