LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY regPC IS
generic (N : integer);
PORT (clk, reset, carga : IN STD_LOGIC;
	  d : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
	  q : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0));
END regPC;

ARCHITECTURE estrutura OF regPC IS
signal ZERO: std_logic_vector(N-1 downto 0) := (others => '0');
BEGIN
	PROCESS(clk, reset)
	BEGIN
		IF(reset = '1') THEN
			q <= ZERO;
		ELSIF(clk'EVENT AND clk = '1' AND carga = '1') THEN
			q <= d + 1;
		END IF;
	END PROCESS;
END estrutura;