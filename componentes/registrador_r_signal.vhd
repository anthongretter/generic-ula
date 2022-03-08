LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY registrador_r_signal IS
PORT (clk, reset, carga : IN STD_LOGIC;
	  d : in std_logic;
	  q : out std_logic);
END registrador_r_signal;

ARCHITECTURE estrutura OF registrador_r_signal IS
BEGIN
	PROCESS(clk, reset)
	BEGIN
		IF(reset = '1') THEN
			q <= '0';
		ELSIF(clk'EVENT AND clk = '1' AND carga = '1') THEN
			q <= d;
		END IF;
	END PROCESS;
END estrutura;