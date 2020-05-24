


library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.type_conversions_pgk.all;
use work.CSV_UtilityPkg.all;



use work.serialdataroutprocess_cl_IO_pgk.all;


entity serialdataroutprocess_cl_reader_et  is
    generic (
        FileName : string := "./serialdataroutprocess_cl_in.csv"
    );
    port (
        clk : in std_logic ;
        data : out serialdataroutprocess_cl_reader_rec
    );
end entity;   

architecture Behavioral of serialdataroutprocess_cl_reader_et is 

  constant  NUM_COL    : integer := 10;
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

  integer_to_slv(csv_r_data(0), data.shiftregister_in_m2s.data_out);
  integer_to_slv(csv_r_data(1), data.config_in_m2s.data.column_select);
  integer_to_slv(csv_r_data(2), data.config_in_m2s.data.sample_stop);
  integer_to_sl(csv_r_data(3), data.config_in_m2s.data.force_test_pattern);
  integer_to_slv(csv_r_data(4), data.config_in_m2s.data.row_select);
  integer_to_slv(csv_r_data(5), data.config_in_m2s.data.sample_start);
  integer_to_slv(csv_r_data(6), data.config_in_m2s.data.asic_num);
  integer_to_sl(csv_r_data(7), data.config_in_m2s.last);
  integer_to_sl(csv_r_data(8), data.config_in_m2s.valid);
  integer_to_sl(csv_r_data(9), data.data_out_s2m.ready);


end Behavioral;
---------------------------------------------------------------------------------------------------
    


library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.type_conversions_pgk.all;
use work.CSV_UtilityPkg.all;



use work.serialdataroutprocess_cl_IO_pgk.all;

entity serialdataroutprocess_cl_writer_et  is
    generic ( 
        FileName : string := "./serialdataroutprocess_cl_out.csv"
    ); port (
        clk : in std_logic ;
        data : in serialdataroutprocess_cl_writer_rec
    );
end entity;

architecture Behavioral of serialdataroutprocess_cl_writer_et is 
  constant  NUM_COL : integer := 20;
  signal data_int   : c_integer_array(NUM_COL - 1 downto 0)  := (others=>0);
begin

    csv_w : entity  work.csv_write_file 
        generic map (
            FileName => FileName,
            HeaderLines=> "shiftregister_in_s2m_sr_clock; shiftregister_in_s2m_sampleselectany; shiftregister_in_s2m_sr_select; shiftregister_in_s2m_sampleselect; shiftregister_in_s2m_sr_clear; shiftregister_in_m2s_data_out; config_in_s2m_ready; config_in_m2s_data_column_select; config_in_m2s_data_sample_stop; config_in_m2s_data_force_test_pattern; config_in_m2s_data_row_select; config_in_m2s_data_sample_start; config_in_m2s_data_asic_num; config_in_m2s_last; config_in_m2s_valid; data_out_s2m_ready; data_out_m2s_data; data_out_m2s_last; data_out_m2s_valid; data_out_raw",
            NUM_COL =>   NUM_COL 
        ) port map(
            clk => clk, 
            Rows => data_int
        );


  slv_to_integer(data.shiftregister_in_s2m.sr_clock, data_int(0) );
  slv_to_integer(data.shiftregister_in_s2m.sampleselectany, data_int(1) );
  sl_to_integer(data.shiftregister_in_s2m.sr_select, data_int(2) );
  slv_to_integer(data.shiftregister_in_s2m.sampleselect, data_int(3) );
  sl_to_integer(data.shiftregister_in_s2m.sr_clear, data_int(4) );
  slv_to_integer(data.shiftregister_in_m2s.data_out, data_int(5) );
  sl_to_integer(data.config_in_s2m.ready, data_int(6) );
  slv_to_integer(data.config_in_m2s.data.column_select, data_int(7) );
  slv_to_integer(data.config_in_m2s.data.sample_stop, data_int(8) );
  sl_to_integer(data.config_in_m2s.data.force_test_pattern, data_int(9) );
  slv_to_integer(data.config_in_m2s.data.row_select, data_int(10) );
  slv_to_integer(data.config_in_m2s.data.sample_start, data_int(11) );
  slv_to_integer(data.config_in_m2s.data.asic_num, data_int(12) );
  sl_to_integer(data.config_in_m2s.last, data_int(13) );
  sl_to_integer(data.config_in_m2s.valid, data_int(14) );
  sl_to_integer(data.data_out_s2m.ready, data_int(15) );
  slv_to_integer(data.data_out_m2s.data, data_int(16) );
  sl_to_integer(data.data_out_m2s.last, data_int(17) );
  sl_to_integer(data.data_out_m2s.valid, data_int(18) );
  slv_to_integer(data.data_out_raw, data_int(19) );


end Behavioral;
---------------------------------------------------------------------------------------------------
    

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.type_conversions_pgk.all;
use work.CSV_UtilityPkg.all;


use work.serialdataroutprocess_cl_IO_pgk.all;

entity serialdataroutprocess_cl_tb_csv is 
end entity;

architecture behavior of serialdataroutprocess_cl_tb_csv is 
  signal clk : std_logic := '0';
  signal data_in : serialdataroutprocess_cl_reader_rec := serialdataroutprocess_cl_reader_rec_null;
  signal data_out : serialdataroutprocess_cl_writer_rec := serialdataroutprocess_cl_writer_rec_null;

begin 

  clk_gen : entity work.ClockGenerator generic map ( CLOCK_period => 10 ns) port map ( clk => clk );

  csv_read : entity work.serialdataroutprocess_cl_reader_et 
    generic map (
        FileName => "./serialdataroutprocess_cl_tb_csv.csv" 
    ) port map (
        clk => clk ,data => data_in
    );
 
  csv_write : entity work.serialdataroutprocess_cl_writer_et
    generic map (
        FileName => "./serialdataroutprocess_cl_tb_csv_out.csv" 
    ) port map (
        clk => clk ,data => data_out
    );
  

data_out.shiftregister_in_m2s <= data_in.shiftregister_in_m2s;
data_out.config_in_m2s <= data_in.config_in_m2s;
data_out.data_out_s2m <= data_in.data_out_s2m;


DUT :  entity work.serialdataroutprocess_cl  port map(

  clk => clk,
  shiftregister_in_s2m => data_out.shiftregister_in_s2m,
  shiftregister_in_m2s => data_out.shiftregister_in_m2s,
  config_in_s2m => data_out.config_in_s2m,
  config_in_m2s => data_out.config_in_m2s,
  data_out_s2m => data_out.data_out_s2m,
  data_out_m2s => data_out.data_out_m2s,
  data_out_raw => data_out.data_out_raw
    );

end behavior;
---------------------------------------------------------------------------------------------------
    