
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.CSV_UtilityPkg.all;


-- Start Include user packages --

-- End Include user packages --

package blinky_IO_pgk is


  type blinky_writer_rec is record
    trigger : std_logic;  
    led : std_logic;  

  end record;

  constant blinky_writer_rec_null : blinky_writer_rec := ( 
    trigger => '0',
    led => '0'
  );
    


  type blinky_reader_rec is record
    trigger : std_logic;  

  end record;

  constant blinky_reader_rec_null : blinky_reader_rec := ( 
    trigger => '0'
  );
    
end blinky_IO_pgk;

package body blinky_IO_pgk is

end package body blinky_IO_pgk;

    