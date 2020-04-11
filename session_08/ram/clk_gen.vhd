-- XGEN: Autogenerated File

library IEEE;
library UNISIM;
library work;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use UNISIM.VComponents.all;
use ieee.std_logic_unsigned.all;
use work.argg_hdl_core.all;


entity clk_gen is 
  port(
    clk :  out  std_logic := '0'
  );
end entity;



architecture rtl of clk_gen is

--------------------------clk_gen-----------------
-------------------------- end clk_gen-----------------

begin
  -- begin architecture
  
-----------------------------------
proc : process
  begin
    clk <= '1';
    wait for  10 ns;
    clk <= '0';
    wait for  10 ns;
    
  end process;
  -- end architecture

end architecture;