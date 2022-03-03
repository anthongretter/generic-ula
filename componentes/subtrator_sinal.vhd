library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity subtrator_sinal is
      generic (N: integer);
      port (A, B: in std_logic_vector(N-1 downto 0);
            S: out std_logic_vector(N-1 downto 0);
				OVF: out std_logic);
end subtrator_sinal;

architecture arch of subtrator_sinal is
signal Y: std_logic_vector(N-1 downto 0) := (others => '0');

begin
	 Y <= A - B;
	 OVF <= '1' when (A(N-1) /= B(N-1) and (B(N-1) = Y(N-1))) else '0';
	 S <= Y;
end arch;
