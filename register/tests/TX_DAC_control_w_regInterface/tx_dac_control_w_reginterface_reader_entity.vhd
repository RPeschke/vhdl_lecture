


library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.type_conversions_pgk.all;
use work.CSV_UtilityPkg.all;



use work.tx_dac_control_w_reginterface_reader_pgk.all;


entity tx_dac_control_w_reginterface_reader_et  is
    generic (
        FileName : string := "./tx_dac_control_w_reginterface_in.csv"
    );
    port (
        clk : in std_logic ;
        data : out tx_dac_control_w_reginterface_reader_rec
    );
end entity;   

architecture Behavioral of tx_dac_control_w_reginterface_reader_et is 

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

  integer_to_slv(csv_r_data(0), data.regin.address);
  integer_to_slv(csv_r_data(1), data.regin.value);
  integer_to_sl(csv_r_data(2), data.regin.clk);


end Behavioral;
    