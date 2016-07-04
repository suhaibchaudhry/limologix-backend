class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.super_admin?
       can [:index, :status_update], V1::Users::DriversEndpoint
    end
  end
end
