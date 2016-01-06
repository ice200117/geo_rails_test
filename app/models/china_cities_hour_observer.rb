class ChinaCitiesHourObserver < ActiveRecord::Observer
	def after_save(c)
		c.logger.info("c has change!")
		#ApplicationController.new.expire_page("/bar")
		ApplicationController.new.expire_page("/bar.json")
		WelcomeSweeper.after_save 1
	end
end
