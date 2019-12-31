class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    general_access
  end

  def show?
    general_access
  end

  def create?
    general_access
  end

  def new?
    create?
  end

  def update?
    general_access
  end

  def edit?
    update?
  end

  def destroy?
    general_access
  end

  private

  def general_access
    false
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end
  end
end
