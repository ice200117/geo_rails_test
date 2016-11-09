
def deal_excel(file)
	Spreadsheet.client_encoding = 'UTF-8'
	book = Spreadsheet.open(file)
	sheet = book.worksheet(0)
	data = Array.new
	firstline = true
	sheet.each do |l|
		if firstline
            firstline = false
            next
        end
		data<<l
	end
	data
end
def input
	file = './vendor/lf_enterprise_data_lb_zhizaoye.xls'
	deal_excel(file).each do |l|
		tmp = Hash.new
        tmp['en_name'] = l[0].strip if !l[0].nil?#企业名称
        tmp['latitude'] = l[1] if !l[1].nil?  #纬度
		tmp['longitude'] = l[2] if !l[2].nil? #经度
		tmp['dust_concentration'] = l[3] if !l[3].nil?#烟尘浓度
		tmp['dust_convert'] = l[4] if !l[4].nil?#	烟尘折算浓度
		tmp['dust_discharge'] = l[5] if !l[5].nil?#烟尘排放量
		tmp['so2_concentration'] = l[6] if !l[6].nil?#so2浓度
		tmp['so2_convert'] = l[7] if !l[7].nil?#so2折算浓度
        tmp['so2_discharge'] = l[8] if !l[8].nil?#	so2排放量
        tmp['nox_concentration'] = l[9] if !l[9].nil?#nox浓度
        tmp['nox_convert'] = l[10] if !l[10].nil?#nox折算浓度
		tmp['nox_discharge'] = l[11] if !l[11].nil?#nox排放量
		tmp['temperature'] = l[12] if !l[12].nil?#温度
		tmp['discharge_height'] = l[13] if !l[13].nil?#排放高度
		tmp['en_category'] = '制造业'
		tmp['nmvoc'] = l[15] if !l[15].nil?
		tmp['co'] = l[16] if !l[16].nil?
		tmp['nh3'] = l[17] if !l[17].nil?
		tmp['pm10'] = l[18] if !l[18].nil?
		tmp['pm25'] = l[19] if !l[19].nil?
		tmp['bc'] = l[20] if !l[20].nil?
		tmp['oc'] = l[21] if !l[21].nil?
		tmp['city_id'] = 18
		result = Enterprise.create(tmp)
		if result
			puts tmp.to_s+' '+'input ok!'
		else
			puts tmp.to_s+' '+'input error!'
		end
	end
	
end
input
