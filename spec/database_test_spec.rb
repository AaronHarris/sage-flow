require "spec_helper"
require 'active_record'

describe "Just to see whether we can connect" do
  it "does something" do
    # ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => 'db/test.db')
    # ActiveRecord::Base.establish_connection(:adapter => 'postgresql', :database => 'sage_flow_test', :username => 'rails')
    # class MyMigration < ActiveRecord::Migration
    #   def up
    #     create_table :foos do |t|
    #       t.string :name
    #     end
    #   end
    #   def down
    #     drop_table :foos
    #   end
    # end
    # MyMigration.new.down
    # MyMigration.new.up
    # class Sample < ActiveRecord::Base
    # end
    f = Sample.new
    f.name = 'hello'
    f.save
    g = Sample.find(f.id)
    g.name.should == 'hello'
  end
  
end