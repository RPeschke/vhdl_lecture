


library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.type_conversions_pgk.all;
use work.CSV_UtilityPkg.all;



use work.registerbuffer_writer_pgk.all;

entity registerbuffer_writer_et  is
    generic ( 
        FileName : string := "./registerbuffer_out.csv"
    ); port (
        clk : in std_logic ;
        data : in registerbuffer_writer_rec
    );
end entity;

architecture Behavioral of registerbuffer_writer_et is 
  constant  NUM_COL : integer := 6;
  signal data_int   : c_integer_array(NUM_COL - 1 downto 0)  := (others=>0);
begin

    csv_w : entity  work.csv_write_file 
        generic map (
            FileName => FileName,
            HeaderLines=> "registersin_address; registersin_value; registersin_clk; registersout_address; registersout_value; registersout_clk",
            NUM_COL =>   NUM_COL 
        ) port map(
            clk => clk, 
            Rows => data_int
        );


  slv_to_integer(data.registersin.address, data_int(0) );
  slv_to_integer(data.registersin.value, data_int(1) );
  sl_to_integer(data.registersin.clk, data_int(2) );
  slv_to_integer(data.registersout.address, data_int(3) );
  slv_to_integer(data.registersout.value, data_int(4) );
  sl_to_integer(data.registersout.clk, data_int(5) );


end Behavioral;
    