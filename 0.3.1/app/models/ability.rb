class Ability
  include CanCan::Ability

  # 특별한 일없이 새로만 든 함수에서 초기화면으로 리다이렉트 되면 어빌리티 없어서임. 
  def initialize(user)
    if user.role == 'Administrator'
      can :manage, :all
    elsif user.role == 'Chiefeditor'
      #노 논문을 읽을 수만 있다.
      can [:all_papers, :show, :new, :create, :update, :make_comment, :change_status, :result],  :all
      #자신의 논문만 접근 할 수 있게함. 
      can :manage, Paper do |paper|
        paper.try(:user) == user
      end  
    elsif user.role == 'Reviewer'
      #can :manage, :all
      can [:show, :new, :create, :update, :make_comment],  :all
      #자신의 논문만 접근 할 수 있게함. 
      can :manage, Paper do |paper|
        paper.try(:user) == user
      end 
    else
      #논 논문 작성은 누구나 가능하게. 
      can [:new, :create], :all
      #자신의 논문만 접근 할 수 있게함. 
      can :manage, Paper do |paper|
        paper.try(:user) == user
      end
    end
    #end
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.Administrator?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
