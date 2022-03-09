library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity tb_projeto is
end tb_projeto;

architecture arch of tb_projeto is
	constant CLK_PERIOD: time := 20ns;
	signal clk, Reset, flagZ, flagN, flagOVF : std_logic := '0';
	signal opcode: std_logic_vector(3 downto 0);
	signal PQ, S, mem_dados, A, B: std_logic_vector(7 downto 0);
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
		opcode => opcode,
		mem_dados => mem_dados,
		A => A,
		B => B);

	-- clock
	clk <= not clk after CLK_PERIOD;

	-- control
	Reset <= '1','0' after 10 ns;
	
end arch;