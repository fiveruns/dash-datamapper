gem 'fiveruns-dash-ruby'
require 'fiveruns/dash'

require 'fiveruns/dash/recipes/datamapper'

module Fiveruns::Dash::DataMapper
  DB_TARGETS = %w(DataMapper::Adapters::DataObjectsAdapter#execute)
  ORM_TARGETS = %w(read_many read_one update delete).map do |meth|
    "DataMapper::Repository##{meth}"
  end
end