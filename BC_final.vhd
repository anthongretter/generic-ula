library ieee;
use ieee.std_logic_1164.all;

entity BC_final is
    port (clk, Reset: in std_logic;
          opcode: in std_logic_vector(3 downto 0);
          pronto: in std_logic;
          enPC, enA, enB, enOut, enOp, reset_bo: out std_logic);
end BC_final;

architecture estrutura of BC_final is
	type state_type is (Inicia, S0, S1, S2, S3, S4, S5, Halt);
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
                state <= S0;
              elsif opcode = "0011" or opcode = "0100" or opcode = "0101" then -- TODAS OPERACOES QUE NAO PRECISAM DE B
                state <= S3; -- operacoes monociclo
					else 
					state <= S2;
              end if;

          -- enableB
          when S2 =>
              if opcode = "1001" or opcode = "1010" then --div ou mult
                state <= S4;
              else
                state <= S3;
              end if;
          
          when S3 => -- operacoes mono ciclo
                state <= S5;

          when S4 => -- operacoes multiciclo
                if pronto = '1' then
                  state <= S5;
                else
                  state <= S4;
                end if;

          when S5 => -- enout
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
			 
        when S0 =>
          enPC <= '1';
          enA <= '0';
          enB <= '0';
          enOut <= '0';
          enOp <= '0';
          reset_bo <= '0';


        when S1 => --enableA
          enPC <= '1';
          enA <= '1';
          enB <= '0';
          enOut <= '0';
          enOp <= '0';
          reset_bo <= '0';


        when S2 => --enableB
          enPC <= '0';
          enA <= '0';
          enB <= '1';
          enOut <= '0';
          enOp <= '0'; 
          reset_bo <= '0';


        when S3 => -- operacoes monociclo
          enPC <= '0';
          enA <= '0';
          enB <= '0';
          enOut <= '0';
          enOp <= '0';
          reset_bo <= '0';
        
        when S4 => -- operacoes multiciclo
          enPC <= '0';
          enA <= '0';
          enB <= '0';
          enOut <= '0';
          enOp <= '0';
          reset_bo <= '0';
        
        when S5 => 
          enPC <= '1';
          enA <= '0';
          enB <= '0';
          enOut <= '1';
          enOp <= '0';
          reset_bo <= '0';

        when Halt => -- avaliar situacao
          enPC <= '0';
          enA <= '0';
          enB <= '0';
          enOut <= '0';
          enOp <= '0';
          reset_bo <= '1'; -- reseta mult e todos regs do BO, exceto PC por enquanto

		  end case;
    end process;
end estrutura;


