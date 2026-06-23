library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mult_seq is

  port (
    clk, reset_n : in  std_logic;
    start        : in  std_logic;
    req_x        : in  std_logic;
    req_y        : in  std_logic;
    x, y         : in  std_logic_vector(3 downto 0);
    ready        : out std_logic;
    p            : out std_logic_vector(3 downto 0)
    );
end mult_seq;

architecture pierre of mult_seq is

  type   state_type is (IDLE, ChX, ChY, Mult, S0, S1, S2, S3, S4);
  signal state, next_state : state_type;

  type control_type is record
    init  : std_logic;
    chRx  : std_logic;
    chRy  : std_logic;
    shift : std_logic;
    add   : std_logic;
  end record;

  constant NO_CONTROL : control_type := ('0', '0', '0', '0', '0');
  signal   control    : control_type;

  type status_type is record
    lsb  : std_logic;
    stop : std_logic;
  end record;

  signal status : status_type;

  signal RP_reg, B_Reg : unsigned(7 downto 0);
  signal A_Reg         : unsigned(3 downto 0);

begin

  tick : process (clk, reset_n)
  begin
    if reset_n = '0' then
      state <= IDLE;
    elsif rising_edge(clk) then
      state <= next_state;
    end if;
  end process;

  controler_next_state : process (req_x, req_y, start, state, status)
    variable state_v   : state_type;
    variable control_v : control_type;
  begin
    state_v   := state;
    control_v := NO_CONTROL;
    ready     <= '0';

    case state_v is
      when IDLE =>
        ready <= '1';
        if start = '1' then
          state_v := ChX;
        end if;
      when ChX =>
        if req_x = '1' then
          state_v        := ChY;
          control_v.chRx := '1';
          control_v.init := '1';
        end if;
      when ChY =>
        if req_y = '1' then
          state_v        := Mult;
          control_v.chRy := '1';
        end if;
      when Mult =>
        if status.stop = '1' then
          state_v := IDLE;
        else
          control_v.shift := '1';
          if status.lsb = '1' then
            control_v.add := '1';
          end if;
        end if;
      when others => null;
    end case;
    control    <= control_v;
    next_state <= state_v;
  end process;

  -------------------------------------------------------------------------------
  --datatpath elements
  -----------------------------------------------------------------------------

  B_reg_proc : process (clk, reset_n)
  begin
    if reset_n = '0' then
      B_Reg <= "00000000";
    elsif rising_edge(clk) then
      if control.chRx = '1' then
        B_Reg <= unsigned("0000" & x);
      elsif control.shift = '1' then
        B_Reg <= B_Reg(6 downto 0) & '0';
      end if;
    end if;
  end process;

  A_reg_proc : process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_Reg <= "0000";
    elsif rising_edge(clk) then
      if control.chRy = '1' then
        A_Reg <= unsigned(y);
      elsif control.shift = '1' then
        A_Reg <= '0' & A_Reg(3 downto 1);
      end if;
    end if;
  end process;

  ACCU : process (clk, reset_n)
    variable tmp : unsigned(3 downto 0);
  begin
    if reset_n = '0' then
      RP_reg <= to_unsigned(0, 8);
    elsif rising_edge(clk) then
      if control.init = '1' then
        RP_reg <= to_unsigned(0, 8);
      elsif control.add = '1' then
        RP_reg <= RP_reg + B_Reg;
      end if;
    end if;
  end process;

  status.lsb  <= A_reg(0);
  status.stop <= not(A_Reg(3) or A_Reg(2) or A_Reg(1) or A_Reg(0));

end pierre;
