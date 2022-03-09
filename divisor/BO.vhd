library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;  

entity bo_div is
      generic (N : integer);
      port (clk, carga_entradas, carga_quociente, carga_index, reset_saidas, reset_entradas : in std_logic;
            index_menosum, divisor_zero, resto_maiorigual : out std_logic;
            mux_index, mux_resto : in std_logic;
            entA, entB : in std_logic_vector(N - 1 downto 0);
            quociente : out std_logic_vector(N - 1 downto 0);
            resto : out std_logic_vector(N - 1 downto 0)); 
end bo_div;
architecture estrutura of bo_div is

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
            port (a, b : in std_logic_vector(N-1 downto 0);
                  sel : in std_logic;
                  y : out std_logic_vector(N-1 downto 0));
      end component;

      component setbit is
            generic (N : integer);
            port (v : in std_logic_vector(N-1 downto 0);
                  s : out std_logic_vector(N-1 downto 0);
                  index : integer;
                  b : std_logic);
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

      component maiorigual IS
            generic (N : integer);
            port (a, b : in std_logic_vector(N-1 downto 0);
                  maiorigual : out std_logic);
      end component;

      component fimindex IS
            generic (N : integer);
            port (a: integer;
                  fim : out std_logic);
      end component;

      signal ZERO_A_MENOS : std_logic_vector(N - 2 downto 0) := (others => '0');
      signal saireg_dividendo, saireg_divisor, saireg_quo, saireg_res : std_logic_vector(N - 1 downto 0);
      signal saimux_index , saisub_resto, saisub_index : std_logic_vecotr(N - 1 downto 0);

begin

      -- REGISTRADORES
      -- entradas:

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

      -- saidas:

      REG_QUOCIENTE : registrador_r generic map (N => N)
      port map
      (
            clk => clk,
            carga => carga_quociente,
            reset => reset_saidas,
            d => saiset_quociente,
            q => saireg_quo
      );

      REG_RESTO : registrador_r generic map (N => N)
      port map
      (
            clk => clk,
            carga => carga_index,
            reset => reset_saidas,
            d => saimux_resto,
            q => saireg_res
      );

      -- index:

      REG_INDEX : registrador generic map (N => N)
      port map
      (
            clk => clk,
            carga => carga_index,
            d => saimux_index,
            q => saireg_index
      );

      -- MUXES
      -- index:

      MUX_INDEX : mux2para1 generic map (N => N)
      port map
      (
            a => std_logic_vector(unsigned(N)),
            b => saireg_index,
            sel => mux_index,
            y => saimux_index
      );
      
      -- resto

      MUX_RESTO : mux2para1 generic map (N => N)
      port map
      (
            a => saiset_resto,
            b => saisub_resto,
            sel => mux_resto,
            y => saimux_resto
      );

     -- OPERAÇÔES
     -- subtrações:

     SUB_INDEX : subtrator generic map (N => N)
     port map
     (
            A => saimux_index,
            B => ZERO_A_MENOS&'1',
            S => saisub_index
     );

     SUB_RESTO : subtrator generic map (N => N)
     port map
     (
            A => saireg_resto,
            B => saireg_divisor,
            S => saisub_resto
     );

     -- set bit:

     SET_RESTO : setbit generic map (N => N)
     port map
     (
            v => std_logic_vector(shift_left(unsigned(saireg_resto), 1)),
            s => saiset_resto,
            index => 0,
            b => saireg_dividendo(to_integer(unsigned(saireg_index)))
     );

     SET_QUOCIENTE : setbit generic map (N => N)
     port map
     (
            v => saireg_quociente,
            s => saiset_quociente,
            index => to_integer(unsigned(saireg_index)),
            b => '1'
     );

     -- TESTES (SINAIS DE STATUS)

	TESTA_DIVISOR : igualazero generic map (N => N) 
      port map 
      (
            a => saireg_divisor,
            igual => divisor_zero
      );

      TESTA_RESTO : maiorigual generic map (N => N)
      port map
      (
            a => saireg_resto,
            b => saireg_divisor,
            maiorigual => resto_maiorigual
      );

      TESTA_INDEX : fimindex generic map (N => N)
      port map
      (
            a => saireg,
            fim => index_menosum
      );

end estrutura;