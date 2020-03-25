
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.CSV_UtilityPkg.all;


-- Start Include user packages --
use work.roling_register_p.all;

-- End Include user packages --

package registerbuffer_writer_pgk is

  type registerbuffer_writer_rec is record
    registersin : registert;  
    registersout : registert;  

  end record;

  constant registerbuffer_writer_rec_null : registerbuffer_writer_rec := ( 
    registersin => registert_null,
    registersout => registert_null
  );

end registerbuffer_writer_pgk;

package body registerbuffer_writer_pgk is

end package body registerbuffer_writer_pgk;

    