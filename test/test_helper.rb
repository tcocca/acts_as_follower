require 'rubygems'
require 'logger'
require 'active_record'
require 'active_record/base'

require File.dirname(__FILE__) + '/../init.rb'
require File.dirname(__FILE__) + '/models/band'
require File.dirname(__FILE__) + '/models/user'
require File.dirname(__FILE__) + '/../lib/generators/templates/model.rb'

require 'test/unit'
require 'active_support'
require 'shoulda'
require 'factory_girl'
Factory.find_definitions

ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + '/debug.log')
ActiveRecord::Base.configurations = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
ActiveRecord::Base.establish_connection(ENV['DB'] || 'mysql')

load(File.dirname(__FILE__) + '/schema.rb')
