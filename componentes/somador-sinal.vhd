library ieee;
use ieee.std_logic_1164.all;
use.ieee.numeric_std;

entity somador-sinal is
    generic(N: integer);
	port(A, B: in signed(N-1 downto 0);
		S: out signed(N-1 downto 0));
end somador-sinal;

architecture arch of somador-sinal is
    -- somador comportamental
begin
    S <= A + B;
end arch;
