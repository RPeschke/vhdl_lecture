library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

package register8bit is

  -------------------------------------------------------------------
  
  type optional_slv8 is record 
    valid : std_logic;
    data : std_logic_vector(7 downto 0);
  end record; 
  
  constant optional_slv8_null : optional_slv8  := (
    valid => '0',
    data => (others => '0')
  );
  
  procedure reset(optData : inout optional_slv8);
  
  function isValid(self : optional_slv8) return boolean;
  
  -------------------------------------------------------------
  
  type reg_addr_data8 is record
    data8o               : std_logic_vector (7  downto 0);
    addr8                : std_logic_vector (6  downto 0);
  end record;
  
  type register8Bit_m2s is record
    en8                  : std_logic;
    wr8                  : std_logic;
    rd8                  : std_logic;
    data8o               : std_logic_vector (7  downto 0);
    addr8                : std_logic_vector (6  downto 0);
  end record;
  
  constant register8Bit_m2s_null : register8Bit_m2s :=(
    en8      => '0', 
    wr8      => '0',
    rd8      => '0',
    data8o   => (others => '0'),
    addr8    => (others => '0')
  );

  
  
  type register8Bit_s2m is record
    data8i               : std_logic_vector (7  downto 0);
    ack                  : std_logic;
  end record;
  constant register8Bit_s2m_null : register8Bit_s2m :=(
    data8i   => (others => '0'),
    ack      => '0'
  );
  
  type register8Bit is record
    en8                  : std_logic;
    wr8                  : std_logic;
    rd8                  : std_logic;
    data8o               : std_logic_vector (7  downto 0);
    addr8                : std_logic_vector (6  downto 0);
    data8i               : std_logic_vector (7  downto 0);
    ack                  : std_logic;
    ack1                 : std_logic;
  end record;
  
  constant register8Bit_null : register8Bit :=(
    en8      => '0', 
    wr8      => '0',
    rd8      => '0',
    data8o   => (others => '0'),
    addr8    => (others => '0'),
    data8i   => (others => '0'),
    ack      => '0',
    ack1    => '0'
    
    
  );
  
  procedure pull( self : inout register8Bit ; signal reg_s2m : in register8Bit_s2m) ;
  procedure push( self : inout register8Bit ; signal reg_m2s : out register8Bit_m2s) ;
  procedure set2write(self : inout register8Bit) ;
  procedure send_data(self : inout register8Bit) ;
  
  procedure set_addr(self : inout register8Bit; addr : std_logic_vector) ;
  procedure set_data(self : inout register8Bit; data : std_logic_vector) ;
  
  procedure request_data(self : inout register8Bit; addr : in std_logic_vector;  data_out : inout optional_slv8);
  
  procedure request_data_current_addr(self : inout register8Bit;  data_out : inout optional_slv8);
  
  procedure stream_data(self : inout register8bit; data : in std_logic_vector);

  function hasStreamHeader(data : std_logic_vector) return boolean;
  
end package;

package body register8bit is
  
  procedure pull( self : inout register8Bit ; signal reg_s2m : in register8Bit_s2m) is
  begin
    self.ack := reg_s2m.ack;
    self.data8i := reg_s2m.data8i;
    -------- Conecting 
    
    ----- On Pull
    self.wr8 := '0';
    self.en8 := '0';
    self.rd8  := '0';
    
    self.data8o  := (others => '0');
  end procedure;
  
  procedure push( self : inout register8Bit ; signal reg_m2s : out register8Bit_m2s) is 
  begin
    ---- On Push 
    self.ack1 := self.ack;
    
    
    
    
    --------------------Conecting 
    reg_m2s.en8          <=   self.en8  ;  
    reg_m2s.wr8          <=   self.wr8 ;  
    reg_m2s.rd8          <=   self.rd8    ;
    reg_m2s.data8o       <=   self.data8o ;
    reg_m2s.addr8        <=   self.addr8  ;
    
    

  end procedure;
  
  procedure set2write(self : inout register8Bit) is 
  begin
  self.wr8 :='1';  

  end procedure;
  procedure send_data(self : inout register8Bit) is 
  begin
    self.en8 := '1';
  end procedure;
  
  procedure set_addr(self : inout register8Bit; addr : std_logic_vector) is 
  begin 
    self.addr8 := addr(self.addr8'length -1 downto 0);
  end procedure;
    
  procedure set_data(self : inout register8Bit; data : std_logic_vector) is 
  begin
    self.data8o := data(self.data8o'length -1 downto 0);
  end procedure;
  
  procedure request_data(self : inout register8Bit; addr : in std_logic_vector;  data_out : inout optional_slv8) is 
  begin 
    reset(data_out);
    self.addr8   := addr(6 downto 0);
    self.rd8  := '1';
    if self.ack1 = '1' then
      data_out.valid := '1';
      data_out.data := self.data8i;
    end if;
    
  end procedure;
  
  procedure request_data_current_addr(self : inout register8Bit;  data_out : inout optional_slv8) is
    
  begin
    request_data(self, self.addr8, data_out);
  end procedure;
    
  
  procedure stream_data(self : inout register8bit; data : in std_logic_vector) is
  begin 
    self.wr8   := '1';
    self.addr8 := (others => '0');
    self.en8 := '1';
    self.data8o := data(7 downto 0);

  end procedure;

  function hasStreamHeader(data : std_logic_vector) return boolean is 
  
  begin
    return data(15 downto 8) = x"70";

  end function;
  
  ----------------------------------------------------------------------------------------------------------
  
  
  procedure reset(optData : inout optional_slv8)is 
  begin 
    optData := optional_slv8_null;
  end procedure;
  
  function isValid(self : optional_slv8) return boolean is 
    
  begin
    return self.valid = '1';
  end function;
  
end package body;