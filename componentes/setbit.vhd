library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity setbit is
    generic (N : integer);
    port (v : in std_logic_vector(N-1 downto 0);
            s : out std_logic_vector(N-1 downto 0);
            index : integer range 0 to N-1;
            b : std_logic);
end setbit;
architecture estrutura of setbit is
begin
    s <= v; s(index) <= b;
end estrutura;