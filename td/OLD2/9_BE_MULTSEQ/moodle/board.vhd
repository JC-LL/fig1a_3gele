library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.seven_seg_controler_pkg.all;

entity board is
  port (
    btnd      : in  std_logic;
    clk100mhz : in  std_logic;
    switches  : in  std_logic_vector(15 downto 0);
    leds      : out std_logic_vector(15 downto 0);
    segments  : out std_logic_vector(6 downto 0);
    anodes    : out std_logic_vector(7 downto 0)
    );
end board;

architecture logic of board is
  signal reset_n      : std_logic;
  signal a, b         : std_logic_vector(3 downto 0);
  signal res          : std_logic_vector(7 downto 0);
  signal state_bits   : std_logic_vector(3 downto 0);
  signal start        : std_logic;
  signal ack_a, ack_b : std_logic;
  signal digits       : digits_array;
  signal ready        : std_logic;
begin

  reset_n <= not btnd;
  a       <= switches(7 downto 4);
  b       <= switches(12 downto 9);
  leds    <= ready & "00000000000" & state_bits;
  start   <= switches(0);
  ack_a   <= switches(1);
  ack_b   <= switches(2);

  multseq_1 : entity work.mult_seq(logic)
    port map (
      clk        => clk100mhz,
      reset_n    => reset_n,
      start      => start,
      ack_a      => ack_a,
      ack_b      => ack_b,
      a          => a,
      b          => b,
      ready      => ready,
      res        => res,
      state_bits => state_bits);

  -- affichage de A,B et RES sur les 7segment 0 2 et 4-5 respectivement
  digits <= (
    -1,
    -1,
    to_integer(unsigned(res(7 downto 4))),
    to_integer(unsigned(res(3 downto 0))),
    -1,
    to_integer(unsigned(b)),
    -1,
    to_integer(unsigned(a))
    );

  seven_seg_controler_1 : entity work.seven_seg_controler
    port map (
      reset_n  => reset_n,
      clk      => clk100mhz,
      digits   => digits,
      segments => segments,
      anodes   => anodes);



end logic;
