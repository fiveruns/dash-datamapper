Fiveruns::Dash.register_recipe :datamapper, :url => 'http://dash.fiveruns.com' do |recipe|

  recipe.time :db_time, 'Database Time', :methods => Fiveruns::Dash::DataMapper::DB_TARGETS  
  recipe.time :orm_time, 'DataMapper Time', :methods => Fiveruns::Dash::DataMapper::ORM_TARGETS,
                                             :reentrant => true
  recipe.added do |settings|

    # We need a way to get the total time for a request/operation so that we can
    # calculate the relative percentage used by AR/DB.    
    if settings[:total_time]
      
      total_time = settings[:total_time].to_s

      Fiveruns::Dash.logger.debug "Limiting FiveRuns Dash DataMapper metrics to within #{total_time}"
      # Limit timing
      recipe.metrics.each do |metric|
        if %w(db_time orm_time).include?(metric.name) && metric.recipe.url == 'http://dash.fiveruns.com'
          metric.options[:only_within] = total_time
        end
      end

      recipe.percentage :orm_util, 'DataMapper Utilization', :sources => ["orm_time", total_time] do |orm_time, all_time|
        all_time == 0 ? 0 : (orm_time / all_time) * 100.0
      end
      recipe.percentage :db_util, 'Database Utilization', :sources => ["db_time", total_time] do |db_time, all_time|
        all_time == 0 ? 0 : (db_time / all_time) * 100.0
      end
    
    else
      
      Fiveruns::Dash.logger.error [
        "Could not add some metrics from the FiveRuns Dash `datamapper' recipe to the configuration;",
        "Please provide a :total_time metric name setting when adding the recipe.",
        "For more information, see the fiveruns-dash-datamapper README"
      ].join("\n")
      
    end
    
  end

end
