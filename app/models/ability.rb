class Ability
  include CanCan::Ability

  def initialize(user)
    can :create, User

    return unless user.present?
    can [:vote, :read], Micropost
    can [:create, :destroy], Micropost, user: user
    can :home, Micropost, ["user_id IN (SELECT followed_id FROM relationships
    WHERE  follower_id = ?) OR user_id = ?", user.id, user.id]

    can :read, User
    can [:update, :following, :followers], User, id: user.id

    can [:vote, :read, :create, :edit], Comment
    can :update, Comment, user: user
    can :destroy, Comment, user: user
    can :destroy, Comment, micropost: { user: user }
    return unless user.has_role? :admin
    can :manage, User
  end
end
