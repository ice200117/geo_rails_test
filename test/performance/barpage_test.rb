require 'test_helper'
require 'rails/performance_test_help'

class BarpageTest < ActionDispatch::PerformanceTest
  # Refer to the documentation for all available options
  # self.profile_options = { runs: 5, metrics: [:wall_time, :memory],
  #                          output: 'tmp/performance', formats: [:flat] }

  #test "homepage" do
    #get '/bar'
  #end
 
  test "china_cities_hours today_avg" do
    ChinaCitiesHour.today_avg
  end
end
