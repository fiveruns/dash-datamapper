# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{dash-datamapper}
  s.version = "0.6.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["FiveRuns Development Team"]
  s.date = %q{2009-02-22}
  s.description = %q{Provides an API to send metrics from applications using DataMapper to the FiveRuns Dash service}
  s.email = %q{dev@fiveruns.com}
  s.files = ["README.rdoc", "VERSION.yml", "lib/fiveruns", "lib/fiveruns/dash", "lib/fiveruns/dash/datamapper.rb", "lib/fiveruns/dash/recipes", "lib/fiveruns/dash/recipes/datamapper.rb", "lib/fiveruns-dash-datamapper.rb", "test/datamapper_test.rb", "test/test_helper.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/fiveruns/dash-datamapper}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{FiveRuns Dash recipe for DataMapper}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
