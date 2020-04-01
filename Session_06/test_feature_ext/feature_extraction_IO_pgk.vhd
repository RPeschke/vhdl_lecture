
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.CSV_UtilityPkg.all;


-- Start Include user packages --
use work.xgen_axistream_32.all;
use work.system_globals.all;
use work.roling_register_p.all;

-- End Include user packages --

package feature_extraction_IO_pgk is


  type feature_extraction_writer_rec is record
    globals : globals_t;  
    data_in_m2s : axisstream_32_m2s;  
    data_in_s2m : axisstream_32_s2m;  
    trigger_in_m2s : axisstream_32_m2s;  
    trigger_in_s2m : axisstream_32_s2m;  
    data_out_m2s : axisstream_32_m2s;  
    data_out_s2m : axisstream_32_s2m;  

  end record;

  constant feature_extraction_writer_rec_null : feature_extraction_writer_rec := ( 
    globals => globals_t_null,
    data_in_m2s => axisstream_32_m2s_null,
    data_in_s2m => axisstream_32_s2m_null,
    trigger_in_m2s => axisstream_32_m2s_null,
    trigger_in_s2m => axisstream_32_s2m_null,
    data_out_m2s => axisstream_32_m2s_null,
    data_out_s2m => axisstream_32_s2m_null
  );
    


  type feature_extraction_reader_rec is record
    globals : globals_t;  
    data_in_m2s : axisstream_32_m2s;  
    trigger_in_m2s : axisstream_32_m2s;  
    data_out_s2m : axisstream_32_s2m;  

  end record;

  constant feature_extraction_reader_rec_null : feature_extraction_reader_rec := ( 
    globals => globals_t_null,
    data_in_m2s => axisstream_32_m2s_null,
    trigger_in_m2s => axisstream_32_m2s_null,
    data_out_s2m => axisstream_32_s2m_null
  );
    
end feature_extraction_IO_pgk;

package body feature_extraction_IO_pgk is

end package body feature_extraction_IO_pgk;

    