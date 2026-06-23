library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mult_seq is

  port (
    clk, reset_n : in  std_logic;
    start        : in  std_logic;
    ack_a        : in  std_logic;
    ack_b        : in  std_logic;
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

  constant IDLE : std_logic_vector(3 downto 0) := "0001";
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


  -- signaux controleur --> datapath. A completer !
  -- shift <= ....
  -- etc

  -- signal vers l'exterieur (fin traitement). A completer !
  -- ready <= ...




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



  -----------------------------------------------------------------------------
  -- registres ACCU. A compléter !
  -----------------------------------------------------------------------------


  -----------------------------------------------------------------------------
  -- resultat vers l'exterieur.
  -----------------------------------------------------------------------------
  res <= std_logic_vector(accu_reg);

  -----------------------------------------------------------------------------
  -- signaux de status : A completer !
  -----------------------------------------------------------------------------
  -- lsb_a <= ...
  -- stop  <= ...

end logic;
