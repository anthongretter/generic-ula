
-- created by   :   Meher Krishna Patel
-- date                 :   25-Dec-16

-- ports:
    -- addr             : input port for getting address
    -- data             : ouput data at location 'addr'
    -- addr_width : total number of elements to store (put exact number)
    -- addr_bits  : bits requires to store elements specified by addr_width
    -- data_width : number of bits in each elements
    
  library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  
  entity memoriaROM is
      generic(
          addr_width : integer; -- quantidade de elementos a guardar
          addr_bits  : integer; -- tamanho de bits da contagem (que vem de REGPC)
          data_width : integer -- numero de bits do elemento
          );
  port(
      addr : in std_logic_vector(addr_bits-1 downto 0);
      data : out std_logic_vector(data_width-1 downto 0)
  );
  end memoriaROM;
  
  architecture arch of memoriaROM is
  
      type rom_type is array (0 to addr_width-1) of std_logic_vector(data_width-1 downto 0);
      
      signal memoria_dados : rom_type := (
                              "00000001", -- op A+B / 1
                              "00110010", -- A / 2
                              "00001100", -- B / 3
                              "00000011", -- op A++ / 4
                              "00011110", -- A / 5
                              "00001001", -- op A * B / 6
                              "00110010", -- A / 7
                              "00001100", -- B / 8
                              "00000010", -- op A - B  / 9
                              "00001100", -- A / 10
                              "00110010", -- B / 11
                              "00000101", -- op not A / 12
                              "00110010", -- A / 13
                              "00000000", -- no op / 14
                              "00001010", -- op divisao / 15
                              "00100000", -- A / 16
                              "00000101", -- B / 17
                              "00000110", -- op A and B 18
                              "00110010", -- A 19
                              "11001101", -- B 20
                              "00000111", -- op A or B 21
                              "00011110", -- A 22
                              "00100001", -- B 23
                              "00001000", -- op A xor B 24
                              "00001111", -- A 25
                              "00110000", -- B 26
                              "00000011", -- op A++ teste overflow 27
                              "01111111", -- A 28
                              "00001010", -- op divisao 29
                              "00000100", -- A 30
                              "00000010", -- B 31
                              "00001111"  -- HALT, ver como vai funcionar ainda 32
          );
  begin
      data <= memoria_dados(to_integer(unsigned(addr)));
  end arch; 