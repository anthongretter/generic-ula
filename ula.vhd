library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use.ieee.numeric_std;


entity ula is
	generic(N: INTEGER := 4);
	port(clk, reset, inicio: in std_logic;
		entradaA, entradaB: in std_logic_vector(N-1 downto 0);
		op: in std_logic_vector(3 downto 0);
		pronto: out std_logic;
		saidaPQ: out std_logic_vector(N-1 downto 0);
		saidaS: out std_logic_vector(N-1 downto 0));
end ula;

architecture arch of ula is
	
	component multiplicador_grupo is
		generic (N : integer);
		port (clk, Reset, inicio: in std_logic;
			entA, entB : in std_logic_vector(N-1 downto 0);
			saida: out std_logic_vector(2*N-1 downto 0);
			pronto: out std_logic);
	end component;
	
	component subtrator-sinal is
      generic (N: integer);
      port (A, B: in signed(N-1 downto 0);
            S: out signed(N-1 downto 0));
	end component;
	
	component somador-sinal is
    generic(N: integer);
		port(A, B: in signed(N-1 downto 0);
		S: out signed(N-1 downto 0));
	end component;
	
	signal multSaidaSig: std_logic_vector(2*N-1 downto 0);
	signal saidaSoma: signed(N-1 downto 0);
	signal saidaSub: signed(N-1 downto 0);
	signal um: signed(N-2 downto 0) := (others => '0');
	signal zero: std_logic_vector(N-1 downto 0) := (others => '0');
	signal saidaIncremento: signed(N-1 downto 0);
	signal saidaDecremento: signed(N-1 downto 0);
	
	
			-- 0000: no operation
			-- 0001: soma 
			-- 0010: sub 
			-- 0011: incrementa 1 em A
			-- 0100: decrementa 1 em A
			-- 0101: not A
			-- 0110 A and B bit a bit
			-- 0111: A or B bit a bit
			-- 1000: A xor B bit a bit
			-- 1001: A * B
			-- 1010: divisao inteira A/B
			-- 1111: Halt??

			-- COMENTÁRIO DO PROFESSOR NA AULA
			-- o others da ula deve ser undefined: (others => 'U') when others;
			-- para evitar latches inferidos
			
	saidaPQ <= zero
	begin
		with op select
			saidaS <= zero when "0000",
					saidaSoma when "0001",
					saidaSub when "0010",
					saidaIncremento when "0011",
					saidaDecremento when "0100",
					not A when "0101",
					entradaA and entradaB when "0110",
					entradaA or entradaB when "0111",
					entradaA xor entradaB when "1000",
					multSaidaSig[N/2 to 0] when "1001",
					zero when others;
			saidaPQ <= multSaidaSig[N-1 to N/2] when "1001",
	-- somador COM SINAL
	somaEntradas: somador-sinal generic map(N => N)
	port map(
		A => entradaA,
		B => entradaB,
		S => saidaSoma
		);
			
	-- subtrator COM SINAL
	subtraiEntradas: subtrator-sinal generic map(N => N)
	port map(
		A => entradaA,
		B => entradaB,
		S => saidaSub
		);
	
	-- incrementa
	incremento: somador-sinal generic map(N => N)
	port map(
		A => entradaA,
		B => um&'1'
		S => saidaIncremento
		);
		
	-- decrementa
	decremento: subtrator-sinal generic map(N => N)
	port map(
		A => entradaA,
		B => um&'1'
		S => saidaDecremento
		);
	
	
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
	