library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;
library ieee;
  use ieee.numeric_std.all;
  use ieee.std_logic_1164.all;
  use work.type_conversions_pgk.all;
  use work.TokenParser_p.all;
  use IEEE.numeric_std.all;
  use IEEE.std_logic_1164.all;

  use ieee.std_logic_unsigned.all;
  use work.xgen_axistream_32.all;

entity TokenParser_ASIC is
  generic(
    ASIC_HEADER : STD_LOGIC_VECTOR(31 downto 0) := ASIC_A
  );
  port (
    clk: in  std_logic;
    rst: in  std_logic;
   
    dummy_data : in STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
    -- Master Interface 
      tx_m2s : out tokenring_interface_m2s :=tokenring_interface_m2s_null;
      tx_s2m : in  tokenring_interface_s2m :=tokenring_interface_s2m_null;
    -- end master interface 
    

    -- SLave Interface 
      rx_m2s :   in tokenring_interface_m2s :=tokenring_interface_m2s_null;
      rx_s2m : out  tokenring_interface_s2m :=tokenring_interface_s2m_null
    -- end Slave interface 

  );
end entity;

architecture rtl of TokenParser_ASIC is
  
  type state_t is (
    idle,
    asic_header_state,
    processing,
    send_token_state
    
  );
  signal state: state_t := idle;

  
  signal data_in_m2s : axisStream_32_m2s := axisStream_32_m2s_null;
  signal data_in_s2m : axisStream_32_s2m := axisStream_32_s2m_null;


  -- Data Out 
  signal data_out_m2s : axisStream_32_m2s := axisStream_32_m2s_null;
  signal data_out_s2m : axisStream_32_s2m := axisStream_32_s2m_null;
begin
  
  
  inFiFO : entity work.axi_fifo_32 port map(
    clk => clk,
    --- Data In
    data_in_m2s => data_in_m2s,
    data_in_s2m => data_in_s2m,


    -- Data Out 
    data_out_m2s => data_out_m2s,
    data_out_s2m => data_out_s2m
  );
  
  process(clk) is 
    variable rx: axisStream_32_slave := axisStream_32_slave_null;
    variable buff : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    variable buff1 : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    variable tr_rx: tokenring_interface_slave := tokenring_interface_slave_null;
    variable tr_tx: tokenring_interface_master := tokenring_interface_master_null;
  begin 
    if rising_edge(clk) then 
      pull(rx,data_out_m2s);
      pull(tr_rx, rx_m2s);
      pull(tr_tx, tx_s2m);
      
      
      case state is
        when idle => 
        
          
          if isReadyToSend(tr_tx)  and isReceivingData(rx) then 
            send_data(tr_tx,  TOKEN_header);
         
            state <= asic_header_state;
          else
            getData(tr_rx,   buff1);
            send_data(tr_tx, buff1);
            send_token(tr_rx, isReadyToSend(tr_tx));
          end if;

        when asic_header_state=> 
          send_data(tr_tx,  ASIC_HEADER);
          state <= processing;
          
        when processing => 
          if isReceivingData(rx) then 
            read_data(rx, buff);
            send_data(tr_tx,  buff);
          else
           -- state <= send_token_state;
            send_data(tr_tx, TOKEN_end);
            send_token(tr_rx);
            state <= idle;

          end if;
        when send_token_state =>

          
      end case;
      
      push(tr_tx, tx_m2s);
      push(tr_rx, rx_s2m);
      push(rx, data_out_s2m);
    end if;
  end process;
  
  
  process(clk) is
    variable tx: axisStream_32_master := axisStream_32_master_null;
  begin
    if rising_edge(clk) then
      pull(tx , data_in_s2m);
      if dummy_data > 0 and ready_to_send(tx) then 
        send_data(tx, dummy_data);

      end if;
      push(tx, data_in_m2s);
    end if;
  end process;
end architecture;