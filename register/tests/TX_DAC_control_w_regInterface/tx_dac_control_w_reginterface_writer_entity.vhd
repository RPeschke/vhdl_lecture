


library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.type_conversions_pgk.all;
use work.CSV_UtilityPkg.all;



use work.tx_dac_control_w_reginterface_writer_pgk.all;

entity tx_dac_control_w_reginterface_writer_et  is
    generic ( 
        FileName : string := "./tx_dac_control_w_reginterface_out.csv"
    ); port (
        clk : in std_logic ;
        data : in tx_dac_control_w_reginterface_writer_rec
    );
end entity;

architecture Behavioral of tx_dac_control_w_reginterface_writer_et is 
  constant  NUM_COL : integer := 7;
  signal data_int   : c_integer_array(NUM_COL - 1 downto 0)  := (others=>0);
begin

    csv_w : entity  work.csv_write_file 
        generic map (
            FileName => FileName,
            HeaderLines=> "regin_address; regin_value; regin_clk; sin; sclk; pclk; reg_clr",
            NUM_COL =>   NUM_COL 
        ) port map(
            clk => clk, 
            Rows => data_int
        );


  slv_to_integer(data.regin.address, data_int(0) );
  slv_to_integer(data.regin.value, data_int(1) );
  sl_to_integer(data.regin.clk, data_int(2) );
  sl_to_integer(data.sin, data_int(3) );
  sl_to_integer(data.sclk, data_int(4) );
  sl_to_integer(data.pclk, data_int(5) );
  sl_to_integer(data.reg_clr, data_int(6) );


end Behavioral;
    