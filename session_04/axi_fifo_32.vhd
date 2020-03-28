

library IEEE;
library UNISIM;
library work;
  use IEEE.numeric_std.all;
  use IEEE.std_logic_1164.all;
  use UNISIM.VComponents.all;
  use ieee.std_logic_unsigned.all;
  use work.xgen_axistream_32.all;

entity axi_fifo_32 is

  port (
    clk : std_logic;
    --- Data In
    data_in_m2s : in  axisStream_32_m2s := axisStream_32_m2s_null;
    data_in_s2m : out  axisStream_32_s2m := axisStream_32_s2m_null;


    -- Data Out 
    data_out_m2s : out axisStream_32_m2s := axisStream_32_m2s_null;
    data_out_s2m : in axisStream_32_s2m := axisStream_32_s2m_null
  );
end entity axi_fifo_32;

architecture rtl of axi_fifo_32 is
  type mem_type is array ( (2**10)-1 downto 0 ) of std_logic_vector(32 downto 0);
  signal mem : mem_type := (others => (others => '0'));

  signal mem_start : integer := 0;
  signal mem_end   : integer := 0;
begin
  

  

  data_out_m2s.data <=  mem(mem_end)(31 downto 0);
  data_out_m2s.last <= mem(mem_end)(32);

  proc1: process(clk)
    variable data_in : axisStream_32_slave := axisStream_32_slave_null; 
  variable dataBuffer :   std_logic_vector(31 downto 0) := (others => '0');

  variable counter : integer := 0;
  variable i_valid : std_logic := '0';
  variable eos : std_logic := '0';
begin
  if rising_edge(clk) then
    pull(data_in , data_in_m2s);
    eos := '0';

    if isReceivingData(data_in) and counter < mem'length  then
      read_data(data_in, dataBuffer);
      if IsEndOfStream(data_in) then
        eos := '1';
      end if;
      mem(mem_start) <= eos &  dataBuffer;
      mem_start <= mem_start + 1;
      counter := counter + 1;
    end if;
    if mem_start = mem'length  - 1 then 
      mem_start <= 0;
    end if;

    if data_out_s2m.ready = '1' and   i_valid = '1' then
      i_valid := '0';
      mem_end <= mem_end + 1;
      counter  := counter -1;
    end if;

    if i_valid = '0' and counter > 0 then 
      i_valid := '1';
    end if;
    if mem_end = mem'length  - 1 then 
      mem_end <= 0;
    end if;

    data_out_m2s.valid <= i_valid;
    push(data_in, data_in_s2m);
  end if;
end process proc1;
end architecture rtl;