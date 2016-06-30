class User < ActiveRecord::Base
  include Authentication

  belongs_to :role
  belongs_to :company
  belongs_to :admin, class_name: :User
  has_many :managers, class_name: :User, foreign_key: :admin_id
  has_many :trips
  has_many :customers

  def full_name
    [first_name, last_name].join(' ').strip
  end
end
