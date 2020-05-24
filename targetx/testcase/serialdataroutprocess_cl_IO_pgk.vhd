
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.CSV_UtilityPkg.all;


-- Start Include user packages --
use work.serialdataconfig_pack.all;
use work.txshiftregistersignals_pack.all;
use work.tx_shift_register_readout_slave_pack.all;
use work.argg_hdl_core.all;
use work.axisstream_serialdataconfig.all;
use work.axisstream_slv32.all;
use work.readoutconfig_pack.all;
use work.tx_slro_st_pack.all;
use work.tx_sr_cl_pack.all;
use work.tx_sr_out_pack.all;

-- End Include user packages --

package serialdataroutprocess_cl_IO_pgk is


  type serialdataroutprocess_cl_writer_rec is record
    shiftregister_in_s2m : txshiftregistersignals_s2m;  
    shiftregister_in_m2s : txshiftregistersignals_m2s;  
    config_in_s2m : axistream_serialdataconfig_s2m;  
    config_in_m2s : axistream_serialdataconfig_m2s;  
    data_out_s2m : axistream_slv32_s2m;  
    data_out_m2s : axistream_slv32_m2s;  
    data_out_raw : std_logic_vector ( 15 downto 0 );  

  end record;

  constant serialdataroutprocess_cl_writer_rec_null : serialdataroutprocess_cl_writer_rec := ( 
    shiftregister_in_s2m => txshiftregistersignals_s2m_null,
    shiftregister_in_m2s => txshiftregistersignals_m2s_null,
    config_in_s2m => axistream_serialdataconfig_s2m_null,
    config_in_m2s => axistream_serialdataconfig_m2s_null,
    data_out_s2m => axistream_slv32_s2m_null,
    data_out_m2s => axistream_slv32_m2s_null,
    data_out_raw => ( others => '0' )
  );
    


  type serialdataroutprocess_cl_reader_rec is record
    shiftregister_in_m2s : txshiftregistersignals_m2s;  
    config_in_m2s : axistream_serialdataconfig_m2s;  
    data_out_s2m : axistream_slv32_s2m;  

  end record;

  constant serialdataroutprocess_cl_reader_rec_null : serialdataroutprocess_cl_reader_rec := ( 
    shiftregister_in_m2s => txshiftregistersignals_m2s_null,
    config_in_m2s => axistream_serialdataconfig_m2s_null,
    data_out_s2m => axistream_slv32_s2m_null
  );
    
end serialdataroutprocess_cl_IO_pgk;

package body serialdataroutprocess_cl_IO_pgk is

end package body serialdataroutprocess_cl_IO_pgk;

    