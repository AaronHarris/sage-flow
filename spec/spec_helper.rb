require 'bundler/setup'
require 'active_record'
require 'action_controller'
require 'action_dispatch'
require 'database_cleaner'
require 'sage_flow'

class SampleMigration < ActiveRecord::Migration
  def up
    create_table :samples do |t|
      t.string :name
      t.string :sage_flow_state
      t.string :type
    end
  end
  def down
    drop_table :samples
  end
end

class Sample < ActiveRecord::Base
  include SageFlow
end

class SampleController
  include SageFlow
end

RSpec.configure do |config|
  # config.use_transactional_fixtures = true
  migration = SampleMigration.new
  config.before(:suite) do
    ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => 'db/test.db')
    migration.up
    DatabaseCleaner.strategy = :transaction
  end
  config.after(:suite) do
    migration.down
  end
  config.before(:each) do
    DatabaseCleaner.start
  end
  config.after(:each) do
    Object.send(:remove_const, :Foo) if Object.const_defined?("Foo")
    Object.send(:remove_const, :SubFoo) if Object.const_defined?("SubFoo")
    Object.send(:remove_const, :SubSubFoo) if Object.const_defined?("SubSubFoo")
    Object.send(:remove_const, :FooController) if Object.const_defined?("FooController")
    DatabaseCleaner.clean
  end
end