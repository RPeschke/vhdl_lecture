
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.CSV_UtilityPkg.all;


-- Start Include user packages --
use work.roling_register_p.all;
use work.xgen_axistream_32.all;

-- End Include user packages --

package tx_dac_control_w_reginterface_writer_pgk is

  type tx_dac_control_w_reginterface_writer_rec is record
    regin : registert;  
    sin : std_logic;  
    sclk : std_logic;  
    pclk : std_logic;  
    reg_clr : std_logic;  

  end record;

  constant tx_dac_control_w_reginterface_writer_rec_null : tx_dac_control_w_reginterface_writer_rec := ( 
    regin => registert_null,
    sin => '0',
    sclk => '0',
    pclk => '0',
    reg_clr => '0'
  );

end tx_dac_control_w_reginterface_writer_pgk;

package body tx_dac_control_w_reginterface_writer_pgk is

end package body tx_dac_control_w_reginterface_writer_pgk;

    