library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity automate is
  port(
    reset_n   : in  std_logic;
    clk       : in  std_logic;
    evenement : in  std_logic;
    sortie    : out std_logic
  );
end automate;

architecture rtl of automate is

  type state_type is (PING,PONG);
  signal state, next_state : state_type;

begin
  process(reset_n,clk)
  begin
    if reset_n='0' then
      state <= PING;
    elsif rising_edge(clk) then
      state <= next_state;
    end if;
  end process;

  -- logique d'etat suivant
  next_state_p: process(state,evenement)
  begin
    next_state <= state;--default
    case state is
      when PING =>
       if evenement='1' then
         next_state <= PONG;
       end if;
      when PONG =>
       if evenement='1' then
         next_state <= PING;
       end if;
      when others =>
        null;
    end case;
  end process;

  -- logique de sortie
  sortie <='1' when state=PONG else '0';

end rtl;
