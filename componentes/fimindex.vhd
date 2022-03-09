LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY fimindex IS
      generic (N : integer);
      PORT (a: integer;
            fim : OUT STD_LOGIC);
END fimindex;

ARCHITECTURE estrutura OF fimindex IS
BEGIN
      fim <= '1' WHEN a = -1 ELSE '0';
END estrutura;