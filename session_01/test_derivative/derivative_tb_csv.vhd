


library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.type_conversions_pgk.all;
use work.CSV_UtilityPkg.all;



use work.derivative_IO_pgk.all;


entity derivative_reader_et  is
    generic (
        FileName : string := "./derivative_in.csv"
    );
    port (
        clk : in std_logic ;
        data : out derivative_reader_rec
    );
end entity;   

architecture Behavioral of derivative_reader_et is 

  constant  NUM_COL    : integer := 1;
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

  integer_to_slv(csv_r_data(0), data.data_in);


end Behavioral;
---------------------------------------------------------------------------------------------------
    


library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.type_conversions_pgk.all;
use work.CSV_UtilityPkg.all;



use work.derivative_IO_pgk.all;

entity derivative_writer_et  is
    generic ( 
        FileName : string := "./derivative_out.csv"
    ); port (
        clk : in std_logic ;
        data : in derivative_writer_rec
    );
end entity;

architecture Behavioral of derivative_writer_et is 
  constant  NUM_COL : integer := 2;
  signal data_int   : c_integer_array(NUM_COL - 1 downto 0)  := (others=>0);
begin

    csv_w : entity  work.csv_write_file 
        generic map (
            FileName => FileName,
            HeaderLines=> "data_in; data_out",
            NUM_COL =>   NUM_COL 
        ) port map(
            clk => clk, 
            Rows => data_int
        );


  slv_to_integer(data.data_in, data_int(0) );
  slv_to_integer(data.data_out, data_int(1) );


end Behavioral;
---------------------------------------------------------------------------------------------------
    

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.type_conversions_pgk.all;
use work.CSV_UtilityPkg.all;


use work.derivative_IO_pgk.all;

entity derivative_tb_csv is 
end entity;

architecture behavior of derivative_tb_csv is 
  signal clk : std_logic := '0';
  signal data_in : derivative_reader_rec := derivative_reader_rec_null;
  signal data_out : derivative_writer_rec := derivative_writer_rec_null;

begin 

  clk_gen : entity work.ClockGenerator generic map ( CLOCK_period => 10 ns) port map ( clk => clk );

  csv_read : entity work.derivative_reader_et 
    generic map (
        FileName => "./derivative_tb_csv.csv" 
    ) port map (
        clk => clk ,data => data_in
    );
 
  csv_write : entity work.derivative_writer_et
    generic map (
        FileName => "./derivative_tb_csv_out.csv" 
    ) port map (
        clk => clk ,data => data_out
    );
  

data_out.data_in <= data_in.data_in;


DUT :  entity work.derivative  port map(

  clk => clk,
  data_in => data_out.data_in,
  data_out => data_out.data_out
    );

end behavior;
---------------------------------------------------------------------------------------------------
    