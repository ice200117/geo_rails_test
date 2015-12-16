class ModifyWeatherHourZhishu < ActiveRecord::Migration
  def change
	  change_column :weather_hours,:zhishu,:text
  end
end
