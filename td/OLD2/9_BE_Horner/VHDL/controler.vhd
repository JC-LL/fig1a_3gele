library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library accelerator_lib;
use accelerator_lib.controler_pkg.all;

entity controler is
  port (
    reset_n : in std_logic;
    clk     : in std_logic;
    go      : in  std_logic;
    done    : out std_logic;
    control : out control_type);
end controler;

architecture rtl of controler is
  type state_t is (s0,s1,s2,s3);
  signal state : state_t;
  signal done_c : std_logic;
begin

  next_state_logic : process(reset_n,clk)
  begin
    if reset_n='0' then
      state <= s0;
    elsif rising_edge(clk) then
      case state is
        when s0 =>
          if go='1' then
            state <= s1;
          end if;
        when s1 =>
          state <= s2;
        when s2 =>
          state <= s3;
        when s3 =>
          state <= s0;
        when others =>
          null;
      end case;
    end if;
  end process;

  output_logic : process(state)
  begin
    done_c <='0'; --by default
    case state is
    when s0 =>
      control.cmd_0 <= 1;
      control.cmd_1 <= 1;
      control.cmd_2 <= 1;
      control.cmd_3 <= 1;
      control.cmd_4 <= 1;
      control.cmd_5 <= 1;--not used in fact
    when s1 =>
      control.cmd_0 <= 0;
      control.cmd_1 <= 0;
      control.cmd_2 <= 0;
      control.cmd_3 <= 2;-- !
      control.cmd_4 <= 0;
      control.cmd_5 <= 0;
    when s2 =>
      control.cmd_0 <= 0;
      control.cmd_1 <= 0;
      control.cmd_2 <= 0;
      control.cmd_3 <= 2;-- !
      control.cmd_4 <= 0;
      control.cmd_5 <= 1;-- !
    when s3 =>
      control.cmd_0 <= 0;
      control.cmd_1 <= 0;
      control.cmd_2 <= 0;
      control.cmd_3 <= 2;-- !
      control.cmd_4 <= 0;
      control.cmd_5 <= 2;-- !
      done_c <= '1';
    when others =>
      control.cmd_0 <= 0;
      control.cmd_1 <= 0;
      control.cmd_2 <= 0;
      control.cmd_3 <= 0;
      control.cmd_4 <= 0;
      control.cmd_5 <= 0;
    end case;
  end process;

  done_reg : process(reset_n,clk)
  begin
    if reset_n='0' then
      done <= '0';
    elsif rising_edge(clk) then
      done <= done_c;
    end if;
  end process;

end rtl;
