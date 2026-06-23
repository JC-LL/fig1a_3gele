library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library accelerator_lib;
use accelerator_lib.controler_pkg.all;

entity fsmd is
  generic (n : natural);
  port (
    reset_n : in std_logic;
    clk     : in std_logic;
    go      : in  std_logic;
    done    : out std_logic;
    x       : in  unsigned(n-1 downto 0);
    a0      : in  unsigned(n-1 downto 0);
    a1      : in  unsigned(n-1 downto 0);
    a2      : in  unsigned(n-1 downto 0);
    a3      : in  unsigned(n-1 downto 0);
    px      : out unsigned(4*n+3-1 downto 0));
end fsmd;

architecture rtl of fsmd is
  signal control : control_type;
begin

  controler_1: entity work.controler
    port map (
      reset_n => reset_n, --port formel => signaux
      clk     => clk,
      go      => go,
      done    => done,
      control => control);

  datapath_1: entity work.datapath
    generic map (
      n => n)
    port map (
      reset_n => reset_n,
      clk     => clk,
      x       => x,
      a0      => a0,
      a1      => a1,
      a2      => a2,
      a3      => a3,
      control => control,
      px      => px);

end rtl;
