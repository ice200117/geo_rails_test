
def deal_excel(file)
	Spreadsheet.client_encoding = 'UTF-8'
	book = Spreadsheet.open(file)
	sheet = book.worksheet(0)
	data = Array.new
	sheet.each do |l|
		data<<l
	end
	data
end
def input
	file = './vendor/enterprise.xls'
	deal_excel(file).each do |l|
		tmp = Hash.new
        tmp['en_name'] = l[0].strip if !l[0].nil?
		tmp['latitude'] = l[1] if !l[1].nil?
		tmp['longitude'] = l[2] if !l[2].nil?
		tmp['dust_concentration'] = l[3] if !l[3].nil?
		tmp['dust_convert'] = l[4] if !l[4].nil?
		tmp['dust_discharge'] = l[5] if !l[5].nil?
		tmp['so2_concentration'] = l[6] if !l[6].nil?
		tmp['so2_convert'] = l[7] if !l[7].nil?
        tmp['so2_discharge'] = l[8] if !l[8].nil?
        tmp['nox_concentration'] = l[9] if !l[9].nil?
        tmp['nox_convert'] = l[10] if !l[10].nil?
		tmp['nox_discharge'] = l[11] if !l[11].nil?
		tmp['temperature'] = l[12] if !l[12].nil?
		tmp['discharge_height'] = l[13] if !l[13].nil?
		result = Enterprise.create(tmp)
		if result
			puts tmp.to_s+' '+'input ok!'
		else
			puts tmp.to_s+' '+'input error!'
		end
	end
	
end
input
