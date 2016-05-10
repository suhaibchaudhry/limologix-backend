class Role < ActiveRecord::Base
  has_many  :users
  scope :admin, -> { find_by(name: 'admin') }
  scope :manager, -> { find_by(name: 'manager') }
end
