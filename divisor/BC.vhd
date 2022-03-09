library ieee;
use ieee.std_logic_1164.all;

entity bc_div is
    port (Reset, clk, inicio : in std_logic;
        index_menosum, divisor_zero, resto_maiorigual: in std_logic;
        carga_entradas, carga_quociente, carga_index, reset_saidas, reset_entradas: out std_logic;
        mux_index, mux_resto : out std_logic;
        pronto, erro: out std_logic);
end bc_div;

architecture estrutura of bc_div is
	type state_type is (S0, S1, S2, S3, E);
	signal state: state_type;
begin
    -- máquina de estados
    process(Reset, clk)
    begin
      if (Reset = '1') then
          state <= S0;
      elsif (clk'event and clk = '1') then
        case state is

          -- espera para ser iniciado 
          when S0 =>
              if (inicio = '0') then
                state <= S0;
              else
                state <= S1;
              end if;

          -- estado de erro (divisões por 0)
          when E =>
              if (inicio = '0') then
                state <= S0;
              else
                state <= S1;
              end if;

          -- estado de setup
          when S1 => 
              state <= S2;

          -- estado de check e incremento do resto
          when S2 =>
              if (index_menosum = '1') then
                state <= S0;
              elsif (divisor_zero = '1') then
                state <= E;
              elsif (resto_maiorigual = '1') then
                state <= S3;
              else
                state <= S2;
              end if;
          
          -- estado de incremento do quociente e redução do resto
          when S3 =>
              state <= S2;

        end case;
      end if;
    end process;

    -- lógica de saída
    process(state)
    begin
      case state is
      -- conteúdo das variáveis de controle (decidindo carga dos flip-flops, etc para o BO)         	

        when S0 =>
          pronto <= '1';
          erro <= '0';

        when E =>
          pronto <= '1';
          erro <= '1';

        when S1 =>
          reset_saidas <= '1';      -- reseta saidas (quociente e resto)
          mux_index <= '0';         -- seta index para N
          carga_index <= '1';       -- atualiza index
          carga_entradas <= '1';    -- atualiza os valores de A e B (entA e entB)
          carga_quociente <= '1';   -- atualiza valor do quociente (reseta valor)
          pronto <= '0';

        when S2 =>
          reset_saidas <= '0';      -- mantem saidas
          mux_index <= '1';         -- index recebe index-1
          mux_resto <= '0';         -- resto recebe set_bit
          carga_index <= '1';
          carga_entradas <= '0';    -- mantem os valores de dividendo e divisor
          carga_quociente <= '0';   -- mantem valor do quociente
          pronto <= '0';

        when S3 =>
          reset_saidas <= '0';
          carga_index <= '0';       -- mantem index
          carga_entradas <= '0';
          carga_quociente <= '1';   -- atualiza valor do quociente
          pronto <= '0';

		  end case;
    end process;
end estrutura;


