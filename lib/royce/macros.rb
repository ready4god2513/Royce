module Royce
  module Macros

    extend ActiveSupport::Concern

    module ClassMethods
      # How a class opts in to roller
      # Pass an array of roles
      def royce_roles(roles)
        confirm_roles_exist roles

        # Work in singleton class
        # Add a read-only class variable to all classes that call `royce_roles`
        class << self
          attr_reader :available_role_names
        end
        @available_role_names = roleis

        include Royce::ClassMethods
        include Royce::Methods
      end


      private

      # Pre-create Role objects when file is loaded
      def confirm_roles_exist(role_names)
        # Wait until the actual tables exist
        return unless ActiveRecord::Base.connection.table_exists? 'royce_role'
        role_names.each do |name|
          Role.find_or_create_by(name: name)
        end
      end

    end
  end


  # Every ActiveRecord::Base now includes Royce::Macros
  # This gives them access to the royce_roles method
  ActiveRecord::Base.send :include, Royce::Macros

end
