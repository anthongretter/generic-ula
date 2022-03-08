library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity tb_ula_inicial is
end tb_ula_inicial;

architecture arch of tb_ula_inicial is
	constant CLK_PERIOD: time := 15ns;
	constant N: integer := 4;
	signal clk, reset, pronto, flag_OVF, flag_Z, flag_N: std_logic := '0';
	signal entradaA, entradaB, saidaPQ, saidaS: std_logic_vector(N-1 downto 0);
	signal op: std_logic_vector(3 downto 0);

begin

	UUT: entity work.ula_inicial generic map(N => N)
	port map (
		clk => clk,
		entradaA => entradaA,
		entradaB => entradaB,
		reset => reset,
		op => op,
		pronto => pronto,
		saidaPQ => saidaPQ,
		saidaS => saidaS,
		flag_OVF => flag_OVF,
		flag_Z => flag_Z,
		flag_N => flag_N);
	
	-- clock
	clk <= not clk after CLK_PERIOD;

	-- control
--	inicio <= '1' when pronto = '1' else '0';
	reset <= '0';
	-- tenho que testar todas as 10 operações, com mais de um caso para soma, sub, mult...
	-- a minha ula tá recebendo pronto e saindo inicio. isso é necessário? 
	-- pronto: sinal tá saindo do multiplicador pra me dizer se a multiplicacao terminou. vai ser util no bc geral da ula.

	-- inicio: entra no mult para saber se ele deve começar o processo, também, então ele deve ser 1 só no caso da multiplicacao. PROVAVELMENTE, vou ter que dividir em inicio_mult e inicio_div, já que os dois tem máquina de estados, e esses valores vão ser pegos... do opcode? análise futura. a lógica atual aqui nesse tb é iniciar quando pronto é 1 porque pronto só é um no s0 do mult; ver isso também...
	-- mas o bc desse projeto só controla enables de A e B na ula. talvez adaptar pra quando o opcode for de mult inserir um inicio especifico na entradamult, base de signal? pensamentos futuros...

	-- entradas. 
	-- lembrete: 4 bits alcanca [-8,7], sendo 7 0111 e -8 1000
	entradaA <= "1111", 
	"0010" after 30 ns, -- comeca soma 1, deve dar 0101
	"0011" after 60 ns, -- soma com signal (3 - 4), resultado deve ser 1111 (-1 em c2)
	"0111" after 90 ns, -- CASO OVERFLOW (ainda nao implementado. uma flag é a melhor saida)
	"0011" after 120 ns, --- COMECA SUBTRAAO, 3-1 = 2
  "0011" after 150 ns, --- SUBTRACAO CASO 3 - (-1) = 4
	"1001" after 180 ns, --- caso overflow, nao implementado.
	"0010" after 210 ns, -- incremento numero positivo (deve dar 0011)
	"1000" after 240 ns, -- incremento numero negativo, deve dar -7 (1001)
	"0010" after 270 ns, -- decremento numero positivo, deve dar 0001
	"1001" after 300 ns, --- decremento numero negativo, deve dar 1000
	"0101" after 330 ns, -- not A
	"0101" after 360 ns; -- A and B, A or B, A xor B, etc.


	entradaB <= "1111", 
	"0011" after 30 ns, -- comeca soma
	"1100" after 60 ns, -- soma com signal
	"0010" after 90 ns, -- caso overflow
	"0001" after 120 ns, -- SUBTRACAO 3 - 1
	"1111" after 150 ns, -- subtbracao c numero neg
	"0010" after 180 ns, -- caso overflow, nao implementado.
	"0000" after 210 ns, -- incremento e decremento
	"1100" after 360 ns; -- A and B


	op <= "0000", -- saidas devem ser zero
				"0001" after 30 ns, --- soma A + B, teste: normal, negativo, overflow.
				"0010" after 120 ns, --- subtracao A - B
				"0011" after 210 ns, -- incrementa em A
				"0100" after 270 ns, -- decremento em A
				"0101" after 330 ns, -- not A
				"0110" after 360 ns, -- A and B bit a bit
				"0111" after 390 ns, -- A or B bit a bit
				"1000" after 410 ns, -- A xor B bit a bit
				"1001" after 440 ns; -- A * b

-- no caso da mult, eu quero 0011 e 1100 em PQ e S 			


end arch;
