class AddColumnsInForecastDetail < ActiveRecord::Migration
  def change
    add_column :forecast_real_data,:ps,:float
    add_column :forecast_real_data,:tg,:float
    add_column :forecast_real_data,:rc,:float
    add_column :forecast_real_data,:rn,:float
    add_column :forecast_real_data,:ttp,:float
    add_column :forecast_real_data,:ter,:float
    add_column :forecast_real_data,:xmf,:float
    add_column :forecast_real_data,:dmf,:float
    add_column :forecast_real_data,:cor,:float
    add_column :forecast_real_data,:xlat,:float
    add_column :forecast_real_data,:xlon,:float
    add_column :forecast_real_data,:lu,:float
    add_column :forecast_real_data,:pbln,:float
    add_column :forecast_real_data,:pblr,:float
    add_column :forecast_real_data,:shf,:float
    add_column :forecast_real_data,:lhf,:float
    add_column :forecast_real_data,:ust,:float
    add_column :forecast_real_data,:swd,:float
    add_column :forecast_real_data,:lwd,:float
    add_column :forecast_real_data,:swo,:float
    add_column :forecast_real_data,:lwo,:float
    add_column :forecast_real_data,:t2m,:float
    add_column :forecast_real_data,:q2m,:float
    add_column :forecast_real_data,:u10,:float
    add_column :forecast_real_data,:v10,:float
    add_column :forecast_real_data,:wd,:float
    add_column :forecast_real_data,:ws,:float
    add_column :forecast_real_data,:pslv,:float
    add_column :forecast_real_data,:pwat,:float
    add_column :forecast_real_data,:clfrlo,:float
    add_column :forecast_real_data,:clfrmi,:float
    add_column :forecast_real_data,:clfrhi,:float
  end
end
