

library IEEE;
library UNISIM;
library work;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use UNISIM.VComponents.all;
use ieee.std_logic_unsigned.all;

entity Derivative is
    port (
        clk : std_logic;
        data_in : std_logic_vector(15 downto 0);
        data_out : out std_logic_vector(15 downto 0)
    );
end entity Derivative;

architecture rtl of Derivative is
    signal buff  : std_logic_vector(15 downto 0) := (others => '0');
begin
    
    
process(clk)
begin
    if rising_edge(clk) then
        data_out <= data_in - buff;
        buff <= data_in;
    end if;
end process;

    
end architecture rtl;

