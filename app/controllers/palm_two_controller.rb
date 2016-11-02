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
                @result_checkboxtable_data=[]
                if c
                  @latitude=c.latitude
                  @longitude=c.longitude
                  number=1
                  c.enterprises.each do |enterprise|
                  tmp=Hash.new
                  tmp['id']=enterprise['id']
                  tmp['number']=number
                  tmp['en_name']=enterprise['en_name']
                  tmp['pollution_contribution_rate']=number
                  tmp['county_name']=enterprise['county_id'].nil? ? '' : County.find_by_id(enterprise['county_id']).name
                  @result_checkboxtable_data<<tmp
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
                Adjoint.emission_by_enterprise(params['citypy'],'nox',params['enterprises'])
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

    def evaluation_page_two
        
    end
    def evaluation_page_three
        respond_to do |format|
            format.html{
                @citynamepy='zhengzhoushi'
                @citynamepy=params['cityname'] unless params['cityname'].nil?
            }
            format.json{
                linechartdata={'data'=>[["2016-06-05",116],["2016-06-06",129],["2016-06-07",135],["2016-06-08",86],["2016-06-09",73],["2016-06-10",85],["2016-06-11",73],["2016-06-12",68],["2016-06-13",92],["2016-06-14",130],["2016-06-15",245],["2016-06-16",139],["2016-06-17",115],["2016-06-18",111],["2016-06-19",309],["2016-06-20",206],["2016-06-21",137],["2016-06-22",128],["2016-06-23",85],["2016-06-24",94],["2016-06-25",71],["2016-06-26",106],["2016-06-27",84],["2016-06-28",93],["2016-06-29",85],["2016-06-30",73],["2016-07-01",83],["2016-07-02",125],["2016-07-03",107],["2016-07-04",82],["2016-07-05",44],["2016-07-06",72],["2016-07-07",106],["2016-07-08",107],["2016-07-09",66],["2016-07-10",91],["2016-07-11",92],["2016-07-12",113],["2016-07-13",107],["2016-07-14",131],["2016-07-15",111],["2016-07-16",64],["2016-07-17",69],["2016-07-18",88],["2016-07-19",77],["2016-07-20",83],["2016-07-21",111],["2016-07-22",57],["2016-07-23",55],["2016-07-24",60],["2016-07-25",44],["2016-07-26",127],["2016-07-27",114],["2016-07-28",86],["2016-07-29",73],["2016-07-30",52],["2016-07-31",69],["2016-08-01",86],["2016-08-02",118],["2016-08-03",56],["2016-08-04",91],["2016-08-05",121],["2016-08-06",127],["2016-08-07",78],["2016-08-08",79],["2016-08-09",46],["2016-08-10",108],["2016-08-11",80],["2016-08-12",79],["2016-08-13",69],["2016-08-14",80],["2016-08-15",105],["2016-08-16",119],["2016-08-17",105],["2016-08-18",55],["2016-08-19",74],["2016-08-20",41],["2016-08-21",62],["2016-08-22",104],["2016-08-23",118],["2016-08-24",121],["2016-08-25",126],["2016-08-26",99],["2016-08-27",92],["2016-08-28",75],["2016-08-29",91],["2016-08-30",94],["2016-08-31",69],["2016-09-01",93],["2016-09-02",124],["2016-09-03",120],["2016-09-04",93],["2016-09-05",26],["2016-09-06",32],["2016-09-07",70],["2016-09-08",89],["2016-09-10",117],["2016-09-11",144],["2016-09-12",111],["2016-09-13",120],["2016-09-14",97],["2016-09-15",108],["2016-09-17",74],["2016-09-18",105],["2016-09-19",127],["2016-09-20",143],["2016-09-21",62],["2016-09-22",80],["2016-09-23",136],["2016-09-24",29],["2016-09-25",91],["2016-09-26",93],["2016-09-27",114],["2016-09-28",45],["2016-09-29",102],["2016-09-30",111],["2016-10-01",93],["2016-10-02",117],["2016-10-03",78],["2016-10-04",76],["2016-10-05",100],["2016-10-06",75],["2016-10-07",169],["2016-10-08",59],["2016-10-09",89],["2016-10-10",91],["2016-10-11",75],["2016-10-12",28],["2016-10-13",47],["2016-10-14",92],["2016-10-16",72],["2016-10-17",149],["2016-10-18",86],["2016-10-19",88],["2016-10-20",104],["2016-10-21",91],["2016-10-22",88],["2016-10-23",55],["2016-10-24",63],["2016-10-25",41],["2016-10-26",85],["2016-10-27",99],["2016-10-28",121],["2016-10-29",96],["2016-10-30",90],["2016-11-01",80],["2016-11-02",116],["2016-11-03",207],["2016-11-04",306],["2016-11-05",283],["2016-11-06",200],["2016-11-07",93]]}
                render json: linechartdata
            }
        end
    end
end
