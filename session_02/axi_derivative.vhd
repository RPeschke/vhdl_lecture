

library IEEE;
library UNISIM;
library work;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use UNISIM.VComponents.all;
use ieee.std_logic_unsigned.all;


entity axi_derivative is
    port (
        clk : std_logic;
        --- Data In
        data_in_valid : in  std_logic;
        data_in_ready : out std_logic;
        data_in_data  : in  std_logic;


        -- Data Out 
        data_out_valid : out std_logic;
        data_out_ready : in  std_logic;
        data_out_data  : out std_logic

    );
end entity axi_derivative;

architecture rtl of axi_derivative is

begin
    proc1: process(clk)
    begin
        if rising_edge(clk) then
            
        
        end if;
    end process proc1;
end architecture rtl;