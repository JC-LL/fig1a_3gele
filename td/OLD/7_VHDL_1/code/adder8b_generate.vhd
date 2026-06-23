library ieee;
use ieee.std_logic_1164.all;

architecture using_generate of adder8b is
  signal dummy_carry : std_logic;
  signal carry : std_logic_vector(7 downto 0);
begin

  dummy_carry <= '0';

  Loop_index: for i in 0 to 7 generate

    first_stage: if i=0 generate
      stage_0: entity work.full_adder(logic)
      port map(
        a => a(i),
        b => b(i),
        cin => dummy_carry,
        sum => sum(i),
        cout => carry(i)
      );
    end generate;

    other_stages: if i>0 generate
      state_i: entity work.full_adder(logic)
      port map(
        a => a(i),
        b => b(i),
        cin => carry(i-1),
        sum => sum(i),
        cout => carry(i)
      );
    end generate;

  end generate;

  cout <= carry(7);

end using_generate;
