

library IEEE;
library UNISIM;
library work;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use UNISIM.VComponents.all;
use ieee.std_logic_unsigned.all;
use work.xgen_axistream_32.all;


entity memory is
    generic(
      dataWidth : integer := 32;
      memDepth  : integer := 8
    );
    port (
        clk : std_logic;
        write_enable   : in  std_logic;
        Write_address  : in  std_logic_vector(memDepth  - 1 downto 0);
        Write_Data     : in  std_logic_vector(dataWidth - 1 downto 0);
        -- Port B
        read_address  : in  std_logic_vector(memDepth  - 1 downto 0);
        read_data     : out std_logic_vector(dataWidth - 1 downto 0)
    );
end entity memory;

architecture rtl of memory is
  

    type mem_type is array ( (2**Write_address'length)-1 downto 0 ) of std_logic_vector(Write_Data'length-1 downto 0);
    signal mem : mem_type := (others => (others => '0'));
begin
 
process(clk) is
begin
    if rising_edge(clk) then
        if(write_enable='1') then
            mem(conv_integer(Write_address)) <= Write_Data;
        end if;
        read_data <= mem(conv_integer(read_address));
    end if;
end process;
    
    
end architecture rtl;