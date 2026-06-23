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
end MultSeq;

architecture pierre of mult_seq is

  signal state, next_state : std_logic_vector(1 downto 0);

  -- signaux de controle
  signal init  : std_logic;
  signal chRx  : std_logic;
  signal chRy  : std_logic;
  signal shift : std_logic;
  signal add   : std_logic;

  -- signaux de status
  signal lsb   : std_logic;
  signal stop  : std_logic;

  -- signaux de sortie des registres
  signal RP_reg, B_Reg : unsigned(7 downto 0);
  signal A_Reg         : unsigned(3 downto 0);

begin

  tick : process (clk, reset_n)
  begin
    if reset_n = '0' then
      state <= "00";
    elsif rising_edge(clk) then
      state <= next_state;
    end if;
  end process;

  controler_next_state : process (req_x, req_y, start, state, lsb, stop)
  begin
    -- à completer !!!
  end process;

  -------------------------------------------------------------------------------
  --datatpath elements
  -----------------------------------------------------------------------------
  A_reg_proc : process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_Reg <= "0000";
    elsif rising_edge(clk) then
      A_Reg <= A_Reg_comb;
    end if;
  end process;

  A_Reg_comb <= unsigned(y) when chRy = '1' else
                control.shift = '1' when shift = '1' else
                A_Reg;

  B_reg_proc : process (clk, reset_n)
  begin
    -- a completer !!!
  end process;

  ACCU : process (clk, reset_n)
  begin
    -- a completer !!!
  end process;

  -----------------------------------------------------------------------------
  -- signaux de status
  -----------------------------------------------------------------------------
  res <= std_logic_vector(accu_reg);
  lsb  <= A_reg(0);
  stop <= not(A_Reg(3) or A_Reg(2) or A_Reg(1) or A_Reg(0));

end pierre;
