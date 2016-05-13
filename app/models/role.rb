class Role < ActiveRecord::Base
  scope :admin, -> { find_by(name: 'admin') }
  scope :manager, -> { find_by(name: 'manager') }

  has_many  :users
end
