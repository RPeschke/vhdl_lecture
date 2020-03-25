
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.CSV_UtilityPkg.all;


-- Start Include user packages --
use work.roling_register_p.all;
use work.xgen_axistream_32.all;

-- End Include user packages --

package tx_dac_control_w_reginterface_reader_pgk is

  type tx_dac_control_w_reginterface_reader_rec is record
    regin : registert;  

  end record;

  constant tx_dac_control_w_reginterface_reader_rec_null : tx_dac_control_w_reginterface_reader_rec := ( 
    regin => registert_null
  );

end tx_dac_control_w_reginterface_reader_pgk;

package body tx_dac_control_w_reginterface_reader_pgk is

end package body tx_dac_control_w_reginterface_reader_pgk;

    