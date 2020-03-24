

library IEEE;
library UNISIM;
library work;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use UNISIM.VComponents.all;
use ieee.std_logic_unsigned.all;
use work.xgen_axistream_32.all;

entity axi_derivative is
    port (
        clk : std_logic;
        --- Data In
        data_in_valid : in  std_logic;
        data_in_ready : out std_logic;
        data_in_data  : in  std_logic_vector(15 downto 0);


        -- Data Out 
        data_out_valid : out std_logic;
        data_out_ready : in  std_logic;
        data_out_data  : out std_logic_vector(15 downto 0)

    );
end entity axi_derivative;

architecture rtl of axi_derivative is
 signal data_in_m2s : axisStream_32_m2s := axisStream_32_m2s_null;
 signal data_in_s2m : axisStream_32_s2m := axisStream_32_s2m_null;

 signal data_out_m2s : axisStream_32_m2s := axisStream_32_m2s_null;
 signal data_out_s2m : axisStream_32_s2m := axisStream_32_s2m_null;

begin
    data_in_m2s.valid <= data_in_valid;
    data_in_m2s.data(15 downto 0) <= data_in_data;
    data_in_ready <=   data_in_s2m.ready;

    data_out_valid <=  data_out_m2s.valid;
    data_out_data  <= data_out_m2s.data(15 downto 0);
    data_out_s2m.ready <= data_out_ready;
    proc1: process(clk)
     variable data_in : axisStream_32_slave := axisStream_32_slave_null; 
      variable dataBuffer :   std_logic_vector(31 downto 0) := (others => '0');
      variable lastData :   std_logic_vector(31 downto 0) := (others => '0');
      variable data_offset :   std_logic_vector(31 downto 0) := x"00000010";
      variable counter : integer  := 0;
      variable data_out : axisStream_32_master := axisStream_32_master_null;

    begin
        if rising_edge(clk) then
            pull(data_in , data_in_m2s);
            pull(data_out , data_out_s2m);
            counter := counter +1;
            if isReceivingData(data_in) and counter = 1  then
                read_data(data_in, dataBuffer);
            end if;
            if ready_to_send(data_out)  and counter > 5 then
                counter := 0;
                send_data(data_out , dataBuffer - lastData);
                lastData := dataBuffer;
            end if;
            push(data_out, data_out_m2s);
            push(data_in, data_in_s2m);
        end if;
    end process proc1;
end architecture rtl;