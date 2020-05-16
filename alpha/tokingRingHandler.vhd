library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;
 use work.TokenParser_p.all;
entity tokingRingHandler is
  port (
    clk: in  std_logic;
    rst: in  std_logic;
    dummy_data       : out STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
    desi_chain_in    : in STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
    desi_chain_out   : out STD_LOGIC_VECTOR(31 downto 0):= (others => '0')
  );
end entity;

architecture rtl of tokingRingHandler is
  type state_t is (
    idle,
    sendEndToken,
    waiting,
    processing    
    
  );
  signal state : state_t:= idle;
begin
  
  
  process(clk) is 
  begin 
    if rising_edge(clk) then 
      desi_chain_out <= (others => '0');
      dummy_data <= (others => '0');
      case state is
        when idle => 
          desi_chain_out <= TOKEN;
          state <= sendEndToken;
        when sendEndToken =>
          desi_chain_out <= TOKEN_end;
          state <= waiting;
        when waiting => 
          if desi_chain_in = TOKEN then
            dummy_data <=  desi_chain_in;
            state <= processing;
          end if;
          
        when processing => 

          dummy_data <= desi_chain_in;
          if desi_chain_in = TOKEN_end then
            state <= idle;
          end if;
      end case;

    end if;
  end process;
  
end architecture;