class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.super_admin?
       can [:index, :status_update], V1::Users::DriversEndpoint
       can [:index], V1::Users::CompaniesEndpoint
       cannot [:update], V1::Users::CompaniesEndpoint
       # can :manage, :all
    end

    if user.admin?
        can [:update], V1::Users::CompaniesEndpoint
    end
  end
end
