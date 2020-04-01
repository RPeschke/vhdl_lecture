


library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.type_conversions_pgk.all;
use work.CSV_UtilityPkg.all;



use work.feature_extraction_IO_pgk.all;


entity feature_extraction_reader_et  is
    generic (
        FileName : string := "./feature_extraction_in.csv"
    );
    port (
        clk : in std_logic ;
        data : out feature_extraction_reader_rec
    );
end entity;   

architecture Behavioral of feature_extraction_reader_et is 

  constant  NUM_COL    : integer := 11;
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

  integer_to_sl(csv_r_data(0), data.globals.clk);
  integer_to_sl(csv_r_data(1), data.globals.rst);
  integer_to_slv(csv_r_data(2), data.globals.reg.address);
  integer_to_slv(csv_r_data(3), data.globals.reg.value);
  integer_to_sl(csv_r_data(4), data.data_in_m2s.last);
  integer_to_sl(csv_r_data(5), data.data_in_m2s.valid);
  integer_to_slv(csv_r_data(6), data.data_in_m2s.data);
  integer_to_sl(csv_r_data(7), data.trigger_in_m2s.last);
  integer_to_sl(csv_r_data(8), data.trigger_in_m2s.valid);
  integer_to_slv(csv_r_data(9), data.trigger_in_m2s.data);
  integer_to_sl(csv_r_data(10), data.data_out_s2m.ready);


end Behavioral;
---------------------------------------------------------------------------------------------------
    


library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.type_conversions_pgk.all;
use work.CSV_UtilityPkg.all;



use work.feature_extraction_IO_pgk.all;

entity feature_extraction_writer_et  is
    generic ( 
        FileName : string := "./feature_extraction_out.csv"
    ); port (
        clk : in std_logic ;
        data : in feature_extraction_writer_rec
    );
end entity;

architecture Behavioral of feature_extraction_writer_et is 
  constant  NUM_COL : integer := 16;
  signal data_int   : c_integer_array(NUM_COL - 1 downto 0)  := (others=>0);
begin

    csv_w : entity  work.csv_write_file 
        generic map (
            FileName => FileName,
            HeaderLines=> "globals_clk; globals_rst; globals_reg_address; globals_reg_value; data_in_m2s_last; data_in_m2s_valid; data_in_m2s_data; data_in_s2m_ready; trigger_in_m2s_last; trigger_in_m2s_valid; trigger_in_m2s_data; trigger_in_s2m_ready; data_out_m2s_last; data_out_m2s_valid; data_out_m2s_data; data_out_s2m_ready",
            NUM_COL =>   NUM_COL 
        ) port map(
            clk => clk, 
            Rows => data_int
        );


  sl_to_integer(data.globals.clk, data_int(0) );
  sl_to_integer(data.globals.rst, data_int(1) );
  slv_to_integer(data.globals.reg.address, data_int(2) );
  slv_to_integer(data.globals.reg.value, data_int(3) );
  sl_to_integer(data.data_in_m2s.last, data_int(4) );
  sl_to_integer(data.data_in_m2s.valid, data_int(5) );
  slv_to_integer(data.data_in_m2s.data, data_int(6) );
  sl_to_integer(data.data_in_s2m.ready, data_int(7) );
  sl_to_integer(data.trigger_in_m2s.last, data_int(8) );
  sl_to_integer(data.trigger_in_m2s.valid, data_int(9) );
  slv_to_integer(data.trigger_in_m2s.data, data_int(10) );
  sl_to_integer(data.trigger_in_s2m.ready, data_int(11) );
  sl_to_integer(data.data_out_m2s.last, data_int(12) );
  sl_to_integer(data.data_out_m2s.valid, data_int(13) );
  slv_to_integer(data.data_out_m2s.data, data_int(14) );
  sl_to_integer(data.data_out_s2m.ready, data_int(15) );


end Behavioral;
---------------------------------------------------------------------------------------------------
    

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.type_conversions_pgk.all;
use work.CSV_UtilityPkg.all;


use work.feature_extraction_IO_pgk.all;

entity feature_extraction_tb_csv is 
end entity;

architecture behavior of feature_extraction_tb_csv is 
  signal clk : std_logic := '0';
  signal data_in : feature_extraction_reader_rec := feature_extraction_reader_rec_null;
  signal data_out : feature_extraction_writer_rec := feature_extraction_writer_rec_null;

begin 

  clk_gen : entity work.ClockGenerator generic map ( CLOCK_period => 10 ns) port map ( clk => clk );

  csv_read : entity work.feature_extraction_reader_et 
    generic map (
        FileName => "./feature_extraction_tb_csv.csv" 
    ) port map (
        clk => clk ,data => data_in
    );
 
  csv_write : entity work.feature_extraction_writer_et
    generic map (
        FileName => "./feature_extraction_tb_csv_out.csv" 
    ) port map (
        clk => clk ,data => data_out
    );
  

  data_out.globals.clk <=clk;
  data_out.globals.reg <= data_in.globals.reg;
  data_out.globals.rst <= data_in.globals.rst;
  data_out.data_in_m2s <= data_in.data_in_m2s;
data_out.trigger_in_m2s <= data_in.trigger_in_m2s;
data_out.data_out_s2m <= data_in.data_out_s2m;


DUT :  entity work.feature_extraction  port map(
globals => data_out.globals,
  data_in_m2s => data_out.data_in_m2s,
  data_in_s2m => data_out.data_in_s2m,
  trigger_in_m2s => data_out.trigger_in_m2s,
  trigger_in_s2m => data_out.trigger_in_s2m,
  data_out_m2s => data_out.data_out_m2s,
  data_out_s2m => data_out.data_out_s2m
    );

end behavior;
---------------------------------------------------------------------------------------------------
    