-- contem: regpc, mem_dados, regA, regB, regOP; ula inicial, regpq, regs, regz.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;  

entity BO_ula is
      generic (N : integer);
      port (
            clk : in std_logic;
            enPC, enA, enB, enOut, enOp, reset: in std_logic;
            pronto, flag_Z, flag_OVF, flag_N: out std_logic;
            PQ, S, opcode: out std_logic_vector(N-1 downto 0)); 
end BO_ula;
architecture estrutura of BO_ula is

-- componentes
component ula_inicial is
	generic(N: INTEGER);
	port(clk, reset: in std_logic;
		entradaA, entradaB: in std_logic_vector(N-1 downto 0);
		op: in std_logic_vector(3 downto 0);
		pronto, flag_OVF, flag_Z, flag_N: out std_logic;
		saidaPQ: out std_logic_vector(N-1 downto 0);
		saidaS: out std_logic_vector(N-1 downto 0));
end component;

component registrador_r IS
generic (N : integer);
PORT (clk, reset, carga : IN STD_LOGIC;
	  d : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
	  q : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0));
END component;

-- falta: mem_dados, regPC. fazer estes dois componentes
-- signals
signal entradaA, entradaB, saidaPQ_sig, saidaS_sig: std_logic_vector(N-1 downto 0);
signal flag_OVF_sig, flag_Z_sig, flag_N_sig: std_logic;
signal opcode_ula: std_logic_vector(N-1 downto 0);


begin
      regA: registrador_r generic map(N => N)
      port map(
            clk => clk,
            reset => reset,
            carga => enA,
            d =>, --- mem_dados
            q => entradaA
      );

      regB: registrador_r generic map(N => N)
      port map(
            clk => clk,
            reset => reset,
            carga => enB,
            d =>, --- mem_dados
            q => entradaB
      );

      regOp: registrador_r generic map(N => N)
      port map(
            clk => clk,
            reset => reset,
            carga => enOp,
            d => --mem_dados
            q => opcode_ula
      );

      ula: ula_inicial generic map(N => N)
      port map(
            clk => clk,
            reset => reset, --- o que isso ffaz?
            entradaA => entradaA, -- vem de mem dados
            entradaB => entradaB,
            op => opcode_ula(3 downto 0),
            pronto => pronto,
            flag_OVF => flag_OVF_sig,
            flag_Z => flag_Z_sig,
            flag_N => flag_N_sig,
            saidaPQ => saidaPQ_sig,
            saidaS => saidaS_sig
      );


      regPQ: registrador_r generic map(N => N)
      port map(
            clk => clk,
            reset => reset,
            carga => enOut,
            d =>  saidaPQ_sig,
            q => PQ
      );

      regS: registrador_r generic map(N => N)
      port map(
            clk => clk,
            reset => reset,
            carga => enOut,
            d => saidaS_sig,
            q => S
      );

      regZ: registrador_r generic map(N => N)
      port map(
            clk => clk,
            reset => reset,
            carga => enOut,
            d => flag_Z_sig,
            q => flag_Z
      );

      regOVF: registrador_r generic map(N => N)
      port map(
            clk => clk,
            reset => reset,
            carga => enOut,
            d => flag_OVF_sig,
            q => flag_OVF
      );

      regN: registrador_r generic map(N => N)
      port map(
            clk => clk,
            reset => reset,
            carga => enOut,
            d => flag_N_sig,
            q => flag_N
      );
-- port maps e atribuicoes
end estrutura;