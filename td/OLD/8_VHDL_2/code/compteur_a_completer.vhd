library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity compteur is
  port(
    reset_n : in  std_logic;
    clk     : in  std_logic;
    value   : out unsigned(7 downto 0)
  );
end compteur;

architecture arch1 of compteur is
  -- declarations eventuelles des signaux locaux à l'architecture
begin

  -- Assignations concurrentes : a <= b+c;

  -- Processus :
  -- process(reset_n,clk)
  -- begin
  -- ....
  -- end process;

  -- Instanciation :
  -- entity work.circuit(arch)
  --   port map(
  --      port_formel => signal,
  --      etc...
  -- );

end arch1;
