library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

entity blinky is
  port (
    clk     : in  std_logic;
    trigger : in  std_logic;
    led     : out std_logic
    
  );
end entity;

architecture rtl of blinky is
  type state_t is (
    idle,
    light_on,
    light_off
    
  );
  signal i_state: state_t := idle;
  constant max_counter : integer := 5;
begin
  
  process(clk) is 
    variable counter  : integer := 0;
    variable counter1 : integer := 0;
  begin 
    if rising_edge(clk) then
      -- <reset> 
      led <= '0';
      -- </reset> 
      
      
      -- <State Machine>
      case  i_state is 
        when idle => 
          counter1 := 0;
          counter  := 0;
          if trigger = '1' then 
            i_state <= light_on;
          end if;
        when light_on => 
          led <= '1';
          counter := counter + 1;
          if counter > max_counter then 
            i_state <= light_off;
            counter := 0;
          end if;
        when light_off => 
          counter := counter + 1;
          if counter > max_counter then 
            i_state <= light_on;
            counter := 0;
            counter1 := counter1 +1;
          end if;
          if counter1 > max_counter then 
            i_state <= idle;
          end if;
          
      end case;
     -- <state Machine> 
    end if;
  end process;
end architecture;