class ReturnMessageService
  class << self
    def successful_logout
      response = {}
      response[:success] = "logout successful"
      response
    end

    def unsuccessful_logout
      response = {}
      response[:error] = "logout was unsuccessful"
      response
    end

    def auth_token_from(key)
      return false unless key

      response = {}
      response[:auth_token] = key.access_token.to_s
      response
    end
  end
end
