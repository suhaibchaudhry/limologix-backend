class Vehicle < ActiveRecord::Base
  belongs_to :vehicle_type
  belongs_to :limo_company
end
