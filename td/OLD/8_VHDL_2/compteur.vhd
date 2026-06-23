library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity compteur is
  port(
    reset_n : in std_logic;
    clk     : in std_logic;
    value   : out unsigned(7 downto 0)
  );
end compteur;

architecture arch1 of compteur is
  signal counter,counter_comb : unsigned(7 downto 0);
begin

  value <= counter;

  counter_comb <= counter + 1;

  bascules_d : process(reset_n,clk)
  begin
    if reset_n='0' then
      counter <= "00000000";
    elsif rising_edge(clk) then
      counter <= counter_comb;
    end if;
  end process;

end arch1;
