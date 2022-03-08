library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;  

entity bo_div is
      generic (N : integer);
      port (clk, carga_entradas, carga_quociente, reset_res : in std_logic;
            divisor_zero, resto_maiorigual : out std_logic;
            entA, entB : in std_logic_vector(N - 1 downto 0);
            quociente : out std_logic_vector(N - 1 downto 0);
            resto : out std_logic_vector(N - 2 downto 0)); 
end bo_div;
architecture estrutura of bo_div is
      
      -- altera um bit de um vetor
      function set_bit (v : in std_logic_vector(N - 1 downto 0),
                        index : in integer, bit : in std_logic) return std_logic_vector is

            variable sv : std_logic_vector(N - 1 downto 0);
      begin 
            sv <= v;
            sv[index] <= bit;
            return sv;
      end set_bit;

      component registrador is
            generic (N : integer);
            port (clk, carga : in std_logic;
                  d : in std_logic_vector(N - 1 downto 0);
                  q : out std_logic_vector(N - 1 downto 0));
      end component;

      component registrador_r is
            generic (N : integer);
            port (clk, reset, carga : in std_logic;
                  d : in std_logic_vector(N-1 DOWNTO 0);
                  q : out std_logic_vector(N-1 DOWNTO 0));
      end component;

      component mux2para1 is
            generic (N : integer);
            port (a, b : in std_logic_vector(N - 1 downto 0);
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
            port (a : in std_logic_vector(N - 1 downto 0);
                  igual : out std_logic);
      end component;

      signal ZERO : std_logic_vector(N - 1 downto 0) := (others => '0');
      signal saireg_dividendo, saireg_divisor, saireg_quo: std_logic_vector(N - 1 downto 0);
      signal saireg_res: std_logic_vector(N - 2 downto 0);

begin

      -- Registradores

      REG_DIVIDENDO : registrador generic map (N => N)
      port map
      (
            clk => clk,
            carga => carga_entradas,
            d => entA,
            q => saireg_dividendo
      );

      REG_DIVISOR : registrador generic map (N => N)
      port map
      (
            clk => clk,
            carga => carga_entradas,
            d => entB,
            q => saireg_divisor
      );

      REG_QUOCIENTE : registrador_r generic map (N => N)
      port map
      (
            clk => clk,
            carga => carga_quociente,
            reset => reset_saidas,
            d => saimuxB,
            q => saireg_quo
      );

      REG_RESTO : registrador_r generic map (N => N-1)
      port map
      (
            clk => clk,
            carga => carga_div,
            reset => reset_saidas,
            d => saimuxdiv,
            q => saireg_res
      );

      -- soma: somador generic map (N => 2*N)
      -- port map
      -- (
      --       A => sairegdiv,
      --       B => std_logic_vector(shift_left(unsigned(sairegA), quant_zero)),
      --       S => saiSoma
      -- );

      -- sub: subtrator generic map(N => 2*N)
      -- port map
      -- (
      --       A => sairegB,
      --       B => std_logic_vector(shift_left(unsigned(zero_um &'1'), quant_zero)),
      --       S => saiSub
      -- );

      -- Teste (sinais de status)

	TESTA_DIVISOR: igualazero generic map (N => N) 
      port map 
      (
            a => saireg_divisor,
            igual => Az
      );

      TESTA_RESTO: maiorigual generic map (N => N)
      port map
      (
            a => saireg_resto,
            b => saireg_divisor,
            maiorigual => resto_maiorigual
      );

end estrutura;