
library IEEE;
library UNISIM;
library work;
  use IEEE.numeric_std.all;
  use IEEE.std_logic_1164.all;
  use UNISIM.VComponents.all;
  use ieee.std_logic_unsigned.all;
  use work.xgen_axistream_32.all;
  use work.system_globals.all;
  use work.roling_register_p.all;
  use work.xgen_klm_scrod_bus.all;
  use work.xgen_Counter.all;

entity TX_waveform is
  port(
    globals : in globals_t;
    data_in_m2s : in    axisStream_32_m2s := axisStream_32_m2s_null;
    data_in_s2m : out   axisStream_32_s2m := axisStream_32_s2m_null;

    TX_Bus_s2m  : out  DataBus_s2m := DataBus_s2m_null;
    TX_Bus_m2s  : in  DataBus_m2s := DataBus_m2s_null

  );

end entity;


architecture rtl of TX_waveform is 
  signal i_data_in_m2s : axisStream_32_m2s := axisStream_32_m2s_null;
  signal i_data_in_s2m : axisStream_32_s2m := axisStream_32_s2m_null;
  
  signal Max_count: std_logic_vector(15 downto 0) := x"1000";
  
  signal current_sample : std_logic_vector(31 downto 0) := (others => '0');
  signal sample_span  :  time_span16_a(31 downto 0) := (others =>  time_span16_null);
  signal sample_select_any_span  :  time_span16_a(31 downto 0) := (others =>  time_span16_null);
  
  
begin 
  fifo : entity work.axi_fifo_32 port map(
    clk => globals.clk,
    --- Data In
    data_in_m2s => data_in_m2s,
    data_in_s2m => data_in_s2m,

    -- Data Out 
    data_out_m2s => i_data_in_m2s,
    data_out_s2m => i_data_in_s2m

  );


  process(globals.clk) is
    variable data_in   : axisStream_32_slave := axisStream_32_slave_null; 
    variable cnt    : counter_16 := counter_16_null;
    variable data_buffer : std_logic_vector(31 downto 0) := (others => '0');
  begin 
    if rising_edge(globals.clk) then 
      pull(data_in, i_data_in_m2s);
      pull(cnt);

      
      
      if isReceivingData(data_in) and isReady(cnt) then 
        read_data(data_in, data_buffer);
        current_sample <= data_buffer;
        StartCountTo(cnt ,Max_count);
      end if;
      TX_Bus_s2m.ShiftRegister.SampleSelect <= InTimeWindowSLV_r_a( cnt , sample_span, current_sample(4 downto 0));
      TX_Bus_s2m.ShiftRegister.SampleSelectAny <= InTimeWindowSLV_r_a( cnt , sample_select_any_span, "00001");
      push(data_in,  i_data_in_s2m);
    end if;
  end process;
  
  
  process(globals.clk) is 
  begin
    if rising_edge(globals.clk) then
      
      for i1 in 0 to sample_span'length -1 loop 
        read_data_s(globals.reg,  sample_span(i1).min ,  10 + i1*2);
        read_data_s(globals.reg,  sample_span(i1).max ,  11 + i1*2);
      end loop;

      
      sample_select_any_span(0).min <= x"0001";
      sample_select_any_span(0).max <= x"0081";
    end if;
  end process;
end rtl;