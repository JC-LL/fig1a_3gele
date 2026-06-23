library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mult_seq_tb is
end mult_seq_tb;

architecture bhv of mult_seq_tb is

  constant HALF_PERIOD : time      := 5 ns;
  signal running       : boolean   := true;
  signal clk, reset_n  : std_logic := '0';
  signal start         : std_logic;
  signal ack_a         : std_logic;
  signal ack_b         : std_logic;
  signal a, b          : std_logic_vector(3 downto 0);
  signal ready         : std_logic;
  signal res           : std_logic_vector(7 downto 0);

begin

  reset_n <= '0', '1' after 13 ns;

  clk <= not(clk) after HALF_PERIOD when running else '0';

  DUT : entity work.mult_seq(logic)      --bhv
    port map(
      clk     => clk,
      reset_n => reset_n,
      start   => start,
      ack_a   => ack_a,
      ack_b   => ack_b,
      a       => a,
      b       => b,
      ready   => ready,
      res     => res
      );

  stim : process
  begin
    ack_b <= '0';
    ack_a <= '0';
    start <= '0';
    a     <= "0000";
    b     <= "0000";
    wait until reset_n = '1';
    report "reset ok...";

    for i in 0 to 3 loop
      wait until rising_edge(clk);
    end loop;
    start <= '1';
    wait until rising_edge(clk);
    start <= '0';

    for i in 0 to 3 loop
      wait until rising_edge(clk);
    end loop;
    a     <= std_logic_vector(to_unsigned(13, 4));
    ack_a <= '1';

    for i in 0 to 3 loop
      wait until rising_edge(clk);
    end loop;
    b     <= std_logic_vector(to_unsigned(5, 4));
    ack_b <= '1';

    --wait until ready='1';
    for i in 0 to 10 loop
      wait until rising_edge(clk);
    end loop;

    report "end of computation";
    wait until rising_edge(clk);
    wait until rising_edge(clk);
    running <= false;
    wait;
  end process;

end bhv;
