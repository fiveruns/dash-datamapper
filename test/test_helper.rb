require 'rubygems'
require 'datamapper'

$LOAD_PATH.unshift(File.dirname(__FILE__) << "/../lib")
require 'fiveruns/dash/datamapper'

require 'test/unit'

begin
  require 'redgreen'
rescue LoadError
end

require 'activerecord'
require 'shoulda'