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

architecture logic of i_love_paris is
  signal state, next_state : std_logic_vector(2 downto 0);
  --preferable to :
  --signal d, q : std_logic_vector(2 downto 0);
begin
  process(reset_n,clk)
  begin
    if reset_n='0' then
      state <= "001";--dodo
    elsif rising_edge(clk) then
      state <= next_state;
    end if;
  end process;

  next_state(0) <= (state(0) and not(reveil)) or (state(2) and not(bug));
  next_state(1) <= (state(0) and reveil) or (state(1) and (greve or panne));
  next_state(2) <= (state(2) and bug) or (state(1) and (not(greve) and not(panne));

end logic;
