
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

entity Feature_extraction is
  port (
    globals  :  globals_t := globals_t_null;
    data_in_m2s : in    axisStream_32_m2s := axisStream_32_m2s_null;
    data_in_s2m : out   axisStream_32_s2m := axisStream_32_s2m_null;

    trigger_in_m2s : in    axisStream_32_m2s := axisStream_32_m2s_null;
    trigger_in_s2m : out   axisStream_32_s2m := axisStream_32_s2m_null;

    data_out_m2s : out  axisStream_32_m2s := axisStream_32_m2s_null;
    data_out_s2m : in   axisStream_32_s2m := axisStream_32_s2m_null
  );
end entity Feature_extraction;

architecture rtl of Feature_extraction is
  signal i_data_in_m2s : axisStream_32_m2s := axisStream_32_m2s_null;
  signal i_data_in_s2m : axisStream_32_s2m := axisStream_32_s2m_null;


  type state_t is (
    idle,
    send_header,
    find_rising_edge,
    find_falling_edge,
    send_falling_edge,
    send_ToT,
    send_tail,
    wait_for_EOS

  );
  signal i_state : state_t := idle;
  constant c_header : std_logic_vector(31 downto 0 ) := x"0000ABCD";
  
  signal r_threshold : std_logic_vector(31 downto 0 ) := x"00000200";
  signal f_threshold : std_logic_vector(31 downto 0 ) := x"00000150";
  
  function maximum1 (m1 , m2 : std_logic_vector) return std_logic_vector is
    
  begin 
    if m1 > m2 then 
      
      return m1 ;

    end if;
    
    return m2;
  end function;
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

  process (globals.clk) is 
    variable data_in   : axisStream_32_slave := axisStream_32_slave_null; 
    variable trigger_in   : axisStream_32_slave := axisStream_32_slave_null; 
    variable data_out  : axisStream_32_master := axisStream_32_master_null;     
    variable trigger_buffer : std_logic_vector (31 downto 0) := (others =>'0');
    variable data_in_buffer : std_logic_vector (31 downto 0) := (others =>'0');
    variable SampleNr       : std_logic_vector (31 downto 0) := (others =>'0');
    variable MaxSampleValue : std_logic_vector (31 downto 0) := (others =>'0');
    variable rising_edge_sampleNr  : std_logic_vector (31 downto 0) := (others =>'0');
    variable falling_edge_sampleNr  : std_logic_vector (31 downto 0) := (others =>'0');
  begin 
    if rising_edge(globals.clk) then 
      pull(data_in, i_data_in_m2s);
      pull(data_out, data_out_s2m);
      pull(trigger_in, trigger_in_m2s);

      case i_state is
        when idle => 
          MaxSampleValue := (others => '0');
          if isReceivingData( trigger_in) and ready_to_send(data_out) then 
            send_data( data_out , c_header );
            i_state <= send_header;
          end if;
        when send_header => 
          if isReceivingData( trigger_in) and ready_to_send(data_out) then           
            read_data( trigger_in, trigger_buffer);
            send_data( data_out , trigger_buffer);
            if IsEndOfStream( trigger_in) then 
              i_state <= find_rising_edge;
            end if;
          end if;  
        when find_rising_edge => 
          if isReceivingData( data_in) and ready_to_send(data_out) then      
            read_data( data_in, data_in_buffer);
            SampleNr := SampleNr + 1;
            MaxSampleValue := maximum1( data_in_buffer , MaxSampleValue);
            if data_in_buffer > r_threshold then 
              rising_edge_sampleNr := SampleNr;
              send_data( data_out , rising_edge_sampleNr);
              i_state <= find_falling_edge;
            elsif IsEndOfStream( data_in) then 
              i_state <= send_tail;
            end if;
          end if;
        when find_falling_edge => 
          if isReceivingData( data_in) and ready_to_send(data_out) then      
            read_data( data_in, data_in_buffer);
            SampleNr := SampleNr + 1;
            MaxSampleValue := maximum1( data_in_buffer , MaxSampleValue);
            if data_in_buffer < f_threshold then 
              falling_edge_sampleNr := SampleNr;
              send_data( data_out , MaxSampleValue);
              i_state <= send_falling_edge;
            elsif IsEndOfStream( data_in) then 
              i_state <= send_tail;
            end if;
          end if;
        when send_falling_edge => 
          if isReceivingData( data_in) then 
            read_data( data_in, data_in_buffer);
          end if;
          if ready_to_send(data_out) then 
            send_data( data_out , falling_edge_sampleNr);
            i_state <= send_ToT;
          end if;
        when send_ToT => 
          if isReceivingData( data_in) then 
            read_data( data_in, data_in_buffer);
          end if;
          if ready_to_send(data_out) then 
            send_data( data_out , falling_edge_sampleNr-rising_edge_sampleNr);
            i_state <= send_tail;
          end if;
        when send_tail  => 
          if ready_to_send(data_out) then 
            send_data( data_out , c_header);
            Send_end_Of_Stream( data_out, true);
            i_state <= wait_for_EOS;
            
          end if;
        when wait_for_EOS => 
          if isReceivingData( data_in) then 
            read_data( data_in, data_in_buffer);
            if IsEndOfStream( data_in) then 
              i_state <= idle;
            end if;
          end if;
      end case;


      push(trigger_in,  trigger_in_s2m);
      push(data_out, data_out_m2s);
      push(data_in,  i_data_in_s2m);
    end if;
  end process;


end architecture rtl;