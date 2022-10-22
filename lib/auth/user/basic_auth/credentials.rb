module Auth
  module User
    module BasicAuth
      class Credentials
        protected attr_reader :digest
        private_class_method  :new

        Generate = ->(login, password) do
          Credentials[login, password]
        end
        
        def self.[](login, password)
          new(login, password)
        end

        def initialize(login, password)
          @login = login
          @password = password
        end

        attr_reader :login, :password
        protected :login, :password

        def ==(other)
          return false unless other.is_a? self.class
          return false unless other.login == self.login
          return false unless other.password == self.password

          true
        end
      end

      private_constant :Credentials
    end
  end
end
