library ieee;
use ieee.std_logic_1164.all;

entity adder8b is
  port(
    a,b : in std_logic_vector(7 downto 0);
    sum : out std_logic_vector(7 downto 0);
    cout : out std_logic
  );
end adder8b;

architecture structural of adder8b is
  signal dummy_carry : std_logic;
  signal carry : std_logic_vector(7 downto 0);
begin

  dummy_carry <= '0';

  fa_0 : entity work.full_adder(logic)
  port map(
    a => a(0),
    b => b(0),
    cin => dummy_carry,
    sum => sum(0),
    cout => carry(0)
  );

  fa_1 : entity work.full_adder(logic)
  port map(
    a => a(1),
    b => b(1),
    cin => carry(0),
    sum => sum(1),
    cout => carry(1)
  );

  fa_2 : entity work.full_adder(logic)
  port map(
    a => a(2),
    b => b(2),
    cin => carry(1),
    sum => sum(2),
    cout => carry(2)
  );

  fa_3 : entity work.full_adder(logic)
  port map(
    a => a(3),
    b => b(3),
    cin => carry(2),
    sum => sum(3),
    cout => carry(3)
  );

  fa_4 : entity work.full_adder(logic)
  port map(
    a => a(4),
    b => b(4),
    cin => carry(3),
    sum => sum(4),
    cout => carry(4)
  );

  fa_5 : entity work.full_adder(logic)
  port map(
    a => a(5),
    b => b(5),
    cin => carry(4),
    sum => sum(5),
    cout => carry(5)
  );

  fa_6 : entity work.full_adder(logic)
  port map(
    a => a(6),
    b => b(6),
    cin => carry(5),
    sum => sum(6),
    cout => carry(6)
  );

  fa_7 : entity work.full_adder(logic)
  port map(
    a => a(7),
    b => b(7),
    cin => carry(6),
    sum => sum(7),
    cout => carry(7)
  );

  cout <= carry(7);

end structural;
