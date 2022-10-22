module Auth
  module User
    module BasicAuth
      module_function

      def authenticate!(login, password)
        valid_credentials = Credentials[ENV['USER_LOGIN'], ENV['USER_PASSWORD']]
        incoming_credentials = Credentials::Generate.(login, password)

        valid_credentials == incoming_credentials
      end
    end
  end
end
