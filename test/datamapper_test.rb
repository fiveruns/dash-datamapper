require File.dirname(__FILE__) << "/test_helper"

Fiveruns::Dash.logger.level = Logger::FATAL

class DataMapperTest < Test::Unit::TestCase

  class TestModel
    include DataMapper::Resource
    property :id, Serial
    property :name, String
  end

  class TestEngine
    def doit
      sleep 1
      2.times do
        t = TestModel.create(:name => 'foo')
        t.destroy
      end
    end

    def conn
      # FIXME: We need a way to suspend execution temporarily
      #        for a specific w/in the DB; sqlite doesn't support sleep()
      #        ... otherwise we need to mock `execute'
      TestModel.repository.adapter.execute("select sleep(1)")
    end

    def entry(meth)
      send(meth)
    end
  end
  

  context "Metric" do
    
    setup do
      DataMapper.setup(:default, 'sqlite3::memory:') 
      DataMapper.auto_migrate!
    end

    should "collect basic ORM metrics" do
      scenario do
        TestEngine.new.entry(:doit)

        data = Fiveruns::Dash.session.data
        assert metric('test_time', data) > 1.0
        assert metric('orm_util', data) > metric('db_util', data)
        assert metric('db_util', data) < 5
      end
    end

    should "collect DB metrics" do
      scenario do
        TestEngine.new.entry(:conn)
        
        data = Fiveruns::Dash.session.data
        assert metric('test_time', data) > 1.0
        assert metric('test_time', data) < 1.1
        assert metric('db_time', data) > 1.0
        assert metric('db_time', data) < 1.1
        assert metric('db_util', data) > 90.0
        assert metric('db_util', data) < 100.0
      end
    end
  end

  def scenario(&block)
    child = fork do
      mock_datamapper!
      yield
    end
    Process.wait
    assert_equal 0, $?.exitstatus
  end

  def metric(metric, data, context=[])
    hash = data.detect { |hash| hash[:name] == metric }
    assert hash, "No metric named #{metric} was found in metrics payload"
    vals = hash[:values]
    assert vals, "No values found for #{metric} in metrics payload"
    val = vals.detect { |val| val[:context] == context }
    assert val, "No value for #{metric} found for context #{context.inspect}"
    val[:value]
  end

  def mock_datamapper!
    
    eval <<-MOCK
      module Fiveruns::Dash
        class Reporter
          private
          def run
          end
        end
      end
    MOCK

    Fiveruns::Dash.register_recipe :tester, :url => 'http://dash.fiveruns.com' do |recipe|
      recipe.time :test_time, 'Test Time', :method => 'DataMapperTest::TestEngine#entry',
                                           :mark => true
    end
    
    Fiveruns::Dash.start :app => '666' do |config|
      config.add_recipe :ruby
      config.add_recipe :tester
      config.add_recipe :datamapper, :total_time => 'test_time'
    end
    
  end
end