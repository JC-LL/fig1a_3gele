library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library accelerator_lib;
use accelerator_lib.controler_pkg.all;

entity datapath is
  generic (n : natural);                --number of bits for inputs.
  port (
    reset_n : in  std_logic;
    clk     : in  std_logic;
    x       : in  unsigned(n-1 downto 0);
    a0      : in  unsigned(n-1 downto 0);
    a1      : in  unsigned(n-1 downto 0);
    a2      : in  unsigned(n-1 downto 0);
    a3      : in  unsigned(n-1 downto 0);
    control : in  control_type;
    px      : out unsigned(4*n+3-1 downto 0));
end datapath;

architecture rtl of datapath is
  signal r0, r1, r2, r4 : unsigned(n-1 downto 0);
  signal r3             : unsigned(4*n+3-1 downto 0);
  signal mulacc         : unsigned(4*n+3-1 downto 0);
  signal operand_add1   : unsigned(n-1 downto 0);
begin

  -- On choisit de decouper en plusieurs processus.
  -- Mais on pourrait ecrire un seul processus.
  -- Cela n'a pas de consequences sur la synthese.
  -- La simulation peut etre impactee (selon le simulateur)

  reg_0 : process(reset_n, clk)
  begin
    if reset_n = '0' then
      r0 <= to_unsigned(0, n);
    elsif rising_edge(clk) then
      if control.cmd_0 = 1 then
        r0 <= x;
        -- else     -- faculatif. omis pour les autres
        --r0 <= r0; -- registres
      end if;
    end if;
  end process;

  reg_1 : process(reset_n, clk)
  begin
    if reset_n = '0' then
      r1 <= to_unsigned(0, n);
    elsif rising_edge(clk) then
      if control.cmd_1 = 1 then
        r1 <= a0;
      end if;
    end if;
  end process;

  reg_2 : process(reset_n, clk)
  begin
    if reset_n = '0' then
      r2 <= to_unsigned(0, n);
    elsif rising_edge(clk) then
      if control.cmd_2 = 1 then
        r2 <= a1;
      end if;
    end if;
  end process;

  reg_4 : process(reset_n, clk)
  begin
    if reset_n = '0' then
      r4 <= to_unsigned(0, n);
    elsif rising_edge(clk) then
      if control.cmd_4 = 1 then
        r4 <= a2;
      end if;
    end if;
  end process;

  reg_3 : process(reset_n, clk)
  begin
    if reset_n = '0' then
      r3 <= to_unsigned(0, 4*n+3);
    elsif rising_edge(clk) then
      case control.cmd_3 is
        when 0 =>
          r3 <= resize(r3, 4*n+3);
        when 1 =>
          r3 <= resize(a3, 4*n+3);
        when 2 =>
          r3 <= mulacc;
        when others =>
          null;
      end case;
    end if;
  end process;

  px <= r3; -- output

  -- combinatorial parts :
  mux5_proc : process(control,r1,r2,r4)
  begin
    case control.cmd_5 is
      when 0 =>
        operand_add1 <= r4;
      when 1 =>
        operand_add1 <= r2;
      when 2 =>
        operand_add1 <= r1;
      when others =>
        operand_add1 <= r1; --default. Needed for inference of mux.
    end case;
  end process;

  mulacc <= resize(r0*r3 + operand_add1, 4*n+3);


end rtl;
