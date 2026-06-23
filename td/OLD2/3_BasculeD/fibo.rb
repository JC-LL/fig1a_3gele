require 'pp'

include Math

def fibo(u1,u0)
  u1+u0
end

PHI=(1+sqrt(5))/2
PHI_P=-1/PHI #(1-sqrt(5))/2

def fibo_n(n)
  (1/sqrt(5))*(PHI**n-PHI_P**n)
end

u0=0
u1=1

for n in 2..10
  old0=u0
  puts "u#{n}= "+(u0=fibo(u1,u0)).to_s
  puts "u#{n}="+fibo_n(n-1).to_s
  u1=old0
  puts
end
