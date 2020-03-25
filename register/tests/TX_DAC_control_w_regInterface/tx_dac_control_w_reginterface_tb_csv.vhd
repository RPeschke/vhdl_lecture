

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.type_conversions_pgk.all;
use work.CSV_UtilityPkg.all;


use work.tx_dac_control_w_reginterface_writer_pgk.all;
use work.tx_dac_control_w_reginterface_reader_pgk.all;
entity tx_dac_control_w_reginterface_tb_csv is 
end entity;

architecture behavior of tx_dac_control_w_reginterface_tb_csv is 
  signal clk : std_logic := '0';
  signal data_in : tx_dac_control_w_reginterface_reader_rec := tx_dac_control_w_reginterface_reader_rec_null;
  signal data_out : tx_dac_control_w_reginterface_writer_rec := tx_dac_control_w_reginterface_writer_rec_null;

begin 

  clk_gen : entity work.ClockGenerator generic map ( CLOCK_period => 10 ns) port map ( clk => clk );

  csv_read : entity work.tx_dac_control_w_reginterface_reader_et 
    generic map (
        FileName => "./tx_dac_control_w_reginterface_tb_csv.csv" 
    ) port map (
        clk => clk ,data => data_in
    );
 
  csv_write : entity work.tx_dac_control_w_reginterface_writer_et
    generic map (
        FileName => "./tx_dac_control_w_reginterface_tb_csv_out.csv" 
    ) port map (
        clk => clk ,data => data_out
    );
  

data_out.regin <= data_in.regin;


DUT :  entity work.tx_dac_control_w_reginterface  port map(
    clk => clk,
      regin => data_out.regin,
  sin => data_out.sin,
  sclk => data_out.sclk,
  pclk => data_out.pclk,
  reg_clr => data_out.reg_clr
    );

end behavior;
    