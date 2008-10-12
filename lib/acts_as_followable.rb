module ActiveRecord
  module Acts
    module Followable
      
      def self.included(base)
        base.extend ClassMethods
      end
      
      module ClassMethods
        def acts_as_followable
          has_many :follows, :as => :followable, :dependent => :nullify
          include ActiveRecord::Acts::Followable::InstanceMethods
          extend  ActiveRecord::Acts::Followable::SingletonMethods
        end
      end
      
      # This module contains class methods
      module SingletonMethods
        
      end
      
      # This module contains instance methods
      module InstanceMethods
        
        def followers_count
          self.follows.size
        end
        
        def followers
          self.follows.collect{ |f| f.follower }
        end
        
        def followed_by?(follwer)
          rtn = false
          self.follows.each do |f|
            rtn = true if follower.id == f.follower.id && follower.class.name == f.follwer_type 
          end
          rtn
        end
        
      end
      
    end
  end
end
