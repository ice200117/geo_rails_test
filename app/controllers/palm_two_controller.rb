class PalmTwoController < ApplicationController
  layout 'palm_two'
  def scheme_simulation

  	respond_to do |format|
        format.html {
            # @citynamepy=params['cityname']
            # @factor=params['factor']
            
            @citynamepy='zhengzhoushi'
            @factor='NOX_120'
            c = City.find_by city_name_pinyin: @citynamepy
            @latitude=c.latitude
            @longitude=c.longitude
        }
        format.json {
        	enterprise_data=Hash.new
        	result = []
            str =""
            str = JSON.parse(params['gridPoint']) unless params['gridPoint']==""
            r_data=Enterprise.new.get_enterprise_data(str)
            number=1
            r_data.each do |enterprise|
            	tmp=[]
            	tmp<<number
            	tmp<<enterprise['en_name']
            	tmp<<''
            	result<<tmp
            	number+=1
            end
            enterprise_data['data']=result
            render json: enterprise_data
        }
    end

  end
end
