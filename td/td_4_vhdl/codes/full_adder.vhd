library ieee;
use ieee.std_logic_1164.all;

entity full_adder is
  port(
    a,b : in std_logic;
    cin : in std_logic;
    sum,cout : out std_logic
  );
end full_adder;

architecture logic of full_adder is
  signal s_1, cout_1,cout_2 : std_logic;
begin

  ha_1 : entity work.half_adder(logic)
  port map(
    a => a,
    b => b,
    sum => s_1,
    cout => cout_1
  );

  ha_2 : entity work.half_adder(logic)
  port map(
    a => cin,
    b => s_1,
    sum => sum,
    cout => cout_2
  );

  cout <= cout_1 or cout_2;

end logic;
