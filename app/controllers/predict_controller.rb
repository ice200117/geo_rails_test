class PredictController < ApplicationController
  layout false
  def index
  	render layout: 'predict_main'
  end

  def analysis
    render 'pollution_situation_analysis',layout: 'predict_analysis'
  end

  def pollution_situation_analysis
  end

  def source_analysis
  end

  def model_forecast_analysis
  end

  def site_comparative_analysis
  end

  def revise
  	render layout: 'predict_revise'
  end
end
