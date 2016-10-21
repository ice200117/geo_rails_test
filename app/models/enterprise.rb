class Enterprise < ActiveRecord::Base
	belongs_to :city
	belongs_to :county
  def get_enterprise_data(gridPoint="")
    if gridPoint==''
      result=Enterprise.all
    else
      result = Array.new
      gridPoint.each do |grid|
        xmin=grid['xmin'].to_f#longitude
        xmax=grid['xmax'].to_f
        ymin=grid['ymin'].to_f#latitude
        ymax=grid['ymax'].to_f
        tmp=Enterprise.where(longitude: xmin..xmax,latitude: ymin..ymax)
        result+=tmp
      end
    end
    result
  end

  def get_enterprise_data_v1(citypy,gridPoint=[],*arg)
    # 获取指定公司信息
    # 输入:citypy:城市信息拼音,gridPoint:坐标格点,arg[0]:行业,arg[1]:污染物类型
    # 输出:
    gset = Array.new
    esum = 0.0
    arg[1] = 'nox_discharge' if arg[1].nil?
    where = Hash.new
    where['en_category'] = arg[0] unless arg[0].nil?
    City.find_by_city_name_pinyin(citypy).enterprises.where(where).each do |l|
      next if l.send(arg[1]) == -1
      esum += l.send(arg[1]).to_f
      gset << l.as_json;next if gridPoint.size == 0
      gridPoint.each do |g|
        if (g['xmin'].to_f..g['xmax'].to_f) === l.longitude and (g['ymin'].to_f..g['ymax'].to_f) === l.latitude
          arg[0].nil? ? gset << l.as_json : (gset << l.as_json if l.en_category == arg[0])
        end
      end
    end
    gset.map do |l|
      l['proportion'] = l[arg[1]].to_f/esum
    end
    gset
  end
end
