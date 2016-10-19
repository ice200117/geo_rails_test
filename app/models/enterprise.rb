class Enterprise < ActiveRecord::Base
  def get_enterprise_data(citypy,gridPoint="")
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

  def get_enterprise_data_v1(citypy,gridPoint="",en_category = nil,pollutant='nox_concentration')
    # 获取指定公司信息
    # 输入:citypy:城市信息拼音,gridPoint:坐标格点,en_category:行业,pollutant:污染物类型
    # 输出:
    gset = Array.new
    esum = 0.0
    City.find_by_city_name_pinyin(citypy).enterprises.where(nox_concentration:pollutant).each do |l|
      next if l.send(pollutant) == -1
      esum += l.send(pollutant)
      gridPoint.each do |g|
        if (g['xmin'].to_f..g['xmax'].to_f) === l.longitude and (g['ymin'].to_f..g['ymax'].to_f) === l.latitude
          en_category.nil? ? gset << l.as_json : (gset << l.as_json if l.en_category == en_category)
        end
      end
    end
    gset.map! do |l|
      l['proportion'] = l[pollutant].to_f/esum
    end
  end
end
