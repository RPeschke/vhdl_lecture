
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.CSV_UtilityPkg.all;


-- Start Include user packages --

-- End Include user packages --

package tokenring_IO_pgk is


  type tokenring_writer_rec is record
    rst : std_logic;  
    asic_a_dummy_data : std_logic_vector ( 31 downto 0 );  
    asic_b_dummy_data : std_logic_vector ( 31 downto 0 );  
    asic_c_dummy_data : std_logic_vector ( 31 downto 0 );  
    asic_d_dummy_data : std_logic_vector ( 31 downto 0 );  
    data_out : std_logic_vector ( 31 downto 0 );  

  end record;

  constant tokenring_writer_rec_null : tokenring_writer_rec := ( 
    rst => '0',
    asic_a_dummy_data => (others => '0'),
    asic_b_dummy_data => (others => '0'),
    asic_c_dummy_data => (others => '0'),
    asic_d_dummy_data => (others => '0'),
    data_out => (others => '0')
  );
    


  type tokenring_reader_rec is record
    rst : std_logic;  
    asic_a_dummy_data : std_logic_vector ( 31 downto 0 );  
    asic_b_dummy_data : std_logic_vector ( 31 downto 0 );  
    asic_c_dummy_data : std_logic_vector ( 31 downto 0 );  
    asic_d_dummy_data : std_logic_vector ( 31 downto 0 );  

  end record;

  constant tokenring_reader_rec_null : tokenring_reader_rec := ( 
    rst => '0',
    asic_a_dummy_data => (others => '0'),
    asic_b_dummy_data => (others => '0'),
    asic_c_dummy_data => (others => '0'),
    asic_d_dummy_data => (others => '0')
  );
    
end tokenring_IO_pgk;

package body tokenring_IO_pgk is

end package body tokenring_IO_pgk;

    