library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

package register_map_pack is

  type vhdl_lecture_register_val_t is record
    Global_reset      : integer; 
    Global_update     : integer; 
    Derivative_offset : integer;
  end record;
  
  constant v_registers : vhdl_lecture_register_val_t := (
    Global_reset                 => 12345,
    Global_update                => 12346,
    Derivative_offset            => 123        
  );
  
  
end package;

package body register_map_pack is
end package body;