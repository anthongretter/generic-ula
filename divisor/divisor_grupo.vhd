library ieee;
use ieee.std_logic_1164.all;

entity divisor_grupo is
    generic (N : integer);
    port (clk, Reset, inicio: in std_logic;
        entA, entB : in std_logic_vector(N-1 downto 0);
        saida, resto: out std_logic_vector(N-1 downto 0);
        pronto, erro: out std_logic);
end divisor_grupo;

architecture arc of divisor_grupo is
    -- componentes (bo e bc)

    component bc_div is
        port (Reset, clk, inicio : in std_logic;
            index_menosum, divisor_zero, resto_maiorigual: in std_logic;
            carga_entradas, carga_quociente, carga_index, reset_saidas, reset_entradas: out std_logic;
            mux_index, mux_resto : out std_logic;
            pronto, erro: out std_logic);
    end component;

    component bo_div is
        generic (N : integer);
        port (clk, carga_entradas, carga_quociente, carga_index, reset_saidas, reset_entradas : in std_logic;
              index_menosum, divisor_zero, resto_maiorigual : out std_logic;
              mux_index, mux_resto : in std_logic;
              entA, entB : in std_logic_vector(N - 1 downto 0);
              quociente : out std_logic_vector(N - 1 downto 0);
              resto : out std_logic_vector(N - 1 downto 0)); 
  end component;

    -- sinais de saida bc
    signal carga_entradas, carga_quociente, carga_index, reset_saidas, reset_entradas : std_logic;
    signal mux_index, mux_resto : std_logic;

    -- sinais de saida do bo
    signal index_menosum, divisor_zero, resto_maiorigual : std_logic;

begin
    -- junção bloco de controle e operativo

    CONTROLE_DIVISOR : bc_div generic map (N => N)
    port map
    (
        Reset => Reset,
        clk => clk,
        inicio => inicio,
        index_menosum => index_menosum,
        divisor_zero => divisor_zero,
        resto_maiorigual => resto_maiorigual,
        carga_entradas => carga_entradas,
        carga_quociente => carga_quociente,
        carga_index => carga_index,
        reset_saidas => reset_saidas,
        reset_entradas => reset_entradas,
        mux_index => mux_index,
        mux_resto => mux_resto,
        pronto => pronto,
        erro => erro
    );

    OPERATIVO_DIVISOR : bo_div generic map (N => N)
    port map
    (
        entA => entA,
        entB => entB,
        clk => clk,
        index_menosum => index_menosum,
        divisor_zero => divisor_zero,
        resto_maiorigual => resto_maiorigual,
        carga_entradas => carga_entradas,
        carga_quociente => carga_quociente,
        carga_index => carga_index,
        reset_saidas => reset_saidas,
        reset_entradas => reset_entradas,
        mux_index => mux_index,
        mux_resto => mux_resto,
        quociente => saida,
        resto => resto,
    );

end arc;