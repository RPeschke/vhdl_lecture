library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;
 use work.TokenParser_p.all;
entity tokingRingHandler_FPGA is
  port (
    clk: in  std_logic;
    rst: in  std_logic;
    dummy_data       : out STD_LOGIC_VECTOR(31 downto 0):= (others => '0');

    -- Master Interface 
    tx_m2s : out tokenring_interface_m2s :=tokenring_interface_m2s_null;
    tx_s2m : in  tokenring_interface_s2m :=tokenring_interface_s2m_null;
    -- end master interface 


    -- SLave Interface 
    rx_m2s :   in tokenring_interface_m2s := tokenring_interface_m2s_null;
    rx_s2m : out  tokenring_interface_s2m := tokenring_interface_s2m_null
    -- end Slave interface 
  );
end entity;

architecture rtl of tokingRingHandler_FPGA is
  type state_t is (
    idle,
    sendEndToken,
    waiting,
    processing    
    
  );
  signal state : state_t:= idle;
  
begin
  
  
  process(clk) is 
     variable buff1 : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    variable tr_rx: tokenring_interface_slave := tokenring_interface_slave_null;
    variable tr_tx: tokenring_interface_master := tokenring_interface_master_null;
    variable hasToken: std_logic := '1';
  begin 
    if rising_edge(clk) then 
      pull(tr_rx, rx_m2s);
      pull(tr_tx, tx_s2m);
      
      dummy_data <= (others => '0');
      case state is
        
        when idle => 
          if isReadyToSend(tr_tx) then 
            hasToken := '1';
          end if;
          if hasToken = '1' then 
            send_token(tr_rx);
            hasToken := '0';
            state <= waiting;
          end if;
        when sendEndToken =>

        when waiting => 
          if isReadyToSend(tr_tx) or hasToken = '1' then 
            hasToken := '1';
            state <= idle;
          end if;

          
          if isReceivingData(tr_rx) then
            getData(tr_rx,   buff1);
            dummy_data <=  buff1;
            state <= processing;
          end if;
        when processing => 
          getData(tr_rx,   buff1);
          dummy_data <= buff1;
          if isEndOfStream(tr_rx) then
            state <= waiting;
          end if;
          if isReadyToSend(tr_tx) then 
            hasToken := '1';
          end if;
      end case;
      push(tr_tx, tx_m2s);
      push(tr_rx, rx_s2m);
    end if;
  end process;
  
end architecture;