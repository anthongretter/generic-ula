-- arquivo que juntara BO e BC de ula, com saidas PQ, S e flagZ.

library ieee;
use ieee.std_logic_1164.all;

entity projeto_final is
  generic(N: integer := 8; --mesmo que data_width
    addr_width : integer := 16; -- quantidade de elementos a guardar
    addr_bits  : integer := 4); -- tamanho de bits da contagem (que vem de REGPC))
  port (clk, Reset: in std_logic;
        PQ, S: out std_logic_vector(N-1 downto 0));
end projeto_final;

architecture arc of projeto_final is

  component BO_final is
    generic (N : integer;
    data_width : integer; -- numero de bits do elemento, igual a N
    addr_width : integer; -- quantidade de elementos a guardar
    addr_bits  : integer); -- tamanho de bits da contagem (que vem de REGPC)
    port (
          clk : in std_logic;
          enPC, enA, enB, enOut, enOp, reset: in std_logic;
          pronto, flag_Z, flag_OVF, flag_N: out std_logic;
          PQ, S, opcode: out std_logic_vector(N-1 downto 0)); 
  end component;

  component BC_final is
    port (clk, Reset: in std_logic;
          opcode_mem: in std_logic_vector(3 downto 0);
          pronto: in std_logic;
          enPC, enA, enB, enOut, enOp, reset_bo: out std_logic);
  end component;

  signal enPC_sig, enA_sig, enB_sig, enOut_sig, enOp_sig, reset_bo_sig: std_logic;
  signal pronto_sig, flag_Z_sig, flag_OVF_sig, flag_N_sig: std_logic;
  signal opcode_8bit: std_logic_vector(N-1 downto 0);


begin 
    BO: BO_final generic map (N => N, 
    data_width => N,
    addr_width => addr_width; -- quantidade de elementos a guardar
    addr_bits  => addr_bits)
    port map(
      -- entradas
      clk => clk,
      enPC => enPC_sig,
      enA => enA_sig,
      enB => enB_sig,
      enOut => enOut_sig,
      enOp => enOp_sig,
      reset => reset_bo_sig,

      -- saidas
      pronto => pronto_sig,
      flag_Z => flag_Z_sig,
      flag_OVF => flag_OVF_sig,
      flag_N => flag_N_sig,
      PQ => PQ,
      S => S,
      opcode => opcode_8bit
    );

    BC: BC_final
    port map (
      --entradas
      clk => clk,
      Reset => Reset,
      opcode_mem => opcode_8bit(3 downto 0),
      pronto => pronto_sig,
      -- saidas
      enPC => enPC_sig,
      enA => enA_sig,
      enB => enB_sig,
      enOut => enOut_sig,
      enOp => enOp_sig,
      reset_bo => reset_bo_sig
    );