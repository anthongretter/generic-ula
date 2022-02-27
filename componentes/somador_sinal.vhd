library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity somador_sinal is
    generic(N: integer);
	port(A, B: in std_logic_vector(N-1 downto 0);
		S: out std_logic_vector(N-1 downto 0));
end somador_sinal;

architecture arch of somador_sinal is
    -- somador comportamental
begin
    S <= A + B;
end arch;
