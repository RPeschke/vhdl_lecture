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
entity TokenParser is
  generic(
    ASIC_HEADER : STD_LOGIC_VECTOR(31 downto 0) := ASIC_A
  );
  port (
    clk: in  std_logic;
    rst: in  std_logic;
   
    dummy_data : in STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
    desi_chain_in  : in STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
    desi_chain_out   : out STD_LOGIC_VECTOR(31 downto 0):= (others => '0')
  );
end entity;

architecture rtl of TokenParser is
  
  type state_t is (
    idle,
    processing
    
  );
  signal state: state_t := idle;
  signal counter : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
  
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
  begin 
    if rising_edge(clk) then 
      pull(rx,data_out_m2s);

      desi_chain_out <= (others => '0');
      case state is
        when idle => 
          counter <= (others => '0');
          desi_chain_out <= desi_chain_in;
          if desi_chain_in = TOKEN_end  and isReceivingData(rx) then 
             desi_chain_out <= ASIC_HEADER;
            counter <= counter + 1;
            state <= processing;
          end if;

         
        when processing => 
          if isReceivingData(rx) then 
            read_data(rx, buff);
            desi_chain_out <= buff;
          else
            state <= idle;
            desi_chain_out <= TOKEN_end;
          end if;

          
            
          
          
      end case;
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