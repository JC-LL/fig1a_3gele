-----------------------------------------------------------------
-- This file was generated automatically by vhdl_tb Ruby utility
-- date : (d/m/y) 06/11/2018 16:50
-- Author : Jean-Christophe Le Lann - 2014
-----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity i_love_paris_tb is
end entity;

architecture bhv of i_love_paris_tb is

  constant HALF_PERIOD : time := 5 ns;

  signal clk     : std_logic := '0';
  signal reset_n : std_logic := '0';
  signal sreset  : std_logic := '0';
  signal running : boolean   := true;

  procedure wait_cycles(n : natural) is
  begin
    for i in 1 to n loop
      wait until rising_edge(clk);
    end loop;
  end procedure;

  signal reveil         : std_logic;
  signal panne          : std_logic;
  signal greve          : std_logic;
  signal bug            : std_logic;
  signal up_and_running : std_logic;

begin
  -------------------------------------------------------------------
  -- clock and reset
  -------------------------------------------------------------------
  reset_n <= '0', '1' after 33 ns;

  clk <= not(clk) after HALF_PERIOD when running else clk;

  --------------------------------------------------------------------
  -- Design Under Test
  --------------------------------------------------------------------
  dut : entity work.i_love_paris(rtl)
    port map (
      reset_n        => reset_n,
      clk            => clk,
      reveil         => reveil,
      panne          => panne,
      greve          => greve,
      bug            => bug,
      up_and_running => up_and_running
      );

  --------------------------------------------------------------------
  -- sequential stimuli
  --------------------------------------------------------------------
  stim : process
  begin
    reveil <= '0';
    panne  <= '0';
    greve  <= '0';
    bug    <= '0';
    report "running testbench for i_love_paris(rtl)";
    report "waiting for asynchronous reset";
    wait until reset_n = '1';
    wait_cycles(5);
    report "applying stimuli...";
    wait until rising_edge(clk);
    report "REVEIL !";
    reveil <= '1';

    wait until rising_edge(clk);
    report "PANNE du METRO!";
    reveil <= '0';
    panne  <= '1';

    wait until rising_edge(clk);
    report "GREVE !";
    panne  <= '0';
    greve  <= '1';

    wait until rising_edge(clk);
    report "BUG !";
    greve  <= '0';
    bug    <= '1';
    wait_cycles(3);

    wait until rising_edge(clk);
    report "BUG résolu";
    bug    <= '0';
    wait_cycles(10);
    report "end of simulation";
    running <= false;
    wait;
  end process;

end bhv;
