library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mult_seq is

  port (
    clk, reset_n : in  std_logic;
    start        : in  std_logic;
    req_a        : in  std_logic;
    req_b        : in  std_logic;
    a, b         : in  std_logic_vector(3 downto 0);
    ready        : out std_logic;
    res          : out std_logic_vector(7 downto 0)
    );
end mult_seq;

-------------------------------------------------------------------------------
-- architecture LOGIC : VHDL restreint a l'UV 1.5
-------------------------------------------------------------------------------
architecture logic of mult_seq is

  signal state, next_state : std_logic_vector(3 downto 0);

  -- assignation des encodages des etats (encodage one-hot)
  constant IDLE   : std_logic_vector(3 downto 0) := "0001";
  constant WAIT_A : std_logic_vector(3 downto 0) := "0010";
  constant WAIT_B : std_logic_vector(3 downto 0) := "0100";
  constant MULT   : std_logic_vector(3 downto 0) := "1000";

  -- signaux de controle
  signal init  : std_logic;
  signal chRa  : std_logic;
  signal chRb  : std_logic;
  signal shift : std_logic;
  signal add   : std_logic;

  -- registre du datapath
  signal accu_reg, accu_reg_comb : unsigned(7 downto 0);
  signal reg_b, reg_b_comb       : unsigned(7 downto 0);
  signal reg_a, reg_a_comb       : unsigned(3 downto 0);

  -- signaux de status : datapath => controleur
  signal stop  : std_logic;
  signal lsb_a : std_logic;

begin

  -----------------------------------------------------------------------------
  -- >>>>>>>>>>>>>>> Controleur <<<<<<<<<<<<<<<
  -----------------------------------------------------------------------------
  bascules_etat : process (clk, reset_n)
  begin
    if reset_n = '0' then
      state <= IDLE;
    elsif rising_edge(clk) then
      state <= next_state;
    end if;
  end process;

  -- logique combinatoire d'etat suivant. A completer !
  -- next_state(0) <= ....
  -- etc
  next_state(0) <= (state(3) and stop) or (state(0) and not(start));
  next_state(1) <= (state(0) and start) or (state(1) and not(req_a));
  next_state(2) <= (state(1) and req_a) or (state(2) and not(req_b));
  next_state(3) <= (state(2) and req_b) or (state(3) and not(stop));

  -- signaux controleur --> datapath. A completer !
  -- shift <= ....
  -- etc
  shift <= state(3);
  add   <= state(3) and lsb_a;
  chrA  <= state(1) and req_a;
  init  <= state(1) and req_a;
  chrB  <= state(2) and req_b;
  -- signal vers l'exterieur (fin traitement). A completer !
  -- ready <= ...
  ready <= state(0);



  -------------------------------------------------------------------------------
  -- >>>>>>>>>>>>>>> DATATPATH <<<<<<<<<<<<<<
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  -- registre A
  -----------------------------------------------------------------------------
  a_reg_proc : process (clk, reset_n)
  begin
    if reset_n = '0' then
      reg_a <= "0000";
    elsif rising_edge(clk) then
      reg_a <= reg_a_comb;
    end if;
  end process;

  reg_a_comb <= unsigned(a) when chRa = '1' else
                '0' & reg_a(3 downto 1) when shift = '1' else
                reg_a;

  -----------------------------------------------------------------------------
  -- registre B. A completer !
  -----------------------------------------------------------------------------
  b_reg_proc : process (clk, reset_n)
  begin
    if reset_n = '0' then
      reg_b <= "00000000";
    elsif rising_edge(clk) then
      reg_b <= reg_b_comb;
    end if;
  end process;

  reg_b_comb <= unsigned("0000" & b) when chRb = '1' else
                reg_b(6 downto 0) & '0' when shift = '1' else
                reg_b;
  -----------------------------------------------------------------------------
  -- registres ACCU. A compléter !
  -----------------------------------------------------------------------------
  ACCU : process (clk,reset_n)
  begin
    if reset_n = '0' then
      accu_reg <= "00000000";
    elsif rising_edge(clk) then
      accu_reg <= accu_reg_comb;
    end if;
  end process;

  accu_reg_comb <= "00000000" when init = '1' else
                   accu_reg + reg_b when add = '1' else
                   accu_reg;

  -----------------------------------------------------------------------------
  -- resultat vers l'exterieur.
  -----------------------------------------------------------------------------
  res <= std_logic_vector(accu_reg);

  -----------------------------------------------------------------------------
  -- signaux de status : A completer !
  -----------------------------------------------------------------------------
  -- lsb_a <= ...
  lsb_a <= reg_a(0);
  -- stop  <= ...
  stop  <= not(reg_a(3) or reg_a(2) or reg_a(1) or reg_a(0));
end logic;
