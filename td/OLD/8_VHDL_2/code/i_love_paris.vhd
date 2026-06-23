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

architecture rtl of i_love_paris is

  type state_type is (DODO,METRO,BOULOT);
  signal state, next_state : state_type;

begin
  process(reset_n,clk)
  begin
    if reset_n='0' then
      state <= DODO;
    elsif rising_edge(clk) then
      state <= next_state;
    end if;
  end process;

  next_state_p: process(state,reveil,greve,panne,bug)
  begin
    next_state <= state;--default
    case state is
      when DODO =>
       if reveil='1' then
         next_state <= METRO;
       end if;
      when METRO =>
       if greve='0' and panne='0' then
         next_state <= BOULOT;
       end if;
      when BOULOT =>
        if bug='0' then
          next_state <= DODO;
        end if;
      when others =>
        null;
    end case;
  end process;

  -- output logic :
  up_and_running <= '0' when state=DODO else '1';

end rtl;
