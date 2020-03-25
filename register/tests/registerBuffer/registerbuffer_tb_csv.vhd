

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.type_conversions_pgk.all;
use work.CSV_UtilityPkg.all;


use work.registerbuffer_writer_pgk.all;
use work.registerbuffer_reader_pgk.all;
entity registerbuffer_tb_csv is 
end entity;

architecture behavior of registerbuffer_tb_csv is 
  signal clk : std_logic := '0';
  signal data_in : registerbuffer_reader_rec := registerbuffer_reader_rec_null;
  signal data_out : registerbuffer_writer_rec := registerbuffer_writer_rec_null;

begin 

  clk_gen : entity work.ClockGenerator generic map ( CLOCK_period => 10 ns) port map ( clk => clk );

  csv_read : entity work.registerbuffer_reader_et 
    generic map (
        FileName => "./registerbuffer_tb_csv.csv" 
    ) port map (
        clk => clk ,data => data_in
    );
 
  csv_write : entity work.registerbuffer_writer_et
    generic map (
        FileName => "./registerbuffer_tb_csv_out.csv" 
    ) port map (
        clk => clk ,data => data_out
    );
  

data_out.registersin <= data_in.registersin;


DUT :  entity work.registerbuffer  port map(
    clk => clk,
      registersin => data_out.registersin,
  registersout => data_out.registersout
    );

end behavior;
    