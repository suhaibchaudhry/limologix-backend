class Role < ActiveRecord::Base
  ROLES = ['super_admin', 'admin', 'manager']

  ROLES.each do |role|
    scope role.to_sym, -> { find_by(name: role) }
  end

  has_many  :users
end
