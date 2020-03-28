

library IEEE;
library UNISIM;
library work;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use UNISIM.VComponents.all;
use ieee.std_logic_unsigned.all;
use work.system_globals.all;
use work.roling_register_p.all;
use work.register_map_pack.all;

entity Derivative is
    port (
        globals  :  globals_t := globals_t_null;
        data_in : std_logic_vector(15 downto 0);
        data_out : out std_logic_vector(15 downto 0)
    );
end entity Derivative;

architecture rtl of Derivative is
    signal buff            :  std_logic_vector(15 downto 0) := (others => '0');
    signal r_offset        :  std_logic_vector(15 downto 0) := (others => '0');
    signal i_reg           :  registerT:= registerT_null;
begin
    
    
process(globals.clk)
begin
    if rising_edge(globals.clk) then
        data_out <= data_in - buff + r_offset;
        buff <= data_in ;
    end if;
end process;

    
process(globals.clk)
begin
  if rising_edge(globals.clk) then
    read_data_s(i_reg,  r_offset  ,  v_registers.Derivative_offset);

  end if;
end process;

reg_buffer : entity work.registerBuffer generic map (
  Depth =>  5
) port map (

  clk => globals.clk,
  registersIn   => globals.reg,
  registersOut  => i_reg
);

end architecture rtl;

