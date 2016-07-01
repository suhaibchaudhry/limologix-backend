class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new # guest user (not logged in)
    if user.super_admin?
       can [:index], V1::Users::DriversEndpoint
    end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
# class Ability
#   include CanCan::Ability

#   def initialize(employee)
#     restricted_models = [ GlobalSetting, Benefit, Employee, Competency, TechnicalCompetency,
#                           BehavioralCompetency, Level, Requisite
#                         ]
#     employee ||= Employee.new

#     alias_action :index, :show, :edit, :create, :update, to: :cru

#     if employee.employee?
#       cannot :manage, restricted_models
#       can [:cru, :check_certificate_name, :update_status, :destroy_proof, :confirm_submission, :submit_for_approval, :update_rating], EmployeeRequisite
#       can [:show, :edit_profile_info, :update_profile_info, :destroy_profile_info], Employee
#     end

#     if employee.rm?
#       cannot :manage, restricted_models
#       can [:cru, :update_status, :rm_submit_approval, :rm_confirm_submission], EmployeeRequisite
#       can [:show, :edit_profile_info, :update_profile_info, :destroy_profile_info], Employee
#     end

#     if employee.administrator?
#       can :manage, :all
#     end
#   end
# end
