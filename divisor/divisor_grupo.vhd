library ieee;
use ieee.std_logic_1164.all;

entity divisor_grupo is
    generic (N : integer);
    port (clk, Reset, inicio: in std_logic;
        entA, entB : in std_logic_vector(N-1 downto 0);
        saida: out std_logic_vector(2*N-1 downto 0);
        pronto: out std_logic);
end divisor_grupo;

architecture arc of divisor_grupo is
end arc;