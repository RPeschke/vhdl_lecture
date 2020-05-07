
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_unsigned.all;
  use ieee.numeric_std.all;
library IEEE;
library UNISIM;
library work;
  use IEEE.numeric_std.all;
  use IEEE.std_logic_1164.all;

  use ieee.std_logic_unsigned.all;
library work;
  use work.register8bit.all;
  use work.register32bit.all;

  use work.axisStream_slv16.all;
  use work.Alpha_IO.all;

  use work.xgen_Counter.all;


entity alpha is 
  port(clk : std_logic;
       Trigger_in_s2m  :  out  axiStream_slv16_s2m := axiStream_slv16_s2m_null;
       Trigger_in_m2s  :  in  axiStream_slv16_m2s := axiStream_slv16_m2s_null;


       ASIC_READ_OUT_m2s : in  ASIC_READ_OUT_T_m2s;
       ASIC_READ_OUT_s2m : out  ASIC_READ_OUT_T_s2m

     );
end entity;


architecture rtl  of alpha is 

  
  constant First_bank : integer := 1;
  constant second_bank: integer := 2;
  
  constant MaxCount : STD_LOGIC_VECTOR(15 downto 0) := X"ffff";
  constant v_ramp_min : STD_LOGIC_VECTOR(15 downto 0) := X"0";
  constant v_ramp_max : STD_LOGIC_VECTOR(15 downto 0) := X"ffff";
begin 


  process(clk) is
    variable rx : axiStream_slv16_slave := axiStream_slv16_slave_null;
    variable ASIC: ASIC_READ_OUT;
    variable Bank_index : integer := 1;
    variable cnt: counter_16 := counter_16_null;
  begin 
    if rising_edge(clk) then 
      pull(rx, Trigger_in_m2s);
      pull(ASIC, ASIC_READ_OUT_m2s);
      pull(cnt);
      
      case ASIC.state is
        when idle => 
          if Triggered(rx) then
            set_State(ASIC,  receiving_trigger);
          end if;
        when receiving_trigger => 
          
          if isReady_bank(ASIC, First_bank ) then 
            set_State(ASIC,  Analog_Sampleing) ;
            Bank_index := First_bank;
          elsif isReady_bank(ASIC,second_bank) then 
            set_State(ASIC ,   Analog_Sampleing);
            Bank_index := second_bank;
          else 
            set_State(ASIC,  Stop_Sampaling);
          end if;
        when Stop_Sampaling =>
          
          
        when Analog_Sampleing => 
          set_ADC_Bias(ASIC);
          if isReady(cnt) then
            StartCountTo(cnt, MaxCount);
          end if;
          
          set_VRamp(ASIC, InTimeWindowSl(cnt, v_ramp_min,v_ramp_max));
          
          
      end case;
      
      push(ASIC, ASIC_READ_OUT_s2m);
      push(rx, Trigger_in_s2m);
    end if;
  end process;



end rtl;