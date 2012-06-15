require 'bundler/setup'
require 'active_record'
require 'sage_flow'

class SampleMigration < ActiveRecord::Migration
  def up
    create_table :samples do |t|
      t.string :name
    end
  end
  def down
    drop_table :samples
  end
end

class Sample < ActiveRecord::Base
  include ActiveModel::Validations
  include SageFlow
end

RSpec.configure do |config|
  migration = SampleMigration.new
  config.before(:suite) do
    ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => 'db/test.db')
    migration.up
  end
  config.after(:suite) do
    migration.down
  end
  config.after(:each) do
    Object.send(:remove_const, :Foo) if Object.const_defined?("Foo")
  end
  # some (optional) config here
end