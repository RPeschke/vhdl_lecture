
library IEEE;
library UNISIM;
library work;
  use IEEE.numeric_std.all;
  use IEEE.std_logic_1164.all;
  use UNISIM.VComponents.all;
  use ieee.std_logic_unsigned.all;
  use work.xgen_axistream_32.all;



entity Feature_extraction is
    port (
        globals  :  globals_t := globals_t_null;
        data_in_m2s : in    axisStream_32_m2s := axisStream_32_m2s_null;
        data_in_s2m : out   axisStream_32_s2m := axisStream_32_s2m_null;
    
        trigger_in_m2s : in    axisStream_32_m2s := axisStream_32_m2s_null;
        trigger_in_s2m : out   axisStream_32_s2m := axisStream_32_s2m_null;

        data_out_m2s : out  axisStream_32_m2s := axisStream_32_m2s_null;
        data_out_s2m : in   axisStream_32_s2m := axisStream_32_s2m_null
    );
end entity Feature_extraction;

architecture rtl of Feature_extraction is
    
begin
    
    
    
end architecture rtl;