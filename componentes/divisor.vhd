library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_UNSIGNED.all;  
use IEEE.STD_LOGIC_ARITH.all; 
 
entity divisor is  
    generic(N: INTEGER := 8); 
    port(reset: in STD_LOGIC; 
        en: in STD_LOGIC; 
        clk: in STD_LOGIC; 
         
        num: in STD_LOGIC_VECTOR((N - 1) downto 0); 
        den: in STD_LOGIC_VECTOR((N - 1) downto 0); 
        quociente: out STD_LOGIC_VECTOR((N - 1) downto 0); 
        resto: out STD_LOGIC_VECTOR((N - 1) downto 0);
		  pronto: out std_logic); 
end divisor; 
 
architecture behav of divisor is 
    signal buf: STD_LOGIC_VECTOR((2 * N - 1) downto 0); 
    signal dbuf: STD_LOGIC_VECTOR((N - 1) downto 0); 
    signal sm: INTEGER range 0 to N; 
	 signal zero: std_logic_vector(N-1 downto 0) := (others => '0');
     
    alias buf1 is buf((2 * N - 1) downto N); 
    alias buf2 is buf((N - 1) downto 0); 
begin 
    p_001: process(reset, en, clk) 
    begin 
        if reset = '1' then 
            quociente <= (others => '0'); 
            resto <= (others => '0'); 
            sm <= 0; 
        elsif rising_edge(clk) then 
            if en = '1' then 
                case sm is 
                when 0 => 
                    buf1 <= (others => '0'); 
                    buf2 <= num; 
                    dbuf <= den; 
                    quociente <= buf2; 
                    resto <= buf1; 
                    sm <= sm + 1;
						  	if buf2 /= zero and buf1 /= zero then
								pronto <= '1';
							else
								pronto <= '0';
							end if;
                when others => 
                    if buf((2 * N - 2) downto (N - 1)) >= dbuf then 
                        buf1 <= '0' & (buf((2 * N - 3) downto (N - 1)) - dbuf((N - 2) downto 0)); 
                        buf2 <= buf2((N - 2) downto 0) & '1'; 
                    else 
                        buf <= buf((2 * N - 2) downto 0) & '0'; 
                    end if; 
                    if sm /= N then 
                        sm <= sm + 1; 
                    else 
                        sm <= 0; 
                    end if; 

                end case; 
            end if; 
        end if; 
    end process; 
end behav;