library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ab_plus_cd_unsigned_overflow is
  generic(n : natural := 8);
  port(
    reset_n : in  std_logic;
    clk     : in  std_logic;
    a,b,c,d : in  unsigned(n-1 downto 0);--8
    f       : out unsigned(n+n-1 downto 0)--17 !!!
  );
end ab_plus_cd_unsigned_overflow;

architecture comb_resize of ab_plus_cd_unsigned_overflow is
  signal s1,s2 : unsigned(n+n-1 downto 0);--16
  signal s3,s4 : unsigned(n+n   downto 0);--17
begin
  s1 <= a*b;
  s2 <= c*d;
  s3 <= resize(s1,2*n+1);
  s4 <= resize(s2,2*n+1);
  f <= s3+s4;
end comb_resize;

architecture comb_concat of ab_plus_cd_unsigned is
  signal s1,s2 : unsigned(n+n-1 downto 0);--16
  signal s3,s4 : unsigned(n+n   downto 0);--17
begin
  s1 <= a*b;
  s2 <= c*d;
  s3 <= '0' & s1;
  s4 <= '0' & s2;
  f <= s3+s4;
end comb_concat;
