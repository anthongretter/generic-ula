--ROM_sevenSegment.vhd

-- created by   :   Meher Krishna Patel
-- date                 :   25-Dec-16

-- Functionality:
  -- seven-segment display format for Hexadecimal values (i.e. 0-F) are stored in ROM 

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
                              "00000001", -- op A+B
                              "00110010", -- A
                              "00001100", -- B
                              "00000011", -- op A++
                              "00011110", -- A
                              "00000000", -- 5
                              "00000000", -- 6
                              "00000000", -- 7
                              "00000000", -- 8
                              "00000000", -- 9
                              "00000000", -- a
                              "00000000", -- b
                              "00000000", -- c
                              "00000000", -- d
                              "00000000", -- e
                              "00001111"  -- HALT, ver como vai funcionar ainda
          );
  begin
      data <= memoria_dados(to_integer(unsigned(addr)));
  end arch; 