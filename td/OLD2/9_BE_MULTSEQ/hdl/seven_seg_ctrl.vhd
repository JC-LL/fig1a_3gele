-------------------------------------------------------------------------------
-- Title      : seven segment controller for NEXYS2 FPGA Board
-- Project    : 
-------------------------------------------------------------------------------
-- File       : seven_seg_ctrl.vhd
-- Author     : Le Lann  <jcll@latitude13-l>
-- Company    : 
-- Created    : 2013-09-11
-- Last update: 2014-01-15
-- Platform   : 
-- Standard   : VHDL'93
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2013 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-09-11  1.0      jcll    Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity seven_seg_ctrl is
  generic(CLOCK_PARAM : natural := 24);  -- nb bits for counting 2**CLOCK_PARAM
  port(
    clk      : in  std_logic;
    reset    : in  std_logic;
    --
    digit_3  : in  unsigned(3 downto 0);
    digit_2  : in  unsigned(3 downto 0);
    digit_1  : in  unsigned(3 downto 0);
    digit_0  : in  unsigned(3 downto 0);
    show     : in  std_logic_vector(3 downto 0);
    --
    enables  : out std_logic_vector(3 downto 0);
    segments : out std_logic_vector(6 downto 0);
    point    : out std_logic);
end seven_seg_ctrl;

architecture rtl of seven_seg_ctrl is
  
  type   state_type is (IDLE, D3, D2, D1, D0, DT);
  signal state, next_state : state_type;
  signal clkdiv            : unsigned(CLOCK_PARAM-1 downto 0) := to_unsigned(0, CLOCK_PARAM);
  signal slow_clk_enable   : std_logic;

  signal digit_3_r  : unsigned(3 downto 0);
  signal digit_2_r  : unsigned(3 downto 0);
  signal digit_1_r  : unsigned(3 downto 0);
  signal digit_0_r  : unsigned(3 downto 0);
  signal do_sample  : std_logic;
  signal show_r     : std_logic_vector(3 downto 0);
  signal segments_c : std_logic_vector(6 downto 0);

  function digit_to_seven_seg (digit : unsigned(3 downto 0)) return std_logic_vector is
    variable ret : std_logic_vector(7 downto 0);
    variable num : integer;
  begin
    ret := x"79";
    num := to_integer(digit);
    case num is                         -- A B C D E F G
      when 0      => ret := x"3F";
      when 1      => ret := x"06";
      when 2      => ret := x"5B";
      when 3      => ret := x"4F";
      when 4      => ret := x"66";
      when 5      => ret := x"6D";
      when 6      => ret := x"7D";
      when 7      => ret := x"07";
      when 8      => ret := x"7F";
      when 9      => ret := x"6F";
      when 10     => ret := x"77";      --A
      when 11     => ret := x"7C";      --B
      when 12     => ret := x"39";      --C
      when 13     => ret := x"5E";      --D
      when 14     => ret := x"79";      --E
      when 15     => ret := x"71";      --F
      when others => null;
    end case;
    return not ret(6 downto 0);         -- need to be INVERTED !!!
  end function;
  
begin  -- rtl

  slow_clk_proc : process (clk, reset)
  begin
    if reset = '0' then
      clkdiv <= to_unsigned(0, CLOCK_PARAM);
    elsif rising_edge(clk) then
      clkdiv <= clkdiv +1;
    end if;
  end process;

  slow_clk_enable <= '1' when clkdiv = to_unsigned(2**CLOCK_PARAM-1, CLOCK_PARAM) else '0';

  tick : process(reset, clk)
  begin
    if reset = '0' then
      state  <= IDLE;
      show_r <= "0000";
    elsif rising_edge(clk) then
      if slow_clk_enable = '1' then
        state <= next_state;
        if do_sample = '1' then
          digit_0_r <= digit_0;
          digit_1_r <= digit_1;
          digit_2_r <= digit_2;
          digit_3_r <= digit_3;
          show_r    <= show;
        end if;
      end if;
    end if;
  end process;

  trans_func : process (digit_0_r, digit_1_r, digit_2_r, digit_3_r, show_r, state)
    variable state_v     : state_type;
    variable segments_v  : std_logic_vector(6 downto 0);
    variable enables_v   : std_logic_vector(3 downto 0);
    variable point_v     : std_logic;
    variable do_sample_v : std_logic;
    constant TRUE_C      : std_logic := '1';
    constant FALSE_C     : std_logic := '0';
    
  begin
    state_v     := state;
    segments_v  := not "0001000";   --stand by (led D on). INVERTION NEEDED !
    enables_v   := not "0000";          --INVERTION NEEDED !
    point_v     := '0';
    do_sample_v := FALSE_C;
    case state_v is
      when IDLE =>
        state_v     := D0;
        do_sample_v := TRUE_C;
      when D0 =>
        segments_v := digit_to_seven_seg(digit_0_r);
        if show_r(0) = '1' then
          enables_v := not "0001";      --INVERTION NEEDED !
        end if;
        state_v := D1;
      when D1 =>
        segments_v := digit_to_seven_seg(digit_1_r);
        if show_r(1) = '1' then
          enables_v := not "0010";      --INVERTION NEEDED !
        end if;
        state_v := D2;
      when D2 =>
        segments_v := digit_to_seven_seg(digit_2_r);
        if show_r(2) = '1' then
          enables_v := not "0100";      --INVERTION NEEDED !
        end if;
        state_v := D3;
      when D3 =>
        segments_v := digit_to_seven_seg(digit_3_r);
        if show_r(3) = '1' then
          enables_v := not "1000";      --INVERTION NEEDED !
        end if;
        state_v := DT;
      when DT =>
        point_v     := '1';
        do_sample_v := TRUE_C;
        state_v     := D0;
      when others => null;
    end case;

    next_state <= state_v;
    segments   <= segments_v;
    point      <= point_v;
    enables    <= enables_v;
    do_sample  <= do_sample_v;
  end process;

  
  
end rtl;
