library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity divisor_grupo is
    generic (N : integer := 4);
    port (reset, inicio: in std_logic;
        entA, entB : in std_logic_vector(N-1 downto 0);
        quociente, resto: out std_logic_vector(N-1 downto 0);
        pronto, erro: out std_logic);
end divisor_grupo;

architecture arc of divisor_grupo is
    signal quo, res, zeros : std_logic_vector(N-1 downto 0) := (others => '0');

begin
    P : process(inicio)
        variable i : integer;
    begin
        if (inicio = '1') then
            i := N - 1;
            pronto <= '0';
            erro <= '0';

            L : while i > -1 loop
					if (entB = zeros) then
						 erro <= '1';
						 exit L;
					end if;
				
                res <= std_logic_vector(shift_left(unsigned(res), 1));
                res(i) <= entA(i);
                
                if (res >= entB) then
                    res <= res - entB;
                    quo(i) <= '1';
                end if;
                i := i - 1;
            end loop L;
            pronto <= '1';
        end if;
    end process;

    quociente <= quo;
    resto <= res;

end arc;