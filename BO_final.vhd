
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;  

entity BO_final is
      generic (N : integer;
      data_width : integer; -- numero de bits do elemento, igual a N
      addr_width : integer; -- quantidade de elementos a guardar
      addr_bits  : integer); -- tamanho de bits da contagem (que vem de REGPC)
      port (
            clk : in std_logic;
            enPC, enA, enB, enOut, enOp, reset, inicia_multi: in std_logic;
            pronto, flag_Z, flag_OVF, flag_N: out std_logic;
            PQ, S, opcode, mem_dados, A, B: out std_logic_vector(N-1 downto 0)); 
end BO_final;
architecture estrutura of BO_final is

-- componentes
component ula_inicial is
	generic(N: INTEGER);
	port(clk, reset, inicia_multi: in std_logic;
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

component regPC IS
generic (N: integer);
PORT (clk, reset, carga : IN STD_LOGIC;
	  d : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
	  q : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0));
END component;

component registrador_r_signal IS
PORT (clk, reset, carga : IN STD_LOGIC;
	  d : in std_logic;
	  q : out std_logic);
end component;


component memoriaROM is
      generic(
          addr_width : integer; -- quantidade de elementos a guardar
          addr_bits  : integer; -- tamanho de bits da contagem (que vem de REGPC)
          data_width : integer -- numero de bits do elemento
          );
  port(
      addr : in std_logic_vector(addr_bits-1 downto 0);
      data : out std_logic_vector(data_width-1 downto 0)
  );
  end component;

-- signals
signal entradaA, entradaB, saidaPQ_sig, saidaS_sig, saidaMem_dados: std_logic_vector(N-1 downto 0);
signal flag_OVF_sig, flag_Z_sig, flag_N_sig: std_logic;
signal opcode_ula: std_logic_vector(N-1 downto 0);
signal count_RegPC: std_logic_vector(addr_bits-1 downto 0); 


begin
      reg_PC: regPC generic map(N => addr_bits)
      port map (
				clk => clk,
				reset => reset,
				carga => enPC,
            d => count_RegPC,
            q => count_RegPC
      );

      regA: registrador_r generic map(N => N)
      port map(
            clk => clk,
            reset => reset,
            carga => enA,
            d => saidaMem_dados, 
            q => entradaA
      );

      regB: registrador_r generic map(N => N)
      port map(
            clk => clk,
            reset => reset,
            carga => enB,
            d => saidaMem_dados,
            q => entradaB
      );

      regOp: registrador_r generic map(N => N)
      port map(
            clk => clk,
            reset => reset,
            carga => enOp,
            d => saidaMem_dados,
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
            saidaS => saidaS_sig,
				inicia_multi => inicia_multi
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

      regZ: registrador_r_signal
      port map(
            clk => clk,
            reset => reset,
            carga => enOut,
            d => flag_Z_sig,
            q => flag_Z
      );

      regOVF: registrador_r_signal
      port map(
            clk => clk,
            reset => reset,
            carga => enOut,
            d => flag_OVF_sig,
            q => flag_OVF
      );

      regN: registrador_r_signal
      port map(
            clk => clk,
            reset => reset,
            carga => enOut,
            d => flag_N_sig,
            q => flag_N
      );

      memoria_dados: memoriaRom generic map(
            addr_width => addr_width, -- quantidade de elementos a guardar
            addr_bits => addr_bits, -- tamanho de bits da contagem (que vem de REGPC)
            data_width => data_width
      )
      port map (
            addr => count_RegPC,
            data => saidaMem_dados
      );

		opcode <= opcode_ula;
		mem_dados <= saidaMem_dados;
		A <= entradaA;
		B <= entradaB;
-- port maps e atribuicoes
end estrutura;