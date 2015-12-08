response = HTTParty.get("http://60.10.135.153:3000/welcome/get_history_data/TempLfDay/"+Time.now.years_ago(1).to_s)
