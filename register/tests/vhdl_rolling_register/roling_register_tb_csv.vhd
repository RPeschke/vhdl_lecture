


library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.type_conversions_pgk.all;
use work.CSV_UtilityPkg.all;



use work.roling_register_IO_pgk.all;


entity roling_register_reader_et  is
    generic (
        FileName : string := "./roling_register_in.csv"
    );
    port (
        clk : in std_logic ;
        data : out roling_register_reader_rec
    );
end entity;   

architecture Behavioral of roling_register_reader_et is 

  constant  NUM_COL    : integer := 4;
  signal    csv_r_data : c_integer_array(NUM_COL -1 downto 0)  := (others=>0)  ;
begin

  csv_r :entity  work.csv_read_file 
    generic map (
        FileName =>  FileName, 
        NUM_COL => NUM_COL,
        useExternalClk=>true,
        HeaderLines =>  2
    ) port map (
        clk => clk,
        Rows => csv_r_data
    );

  integer_to_sl(csv_r_data(0), data.registerin_m2s.valid);
  integer_to_sl(csv_r_data(1), data.registerin_m2s.last);
  integer_to_slv(csv_r_data(2), data.registerin_m2s.data.address);
  integer_to_slv(csv_r_data(3), data.registerin_m2s.data.value);


end Behavioral;
---------------------------------------------------------------------------------------------------
    


library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.type_conversions_pgk.all;
use work.CSV_UtilityPkg.all;



use work.roling_register_IO_pgk.all;

entity roling_register_writer_et  is
    generic ( 
        FileName : string := "./roling_register_out.csv"
    ); port (
        clk : in std_logic ;
        data : in roling_register_writer_rec
    );
end entity;

architecture Behavioral of roling_register_writer_et is 
  constant  NUM_COL : integer := 9;
  signal data_int   : c_integer_array(NUM_COL - 1 downto 0)  := (others=>0);
begin

    csv_w : entity  work.csv_write_file 
        generic map (
            FileName => FileName,
            HeaderLines=> "registerin_m2s_valid; registerin_m2s_last; registerin_m2s_data_address; registerin_m2s_data_value; registerin_s2m_ready; globals_clk; globals_rst; globals_reg_address; globals_reg_value",
            NUM_COL =>   NUM_COL 
        ) port map(
            clk => clk, 
            Rows => data_int
        );


  sl_to_integer(data.registerin_m2s.valid, data_int(0) );
  sl_to_integer(data.registerin_m2s.last, data_int(1) );
  slv_to_integer(data.registerin_m2s.data.address, data_int(2) );
  slv_to_integer(data.registerin_m2s.data.value, data_int(3) );
  sl_to_integer(data.registerin_s2m.ready, data_int(4) );
  sl_to_integer(data.globals.clk, data_int(5) );
  sl_to_integer(data.globals.rst, data_int(6) );
  slv_to_integer(data.globals.reg.address, data_int(7) );
  slv_to_integer(data.globals.reg.value, data_int(8) );


end Behavioral;
---------------------------------------------------------------------------------------------------
    

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.type_conversions_pgk.all;
use work.CSV_UtilityPkg.all;


use work.roling_register_IO_pgk.all;

entity roling_register_tb_csv is 
end entity;

architecture behavior of roling_register_tb_csv is 
  signal clk : std_logic := '0';
  signal data_in : roling_register_reader_rec := roling_register_reader_rec_null;
  signal data_out : roling_register_writer_rec := roling_register_writer_rec_null;

begin 

  clk_gen : entity work.ClockGenerator generic map ( CLOCK_period => 10 ns) port map ( clk => clk );

  csv_read : entity work.roling_register_reader_et 
    generic map (
        FileName => "./roling_register_tb_csv.csv" 
    ) port map (
        clk => clk ,data => data_in
    );
 
  csv_write : entity work.roling_register_writer_et
    generic map (
        FileName => "./roling_register_tb_csv_out.csv" 
    ) port map (
        clk => clk ,data => data_out
    );
  

  data_out.globals.clk <=clk;
  data_out.registerin_m2s <= data_in.registerin_m2s;


DUT :  entity work.roling_register  port map(
  clk => clk,
registerin_m2s => data_out.registerin_m2s,
  registerin_s2m => data_out.registerin_s2m,
  globals => data_out.globals
    );

end behavior;
---------------------------------------------------------------------------------------------------
    