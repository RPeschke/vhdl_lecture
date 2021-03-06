-- XGEN: Autogenerated File

-- Unable to locate package which contains class: 'register'  $$$missingInclude$$$
library IEEE;
library IEEE;
library UNISIM;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use UNISIM.VComponents.all;


package xgen_axistream_register_t is 

-------------------------------------------------------------------------
------- Start Psuedo Class axisStream_register -------------------------

type axisStream_register_m2s is record 
  valid : std_logic; 
  last : std_logic; 
  data : registerT; 
end record;


constant axisStream_register_m2s_null : axisStream_register_m2s:= (
  valid => '0',
  last => '0',
  data => register_null
);


type axisStream_register_m2s_a is array (natural range <>) of axisStream_register_m2s;




type axisStream_register_s2m is record 
  ready : std_logic; 
end record;


constant axisStream_register_s2m_null : axisStream_register_s2m:= (
  ready => '0'
);


type axisStream_register_s2m_a is array (natural range <>) of axisStream_register_s2m;




type axisStream_register is record 
  valid : std_logic; 
  last : std_logic; 
  data : register; 
  ready : std_logic; 
end record;


constant axisStream_register_null : axisStream_register:= (
  valid => '0',
  last => '0',
  data => register_null,
  ready => '0'
);


type axisStream_register_a is array (natural range <>) of axisStream_register;

  procedure pull ( self : inout axisStream_register; signal dataIn :  in axisStream_register_s2m);
  procedure pull ( self : inout axisStream_register;  signal ready :  in  std_logic);
  procedure push ( self : inout axisStream_register; signal dataOut :  out axisStream_register_m2s);
  procedure push ( self : inout axisStream_register;  signal valid :  out  std_logic; signal last :  out  std_logic; signal data :  out  register);
  procedure pull_rev ( self : inout axisStream_register; signal dataIn :  in axisStream_register_m2s);
  procedure pull_rev ( self : inout axisStream_register;  signal valid :  in  std_logic; signal last :  in  std_logic; signal data :  in  register);
  procedure push_rev ( self : inout axisStream_register; signal dataOut :  out axisStream_register_s2m);
  procedure push_rev ( self : inout axisStream_register;  signal ready :  out  std_logic);
------- End Psuedo Class axisStream_register -------------------------
-------------------------------------------------------------------------


-------------------------------------------------------------------------
------- Start Psuedo Class axisStream_register_slave -------------------------

type axisStream_register_slave is record 
  rx : axisStream_register; 
  data_isvalid : std_logic; 
  data_internal2 : register; 
  data_internal_isvalid2 : std_logic; 
  data_internal_was_read2 : std_logic; 
  data_internal_isLast2 : std_logic; 
end record;


constant axisStream_register_slave_null : axisStream_register_slave:= (
  rx => axisStream_register_null,
  data_isvalid => '0',
  data_internal2 => register_null,
  data_internal_isvalid2 => '0',
  data_internal_was_read2 => '0',
  data_internal_isLast2 => '0'
);


type axisStream_register_slave_a is array (natural range <>) of axisStream_register_slave;

  procedure read_data ( self : inout axisStream_register_slave; datain : out register);
  function isReceivingData (   self : axisStream_register_slave) return boolean;
  function IsEndOfStream (   self : axisStream_register_slave) return boolean;
  procedure pull ( self : inout axisStream_register_slave;  signal rx :  in  axisStream_register_m2s);
  procedure push ( self : inout axisStream_register_slave;  signal rx :  out  axisStream_register_s2m);
------- End Psuedo Class axisStream_register_slave -------------------------
-------------------------------------------------------------------------


-------------------------------------------------------------------------
------- Start Psuedo Class axisStream_register_master -------------------------

type axisStream_register_master is record 
  tx : axisStream_register; 
end record;


constant axisStream_register_master_null : axisStream_register_master:= (
  tx => axisStream_register_null
);


type axisStream_register_master_a is array (natural range <>) of axisStream_register_master;

  procedure send_data ( self : inout axisStream_register_master; datain : in register);
  function ready_to_send (   self : axisStream_register_master) return boolean;
  procedure Send_end_Of_Stream ( self : inout axisStream_register_master; EndOfStream : in boolean := true);
  procedure pull ( self : inout axisStream_register_master;  signal tx :  in  axisStream_register_s2m);
  procedure push ( self : inout axisStream_register_master;  signal tx :  out  axisStream_register_m2s);
------- End Psuedo Class axisStream_register_master -------------------------
-------------------------------------------------------------------------


end xgen_axistream_register_t;


package body xgen_axistream_register_t is

-------------------------------------------------------------------------
------- Start Psuedo Class axisStream_register -------------------------
procedure pull (  self : inout axisStream_register; signal dataIn :  in axisStream_register_s2m) is
   
  begin 
 
    
-- Start Connecting
    
  self.ready := dataIn.ready;

-- End Connecting
    
             
end procedure;

procedure pull (  self : inout axisStream_register;  signal ready :  in  std_logic) is
   
  begin 
 
    
-- Start Connecting
    
  self.ready := ready;

-- End Connecting
    
             
end procedure;

procedure push (  self : inout axisStream_register; signal dataOut :  out axisStream_register_m2s) is
   
  begin 
 
    
-- Start Connecting
    
  dataOut.valid <=  self.valid;
  dataOut.last <=  self.last;
  dataOut.data <=  self.data;

-- End Connecting
    
             
end procedure;

procedure push (  self : inout axisStream_register;  signal valid :  out  std_logic; signal last :  out  std_logic; signal data :  out  register) is
   
  begin 
 
    
-- Start Connecting
    
  valid <=  self.valid;
  last <=  self.last;
  data <=  self.data;

-- End Connecting
    
             
end procedure;

procedure pull_rev (  self : inout axisStream_register; signal dataIn :  in axisStream_register_m2s) is
   
  begin 
 
    
-- Start Connecting
    
  self.valid := dataIn.valid;
  self.last := dataIn.last;
  self.data := dataIn.data;

-- End Connecting
    
             
end procedure;

procedure pull_rev (  self : inout axisStream_register;  signal valid :  in  std_logic; signal last :  in  std_logic; signal data :  in  register) is
   
  begin 
 
    
-- Start Connecting
    
  self.valid := valid;
  self.last := last;
  self.data := data;

-- End Connecting
    
             
end procedure;

procedure push_rev (  self : inout axisStream_register; signal dataOut :  out axisStream_register_s2m) is
   
  begin 
 
    
-- Start Connecting
    
  dataOut.ready <=  self.ready;

-- End Connecting
    
             
end procedure;

procedure push_rev (  self : inout axisStream_register;  signal ready :  out  std_logic) is
   
  begin 
 
    
-- Start Connecting
    
  ready <=  self.ready;

-- End Connecting
    
             
end procedure;

------- End Psuedo Class axisStream_register -------------------------
  -------------------------------------------------------------------------


-------------------------------------------------------------------------
------- Start Psuedo Class axisStream_register_slave -------------------------
-------------------------------------------------------------------------
------- Start Psuedo Class axisStream_register -------------------------
------- End Psuedo Class axisStream_register -------------------------
  -------------------------------------------------------------------------


procedure read_data (  self : inout axisStream_register_slave; datain : out register) is
   
  begin 
 
    if(self.data_internal_isvalid2 = '1') then
        datain := self.data_internal2;
        self.data_internal_was_read2 :='1';
    end if;
 
end procedure;

function isReceivingData (   self : axisStream_register_slave) return boolean is
   
  begin 
 
    return  self.data_internal_isvalid2 = '1' ;
 
end function;

function IsEndOfStream (   self : axisStream_register_slave) return boolean is
   
  begin 
 
    return  self.data_internal_isvalid2 = '1' and  self.data_internal_isLast2 = '1';
 
end function;

procedure pull (  self : inout axisStream_register_slave;  signal rx :  in  axisStream_register_m2s) is
   
  begin 
 
    
-- Start Connecting
    
  pull_rev( self.rx, rx);

-- End Connecting
    
    if( self.rx.ready = '1'  and self.rx.valid ='1') then 
        self.data_isvalid := '1';
    end if;

    self.data_internal_was_read2 := '0';
    self.rx.ready := '0';


    if (self.data_isvalid ='1' and  self.data_internal_isvalid2 = '0') then
        self.data_internal2:= self.rx.data ;
        self.data_internal_isvalid2 := self.data_isvalid;
        self.data_internal_isLast2 := self.rx.last;
        self.data_isvalid:='0';

    end if;
        
             
end procedure;

procedure push (  self : inout axisStream_register_slave;  signal rx :  out  axisStream_register_s2m) is
   
  begin 
 
    
    if (self.data_internal_was_read2 = '1'   ) then
      self.data_internal_isvalid2 := '0';
    end if;


    if (self.data_isvalid = '0'   and self.data_internal_isvalid2 = '0' ) then 
        self.rx.ready := '1';
    end if;
        
-- Start Connecting
    
  push_rev( self.rx, rx);

-- End Connecting
    
             
end procedure;

------- End Psuedo Class axisStream_register_slave -------------------------
  -------------------------------------------------------------------------


-------------------------------------------------------------------------
------- Start Psuedo Class axisStream_register_master -------------------------
-------------------------------------------------------------------------
------- Start Psuedo Class axisStream_register -------------------------
------- End Psuedo Class axisStream_register -------------------------
  -------------------------------------------------------------------------


procedure send_data (  self : inout axisStream_register_master; datain : in register) is
   
  begin 
 
   self.tx.valid   := '1';
   self.tx.data    := datain; 
 
end procedure;

function ready_to_send (   self : axisStream_register_master) return boolean is
   
  begin 
 
    return self.tx.valid = '0';
 
end function;

procedure Send_end_Of_Stream (  self : inout axisStream_register_master; EndOfStream : in boolean := true) is
   
  begin 
 
    if EndOfStream then 
        self.tx.last := '1';
    else 
        self.tx.last := '0';
    end if; 
 
end procedure;

procedure pull (  self : inout axisStream_register_master;  signal tx :  in  axisStream_register_s2m) is
   
  begin 
 
    
-- Start Connecting
    
  pull( self.tx, tx);

-- End Connecting
    
    if (self.tx.ready = '1') then 
        self.tx.valid   := '0'; 
        self.tx.last := '0';  
        self.tx.data := register_null;
    end if;
        
             
end procedure;

procedure push (  self : inout axisStream_register_master;  signal tx :  out  axisStream_register_m2s) is
   
  begin 
 
    
-- Start Connecting
    
  push( self.tx, tx);

-- End Connecting
    
             
end procedure;

------- End Psuedo Class axisStream_register_master -------------------------
  -------------------------------------------------------------------------


end xgen_axistream_register_t;