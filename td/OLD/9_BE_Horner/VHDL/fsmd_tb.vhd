library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fsmd_tb is
end entity;

architecture bhv of fsmd_tb is
  constant n : natural :=8;

  constant HALF_PERIOD : time :=5 ns;

  signal clk : std_logic := '0';
  signal reset_n : std_logic := '0';

  signal running : boolean := true;

  procedure wait_cycles(nb_cycles : natural) is
  begin
    for i in 1 to nb_cycles loop
      wait until rising_edge(clk);
    end loop;
  end procedure;

  signal go,done : std_logic;

  signal sig_x       : unsigned(n - 1 downto 0);
  signal sig_a0      : unsigned(n - 1 downto 0);
  signal sig_a1      : unsigned(n - 1 downto 0);
  signal sig_a2      : unsigned(n - 1 downto 0);
  signal sig_a3      : unsigned(n - 1 downto 0);
  signal sig_px      : unsigned(4 * n + 3 - 1 downto 0);

  function polynome(a3,a2,a1,a0,x : natural)  return natural is
  begin
    return a3*x**3 + a2*x**2 +a1*x +a0;
  end function;
begin
  ----------------------------------------------------------
  -- clock and reset
  ----------------------------------------------------------
  reset_n <= '0','1' after 123 ns;

  clk <= not(clk) after HALF_PERIOD when running else clk;
  ----------------------------------------------------------
  -- Design Under Test
  ----------------------------------------------------------
  dut : entity work.fsmd(rtl)
    generic map(n=> 8)
    port map (
      reset_n => reset_n,
      clk     => clk    ,
      go      => go     ,
      done    => done   ,
      x       => sig_x      ,
      a0      => sig_a0     ,
      a1      => sig_a1     ,
      a2      => sig_a2     ,
      a3      => sig_a3     ,
      px      => sig_px     );
  ------------------------------------------------------
  -- sequential stimuli
  ------------------------------------------------------
  stim : process
    variable px_expected,px_actual : natural;
    variable nb_errors : natural :=0;
    constant NB_TESTS : natural := 20;
  begin
    go <= '0';
    sig_x  <= to_unsigned(0,n);
    sig_a0 <= to_unsigned(0,n);
    sig_a1 <= to_unsigned(0,n);
    sig_a2 <= to_unsigned(0,n);
    sig_a3 <= to_unsigned(0,n);

    report "running testbench for fsmd(rtl)";
    report "waiting for asynchronous reset";
    wait until reset_n='1';
    wait_cycles(10);
    report "p(x)=4x^3 +3x^2 + 2^x + 1";
    report "sending parameters a0...a3";
    sig_a0 <= to_unsigned(1,n);
    sig_a1 <= to_unsigned(2,n);
    sig_a2 <= to_unsigned(3,n);
    sig_a3 <= to_unsigned(4,n);
    wait_cycles(10);
    for val in 0 to NB_TESTS-1 loop
      px_expected := polynome(4,3,2,1,val); -- reference model (here in VHDL itself)
      report "expected p(" & integer'image(val) & ")=" & integer'image(px_expected);
      go <= '1';
      sig_x <= to_unsigned(val,n);
      wait_cycles(1);
      go <= '0';
      wait_cycles(1);
      wait until done='1';
      wait_cycles(1);
      px_actual:=to_integer(sig_px);
      report "actual : p(" & integer'image(val) & ")=" & integer'image(px_actual);
      if px_expected/=px_actual then
        nb_errors:=nb_errors+1;
      end if;
    end loop;
    report "end of simulation";
    report "number of errors : " & integer'image(nb_errors) & " / " & integer'image(NB_TESTS) & " tests";
    wait_cycles(20); -- cosmetic
    running <= false;
    wait;
  end process;
end bhv;
