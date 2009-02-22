unless ENV['APP_TOKEN']
  abort "Must provide APP_TOKEN environment variable."
end

require 'rubygems'
require 'datamapper'

$:.unshift(File.dirname(__FILE__) << "/../lib")
require 'fiveruns/dash/datamapper'

class Job
  include DataMapper::Resource
  property :id, Serial
  
  def process!
    destroy
  end
  
end

class Worker
  
  def process
    count = 0
    Job.all.each do |job|
      job.process!
      count += 1
    end
    puts "Processed #{count}"
  end
  
end

DataMapper.setup(:default, 'sqlite3::memory:') 
DataMapper.auto_migrate!

Fiveruns::Dash.register_recipe :dm_example,
                               :url => 'http://dash.fiveruns.com' do |recipe|
  recipe.counter :jobs_processed, :incremented_by => 'Job#process!'
  recipe.time :processing_time, :method => 'Worker#process'                                 
end

Fiveruns::Dash.start :app => ENV['APP_TOKEN'] do |config|
  config.add_recipe :dm_example
  config.add_recipe :datamapper, :total_time => 'processing_time'
end

worker = Worker.new
loop do
  rand(300).times { Job.create }
  worker.process
end