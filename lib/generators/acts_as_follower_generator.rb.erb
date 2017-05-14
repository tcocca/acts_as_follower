require 'rails/generators'
require 'rails/generators/migration'

class ActsAsFollowerGenerator < Rails::Generators::Base
  
  include Rails::Generators::Migration
  
  def self.source_root
    @source_root ||= File.join(File.dirname(__FILE__), 'templates')
  end
  
  # Implement the required interface for Rails::Generators::Migration.
  # taken from https://github.com/rails/rails/blob/master/activerecord/lib/rails/generators/active_record.rb
  def self.next_migration_number(dirname)
    if ActiveRecord::Base.timestamped_migrations
      Time.now.utc.strftime("%Y%m%d%H%M%S")
    else
     "%.3d" % (current_migration_number(dirname) + 1)
    end
  end
  
  def create_migration_file
    migration_template 'migration.rb', 'db/migrate/acts_as_follower_migration.rb', migration_version: migration_version
  end
  
  def create_model
    template "model.rb", File.join('app/models', "follow.rb")
  end
  
  def migration_version
     if rails5?
        "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]"
     end
  end
  
  def rails5?
     Rails.version.start_with? '5'
  end
  
end
