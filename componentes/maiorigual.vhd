LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY maiorigual IS
      generic (N : integer);
      PORT (a, b : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
            maiorigual : OUT STD_LOGIC);
END maiorigual;

ARCHITECTURE estrutura OF maiorigual IS
BEGIN
      maiorigual <= '1' WHEN a >= b ELSE '0';
END estrutura;