library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity compteur is
  port(
    reset_n : in  std_logic;
    clk     : in  std_logic;
    value   : out unsigned(7 downto 0)
  );
end compteur;

architecture arch1 of compteur is
  signal counter : unsigned(7 downto 0);
  signal counter_comb : unsigned(7 downto 0);
begin

  counter_p : process(reset_n,clk)
  begin
    if reset_n='0' then
      counter <= "00000000";
    elsif rising_edge(clk) then
      counter <= counter_comb;
    end if;
  end process;

  counter_comb <= counter + 1;

  value <= counter;
end arch1;

architecture arch2 of compteur is
  signal counter : unsigned(7 downto 0);
begin
  counter_p : process(reset_n,clk)
  begin
    if reset_n='0' then
      counter <= "00000000";
    elsif rising_edge(clk) then
      counter <= counter + 1;
    end if;
  end process;

  value <= counter;
end arch2;
