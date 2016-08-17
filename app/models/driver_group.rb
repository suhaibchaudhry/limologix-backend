class DriverGroup < ActiveRecord::Base
  belongs_to :driver
  belongs_to :group
end
