library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity ula is
	generic(N: INTEGER := 4);
	port(clk, reset, inicio: in std_logic;
		entradaA, entradaB: in std_logic_vector(N-1 downto 0);
		op: in std_logic_vector(1 downto 0);
		pronto: out std_logic;
		saida: out std_logic_vector(2*N-1 downto 0));
end ula;

architecture arch of ula is
	
	component multiplicador_grupo is
		generic (N : integer);
		port (clk, Reset, inicio: in std_logic;
			entA, entB : in std_logic_vector(N-1 downto 0);
			saida: out std_logic_vector(2*N-1 downto 0);
			pronto: out std_logic);
	end component;
	
	signal multSaidaSig: std_logic_vector(2*N-1 downto 0);

		-- somador quando 00
		-- subtrator quando 01
		-- multiplicador quando 11 
		-- divisor quando 10

	begin
		with op select
			saida <= "00000000" when "00",
					"00000000" when "01",
					multSaidaSig when "11",
					"00000000" when others;
	
	-- somador
	
	-- divisor
	
	-- subtrator
	
	-- multiplicador
		mult: multiplicador_grupo generic map(N => N)
		port map (
			clk => clk,
			reset => reset,
			inicio => inicio,
			pronto => pronto,
			entA => entradaA,
			entB => entradaB,
			saida => multSaidaSig
		);
	
end arch;
	