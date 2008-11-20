require 'test/unit'
require 'rubygems'

begin
  require File.dirname(__FILE__) + '/../../../../config/boot'
  require 'active_record'
rescue LoadError
  require 'rubygems'
  require_gem 'activerecord'
end

require 'active_record/fixtures'

require File.dirname(__FILE__) + '/../init.rb'

ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + '/debug.log')
ActiveRecord::Base.configurations = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
ActiveRecord::Base.establish_connection(ENV['DB'] || 'mysql')

load(File.dirname(__FILE__) + '/schema.rb')

Test::Unit::TestCase.fixture_path = File.dirname(__FILE__) + '/fixtures/'
$LOAD_PATH.unshift(Test::Unit::TestCase.fixture_path)

class Test::Unit::TestCase #:nodoc:
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
  
  def setup
    # Put any additional setup here.
  end
  
end
