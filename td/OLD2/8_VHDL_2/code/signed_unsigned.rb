min,max=100000,-10000000
for a in -2**7..2**7-1
  for b in -2**7..2**7-1
    s=a+b
    if s> max
      max=s
    end
    if s<min
      min=s
    end
  end
end
puts "s8+s8 : min,max=#{min},#{max}"

min,max=10000000000,-1000000000000
for a in -2**7..2**7-1
  for b in -2**7..2**7-1
    s=a*b
    if s> max
      max=s
    end
    if s<min
      min=s
    end
  end
end
puts "s8*s8 : min,max=#{min},#{max}"

min,max=10000000000,-1000000000000
for a in [0,2**8-1]
  for b in [0,2**8-1]
    for c in [0,2**8-1]
      for d in [0,2**8-1]
        s=a*b+c*d
        if s> max
          max=s
        end
        if s<min
          min=s
        end
      end
    end
  end
end
puts "u8*u8+s8*s8 : min,max=#{min},#{max}"
