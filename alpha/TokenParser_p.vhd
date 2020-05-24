library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

package TokenParser_p is
  constant TOKEN_header : STD_LOGIC_VECTOR(31 downto 0) := x"FFFFFFFE";
  constant TOKEN_end : STD_LOGIC_VECTOR(31 downto 0) := x"FFFFFFFF";
  constant ASIC_A: STD_LOGIC_VECTOR(31 downto 0) := x"AAAAAAAA";
  constant ASIC_B: STD_LOGIC_VECTOR(31 downto 0) := x"BBBBBBBB";
  constant ASIC_C: STD_LOGIC_VECTOR(31 downto 0) := x"CCCCCCCC";
  constant ASIC_D: STD_LOGIC_VECTOR(31 downto 0) := x"DDDDDDDD";
  
  
  type tokenring_interface_m2s is record
    data :  STD_LOGIC_VECTOR(31 downto 0);
  end record;
  
  constant tokenring_interface_m2s_null : tokenring_interface_m2s := (
    data => (others => '0')
  );
  
  type tokenring_interface_s2m is record
    token :  STD_LOGIC;
  end record;
  
  constant tokenring_interface_s2m_null : tokenring_interface_s2m := (
    token => '0'
  );
  -- Master
  type tokenring_interface_master is record 
    data :  STD_LOGIC_VECTOR(31 downto 0);
    token :  STD_LOGIC;
  end record;
  constant tokenring_interface_master_null : tokenring_interface_master := (
    data => (others => '0'),
    token => '0'
  );
  
  procedure pull( self : inout tokenring_interface_master ;signal tx : tokenring_interface_s2m);
  procedure push( self : inout tokenring_interface_master ;signal tx : out tokenring_interface_m2s);
  function isReadyToSend(self : tokenring_interface_master) return boolean;
  procedure send_data(self : inout tokenring_interface_master; data : STD_LOGIC_VECTOR);
  -- end master
  -- slave
  type tokenring_interface_slave is record 
    data :  STD_LOGIC_VECTOR(31 downto 0);
    token :  STD_LOGIC;
  end record;

  constant tokenring_interface_slave_null : tokenring_interface_slave := (
    data => (others => '0'),
    token => '0'
  );
  procedure pull( self : inout tokenring_interface_slave ;signal rx : tokenring_interface_m2s);
  procedure push( self : inout tokenring_interface_slave ;signal rx : out tokenring_interface_s2m);

  function isReceivingData(self : tokenring_interface_slave) return boolean;
  function isEndOfStream(self : tokenring_interface_slave) return boolean;
  procedure getData(self : inout tokenring_interface_slave; data: out STD_LOGIC_VECTOR); 
  procedure send_token(self : inout tokenring_interface_slave; token : boolean := true);
  -- end slave

end package;

package body TokenParser_p is
  -- Master
  procedure pull( self : inout tokenring_interface_master ;signal tx : tokenring_interface_s2m) is
    -- my headset run out of accu 
  begin 
    self.token := tx.token;
    self.data := (others => '0');
  end procedure;
  
  procedure push( self : inout tokenring_interface_master ;signal tx : out tokenring_interface_m2s) is
    
  begin 
    tx.data <= self.data;
    
  end procedure;
  
  function isReadyToSend(self : tokenring_interface_master) return boolean is
  begin
    return self.token = '1';
  end function;
  procedure send_data(self : inout tokenring_interface_master; data : STD_LOGIC_VECTOR)is 
  begin 
    self.data := data;
  end procedure;
  
  -- end master
  
  
  
   -- slave
  procedure pull( self : inout tokenring_interface_slave ;signal rx : tokenring_interface_m2s) is 
    
  begin
    -- conection
    self.data := rx.data;
    
    -- on pull 
    self.token := '0';
    
  end procedure;
    
  procedure push( self : inout tokenring_interface_slave ;signal rx : out tokenring_interface_s2m) is 
    begin
      rx.token <= self.token;
    end procedure;
    
    function isReceivingData(self : tokenring_interface_slave) return boolean is 
    begin 
      return self.data = TOKEN_header;
    end function;

    function isEndOfStream(self : tokenring_interface_slave) return boolean is 

    begin
      return self.data = TOKEN_end;
    end function;
    procedure getData(self : inout tokenring_interface_slave; data: out STD_LOGIC_VECTOR) is 
    begin
      data := self.data;      
    end procedure;
    
    procedure send_token(self : inout tokenring_interface_slave; token : boolean := true)is 
    begin
      if (token) then
        self.token := '1';
      end if;
    end procedure;
        -- end slave
end package body;