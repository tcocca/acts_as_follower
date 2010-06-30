class ActsAsFollowerGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.directory "app/models"
      m.template "model.rb", "app/models/follow.rb"

      m.migration_template 'migration.rb', 'db/migrate'
    end
  end

  def file_name
    "acts_as_follower_migration"
  end
end
