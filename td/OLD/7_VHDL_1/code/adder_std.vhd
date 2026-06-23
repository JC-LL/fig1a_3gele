library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test is
end test;

architecture example of test is
  signal a,b,f : signed(7 downto 0);
begin
  f <= a + b;
end example;
