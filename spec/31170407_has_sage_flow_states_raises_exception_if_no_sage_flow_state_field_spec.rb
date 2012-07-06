require 'spec_helper'

describe "31170407 has_sage_flow_states adds validator to test for presence of sage_flow_state field" do
  describe "when field is not defined" do
    before(:each) do
      class StatelessSampleMigration < ActiveRecord::Migration
        def up
          create_table :stateless_samples do |t|
            t.string :name
            t.string :type
          end
        end
        def down
          drop_table :stateless_samples
        end
      end

      class StatelessSample < ActiveRecord::Base
        include ActiveModel::Validations
        include SageFlow
      end
      ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => 'db/test.db')
      StatelessSampleMigration.new.up
    end
    after(:each) do
      StatelessSampleMigration.new.down
    end
    it "Throws exception when field is not defined at all" do
      expect do
        class StatelessFoo < StatelessSample
          has_sage_flow_states :bar
        end
        StatelessFoo.new.valid?
      end.to raise_error
    end
  end
  it "Is invalid when there is no value" do
    class Foo < Sample
      has_sage_flow_states
    end
    Foo.new.valid?.should be_false
  end
  it "is valid when has a value" do
    class Foo < Sample
      has_sage_flow_states :bar
    end
    f = Foo.new
    f.sage_flow_state = "bar"
    f.valid?.should be_true
  end
end
