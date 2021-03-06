-- XGEN: Autogenerated File

library IEEE;
library UNISIM;
library work;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use UNISIM.VComponents.all;
use ieee.std_logic_unsigned.all;
use work.argg_hdl_core.all;
use work.slv32_a_pack.all;


package ramBlock_pack is 

-------------------------------------------------------------------------
------- Start Psuedo Class ramBlock -------------------------

type ramBlock is record 
    content : slv32_a(100 - 1 downto 0);
end record;
    
    
  constant ramBlock_null : ramBlock:= (
    content => (others => (others => '0'))
  );


    type ramBlock_a is array (natural range <>) of ramBlock;
        

-- v_list getHeader
-- empty procedure removed. name: 'push'
-- empty procedure removed. name: 'pull'
-- empty procedure removed. name: 'pull'
-- empty procedure removed. name: 'push'
  procedure get_data_011 (self :  inout  ramBlock; signal data :  out  std_logic_vector(31 downto 0); signal addr :  in  std_logic_vector(31 downto 0));
  procedure set_data_011 (self :  inout  ramBlock; signal data :  in  std_logic_vector(31 downto 0); signal addr :  in  std_logic_vector(31 downto 0));
------- End Psuedo Class ramBlock -------------------------
-------------------------------------------------------------------------


end ramBlock_pack;


package body ramBlock_pack is

-------------------------------------------------------------------------
------- Start Psuedo Class ramBlock -------------------------
-- empty procedure removed. name: 'push'
-- empty procedure removed. name: 'pull'
-- empty procedure removed. name: 'pull'
-- empty procedure removed. name: 'push'
procedure set_data_011 (self :  inout  ramBlock; signal data :  in  std_logic_vector(31 downto 0); signal addr :  in  std_logic_vector(31 downto 0)) is
   
  begin 
 self.content(to_integer(signed( addr))) := data;
   
end procedure;

procedure get_data_011 (self :  inout  ramBlock; signal data :  out  std_logic_vector(31 downto 0); signal addr :  in  std_logic_vector(31 downto 0)) is
   
  begin 
 data <= (others => '0');
  data <= self.content(to_integer(signed( addr)));
   
end procedure;

------- End Psuedo Class ramBlock -------------------------
  -------------------------------------------------------------------------


end ramBlock_pack;

