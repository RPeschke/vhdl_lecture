


library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.type_conversions_pgk.all;
use work.CSV_UtilityPkg.all;



use work.blinky_IO_pgk.all;


entity blinky_reader_et  is
    generic (
        FileName : string := "./blinky_in.csv"
    );
    port (
        clk : in std_logic ;
        data : out blinky_reader_rec
    );
end entity;   

architecture Behavioral of blinky_reader_et is 

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

  integer_to_sl(csv_r_data(0), data.trigger);


end Behavioral;
---------------------------------------------------------------------------------------------------
    


library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.type_conversions_pgk.all;
use work.CSV_UtilityPkg.all;



use work.blinky_IO_pgk.all;

entity blinky_writer_et  is
    generic ( 
        FileName : string := "./blinky_out.csv"
    ); port (
        clk : in std_logic ;
        data : in blinky_writer_rec
    );
end entity;

architecture Behavioral of blinky_writer_et is 
  constant  NUM_COL : integer := 2;
  signal data_int   : c_integer_array(NUM_COL - 1 downto 0)  := (others=>0);
begin

    csv_w : entity  work.csv_write_file 
        generic map (
            FileName => FileName,
            HeaderLines=> "trigger; led",
            NUM_COL =>   NUM_COL 
        ) port map(
            clk => clk, 
            Rows => data_int
        );


  sl_to_integer(data.trigger, data_int(0) );
  sl_to_integer(data.led, data_int(1) );


end Behavioral;
---------------------------------------------------------------------------------------------------
    

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.type_conversions_pgk.all;
use work.CSV_UtilityPkg.all;


use work.blinky_IO_pgk.all;

entity blinky_tb_csv is 
end entity;

architecture behavior of blinky_tb_csv is 
  signal clk : std_logic := '0';
  signal data_in : blinky_reader_rec := blinky_reader_rec_null;
  signal data_out : blinky_writer_rec := blinky_writer_rec_null;

begin 

  clk_gen : entity work.ClockGenerator generic map ( CLOCK_period => 10 ns) port map ( clk => clk );

  csv_read : entity work.blinky_reader_et 
    generic map (
        FileName => "./blinky_tb_csv.csv" 
    ) port map (
        clk => clk ,data => data_in
    );
 
  csv_write : entity work.blinky_writer_et
    generic map (
        FileName => "./blinky_tb_csv_out.csv" 
    ) port map (
        clk => clk ,data => data_out
    );
  

data_out.trigger <= data_in.trigger;


DUT :  entity work.blinky  port map(

  clk => clk,
  trigger => data_out.trigger,
  led => data_out.led
    );

end behavior;
---------------------------------------------------------------------------------------------------
    