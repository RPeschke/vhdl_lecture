
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.CSV_UtilityPkg.all;


-- Start Include user packages --
use work.roling_register_p.all;

-- End Include user packages --

package registerbuffer_reader_pgk is

  type registerbuffer_reader_rec is record
    registersin : registert;  

  end record;

  constant registerbuffer_reader_rec_null : registerbuffer_reader_rec := ( 
    registersin => registert_null
  );

end registerbuffer_reader_pgk;

package body registerbuffer_reader_pgk is

end package body registerbuffer_reader_pgk;

    