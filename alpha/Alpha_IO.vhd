library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

package Alpha_IO is
  type state_t is (
    idle,
    receiving_trigger,
    Bank_1,
    Bank_2,
    Stop_Sampaling,
    Analog_Sampleing

  );
 
  type ASIC_READ_OUT_T_m2s is record
    token_in  : std_logic_vector(15 downto 0);    
    LVDS      : std_logic_vector(15 downto 0);
    state     :   state_t;
  end record;

  type ASIC_READ_OUT_T_s2m is record
    token_out     : std_logic_vector(15 downto 0);    
    state_out     :   state_t;
  end record;

  type ASIC_READ_OUT is record
    token_in  : std_logic_vector(15 downto 0);    
    LVDS      : std_logic_vector(15 downto 0);
    token_out : std_logic_vector(15 downto 0);    
    state     :   state_t;
    state_out     :   state_t;
  end record;
  function isReady_bank(self: ASIC_READ_OUT; Index :integer) return boolean;
  procedure set_ADC_Bias(self: inout ASIC_READ_OUT);
  procedure set_VRamp(self : inout ASIC_READ_OUT; v : in std_logic_vector);
  
  procedure set_State(self : inout ASIC_READ_OUT; state     :   state_t);
end package;
package body Alpha_IO is
end package body;