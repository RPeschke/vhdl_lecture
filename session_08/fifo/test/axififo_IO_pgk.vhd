
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.CSV_UtilityPkg.all;


-- Start Include user packages --
use work.argg_hdl_core.all;
use work.axisstream_slv32.all;
use work.slv32_a_pack.all;

-- End Include user packages --

package axififo_IO_pgk is


  type axififo_writer_rec is record
    axi_in_s2m : axistream_slv32_s2m;  
    axi_in_m2s : axistream_slv32_m2s;  
    axi_out_s2m : axistream_slv32_s2m;  
    axi_out_m2s : axistream_slv32_m2s;  

  end record;

  constant axififo_writer_rec_null : axififo_writer_rec := ( 
    axi_in_s2m => axistream_slv32_s2m_null,
    axi_in_m2s => axistream_slv32_m2s_null,
    axi_out_s2m => axistream_slv32_s2m_null,
    axi_out_m2s => axistream_slv32_m2s_null
  );
    


  type axififo_reader_rec is record
    axi_in_m2s : axistream_slv32_m2s;  
    axi_out_s2m : axistream_slv32_s2m;  

  end record;

  constant axififo_reader_rec_null : axififo_reader_rec := ( 
    axi_in_m2s => axistream_slv32_m2s_null,
    axi_out_s2m => axistream_slv32_s2m_null
  );
    
end axififo_IO_pgk;

package body axififo_IO_pgk is

end package body axififo_IO_pgk;

    