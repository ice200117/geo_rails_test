class PalmTwoController < ApplicationController
    layout 'palm_two'
    def scheme_simulation
        respond_to do |format|
            format.html {
                # @citynamepy=params['cityname']
                # @factor=params['factor']
                @citynamepy='zhengzhoushi'
                @citynamepy=params['cityname'] unless params['cityname'].nil?
                @factor='nox'
                c = City.find_by city_name_pinyin: @citynamepy
                @ccs=[]
                @en_count=[]
                @en_list=[]
                if c
                    @latitude=c.latitude
                    @longitude=c.longitude
                    c.counties.each do |cc|
                        @ccs<<cc.name
                        @en_count<<cc.enterprises.size
                    end
                    number=1
                    c.enterprises.each do |enterprise|
                        tmp=[]
                        tmp<<number
                        tmp<<enterprise['en_name']
                        tmp<<''
                        @en_list<<tmp
                        number+=1                
                    end
                end
                render 'page_lost_city',layout: false unless c
            }
            format.json {
                enterprise_data=Hash.new
                result = []
                str =""
                str = JSON.parse(params['gridPoint']) unless params['gridPoint']==""
                r_data=Enterprise.new.get_enterprise_data(citynamepy,str)
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

    def get_checkboxtable_data
        checkboxtable_data=Hash.new
        result=[]
        city=City.find_by_city_name_pinyin(params['citynamepy'])
        r_data=city.enterprises
        number=1
        r_data.each do |enterprise|
            tmp=Hash.new
            tmp['id']=enterprise['id']
            tmp['number']=number
            tmp['en_name']=enterprise['en_name']
            tmp['pollution_contribution_rate']=number
            tmp['county_name']=enterprise['county_id'].nil? ? '' : County.find_by_id(enterprise['county_id']).name
            result<<tmp
            number+=1
        end
        checkboxtable_data['data']=result
        respond_to do |format|
            format.json {
                render json: checkboxtable_data
            }
        end
    end

    def get_all_data
        factor=params['factor']
        citynamepy=params['citynamepy']
        percent=params['percent'].to_f
        all_data=Adjoint.emission_v1(citynamepy,factor,percent)
        respond_to do |format|
            format.json {
                render json: all_data
            }
        end    
    end

    def query_gou_xuan_en_data_all
        respond_to do |format|
            format.json {
                render json: {chenggong:'chenggong'}
            }
        end
    end

    def effect_evaluation
        params['cityname'].nil? ? cityname = 'langfangshi' : cityname = params['cityname']
        @evaluate = Adjoint.evaluate(cityname,Time.now.days_ago(5),Time.now.yesterday)
        respond_to do |format|
            format.html
            format.json{render json: @evaluate}
        end
    end
end
