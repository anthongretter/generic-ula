library ieee;
use ieee.std_logic_1164.all;

entity BC_final is
    port (clk, Reset: in std_logic;
          opcode: in std_logic_vector(3 downto 0);
          pronto: in std_logic;
          enPC, enA, enB, enOut, enOp, reset_bo, inicia_multi: out std_logic);
end BC_final;

architecture estrutura of BC_final is
	type state_type is (Inicia, S0, S1, S2, S3, S4, S5, S6, Halt);
	signal state: state_type;
begin
    -- máquina de estados
    process(Reset, clk)
    begin
      if (Reset = '1') then
          state <= Inicia;
      elsif (clk'event and clk = '1') then
        case state is
				when Inicia =>
					state <= S0;
					
          when S0 =>
            if (opcode = "1111") then -- OP HALT
              state <= Halt;
            else
              state <= S1;
            end if;
				
          -- enA
          when S1 => 
              if opcode = "0000" then -- NO OPERATION
                state <= Inicia;
              elsif opcode = "0011" or opcode = "0100" or opcode = "0101" then -- TODAS OPERACOES QUE NAO PRECISAM DE B
                state <= S3; -- operacoes monociclo
					else 
					state <= S2;
              end if;

			when S2 =>
				state  <= S3;
				
          -- enableB
          when S3 =>
              if opcode = "1001" or opcode = "1010" then --div ou mult
                state <= S5;
              else
                state <= S4;
              end if;
          
          when S4 => -- operacoes mono ciclo
                state <= S6;

          when S5 => -- operacoes multiciclo
                if pronto = '1' then
                  state <= S6;
                else
                  state <= S5;
                end if;

          when S6 => -- enout
                state <= Inicia;

          when Halt =>
                state <= Halt; -- única maneira de sair do halt é reset externo
        end case;
      end if;
    end process;

    -- lógica de saída
    process(state)
    begin
      case state is
      -- conteúdo das variáveis de controle (decidindo carga dos flip-flops, etc para o BO)         	
			when Inicia =>
			enPC <= '0';
          enA <= '0';
          enB <= '0';
          enOut <= '0';
          enOp <= '1';
          reset_bo <= '0';
			 inicia_multi <= '0';
			 
        when S0 =>
          enPC <= '1'; -- regpc pro proximo (A)
          enA <= '0';
          enB <= '0';
          enOut <= '0';
          enOp <= '0';
          reset_bo <= '0';
			 inicia_multi <= '0';


        when S1 => --enableA
          enPC <= '0';
          enA <= '1';
          enB <= '0';
          enOut <= '0';
          enOp <= '0';
          reset_bo <= '0';
			 inicia_multi <= '0';


			 when S2 =>  -- +1reg pc prox estado caso precise B
				 enPC <= '1';
				 enA <= '0';
				 enB <= '0';
				 enOut <= '0';
				 enOp <= '0';
				 reset_bo <= '0';
				 inicia_multi <= '0';

        when S3 => --enableB
          enPC <= '0';
          enA <= '0';
          enB <= '1';
          enOut <= '0';
          enOp <= '0'; 
          reset_bo <= '0';
			 inicia_multi <= '0';


        when S4 => -- operacoes monociclo
          enPC <= '0';
          enA <= '0';
          enB <= '0';
          enOut <= '0';
          enOp <= '0';
          reset_bo <= '0';
        	inicia_multi <= '0';

        when S5 => -- operacoes multiciclo
          enPC <= '0';
          enA <= '0';
          enB <= '0';
          enOut <= '0';
          enOp <= '0';
          reset_bo <= '0';
			inicia_multi <= '1';

        when S6 =>  -- final: enpc e enout
          enPC <= '1';
          enA <= '0';
          enB <= '0';
          enOut <= '1';
          enOp <= '0';
          reset_bo <= '0';
			 inicia_multi <= '0';


        when Halt => -- avaliar situacao
          enPC <= '0';
          enA <= '0';
          enB <= '0';
          enOut <= '0';
          enOp <= '0';
          reset_bo <= '1'; -- reseta mult e todos regs do BO
			inicia_multi <= '0';

		  end case;
    end process;
end estrutura;


