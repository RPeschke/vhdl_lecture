library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

package TokenParser_p is
  constant TOKEN : STD_LOGIC_VECTOR(31 downto 0) := x"ABCDABCD";
  constant TOKEN_end : STD_LOGIC_VECTOR(31 downto 0) := x"FFFFFFFF";
  constant ASIC_A: STD_LOGIC_VECTOR(31 downto 0) := x"AAAAAAAA";
  constant ASIC_B: STD_LOGIC_VECTOR(31 downto 0) := x"BBBBBBBB";
  constant ASIC_C: STD_LOGIC_VECTOR(31 downto 0) := x"CCCCCCCC";
  constant ASIC_D: STD_LOGIC_VECTOR(31 downto 0) := x"DDDDDDDD";
  
end package;

package body TokenParser_p is
end package body;