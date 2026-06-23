library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ab_plus_cd is
  generic(n : natural := 8);
  port(
    reset_n : in  std_logic;
    clk     : in  std_logic;
    a,b,c,d : in  signed(n-1 downto 0);--8
    f       : out signed(n+n-1 downto 0)--16
  );
end ab_plus_cd;

architecture combinatoire of ab_plus_cd is
  -- Cette architecture est plus subtile qu'il n'y parait !
  -- Dans le cas general, les dynamiques des signaux doivent etre calculees avec soin
  -- voir note complementaire.
begin
  f <= a*b+c*d;
end combinatoire;
