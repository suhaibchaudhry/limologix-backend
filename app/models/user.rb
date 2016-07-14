class User < ActiveRecord::Base
  include Authentication

  belongs_to :role
  belongs_to :company
  belongs_to :admin, class_name: :User
  has_many :managers,-> { where(role_id: Role.manager.id) }, class_name: :User, foreign_key: :admin_id
  has_many :trips
  has_many :customers


  Role.all.each do |role|
    define_method("#{role.name}?") do
      self.role == role
    end
  end

  def full_name
    [first_name, last_name].join(' ').strip
  end
end
