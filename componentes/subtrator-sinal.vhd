library ieee;
use ieee.std_logic_1164.all;
use.ieee.numeric_std;

entity subtrator-sinal is
      generic (N: integer);
      port (A, B: in signed(N-1 downto 0);
            S: out signed(N-1 downto 0));
end subtrator-sinal;

architecture arch of subtrator-sinal is

begin
    S <= A - B;
end arch;
