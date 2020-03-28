-- XGEN: Autogenerated File

library IEEE;
library UNISIM;
  use IEEE.numeric_std.all;
  use IEEE.std_logic_1164.all;
  use UNISIM.VComponents.all;
  use ieee.std_logic_unsigned.all;


package xgen_ramHandler_32_10 is 

  -------------------------------------------------------------------------
  ------- Start Psuedo Class ram_handle -------------------------


  constant addressSize: natural := 8;
  constant dataSize  : natural := 32;
  constant fifoDept  : natural := 4;

  type ram_handle_m2s is record 
    readAddress : std_logic_vector(addressSize -1  downto 0); 
    writeAddress : std_logic_vector(addressSize -1  downto 0); 
    writeData : std_logic_vector(dataSize - 1  downto 0); 
    writeEnable : std_logic; 
  end record;


  constant ram_handle_m2s_null : ram_handle_m2s:= (
    readAddress => (others => '0'),
    writeAddress => (others => '0'),
    writeData => (others => '0'),
    writeEnable => '0'
  );


  type ram_handle_m2s_a is array (natural range <>) of ram_handle_m2s;




  type ram_handle_s2m is record 
    readData : std_logic_vector(dataSize - 1  downto 0); 
  end record;


  constant ram_handle_s2m_null : ram_handle_s2m:= (
    readData => (others => '0')
  );


  type ram_handle_s2m_a is array (natural range <>) of ram_handle_s2m;




  type ram_handle is record 
    readAddress : std_logic_vector(addressSize -1  downto 0); 
    readData : std_logic_vector(dataSize - 1  downto 0); 
    writeAddress : std_logic_vector(addressSize -1  downto 0); 
    writeData : std_logic_vector(dataSize - 1  downto 0); 
    writeEnable : std_logic; 
  end record;


  constant ram_handle_null : ram_handle:= (
    readAddress => (others => '0'),
    readData => (others => '0'),
    writeAddress => (others => '0'),
    writeData => (others => '0'),
    writeEnable => '0'
  );


  type ram_handle_a is array (natural range <>) of ram_handle;

  procedure pull ( self : inout ram_handle;  signal readData :  in  std_logic_vector(dataSize - 1  downto 0));
  procedure pull_rev ( self : inout ram_handle;  signal readAddress :  in  std_logic_vector(addressSize -1  downto 0); signal writeAddress :  in  std_logic_vector(addressSize -1  downto 0); signal writeData :  in  std_logic_vector(dataSize - 1  downto 0); signal writeEnable :  in  std_logic);
  procedure push_rev ( self : inout ram_handle;  signal readData :  out  std_logic_vector(dataSize - 1  downto 0));
  procedure push ( self : inout ram_handle;  signal readAddress :  out  std_logic_vector(addressSize -1  downto 0); signal writeAddress :  out  std_logic_vector(addressSize -1  downto 0); signal writeData :  out  std_logic_vector(dataSize - 1  downto 0); signal writeEnable :  out  std_logic);
  procedure push ( self : inout ram_handle; signal dataOut :  out ram_handle_m2s);
  procedure push_rev ( self : inout ram_handle; signal dataOut :  out ram_handle_s2m);
  procedure pull ( self : inout ram_handle; signal dataIn :  in ram_handle_s2m);
  procedure pull_rev ( self : inout ram_handle; signal dataIn :  in ram_handle_m2s);
  ------- End Psuedo Class ram_handle -------------------------
  -------------------------------------------------------------------------


  -------------------------------------------------------------------------
  ------- Start Psuedo Class ram_handle_master -------------------------


  type ram_handler_fifo is record 
    requesting_data : std_logic; 
    Address : std_logic_vector(addressSize -1  downto 0);
    Data : std_logic_vector(dataSize - 1  downto 0); 
    Data_was_read : std_logic; 
  end record ;

  constant ram_handler_fifo_null : ram_handler_fifo:= (

    requesting_data => '0',
    Address => (others => '0'),
    Data => (others => '0'),
    Data_was_read => '0'
  );

  type ram_handler_fifo_a is array (natural range <>) of ram_handler_fifo;

  type ram_handle_master is record 
    read_process_fifo :  ram_handler_fifo_a(2 downto 0);
    read_data_fifo :  ram_handler_fifo_a(fifoDept -1 downto 0);
    txrx : ram_handle; 
    writeEnable_internal : std_logic; 
  end record;


  constant ram_handle_master_null : ram_handle_master:= (
    read_process_fifo => (others => ram_handler_fifo_null),
    read_data_fifo => (others => ram_handler_fifo_null),
    txrx => ram_handle_null,
    writeEnable_internal => '0'
  );


  type ram_handle_master_a is array (natural range <>) of ram_handle_master;

  procedure push ( self : inout ram_handle_master;  signal txrx :  out  ram_handle_m2s);
  procedure pull ( self : inout ram_handle_master;  signal txrx :  in  ram_handle_s2m);

  function Nr_of_free_Slots(self: ram_handle_master) return integer;
  function isReady2Store (  self : ram_handle_master) return boolean;
  procedure Store_Data (self : inout ram_handle_master; Address :  in  std_logic_vector; Data :  in  std_logic_vector);
  procedure request_Data (self : inout ram_handle_master; Address :  in  std_logic_vector);
  function isReady2Load (  self : ram_handle_master; Address :   std_logic_vector) return boolean;
  procedure read_Data (self : inout ram_handle_master; Address :  in  std_logic_vector; Data :  out  std_logic_vector);
  procedure reset(self : inout ram_handle_master);
  ------- End Psuedo Class ram_handle_master -------------------------
  -------------------------------------------------------------------------


end xgen_ramHandler_32_10;


package body xgen_ramHandler_32_10 is

  -------------------------------------------------------------------------
  ------- Start Psuedo Class ram_handle -------------------------
  procedure pull (  self : inout ram_handle;  signal readData :  in  std_logic_vector(dataSize - 1  downto 0)) is

  begin 


    -- Start Connecting

    self.readData := readData;

    -- End Connecting


  end procedure;

  procedure pull_rev (  self : inout ram_handle;  signal readAddress :  in  std_logic_vector(addressSize -1  downto 0); signal writeAddress :  in  std_logic_vector(addressSize -1  downto 0); signal writeData :  in  std_logic_vector(dataSize - 1  downto 0); signal writeEnable :  in  std_logic) is

  begin 


    -- Start Connecting

    self.readAddress := readAddress;
    self.writeAddress := writeAddress;
    self.writeData := writeData;
    self.writeEnable := writeEnable;

    -- End Connecting


  end procedure;

  procedure push_rev (  self : inout ram_handle;  signal readData :  out  std_logic_vector(dataSize - 1  downto 0)) is

  begin 


    -- Start Connecting

    readData <=  self.readData;

    -- End Connecting


  end procedure;

  procedure push (  self : inout ram_handle;  signal readAddress :  out  std_logic_vector(addressSize -1  downto 0); signal writeAddress :  out  std_logic_vector(addressSize -1  downto 0); signal writeData :  out  std_logic_vector(dataSize - 1  downto 0); signal writeEnable :  out  std_logic) is

  begin 


    -- Start Connecting

    readAddress <=  self.readAddress;
    writeAddress <=  self.writeAddress;
    writeData <=  self.writeData;
    writeEnable <=  self.writeEnable;

    -- End Connecting


  end procedure;

  procedure push (  self : inout ram_handle; signal dataOut :  out ram_handle_m2s) is

  begin 


    -- Start Connecting

    dataOut.readAddress <=  self.readAddress;
    dataOut.writeAddress <=  self.writeAddress;
    dataOut.writeData <=  self.writeData;
    dataOut.writeEnable <=  self.writeEnable;

    -- End Connecting


  end procedure;

  procedure push_rev (  self : inout ram_handle; signal dataOut :  out ram_handle_s2m) is

  begin 


    -- Start Connecting

    dataOut.readData <=  self.readData;

    -- End Connecting


  end procedure;

  procedure pull (  self : inout ram_handle; signal dataIn :  in ram_handle_s2m) is

  begin 


    -- Start Connecting

    self.readData := dataIn.readData;

    -- End Connecting


  end procedure;

  procedure pull_rev (  self : inout ram_handle; signal dataIn :  in ram_handle_m2s) is

  begin 


    -- Start Connecting

    self.readAddress := dataIn.readAddress;
    self.writeAddress := dataIn.writeAddress;
    self.writeData := dataIn.writeData;
    self.writeEnable := dataIn.writeEnable;

    -- End Connecting


  end procedure;

  ------- End Psuedo Class ram_handle -------------------------
  -------------------------------------------------------------------------


  -------------------------------------------------------------------------
  ------- Start Psuedo Class ram_handle_master -------------------------
  procedure push (  self : inout ram_handle_master;  signal txrx :  out  ram_handle_m2s) is

  begin 
    self.txrx.writeEnable := self.writeEnable_internal;



    self.txrx.readAddress := self.read_process_fifo(0).Address;
    -- Start Connecting

    push( self.txrx, txrx);

    -- End Connecting


  end procedure;

  procedure pull (  self : inout ram_handle_master;  signal txrx :  in  ram_handle_s2m) is

  begin 


    -- Start Connecting

    pull( self.txrx, txrx);

    -- End Connecting

    for i in 1 to self.read_process_fifo'length - 1 loop
      self.read_process_fifo(self.read_process_fifo'length - i)  := self.read_process_fifo(self.read_process_fifo'length - 1 -i);
    end loop;

    self.read_process_fifo(0).requesting_data := '0';
    self.read_process_fifo(2).Data := self.txrx.readData;

    if Nr_of_free_Slots(self) > 1 or self.read_process_fifo(2).requesting_data = '1' then
      for i in 1 to self.read_data_fifo'length - 1 loop
        self.read_data_fifo(self.read_data_fifo'length - i) := self.read_data_fifo(self.read_data_fifo'length - 1 -i);
      end loop;
      self.read_data_fifo(0) := self.read_process_fifo(2);
      self.read_process_fifo(0).Address := self.read_process_fifo(1).Address +1;
    end if;






    self.writeEnable_internal := '0';
  end procedure;

  function Nr_of_free_Slots(self: ram_handle_master) return integer is 
    variable ret : integer := self.read_data_fifo'length;
  begin 
    for i in 0 to self.read_data_fifo'length - 1 loop
      if self.read_data_fifo(i).requesting_data = '1' and  self.read_data_fifo(i).Data_was_read  ='0'  then 
        ret := self.read_data_fifo'length - i;
        return ret;
      end if;

      if self.read_data_fifo(i).requesting_data = '1' and  self.read_data_fifo(i).Data_was_read  ='1'  then 
        ret := self.read_data_fifo'length;
        return ret;
      end if;
    end loop;
    return ret;
  end function;

  function isReady2Store (  self : ram_handle_master) return boolean is

  begin 
    return self.writeEnable_internal = '0';

  end function;

  procedure Store_Data ( self : inout ram_handle_master; Address :  in  std_logic_vector; Data :  in  std_logic_vector) is

  begin 

    if (isReady2Store(self)) then 
      self.writeEnable_internal := '1';
      self.txrx.writeAddress(addressSize - 1  downto 0) := Address(addressSize - 1  downto 0);
      self.txrx.writeData(dataSize - 1  downto 0) := Data(dataSize - 1  downto 0);

    end if;

  end procedure;

  procedure request_Data ( self : inout ram_handle_master; Address :  in  std_logic_vector) is

  begin 


    for i in 0 to self.read_data_fifo'length - 1 loop
      if self.read_data_fifo(i).Address = Address then
        self.read_data_fifo(i).requesting_data := '1';
        return;
      end if;
    end loop;

    for i in 0 to self.read_process_fifo'length - 1 loop
      if self.read_process_fifo(i).Address = Address then
        self.read_process_fifo(i).requesting_data := '1';
        return;
      end if;
    end loop;

    self.read_process_fifo(0).Address(addressSize - 1 downto 0) := Address(addressSize - 1 downto 0);
    self.read_process_fifo(0).requesting_data := '1';



  end procedure;

  function isReady2Load (  self : ram_handle_master; Address :   std_logic_vector) return boolean is

  begin 
    for i in 0 to self.read_data_fifo'length - 1 loop
      if self.read_data_fifo(i).Address = Address then
        return true;
      end if;
    end loop;
    return   false;

  end function;

  procedure read_Data ( self : inout ram_handle_master; Address :  in  std_logic_vector; Data :  out  std_logic_vector) is

  begin 

    for i in 0 to self.read_data_fifo'length - 1 loop
      if (self.read_data_fifo(i).Address = Address) then
        Data := self.read_data_fifo(i).Data;
        self.read_data_fifo(i).Data_was_read := '1';        
        self.read_data_fifo(i).requesting_data := '1';    
      end if;
    end loop;


  end procedure;
  procedure reset(self : inout ram_handle_master) is
  begin
    self.read_data_fifo :=  (others => ram_handler_fifo_null);
    self.read_process_fifo :=  (others => ram_handler_fifo_null);
    
  end procedure;
  ------- End Psuedo Class ram_handle_master -------------------------
  -------------------------------------------------------------------------


end xgen_ramHandler_32_10;