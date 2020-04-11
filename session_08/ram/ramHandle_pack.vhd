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


package ramHandle_pack is 

-------------------------------------------------------------------------
------- Start Psuedo Class ramHandle -------------------------

type ramHandle is record 
    content : slv32_a(100 - 1 downto 0);
end record;
    
    
  constant ramHandle_null : ramHandle:= (
    content => (others => (others => '0'))
  );


    type ramHandle_a is array (natural range <>) of ramHandle;
        

-- v_list getHeader
-- empty procedure removed. name: 'pull'
-- empty procedure removed. name: 'push'
-- empty procedure removed. name: 'pull'
-- empty procedure removed. name: 'push'
  procedure set_data_011 (self :  inout  ramHandle; signal data :  in  std_logic_vector(31 downto 0); signal addr :  in  std_logic_vector(31 downto 0));
------- End Psuedo Class ramHandle -------------------------
-------------------------------------------------------------------------


end ramHandle_pack;


package body ramHandle_pack is

-------------------------------------------------------------------------
------- Start Psuedo Class ramHandle -------------------------
-- empty procedure removed. name: 'pull'
-- empty procedure removed. name: 'push'
-- empty procedure removed. name: 'pull'
-- empty procedure removed. name: 'push'
procedure set_data_011 (self :  inout  ramHandle; signal data :  in  std_logic_vector(31 downto 0); signal addr :  in  std_logic_vector(31 downto 0)) is
   
  begin 
 self.content(to_integer(signed( addr))) := data;
   
end procedure;

------- End Psuedo Class ramHandle -------------------------
  -------------------------------------------------------------------------


end ramHandle_pack;

