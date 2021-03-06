class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new #guest uset
    if user.admin?
        can :manage, Exam
        can :manage, Answer
        can :manage, Question
        can :manage, Attempt
        can :manage, User
    elsif user.teacher?
        can :manage, Exam
        can :manage, Answer
        can :manage, Question
        can :manage , Attempt
    elsif user.student?
        can :read, Question
        can :create, Answer
        can :read, Answer
        can :create, Attempt
        can :read, Attempt
        can :read, Exam
    end
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
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
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
