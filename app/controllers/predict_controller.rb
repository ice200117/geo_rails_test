class PredictController < ApplicationController
  def index
  	render layout: 'predict_main'
  end

  def pollution_situation_analysis
  	render layout: 'predict_analysis'
  end

  def source_analysis
	render layout: 'predict_analysis'	
  end

  def revise
  	render layout: 'predict_revise'
  end
end
