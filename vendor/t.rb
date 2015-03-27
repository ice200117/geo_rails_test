require 'iconv'
class Iconv
  def Iconv.conv_from_cp936(str,big_endian=true)
    unless big_endian
      odd_or_even = 1
      i = 0
      str.each_byte{|c|
        odd_or_even = 1 - odd_or_even
        if odd_or_even==0
          puts i
          str[i],str[i+1] = str[i+1],str[i] if i<str.length
          i += 2
        end
      }
    end
    Iconv.iconv("cp936","UTF-8",str.to_s)
  end
end

IO.foreach("1"){|block| 
  puts Iconv.conv_from_cp936(block, false)}
