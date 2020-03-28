
library IEEE;
library UNISIM;
library work;
  use IEEE.numeric_std.all;
  use IEEE.std_logic_1164.all;
  use UNISIM.VComponents.all;
  use ieee.std_logic_unsigned.all;
  use work.xgen_axistream_32.all;
  use work.xgen_ramHandler_32_10.all;


entity pedestal_substraction is
  port (
    clk : std_logic;

    ped_data : std_logic_vector(31 downto 0);
    ped_data_address : std_logic_vector(7 downto 0 );

    data_in_m2s : in    axisStream_32_m2s := axisStream_32_m2s_null;
    data_in_s2m : out   axisStream_32_s2m := axisStream_32_s2m_null;

    data_out_m2s : out  axisStream_32_m2s := axisStream_32_m2s_null;
    data_out_s2m : in   axisStream_32_s2m := axisStream_32_s2m_null
  );
end entity pedestal_substraction;

architecture rtl of pedestal_substraction is
  signal i_data_in_m2s : axisStream_32_m2s := axisStream_32_m2s_null;
  signal i_data_in_s2m : axisStream_32_s2m := axisStream_32_s2m_null;

  signal ram_m_m2s :   ram_handle_m2s := ram_handle_m2s_null;
  signal ram_m_s2m :   ram_handle_s2m := ram_handle_s2m_null;
begin
  fifo : entity work.axi_fifo_32 port map(
    clk => clk,
    --- Data In
    data_in_m2s => data_in_m2s,
    data_in_s2m => data_in_s2m,


    -- Data Out 
    data_out_m2s => i_data_in_m2s,
    data_out_s2m => i_data_in_s2m

  );
  mem : entity work.memory port map (
    clk => clk,
    write_enable  => '1',
    Write_address =>  ped_data_address,
    Write_Data    => ped_data,
    -- Port B
    read_address  => ram_m_m2s.readAddress,
    read_data     => ram_m_s2m.readData
  );


  ped_sub: process(clk)
    variable actual_counter  : std_logic_vector(7 downto 0) := x"01";
  variable data_in   : axisStream_32_slave := axisStream_32_slave_null; 
  variable data_out  : axisStream_32_master := axisStream_32_master_null; 
  variable data_buffer     : std_logic_vector(31 downto 0) := (others => '0');
  variable ped_data_buffer     : std_logic_vector(31 downto 0) := (others => '0');
  variable ram_h :  ram_handle_master := ram_handle_master_null;
  variable hasData :boolean := false;
  variable eos : boolean := false;
begin
  if rising_edge(clk) then
    pull(data_in, i_data_in_m2s);
    pull(data_out, data_out_s2m);
    pull(ram_h,  ram_m_s2m);
    
    if ped_data_address > 0 then 
      reset(ram_h);
    end if;
    request_Data(ram_h,  actual_counter);
    if isReceivingData(data_in) and hasData = false then 
      read_data(data_in, data_buffer);
      request_Data(ram_h,  actual_counter);
      hasData := True;
      eos := IsEndOfStream(data_in);
    end if;
    if hasData and  ready_to_send(data_out) and isReady2Load(ram_h,  actual_counter)  then 
      read_Data(ram_h, actual_counter, ped_data_buffer);
      send_data(data_out, data_buffer - ped_data_buffer);

      if eos  then 
        actual_counter := x"01";
      end if;
      Send_end_Of_Stream(data_out, eos);
      hasData := false;
      actual_counter := actual_counter + 1;
    end if;

    push(ram_h,  ram_m_m2s);
    push(data_out, data_out_m2s);
    push(data_in,  i_data_in_s2m);
  end if;
end process ped_sub;

end architecture rtl;