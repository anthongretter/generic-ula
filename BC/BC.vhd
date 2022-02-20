library ieee;
use ieee.std_logic_1164.all;

entity bc is
    port (Reset, clk, inicio : in std_logic;
        A_zero, B_zero: in std_logic;
        pronto: out std_logic;
        carga_Entradas, carga_mult, mux_B, mux_mult: out std_logic);
end bc;

architecture estrutura of bc is
	type state_type is (S0, S1, S2, S3);
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
          
          -- estado de setup
          when S1 => 
              state <= S2;


          when S2 =>
              if (B_zero = '1' or A_zero = '1') then
                state <= S0;
              else
                state <= S3;
              end if;
          
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
			 carga_mult <= '0';

        when S1 =>
          mux_mult <= '1';      -- reseta multiplicação
          mux_B <= '1';         -- B recebe entB
          carga_Entradas <= '1';  -- atualiza os valores de A e B (entA e entB)
          carga_mult <= '1';      -- atualiza valor da multiplicacao (reseta valor)
          pronto <= '0';
          -- definindo valores iniciais arbitrarios:
			 

        when S2 =>
          mux_B <= '0';         -- B passa a receber valor da subtração
          carga_Entradas <= '0';  -- mantem os valores de A e B (checa A = 0)
          carga_mult <= '0';
			    mux_mult <= '0';      -- regmult recebe a soma
          pronto <= '0';

        when S3 =>
          carga_Entradas <= '1';  -- mantem os valores de A e B (checa B = 0)
          mux_B <= '0';
          carga_mult <= '1';
			    mux_mult <= '0';      -- regmult recebe a soma
          pronto <= '0';

		  end case;
    end process;
end estrutura;


