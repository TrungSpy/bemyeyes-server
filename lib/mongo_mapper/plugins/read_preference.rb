# http://stackoverflow.com/questions/17774584/temporarily-switch-mongomapper-to-read-from-slave-replicas
module MongoMapper
  module Plugins
    module ReadPreference
      extend ActiveSupport::Concern

      included do
        class << self
          attr_accessor :read_preference
        end
      end

      module ClassMethods
        def query(options={})
          options.merge!(:read => read_preference) if read_preference
          super options
        end

        def with_read_preference(preference)
          self.read_preference = preference
          begin
            yield
          ensure
            self.read_preference = nil
          end
        end
      end
    end
  end
end

