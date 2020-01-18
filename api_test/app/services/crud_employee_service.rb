class CrudEmployeeService
  class << self 

    def create(params)
      if ['password', 'password_confirmation'].none? { |key| params.key? key }
        params['password'] = Devise.friendly_token.first(8) 
      end
      User.employee.create(params)
    end

  end
end