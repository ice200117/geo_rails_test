class ModifyWeatherHours < ActiveRecord::Migration
  def change
	  rename_column :weather_hours,:shizhu,:zhishu
  end
end
