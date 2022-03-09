library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity tb_projeto is
end tb_projeto;

architecture arch of tb_projeto is
	constant CLK_PERIOD: time := 20ns;
	signal clk, Reset, flagZ, flagN, flagOVF, termina_op : std_logic := '0';
	signal PQ, S: std_logic_vector(7 downto 0);
begin

	UUT: entity work.projeto
		port map(
		clk => clk,
		Reset => Reset,
      PQ => PQ,
		S => S,
		flagZ => flagZ,
		flagN => flagN,
		flagOVF => flagOVF,
		termina_op => termina_op);

	-- clock
	clk <= not clk after CLK_PERIOD;

	-- control
	Reset <= '1','0' after 10 ns;
	
end arch;