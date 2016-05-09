module WelcomeHelper

  def add_loss_hour_data(data)
    ret_data = []
    st = data[0][0]
    data.each_index do |i|
	  puts data[i], st
      if data[i][0] < st
		  next
	  elsif data[i][0] == st
		ret_data << data[i]
		st = data[i][0]+1.hours
        if i < data.length-1 and data[i+1][0] - data[i][0] > 1.hours
          st = data[i][0]+1.hours
          while st<data[i+1][0]
            ret_data << [st, nil]
            st = st + 1.hours
          end
        end
	  else
        while st<data[i][0]
          ret_data << [st, nil]
          st = st + 1.hours
        end
        ret_data << data[i]
        st = st + 1.hours
	  end
    end
    ret_data
  end


  def r(v1, v2)
    a = v1.to_vector
    b = v2.to_vector
    pearson = Statsample::Bivariate::Pearson.new(a,b)
    pearson.r
  end

  def data_to_vector(data1, data2)
	[[], []] if data1.empty? or data2.empty?
    st = data1[0][0]>data2[0][0] ? data1[0][0] : data2[0][0]
    et = data1.last[0]<data2.last[0] ? data1.last[0] : data2.last[0]
    ret1 = []
    ret2 = []
    data1.each do |d|
      if d[0] >= st and d[0] <= et
        ret1 << d
      end
    end
    data2.each do |d|
      if d[0] >= st and d[0] <= et
        ret2 << d
      end
    end
    [ret1,ret2]
  end
end
