


library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.type_conversions_pgk.all;
use work.CSV_UtilityPkg.all;



use work.axi_derivative_IO_pgk.all;


entity axi_derivative_reader_et  is
    generic (
        FileName : string := "./axi_derivative_in.csv"
    );
    port (
        clk : in std_logic ;
        data : out axi_derivative_reader_rec
    );
end entity;   

architecture Behavioral of axi_derivative_reader_et is 

  constant  NUM_COL    : integer := 3;
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

  integer_to_sl(csv_r_data(0), data.data_in_valid);
  integer_to_slv(csv_r_data(1), data.data_in_data);
  integer_to_sl(csv_r_data(2), data.data_out_ready);


end Behavioral;
---------------------------------------------------------------------------------------------------
    


library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.type_conversions_pgk.all;
use work.CSV_UtilityPkg.all;



use work.axi_derivative_IO_pgk.all;

entity axi_derivative_writer_et  is
    generic ( 
        FileName : string := "./axi_derivative_out.csv"
    ); port (
        clk : in std_logic ;
        data : in axi_derivative_writer_rec
    );
end entity;

architecture Behavioral of axi_derivative_writer_et is 
  constant  NUM_COL : integer := 6;
  signal data_int   : c_integer_array(NUM_COL - 1 downto 0)  := (others=>0);
begin

    csv_w : entity  work.csv_write_file 
        generic map (
            FileName => FileName,
            HeaderLines=> "data_in_valid; data_in_ready; data_in_data; data_out_valid; data_out_ready; data_out_data",
            NUM_COL =>   NUM_COL 
        ) port map(
            clk => clk, 
            Rows => data_int
        );


  sl_to_integer(data.data_in_valid, data_int(0) );
  sl_to_integer(data.data_in_ready, data_int(1) );
  slv_to_integer(data.data_in_data, data_int(2) );
  sl_to_integer(data.data_out_valid, data_int(3) );
  sl_to_integer(data.data_out_ready, data_int(4) );
  slv_to_integer(data.data_out_data, data_int(5) );


end Behavioral;
---------------------------------------------------------------------------------------------------
    

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.type_conversions_pgk.all;
use work.CSV_UtilityPkg.all;


use work.axi_derivative_IO_pgk.all;

entity axi_derivative_tb_csv is 
end entity;

architecture behavior of axi_derivative_tb_csv is 
  signal clk : std_logic := '0';
  signal data_in : axi_derivative_reader_rec := axi_derivative_reader_rec_null;
  signal data_out : axi_derivative_writer_rec := axi_derivative_writer_rec_null;

begin 

  clk_gen : entity work.ClockGenerator generic map ( CLOCK_period => 10 ns) port map ( clk => clk );

  csv_read : entity work.axi_derivative_reader_et 
    generic map (
        FileName => "./axi_derivative_tb_csv.csv" 
    ) port map (
        clk => clk ,data => data_in
    );
 
  csv_write : entity work.axi_derivative_writer_et
    generic map (
        FileName => "./axi_derivative_tb_csv_out.csv" 
    ) port map (
        clk => clk ,data => data_out
    );
  

data_out.data_in_valid <= data_in.data_in_valid;
data_out.data_in_data <= data_in.data_in_data;
data_out.data_out_ready <= data_in.data_out_ready;


DUT :  entity work.axi_derivative  port map(

  clk => clk,
  data_in_valid => data_out.data_in_valid,
  data_in_ready => data_out.data_in_ready,
  data_in_data => data_out.data_in_data,
  data_out_valid => data_out.data_out_valid,
  data_out_ready => data_out.data_out_ready,
  data_out_data => data_out.data_out_data
    );

end behavior;
---------------------------------------------------------------------------------------------------
    