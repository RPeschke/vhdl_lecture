-- XGEN: Autogenerated File

library IEEE;
library UNISIM;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use UNISIM.VComponents.all;
use ieee.std_logic_unsigned.all;


package xgen_axistream_32 is 

-------------------------------------------------------------------------
------- Start Psuedo Class axisStream_32 -------------------------

type axisStream_32_m2s is record 
  last : std_logic; 
  valid : std_logic; 
  data : std_logic_vector(31 downto 0); 
end record;


constant axisStream_32_m2s_null : axisStream_32_m2s:= (
  last => '0',
  valid => '0',
  data => (others => '0')
);


type axisStream_32_m2s_a is array (natural range <>) of axisStream_32_m2s;




type axisStream_32_s2m is record 
  ready : std_logic; 
end record;


constant axisStream_32_s2m_null : axisStream_32_s2m:= (
  ready => '0'
);


type axisStream_32_s2m_a is array (natural range <>) of axisStream_32_s2m;




type axisStream_32 is record 
  last : std_logic; 
  valid : std_logic; 
  ready : std_logic; 
  data : std_logic_vector(31 downto 0); 
end record;


constant axisStream_32_null : axisStream_32:= (
  last => '0',
  valid => '0',
  ready => '0',
  data => (others => '0')
);


type axisStream_32_a is array (natural range <>) of axisStream_32;

  procedure pull ( self : inout axisStream_32;  signal ready :  in  std_logic);
  procedure push_rev ( self : inout axisStream_32; signal dataOut :  out axisStream_32_s2m);
  procedure pull ( self : inout axisStream_32; signal dataIn :  in axisStream_32_s2m);
  procedure push_rev ( self : inout axisStream_32;  signal ready :  out  std_logic);
  procedure push ( self : inout axisStream_32;  signal last :  out  std_logic; signal valid :  out  std_logic; signal data :  out  std_logic_vector(31 downto 0));
  procedure pull_rev ( self : inout axisStream_32; signal dataIn :  in axisStream_32_m2s);
  procedure push ( self : inout axisStream_32; signal dataOut :  out axisStream_32_m2s);
  procedure pull_rev ( self : inout axisStream_32;  signal last :  in  std_logic; signal valid :  in  std_logic; signal data :  in  std_logic_vector(31 downto 0));
------- End Psuedo Class axisStream_32 -------------------------
-------------------------------------------------------------------------


-------------------------------------------------------------------------
------- Start Psuedo Class axisStream_32_slave -------------------------

type axisStream_32_slave is record 
  data_isvalid : std_logic; 
  data_internal_was_read2 : std_logic; 
  data_internal_isvalid2 : std_logic; 
  data_internal_isLast2 : std_logic; 
  data_internal2 : std_logic_vector(31 downto 0); 
  rx : axisStream_32; 
end record;


constant axisStream_32_slave_null : axisStream_32_slave:= (
  data_isvalid => '0',
  data_internal_was_read2 => '0',
  data_internal_isvalid2 => '0',
  data_internal_isLast2 => '0',
  data_internal2 => (others => '0'),
  rx => axisStream_32_null
);


type axisStream_32_slave_a is array (natural range <>) of axisStream_32_slave;

  procedure pull ( self : inout axisStream_32_slave;  signal rx :  in  axisStream_32_m2s);
  procedure push (self : inout axisStream_32_slave_a; signal rx :  out  axisStream_32_s2m_a);
  procedure push ( self : inout axisStream_32_slave;  signal rx :  out  axisStream_32_s2m);
  procedure pull (self : inout axisStream_32_slave_a; signal rx :  in  axisStream_32_m2s_a);
  procedure observe_data (self : inout axisStream_32_slave; dataOut :  out  std_logic_vector(31 downto 0));
  procedure read_data (self : inout axisStream_32_slave; dataOut :  out  std_logic_vector(31 downto 0));
  function isReceivingData (  self : axisStream_32_slave) return boolean;
  function IsEndOfStream (  self : axisStream_32_slave) return boolean;
------- End Psuedo Class axisStream_32_slave -------------------------
-------------------------------------------------------------------------


-------------------------------------------------------------------------
------- Start Psuedo Class axisStream_32_master -------------------------

type axisStream_32_master is record 
  tx : axisStream_32; 
end record;


constant axisStream_32_master_null : axisStream_32_master:= (
  tx => axisStream_32_null
);


type axisStream_32_master_a is array (natural range <>) of axisStream_32_master;

  procedure pull ( self : inout axisStream_32_master;  signal tx :  in  axisStream_32_s2m);
  procedure push ( self : inout axisStream_32_master;  signal tx :  out  axisStream_32_m2s);
  procedure pull (self : inout axisStream_32_master_a; signal tx :  in  axisStream_32_s2m_a);
  procedure push (self : inout axisStream_32_master_a; signal tx :  out  axisStream_32_m2s_a);
  procedure send_data (self : inout axisStream_32_master; dataIn :  in  std_logic_vector(31 downto 0));
  function ready_to_send (  self : axisStream_32_master) return boolean;
  procedure Send_end_Of_Stream (self : inout axisStream_32_master; EndOfStream :  in  boolean);
------- End Psuedo Class axisStream_32_master -------------------------
-------------------------------------------------------------------------


-------------------------------------------------------------------------
------- Start Psuedo Class axisStream_32_master_with_counter -------------------------

type axisStream_32_master_with_counter is record 
  AxiTX : axisStream_32_master; 
  EOF_Counter_max : integer; 
  Counter : integer; 
  SendingData : std_logic; 
  EndOfStream : std_logic; 
end record;


constant axisStream_32_master_with_counter_null : axisStream_32_master_with_counter:= (
  AxiTX => axisStream_32_master_null,
  EOF_Counter_max => 0,
  Counter => 0,
  SendingData => '0',
  EndOfStream => '0'
);


type axisStream_32_master_with_counter_a is array (natural range <>) of axisStream_32_master_with_counter;

  procedure send_data_begining_at ( self : inout axisStream_32_master_with_counter; position : integer ;  datain : in std_logic_vector(31 downto 0));
  procedure Send_end_Of_Stream ( self : inout axisStream_32_master_with_counter; EndOfStream : in boolean := true);
  function ready_to_send_at_pos (   self : axisStream_32_master_with_counter; position : integer) return boolean;
  procedure send_data ( self : inout axisStream_32_master_with_counter; datain : in std_logic_vector(31 downto 0));
  function ready_to_send_begining_at (   self : axisStream_32_master_with_counter; position : integer) return boolean;
  procedure send_data_at ( self : inout axisStream_32_master_with_counter; position : integer ;  datain : in std_logic_vector(31 downto 0));
  procedure push ( self : inout axisStream_32_master_with_counter;    signal tx :  out  axisStream_32_m2s);
  function ready_to_send (   self : axisStream_32_master_with_counter) return boolean;
  procedure pull ( self : inout axisStream_32_master_with_counter;    signal tx :  in  axisStream_32_s2m);
------- End Psuedo Class axisStream_32_master_with_counter -------------------------
-------------------------------------------------------------------------


end xgen_axistream_32;


package body xgen_axistream_32 is

-------------------------------------------------------------------------
------- Start Psuedo Class axisStream_32 -------------------------
procedure pull (  self : inout axisStream_32;  signal ready :  in  std_logic) is
   
  begin 
 
    
-- Start Connecting
    
  self.ready := ready;

-- End Connecting
    
             
end procedure;

procedure push_rev (  self : inout axisStream_32; signal dataOut :  out axisStream_32_s2m) is
   
  begin 
 
    
-- Start Connecting
    
  dataOut.ready <=  self.ready;

-- End Connecting
    
             
end procedure;

procedure pull (  self : inout axisStream_32; signal dataIn :  in axisStream_32_s2m) is
   
  begin 
 
    
-- Start Connecting
    
  self.ready := dataIn.ready;

-- End Connecting
    
             
end procedure;

procedure push_rev (  self : inout axisStream_32;  signal ready :  out  std_logic) is
   
  begin 
 
    
-- Start Connecting
    
  ready <=  self.ready;

-- End Connecting
    
             
end procedure;

procedure push (  self : inout axisStream_32;  signal last :  out  std_logic; signal valid :  out  std_logic; signal data :  out  std_logic_vector(31 downto 0)) is
   
  begin 
 
    
-- Start Connecting
    
  last <=  self.last;
  valid <=  self.valid;
  data <=  self.data;

-- End Connecting
    
             
end procedure;

procedure pull_rev (  self : inout axisStream_32; signal dataIn :  in axisStream_32_m2s) is
   
  begin 
 
    
-- Start Connecting
    
  self.last := dataIn.last;
  self.valid := dataIn.valid;
  self.data := dataIn.data;

-- End Connecting
    
             
end procedure;

procedure push (  self : inout axisStream_32; signal dataOut :  out axisStream_32_m2s) is
   
  begin 
 
    
-- Start Connecting
    
  dataOut.last <=  self.last;
  dataOut.valid <=  self.valid;
  dataOut.data <=  self.data;

-- End Connecting
    
             
end procedure;

procedure pull_rev (  self : inout axisStream_32;  signal last :  in  std_logic; signal valid :  in  std_logic; signal data :  in  std_logic_vector(31 downto 0)) is
   
  begin 
 
    
-- Start Connecting
    
  self.last := last;
  self.valid := valid;
  self.data := data;

-- End Connecting
    
             
end procedure;

------- End Psuedo Class axisStream_32 -------------------------
  -------------------------------------------------------------------------


-------------------------------------------------------------------------
------- Start Psuedo Class axisStream_32_slave -------------------------
procedure pull (  self : inout axisStream_32_slave;  signal rx :  in  axisStream_32_m2s) is
   
  begin 
 
    
-- Start Connecting
    
  pull_rev( self.rx, rx);

-- End Connecting
    
    if (( self.rx.ready = '1' and self.rx.valid = '1') ) then 
      self.data_isvalid := '1';
      
    end if;
  self.data_internal_was_read2 := '0';
  self.rx.ready := '0';
  
    if (( self.data_isvalid = '1' and  not  ( self.data_internal_isvalid2 = '1' ) ) ) then 
      self.data_internal2 := self.rx.data;
      self.data_internal_isvalid2 := self.data_isvalid;
      self.data_internal_isLast2 := self.rx.last;
      self.data_isvalid := '0';
      
    end if;
  
             
end procedure;

procedure push ( self : inout axisStream_32_slave_a; signal rx :  out  axisStream_32_s2m_a) is
   
  begin 
 
        for i in 0 to self'length - 1 loop
        push(self(i) , rx(i));
        end loop;
             
end procedure;

procedure push (  self : inout axisStream_32_slave;  signal rx :  out  axisStream_32_s2m) is
   
  begin 
 
    
    if (self.data_internal_was_read2 = '1') then 
      self.data_internal_isvalid2 := '0';
      
    end if;
  
    if ((  not  ( self.data_isvalid = '1' )  and  not  ( self.data_internal_isvalid2 = '1' ) ) ) then 
      self.rx.ready := '1';
      
    end if;
  
-- Start Connecting
    
  push_rev( self.rx, rx);

-- End Connecting
    
             
end procedure;

procedure pull ( self : inout axisStream_32_slave_a; signal rx :  in  axisStream_32_m2s_a) is
   
  begin 
 
        for i in 0 to self'length - 1 loop
        pull(self(i) , rx(i));
        end loop;
             
end procedure;

procedure observe_data ( self : inout axisStream_32_slave; dataOut :  out  std_logic_vector(31 downto 0)) is
   
  begin 
 
    if (self.data_internal_isvalid2 = '1') then 
      dataOut := self.data_internal2;
      
    end if;
   
end procedure;

procedure read_data ( self : inout axisStream_32_slave; dataOut :  out  std_logic_vector(31 downto 0)) is
   
  begin 
 
    if (self.data_internal_isvalid2 = '1') then 
      dataOut := self.data_internal2;
      self.data_internal_was_read2 := '1';
      
    end if;
   
end procedure;

function isReceivingData (  self : axisStream_32_slave) return boolean is
   
  begin 
 return self.data_internal_isvalid2 = '1';
   
end function;

function IsEndOfStream (  self : axisStream_32_slave) return boolean is
   
  begin 
 return ( self.data_internal_isvalid2 = '1' and self.data_internal_isLast2 = '1') ;
   
end function;

------- End Psuedo Class axisStream_32_slave -------------------------
  -------------------------------------------------------------------------


-------------------------------------------------------------------------
------- Start Psuedo Class axisStream_32_master -------------------------
procedure pull (  self : inout axisStream_32_master;  signal tx :  in  axisStream_32_s2m) is
   
  begin 
 
    
-- Start Connecting
    
  pull( self.tx, tx);

-- End Connecting
    
    if (self.tx.ready = '1') then 
      self.tx.valid := '0';
      self.tx.last := '0';
      self.tx.data :=  (others => '0');
      
    end if;
  
             
end procedure;

procedure push (  self : inout axisStream_32_master;  signal tx :  out  axisStream_32_m2s) is
   
  begin 
 
    
-- Start Connecting
    
  push( self.tx, tx);

-- End Connecting
    
             
end procedure;

procedure pull ( self : inout axisStream_32_master_a; signal tx :  in  axisStream_32_s2m_a) is
   
  begin 
 
        for i in 0 to self'length - 1 loop
        pull(self(i) , tx(i));
        end loop;
             
end procedure;

procedure push ( self : inout axisStream_32_master_a; signal tx :  out  axisStream_32_m2s_a) is
   
  begin 
 
        for i in 0 to self'length - 1 loop
        push(self(i) , tx(i));
        end loop;
             
end procedure;

procedure send_data ( self : inout axisStream_32_master; dataIn :  in  std_logic_vector(31 downto 0)) is
   
  begin 
 self.tx.valid := '1';
  self.tx.data := dataIn;
   
end procedure;

function ready_to_send (  self : axisStream_32_master) return boolean is
   
  begin 
 return  not  ( self.tx.valid = '1' ) ;
   
end function;

procedure Send_end_Of_Stream ( self : inout axisStream_32_master; EndOfStream :  in  boolean) is
   
  begin 
 
    if (EndOfStream) then 
      self.tx.last := '1';
      
    else
      self.tx.last := '0';
      
    end if;
   
end procedure;

------- End Psuedo Class axisStream_32_master -------------------------
  -------------------------------------------------------------------------


-------------------------------------------------------------------------
------- Start Psuedo Class axisStream_32_master_with_counter -------------------------
procedure send_data_begining_at (  self : inout axisStream_32_master_with_counter; position : integer ;  datain : in std_logic_vector(31 downto 0)) is
   
  begin 
 
        if ready_to_send_begining_at(self,position) then
            send_data(self, datain);
        end if;
        
        if position < self.EOF_Counter_max then
            self.EOF_Counter_max := position;
        end if;
    
end procedure;

procedure Send_end_Of_Stream (  self : inout axisStream_32_master_with_counter; EndOfStream : in boolean := true) is
   
  begin 
 
        if EndOfStream then
            self.EndOfStream := '1';
        else
            self.EndOfStream := '0';
        end if;
        
   
 
end procedure;

function ready_to_send_at_pos (   self : axisStream_32_master_with_counter; position : integer) return boolean is
   
  begin 
 
        if self.counter = position then
            return ready_to_send(self); 
        end if;

        return false;
         
end function;

procedure send_data (  self : inout axisStream_32_master_with_counter; datain : in std_logic_vector(31 downto 0)) is
   
  begin 
 
        if ready_to_send(self) then
            send_data(self.AxiTX,datain);
            self.SendingData := '1';
        end if;
    
end procedure;

function ready_to_send_begining_at (   self : axisStream_32_master_with_counter; position : integer) return boolean is
   
  begin 
 
        if self.counter >= position  then
            return ready_to_send(self); 
        end if;
        return false;
         
end function;

procedure send_data_at (  self : inout axisStream_32_master_with_counter; position : integer ;  datain : in std_logic_vector(31 downto 0)) is
   
  begin 
 
        if ready_to_send_at_pos(self, position) then
            send_data(self, datain);
        end if;
        
        if position < self.EOF_Counter_max then
            self.EOF_Counter_max := position;
        end if;
    
end procedure;

procedure push (  self : inout axisStream_32_master_with_counter;    signal tx :  out  axisStream_32_m2s) is
   
  begin 
 
    
        if self.SendingData = '1' then
            self.counter := self.counter + 1;
        end if;
       
        if self.SendingData = '1' and self.counter = 0 and self.EndOfStream ='1' then
            
            Send_end_Of_Stream(self.AxiTX,true);
            self.EndOfStream :='0';
            
        elsif  self.SendingData = '1' and self.counter > 0 and self.EndOfStream ='1' then
            self.counter := self.EOF_Counter_max;
        end if;

        self.SendingData := '0';
        
-- Start Connecting
    
  push( self.AxiTX,   tx );

-- End Connecting
    
             
end procedure;

function ready_to_send (   self : axisStream_32_master_with_counter) return boolean is
   
  begin 
 
        return ready_to_send(self.AxiTX); 
         
end function;

procedure pull (  self : inout axisStream_32_master_with_counter;    signal tx :  in  axisStream_32_s2m) is
   
  begin 
 
    
-- Start Connecting
    
  pull( self.AxiTX,   tx );

-- End Connecting
    
             
end procedure;

------- End Psuedo Class axisStream_32_master_with_counter -------------------------
  -------------------------------------------------------------------------


end xgen_axistream_32;