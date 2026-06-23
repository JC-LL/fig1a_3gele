library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

architecture clocked_1 of ab_plus_cd is
  --chemin combinatoire long mais borne' => Frequence basse +
  --1 process par entree.
  signal a_r,b_r,c_r,d_r : signed(n-1 downto 0);
  signal f_comb : signed(n+n-1 downto 0);
begin
  bascule_a : process(reset_n,clk)
  begin
    if reset_n='0' then
      a_r <= to_signed(0,n);
    elsif rising_edge(clk) then
      a_r <= a;
    end if;
  end process;

  bascule_b : process(reset_n,clk)
  begin
    if reset_n='0' then
      b_r <= to_signed(0,n);
    elsif rising_edge(clk) then
      b_r <= b;
    end if;
  end process;

  bascule_c : process(reset_n,clk)
  begin
    if reset_n='0' then
      c_r <= to_signed(0,n);
    elsif rising_edge(clk) then
      c_r <= c;
    end if;
  end process;

  bascule_d : process(reset_n,clk)
  begin
    if reset_n='0' then
      d_r <= to_signed(0,n);
    elsif rising_edge(clk) then
      d_r <= d;
    end if;
  end process;

  f_comb <= a_r*b_r+c_r*d_r;

  bascule_f : process(reset_n,clk)
  begin
    if reset_n='0' then
      f <= to_signed(0,2*n);
    elsif rising_edge(clk) then
      f <= f_comb;
    end if;
  end process;

end clocked_1;

architecture clocked_2 of ab_plus_cd is
  --chemin combinatoire long mais borne' => Frequence basse +
  --regroupement de processus.
  -- plus elegant que clocked_1 !!!
  signal a_r,b_r,c_r,d_r : signed(n-1 downto 0);
begin
  bascules_d : process(reset_n,clk)
  begin
    if reset_n='0' then
      a_r <= to_signed(0,n);
      b_r <= to_signed(0,n);
      c_r <= to_signed(0,n);
      d_r <= to_signed(0,n);
    elsif rising_edge(clk) then
      a_r <= a;
      b_r <= b;
      c_r <= c;
      d_r <= d;
      f <= a_r*b_r + c_r*d_r;
    end if;
  end process;
end clocked_2;

architecture clocked_3 of ab_plus_cd is
  --chemin combinatoire borne' et plus court => Frequence haute.
  signal a_r,b_r,c_r,d_r : signed(n-1 downto 0);
  signal prod1,prod2 : signed(2*n-1 downto 0);
begin
  bascules_d : process(reset_n,clk)
  begin
    if reset_n='0' then
      a_r <= to_signed(0,n);
      b_r <= to_signed(0,n);
      c_r <= to_signed(0,n);
      d_r <= to_signed(0,n);
    elsif rising_edge(clk) then
      a_r <= a;
      b_r <= b;
      c_r <= c;
      d_r <= d;
    end if;
  end process;

  prod1 <= a_r*b_r;
  prod2 <= c_r*d_r;

  bascules_res : process(reset_n,clk)
  begin
    if reset_n='0' then
      f <= to_signed(0,2*n);
    elsif rising_edge(clk) then
      f <= prod1+prod2;
    end if;
  end process;

end clocked_3;
