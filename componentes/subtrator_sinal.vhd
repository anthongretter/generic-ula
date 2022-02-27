library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity subtrator_sinal is
      generic (N: integer);
      port (A, B: in std_logic_vector(N-1 downto 0);
            S: out std_logic_vector(N-1 downto 0));
end subtrator_sinal;

architecture arch of subtrator_sinal is

begin
    S <= A - B;
end arch;
