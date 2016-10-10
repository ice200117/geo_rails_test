class PalmTwoController < ApplicationController
  layout 'palm_two'
  def scheme_simulation

  	respond_to do |format|
        format.html {
            # @citynamepy=params['cityname']
            # @factor=params['factor']
            
            @citynamepy='zhengzhoushi'
            @citynamepy=params['cityname'] unless params['cityname'].nil?
            @factor='NOX_120'
            c = City.find_by city_name_pinyin: @citynamepy
            if c
              @latitude=c.latitude
              @longitude=c.longitude
            end
            render 'page_lost_city',layout: false unless c
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

  def get_all_data
    factor=params['factor']
    citynamepy=params['citynamepy']
    percent=params['percent'].to_f
    all_data=Adjoint.emission(factor,citynamepy,percent,nil)
    respond_to do |format|
        format.json {
            render json: all_data
        }
    end    
      
  end

end
