library ieee;
use ieee.std_logic_1164.all;

entity multiplicador_grupo is
    generic (N : integer);
    port (clk, Reset, inicio: in std_logic;
        entA, entB : in std_logic_vector(N-1 downto 0);
        saida: out std_logic_vector(2*N-1 downto 0);
        pronto: out std_logic);
end multiplicador_grupo;

architecture arc of multiplicador_grupo is
    -- componentes (bo e bc)

    component bc is
      port (Reset, clk, inicio : in std_logic;
      A_zero, B_zero: in std_logic;
      pronto: out std_logic;
      carga_Entradas, carga_mult, mux_B, mux_mult: out std_logic);
    end component;

    component bo is
      generic (N : integer);
      port (
            clk : in std_logic;
            carga_Entradas, mux_B, carga_mult, mux_mult : in std_logic;
            entA, entB : in std_logic_vector(N - 1 downto 0);
            Az, Bz: out std_logic;
            mult : out std_logic_vector(2*N - 1 downto 0));
    end component;

    -- sinais de saida bc
    signal carga_Entradas, carga_mult, mux_B, mux_mult: std_logic;

    -- sinais de saida do bo
    signal Az, Bz: std_logic;

begin
  -- port map (conexoes entre bloco de controle e bloco operativo)

     -- bloco de comando
    CONTROLE : bc port map (
      Reset => Reset,
      clk => clk,
      inicio => inicio,
      A_zero => Az, 
      B_zero => Bz, 
      pronto => pronto,
      carga_Entradas => carga_Entradas,
      carga_mult => carga_mult,
      mux_B => mux_B, 
      mux_mult => mux_mult
    );

  -- bloco operativo
    OPERATIVO : bo generic map (N => N) port map (
            clk => clk,
            carga_Entradas => carga_Entradas, 
            mux_B => mux_B, 
            carga_mult => carga_mult, 
            mux_mult => mux_mult,
            entA => entA,
            entB => entB,
            Az => Az,
            Bz => Bz,
            mult => saida
    );
	 
end arc;