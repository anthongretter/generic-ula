library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;  

entity bo is
      generic (N : integer);
      port (
            clk : in std_logic;
            carga_Entradas, mux_B, carga_mult, mux_mult : in std_logic;
            entA, entB : in std_logic_vector(N - 1 downto 0);
            Az, Bz: out std_logic;
            mult : out std_logic_vector(2*N - 1 downto 0)); 
end bo;
architecture estrutura of bo is

      component registrador is
            generic (N : integer);
            port (
                  clk, carga : in std_logic;
                  d : in std_logic_vector(N - 1 downto 0);
                  q : out std_logic_vector(N - 1 downto 0));
      end component;

      component mux2para1 is
            generic (N : integer);
            port (
                  a, b : in std_logic_vector(N - 1 downto 0);
                  sel : in std_logic;
                  y : out std_logic_vector(N - 1 downto 0));
      end component;

      component somador is
            generic(N: integer);
            port(A, B: in std_logic_vector(N-1 downto 0);
                  S: out std_logic_vector(N-1 downto 0));
      end component;

      component subtrator is
            generic (N: integer);
            port (A, B: in std_logic_vector(N-1 downto 0);
                  S: out std_logic_vector(N-1 downto 0));
      end component;

      component igualazero is
            generic (N : integer);
            port (
                  a : in std_logic_vector(N - 1 downto 0);
                  igual : out std_logic);
      end component;

      component checa_potencia is
            generic (N : integer);
            port (
                  entB : in std_logic_vector(N - 1 downto 0);
                  zeros : out integer range 0 to N - 1);
      end component;

      signal ZERO : std_logic_vector(N - 1 downto 0)  := (others => '0');
      signal sairegMult, saimuxB, sairegA, sairegB, saimuxMult, saiSoma, saiSub: std_logic_vector (2*N - 1 downto 0);
      signal quant_zero : integer range 0 to 2*N - 1;
      signal zero_um: std_logic_vector(2*N - 2 downto 0):= (others => '0');

begin


      regA : registrador generic map(N => 2*N)
      port map
      (
            clk => clk,
            carga => carga_Entradas,
            d => ZERO&entA, -- transforma pro max bit 
            q => sairegA
      );
      
      muxB: mux2para1 generic map (N => 2*N)
      port map
      (
            a => saiSub,    -- sub de B - potencia
            b => ZERO&entB, -- transforma pro max bit 
            sel => mux_B,
            y => saimuxB
      );

      regB : registrador generic map(N => 2*N)
      port map
      (
            clk => clk,
            carga => carga_Entradas,
            d => saimuxB,
            q => sairegB
      );

      quantosZero: checa_potencia generic map(N => 2*N)
      port map
      (
            entB => sairegB,
            zeros => quant_zero 
      );


      muxMult: mux2para1 generic map (N => 2*N)
      port map
      (
            a => saiSoma,     -- soma da mult
            b => ZERO&ZERO,
            sel => mux_mult,
            y => saimuxMult
      );

      regMult : registrador generic map(N => 2*N)
      port map
      (
            clk => clk,
            carga => carga_mult,
            d => saimuxMult,
            q => sairegMult
      );

      soma: somador generic map (N => 2*N)
      port map
      (
            A => sairegMult,
            B => std_logic_vector(shift_left(unsigned(sairegA), quant_zero)),
            S => saiSoma
      );

      sub: subtrator generic map(N => 2*N)
      port map
      (
            A => sairegB,
            B => std_logic_vector(shift_left(unsigned(zero_um &'1'), quant_zero)),
            S => saiSub
      );

	geraAz: igualazero generic map(N  => 2*N) 
      port map 
      (
            a => sairegA,
            igual => Az
      ); 

      geraBz: igualazero generic map(N  => 2*N) 
      port map 
      (
            a => sairegB,
            igual => Bz
      ); 


	mult <= sairegMult;
end estrutura;