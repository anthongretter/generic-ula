library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity checa_potencia is
	generic (N : integer);
	port (
		entB : in std_logic_vector(N - 1 downto 0);
		zeros : out integer range 0 to N - 1);
end checa_potencia;
architecture estrutura of checa_potencia is
	signal posicao : integer range 0 to N;

begin
	process (entB)
		variable i : integer;
	begin
		i := N - 1;
		L3 : while i >= 0 loop
			if entB(i) = '1' then
				posicao <= i;
				exit L3;
			end if;
			i := i - 1;
		end loop L3;
	end process;

	zeros <= posicao;

end estrutura;