library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity i_love_paris is
  port(
    reset_n : in std_logic;
    clk     : in std_logic;
    reveil  : in std_logic;
    panne   : in std_logic;
    greve   : in std_logic;
    bug     : in std_logic;
    up_and_running : out std_logic
  );
end i_love_paris;
