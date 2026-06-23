library ieee;
use ieee.std_logic_1164.all;

entity MonCircuit is
  port (
    reset_n : in std_logic;
    clk      : in std_logic;
    e1       : in std_logic;
    e2       : in std_logic;
    e3       : in std_logic_vector(3 downto 0);
    e4,e5    : in std_logic_vector(3 downto 0);
    o1       : out std_logic;
    o2       : out std_logic_vector(3 downto 0);
    o3       : out std_logic_vector(3 downto 0) --pas de ';' pour le dernier port
  ); --noter le ; ici
end MonCircuit; -- le nom du circuit est rappele ici.


architecture empty of MonCircuit is
begin
end empty;
