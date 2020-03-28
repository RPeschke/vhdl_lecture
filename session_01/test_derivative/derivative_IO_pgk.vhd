
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.CSV_UtilityPkg.all;


-- Start Include user packages --
use work.system_globals.all;

-- End Include user packages --

package derivative_IO_pgk is


  type derivative_writer_rec is record
    globals : globals_t;  
    data_in : std_logic_vector ( 15 downto 0 );  
    data_out : std_logic_vector ( 15 downto 0 );  

  end record;

  constant derivative_writer_rec_null : derivative_writer_rec := ( 
    globals => globals_t_null,
    data_in => (others => '0'),
    data_out => (others => '0')
  );
    


  type derivative_reader_rec is record
    globals : globals_t;  
    data_in : std_logic_vector ( 15 downto 0 );  

  end record;

  constant derivative_reader_rec_null : derivative_reader_rec := ( 
    globals => globals_t_null,
    data_in => (others => '0')
  );
    
end derivative_IO_pgk;

package body derivative_IO_pgk is

end package body derivative_IO_pgk;

    