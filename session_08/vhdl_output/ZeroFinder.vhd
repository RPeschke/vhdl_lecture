-- XGEN: Autogenerated File

library IEEE;
library UNISIM;
library work;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use UNISIM.VComponents.all;
use ieee.std_logic_unsigned.all;
use work.argg_hdl_core.all;
use work.axisStream_slv32.all;


entity ZeroFinder is 
  port(
    DataIn_s2m :  out  axiStream_slv32_s2m := axiStream_slv32_s2m_null;
    DataIn_m2s :  in  axiStream_slv32_m2s := axiStream_slv32_m2s_null;
    DataOut_s2m :  in  axiStream_slv32_s2m := axiStream_slv32_s2m_null;
    DataOut_m2s :  out  axiStream_slv32_m2s := axiStream_slv32_m2s_null;
    clk :  in  std_logic := '0'
  );
end entity;



architecture rtl of ZeroFinder is

--------------------------ZeroFinder-----------------
-------------------------- end ZeroFinder-----------------

begin
  -- begin architecture
  
-----------------------------------
proc : process(clk) is
  variable h_datain : axiStream_slv32_slave := axiStream_slv32_slave_null;
  variable h_dataOut : axiStream_slv32_master := axiStream_slv32_master_null;
  variable data1 : std_logic_vector(31 downto 0) := (others => '0');
  variable data2 : std_logic_vector(31 downto 0) := (others => '0');
  begin
    if rising_edge(clk) then 
      pull( self  =>  h_datain, rx => DataIn_m2s);
      pull( self  =>  h_dataOut, tx => DataOut_s2m);
  
      if (( isReceivingData_0(self => h_datain) and ready_to_send_0(self => h_dataOut)) ) then 
        cntr <= cntr + 1;
        get_value_00_rshift(self => h_datain, rhs => data1);
        
        if (( ( data1 > 0 and data2 < 0)  or ( data1 < 0 and data2 > 0) ) ) then 
          send_data_01(self => h_dataOut, dataIn => cntr);
          cntr <=  (others => '0');
          
        end if;
        data2 := data1;
        
      end if;
        push( self  =>  h_datain, rx => DataIn_s2m);
      push( self  =>  h_dataOut, tx => DataOut_m2s);
  end if;
  
  end process;
  -- end architecture

end architecture;