library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

  -- from/to register I/O (A16D32 version)
package register32bit is
  type register32Bit_m2s is record 
    en32                 :  std_logic;
    wr32                 :  std_logic;
    rd32                 :  std_logic;
    data32o              :  std_logic_vector (31 downto 0);
    addr32               :  std_logic_vector (15 downto 0);
  end record;

  
  type register32Bit_s2m is record 
    data32i              : std_logic_vector (31 downto 0);
    ack                  : std_logic;
  end record;
  
  
  type register32Bit is record 
    en32                 : std_logic;
    wr32                 : std_logic;
    rd32                 : std_logic;
    data32i              : std_logic_vector (31 downto 0);
    data32o              : std_logic_vector (31 downto 0);
    addr32               : std_logic_vector (15 downto 0);
    ack                  : std_logic;
  end record;
  
end package;

package body register32bit is
end package body;