


library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.type_conversions_pgk.all;
use work.CSV_UtilityPkg.all;



use work.axififo_IO_pgk.all;


entity axififo_reader_et  is
    generic (
        FileName : string := "./axififo_in.csv"
    );
    port (
        clk : in std_logic ;
        data : out axififo_reader_rec
    );
end entity;   

architecture Behavioral of axififo_reader_et is 

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

  integer_to_slv(csv_r_data(0), data.axi_in_m2s.data);
  integer_to_sl(csv_r_data(1), data.axi_in_m2s.last);
  integer_to_sl(csv_r_data(2), data.axi_in_m2s.valid);
  integer_to_sl(csv_r_data(3), data.axi_out_s2m.ready);


end Behavioral;
---------------------------------------------------------------------------------------------------
    


library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.type_conversions_pgk.all;
use work.CSV_UtilityPkg.all;



use work.axififo_IO_pgk.all;

entity axififo_writer_et  is
    generic ( 
        FileName : string := "./axififo_out.csv"
    ); port (
        clk : in std_logic ;
        data : in axififo_writer_rec
    );
end entity;

architecture Behavioral of axififo_writer_et is 
  constant  NUM_COL : integer := 8;
  signal data_int   : c_integer_array(NUM_COL - 1 downto 0)  := (others=>0);
begin

    csv_w : entity  work.csv_write_file 
        generic map (
            FileName => FileName,
            HeaderLines=> "axi_in_s2m_ready; axi_in_m2s_data; axi_in_m2s_last; axi_in_m2s_valid; axi_out_s2m_ready; axi_out_m2s_data; axi_out_m2s_last; axi_out_m2s_valid",
            NUM_COL =>   NUM_COL 
        ) port map(
            clk => clk, 
            Rows => data_int
        );


  sl_to_integer(data.axi_in_s2m.ready, data_int(0) );
  slv_to_integer(data.axi_in_m2s.data, data_int(1) );
  sl_to_integer(data.axi_in_m2s.last, data_int(2) );
  sl_to_integer(data.axi_in_m2s.valid, data_int(3) );
  sl_to_integer(data.axi_out_s2m.ready, data_int(4) );
  slv_to_integer(data.axi_out_m2s.data, data_int(5) );
  sl_to_integer(data.axi_out_m2s.last, data_int(6) );
  sl_to_integer(data.axi_out_m2s.valid, data_int(7) );


end Behavioral;
---------------------------------------------------------------------------------------------------
    

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.type_conversions_pgk.all;
use work.CSV_UtilityPkg.all;


use work.axififo_IO_pgk.all;

entity axififo_tb_csv is 
end entity;

architecture behavior of axififo_tb_csv is 
  signal clk : std_logic := '0';
  signal data_in : axififo_reader_rec := axififo_reader_rec_null;
  signal data_out : axififo_writer_rec := axififo_writer_rec_null;

begin 

  clk_gen : entity work.ClockGenerator generic map ( CLOCK_period => 10 ns) port map ( clk => clk );

  csv_read : entity work.axififo_reader_et 
    generic map (
        FileName => "./axififo_tb_csv.csv" 
    ) port map (
        clk => clk ,data => data_in
    );
 
  csv_write : entity work.axififo_writer_et
    generic map (
        FileName => "./axififo_tb_csv_out.csv" 
    ) port map (
        clk => clk ,data => data_out
    );
  

data_out.axi_in_m2s <= data_in.axi_in_m2s;
data_out.axi_out_s2m <= data_in.axi_out_s2m;


DUT :  entity work.axififo  port map(

  clk => clk,
  axi_in_s2m => data_out.axi_in_s2m,
  axi_in_m2s => data_out.axi_in_m2s,
  axi_out_s2m => data_out.axi_out_s2m,
  axi_out_m2s => data_out.axi_out_m2s
    );

end behavior;
---------------------------------------------------------------------------------------------------
    