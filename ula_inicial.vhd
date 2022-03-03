library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity ula_inicial is
	generic(N: INTEGER := 4);
	port(clk, reset, inicio: in std_logic;
		entradaA, entradaB: in std_logic_vector(N-1 downto 0);
		op: in std_logic_vector(3 downto 0);
		pronto: out std_logic;
		saidaPQ: out std_logic_vector(N-1 downto 0);
		saidaS: out std_logic_vector(N-1 downto 0));
end ula_inicial;

architecture arch of ula_inicial is
	
	component multiplicador_grupo is
		generic (N : integer);
		port (clk, Reset, inicio: in std_logic;
			entA, entB : in std_logic_vector(N-1 downto 0);
			saida: out std_logic_vector(2*N-1 downto 0);
			pronto: out std_logic);
	end component;
	
	component subtrator_sinal is
      generic (N: integer);
      port (A, B: in std_logic_vector(N-1 downto 0);
            S: out std_logic_vector(N-1 downto 0));
	end component;
	
	component somador_sinal is
    generic(N: integer);
		port(A, B: in std_logic_vector(N-1 downto 0);
		S: out std_logic_vector(N-1 downto 0));
	end component;
	
	component mux2para1 is
	generic (N : integer);
	PORT ( a, b : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        sel: IN STD_LOGIC;
        y : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0));
	end component;
	
	signal multSaidaSig: std_logic_vector((2*N)-1 downto 0);
	signal saidaSoma, saiMuxEntradaB, saidaSub: std_logic_vector(N-1 downto 0);
	signal um: std_logic_vector(N-2 downto 0) := (others => '0');
	signal zero: std_logic_vector(N-1 downto 0) := (others => '0');
	
	
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
			
	begin
		with op select
			saidaS <= zero when "0000",
					saidaSoma when "0001",
					saidaSub when "0010",
					saidaSoma when "0011",
					saidaSub when "0100",
					not entradaA when "0101",
					entradaA and entradaB when "0110",
					entradaA or entradaB when "0111",
					entradaA xor entradaB when "1000",
					multSaidaSig(N-1 downto 0) when "1001",
					zero when others;
		with op select
			saidaPQ <= multSaidaSig((2*N)-1 downto N) when "1001",
						zero when others;
			
	-- somador COM SINAL
	somaEntradas: somador_sinal generic map(N => N)
	port map(
		A => entradaA,
		B => saiMuxEntradaB,
		S => saidaSoma
		);
			
	-- subtrator COM SINAL
	subtraiEntradas: subtrator_sinal generic map(N => N)
	port map(
		A => entradaA,
		B => saiMuxEntradaB,
		S => saidaSub
		);
	
	
	-- entradaB quando 0 e um quando 1
	muxEntradaB: mux2para1 generic map(N => N)
	port map(
		a => entradaB,
		b => um&'1',
		sel => op(2) or (op(1) and op(0)),
		y => saiMuxEntradaB
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
	