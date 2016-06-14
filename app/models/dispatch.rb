class Dispatch < ActiveRecord::Base
  belongs_to :driver
  belongs_to :trip
end
