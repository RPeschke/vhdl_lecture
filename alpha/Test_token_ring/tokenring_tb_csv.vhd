


library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.type_conversions_pgk.all;
use work.CSV_UtilityPkg.all;



use work.tokenring_IO_pgk.all;


entity tokenring_reader_et  is
    generic (
        FileName : string := "./tokenring_in.csv"
    );
    port (
        clk : in std_logic ;
        data : out tokenring_reader_rec
    );
end entity;   

architecture Behavioral of tokenring_reader_et is 

  constant  NUM_COL    : integer := 5;
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

  integer_to_sl(csv_r_data(0), data.rst);
  integer_to_slv(csv_r_data(1), data.asic_a_dummy_data);
  integer_to_slv(csv_r_data(2), data.asic_b_dummy_data);
  integer_to_slv(csv_r_data(3), data.asic_c_dummy_data);
  integer_to_slv(csv_r_data(4), data.asic_d_dummy_data);


end Behavioral;
---------------------------------------------------------------------------------------------------
    


library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.type_conversions_pgk.all;
use work.CSV_UtilityPkg.all;



use work.tokenring_IO_pgk.all;

entity tokenring_writer_et  is
    generic ( 
        FileName : string := "./tokenring_out.csv"
    ); port (
        clk : in std_logic ;
        data : in tokenring_writer_rec
    );
end entity;

architecture Behavioral of tokenring_writer_et is 
  constant  NUM_COL : integer := 6;
  signal data_int   : c_integer_array(NUM_COL - 1 downto 0)  := (others=>0);
begin

    csv_w : entity  work.csv_write_file 
        generic map (
            FileName => FileName,
            HeaderLines=> "rst; asic_a_dummy_data; asic_b_dummy_data; asic_c_dummy_data; asic_d_dummy_data; data_out",
            NUM_COL =>   NUM_COL 
        ) port map(
            clk => clk, 
            Rows => data_int
        );


  sl_to_integer(data.rst, data_int(0) );
  slv_to_integer(data.asic_a_dummy_data, data_int(1) );
  slv_to_integer(data.asic_b_dummy_data, data_int(2) );
  slv_to_integer(data.asic_c_dummy_data, data_int(3) );
  slv_to_integer(data.asic_d_dummy_data, data_int(4) );
  slv_to_integer(data.data_out, data_int(5) );


end Behavioral;
---------------------------------------------------------------------------------------------------
    

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.type_conversions_pgk.all;
use work.CSV_UtilityPkg.all;


use work.tokenring_IO_pgk.all;

entity tokenring_tb_csv is 
end entity;

architecture behavior of tokenring_tb_csv is 
  signal clk : std_logic := '0';
  signal data_in : tokenring_reader_rec := tokenring_reader_rec_null;
  signal data_out : tokenring_writer_rec := tokenring_writer_rec_null;

begin 

  clk_gen : entity work.ClockGenerator generic map ( CLOCK_period => 10 ns) port map ( clk => clk );

  csv_read : entity work.tokenring_reader_et 
    generic map (
        FileName => "./tokenring_tb_csv.csv" 
    ) port map (
        clk => clk ,data => data_in
    );
 
  csv_write : entity work.tokenring_writer_et
    generic map (
        FileName => "./tokenring_tb_csv_out.csv" 
    ) port map (
        clk => clk ,data => data_out
    );
  

data_out.rst <= data_in.rst;
data_out.asic_a_dummy_data <= data_in.asic_a_dummy_data;
data_out.asic_b_dummy_data <= data_in.asic_b_dummy_data;
data_out.asic_c_dummy_data <= data_in.asic_c_dummy_data;
data_out.asic_d_dummy_data <= data_in.asic_d_dummy_data;


DUT :  entity work.tokenring  port map(

  clk => clk,
  rst => data_out.rst,
  asic_a_dummy_data => data_out.asic_a_dummy_data,
  asic_b_dummy_data => data_out.asic_b_dummy_data,
  asic_c_dummy_data => data_out.asic_c_dummy_data,
  asic_d_dummy_data => data_out.asic_d_dummy_data,
  data_out => data_out.data_out
    );

end behavior;
---------------------------------------------------------------------------------------------------
    