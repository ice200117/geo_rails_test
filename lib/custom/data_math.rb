module Custom::DataMath

  def self.getDSFromUv(u, v)
    u = u.to_f
    v = v.to_f
    windSpeed = Math.sqrt(u * u + v * v);
    if (windSpeed == 0)
      windDir = 0;
    else
      windDir = Math.asin(u / windSpeed) * 180 / Math::PI;
      if (u < 0 and v < 0)
        windDir = 180.0 - windDir;
      elsif (u > 0 and v < 0)
        windDir = 180.0 - windDir;
      elsif (u < 0 and v > 0)
        windDir = 360.0 + windDir;
      end
      windDir += 180;
      if (windDir >= 360)
        windDir -= 360;
      end
    end

    {:d=>windDir,:s=>windSpeed}
  end

end
