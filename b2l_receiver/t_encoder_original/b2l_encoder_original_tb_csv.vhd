


library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.type_conversions_pgk.all;
use work.CSV_UtilityPkg.all;



use work.b2l_encoder_original_IO_pgk.all;


entity b2l_encoder_original_reader_et  is
    generic (
        FileName : string := "./b2l_encoder_original_in.csv"
    );
    port (
        clk : in std_logic ;
        data : out b2l_encoder_original_reader_rec
    );
end entity;   

architecture Behavioral of b2l_encoder_original_reader_et is 

  constant  NUM_COL    : integer := 23;
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

  integer_to_sl(csv_r_data(0), data.b2clkup);
  integer_to_sl(csv_r_data(1), data.b2ttup);
  integer_to_slv(csv_r_data(2), data.b2ttversion);
  integer_to_slv(csv_r_data(3), data.trgtag);
  integer_to_slv(csv_r_data(4), data.data8i);
  integer_to_slv(csv_r_data(5), data.data32i);
  integer_to_sl(csv_r_data(6), data.ack);
  integer_to_slv(csv_r_data(7), data.cntsemscan);
  integer_to_slv(csv_r_data(8), data.cntsemsim);
  integer_to_slv(csv_r_data(9), data.cntsemdet);
  integer_to_slv(csv_r_data(10), data.cntsemack);
  integer_to_slv(csv_r_data(11), data.cntsembusy);
  integer_to_sl(csv_r_data(12), data.semsbe);
  integer_to_sl(csv_r_data(13), data.semmbe);
  integer_to_sl(csv_r_data(14), data.semactiv);
  integer_to_sl(csv_r_data(15), data.sembusy);
  integer_to_sl(csv_r_data(16), data.semcrc);
  integer_to_sl(csv_r_data(17), data.semess);
  integer_to_slv(csv_r_data(18), data.neventout);
  integer_to_slv(csv_r_data(19), data.nwordout);
  integer_to_slv(csv_r_data(20), data.sig_ilatx);
  integer_to_sl(csv_r_data(21), data.data_in_wr);
  integer_to_slv(csv_r_data(22), data.data_in_data);


end Behavioral;
---------------------------------------------------------------------------------------------------
    


library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.type_conversions_pgk.all;
use work.CSV_UtilityPkg.all;



use work.b2l_encoder_original_IO_pgk.all;

entity b2l_encoder_original_writer_et  is
    generic ( 
        FileName : string := "./b2l_encoder_original_out.csv"
    ); port (
        clk : in std_logic ;
        data : in b2l_encoder_original_writer_rec
    );
end entity;

architecture Behavioral of b2l_encoder_original_writer_et is 
  constant  NUM_COL : integer := 42;
  signal data_int   : c_integer_array(NUM_COL - 1 downto 0)  := (others=>0);
begin

    csv_w : entity  work.csv_write_file 
        generic map (
            FileName => FileName,
            HeaderLines=> "b2clkup; b2ttup; b2ttversion; trgtag; trigen; linklost; parawe; paradata; en8; wr8; rd8; data8i; data8o; addr8; en32; wr32; rd32; data32i; data32o; addr32; ack; regsimsbe; regsimmbe; regsemrst; regsimaddr; cntsemscan; cntsemsim; cntsemdet; cntsemack; cntsembusy; semsbe; semmbe; semactiv; sembusy; semcrc; semess; neventout; nwordout; sig_ilatx; sig_ila; data_in_wr; data_in_data",
            NUM_COL =>   NUM_COL 
        ) port map(
            clk => clk, 
            Rows => data_int
        );


  sl_to_integer(data.b2clkup, data_int(0) );
  sl_to_integer(data.b2ttup, data_int(1) );
  slv_to_integer(data.b2ttversion, data_int(2) );
  slv_to_integer(data.trgtag, data_int(3) );
  sl_to_integer(data.trigen, data_int(4) );
  sl_to_integer(data.linklost, data_int(5) );
  sl_to_integer(data.parawe, data_int(6) );
  slv_to_integer(data.paradata, data_int(7) );
  sl_to_integer(data.en8, data_int(8) );
  sl_to_integer(data.wr8, data_int(9) );
  sl_to_integer(data.rd8, data_int(10) );
  slv_to_integer(data.data8i, data_int(11) );
  slv_to_integer(data.data8o, data_int(12) );
  slv_to_integer(data.addr8, data_int(13) );
  sl_to_integer(data.en32, data_int(14) );
  sl_to_integer(data.wr32, data_int(15) );
  sl_to_integer(data.rd32, data_int(16) );
  slv_to_integer(data.data32i, data_int(17) );
  slv_to_integer(data.data32o, data_int(18) );
  slv_to_integer(data.addr32, data_int(19) );
  sl_to_integer(data.ack, data_int(20) );
  sl_to_integer(data.regsimsbe, data_int(21) );
  sl_to_integer(data.regsimmbe, data_int(22) );
  sl_to_integer(data.regsemrst, data_int(23) );
  slv_to_integer(data.regsimaddr, data_int(24) );
  slv_to_integer(data.cntsemscan, data_int(25) );
  slv_to_integer(data.cntsemsim, data_int(26) );
  slv_to_integer(data.cntsemdet, data_int(27) );
  slv_to_integer(data.cntsemack, data_int(28) );
  slv_to_integer(data.cntsembusy, data_int(29) );
  sl_to_integer(data.semsbe, data_int(30) );
  sl_to_integer(data.semmbe, data_int(31) );
  sl_to_integer(data.semactiv, data_int(32) );
  sl_to_integer(data.sembusy, data_int(33) );
  sl_to_integer(data.semcrc, data_int(34) );
  sl_to_integer(data.semess, data_int(35) );
  slv_to_integer(data.neventout, data_int(36) );
  slv_to_integer(data.nwordout, data_int(37) );
  slv_to_integer(data.sig_ilatx, data_int(38) );
  slv_to_integer(data.sig_ila, data_int(39) );
  sl_to_integer(data.data_in_wr, data_int(40) );
  slv_to_integer(data.data_in_data, data_int(41) );


end Behavioral;
---------------------------------------------------------------------------------------------------
    

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.type_conversions_pgk.all;
use work.CSV_UtilityPkg.all;


use work.b2l_encoder_original_IO_pgk.all;

entity b2l_encoder_original_tb_csv is 
end entity;

architecture behavior of b2l_encoder_original_tb_csv is 
  signal clk : std_logic := '0';
  signal data_in : b2l_encoder_original_reader_rec := b2l_encoder_original_reader_rec_null;
  signal data_out : b2l_encoder_original_writer_rec := b2l_encoder_original_writer_rec_null;

begin 

  clk_gen : entity work.ClockGenerator generic map ( CLOCK_period => 10 ns) port map ( clk => clk );

  csv_read : entity work.b2l_encoder_original_reader_et 
    generic map (
        FileName => "./b2l_encoder_original_tb_csv.csv" 
    ) port map (
        clk => clk ,data => data_in
    );
 
  csv_write : entity work.b2l_encoder_original_writer_et
    generic map (
        FileName => "./b2l_encoder_original_tb_csv_out.csv" 
    ) port map (
        clk => clk ,data => data_out
    );
  

data_out.b2clkup <= data_in.b2clkup;
data_out.b2ttup <= data_in.b2ttup;
data_out.b2ttversion <= data_in.b2ttversion;
data_out.trgtag <= data_in.trgtag;
data_out.data8i <= data_in.data8i;
data_out.data32i <= data_in.data32i;
data_out.ack <= data_in.ack;
data_out.cntsemscan <= data_in.cntsemscan;
data_out.cntsemsim <= data_in.cntsemsim;
data_out.cntsemdet <= data_in.cntsemdet;
data_out.cntsemack <= data_in.cntsemack;
data_out.cntsembusy <= data_in.cntsembusy;
data_out.semsbe <= data_in.semsbe;
data_out.semmbe <= data_in.semmbe;
data_out.semactiv <= data_in.semactiv;
data_out.sembusy <= data_in.sembusy;
data_out.semcrc <= data_in.semcrc;
data_out.semess <= data_in.semess;
data_out.neventout <= data_in.neventout;
data_out.nwordout <= data_in.nwordout;
data_out.sig_ilatx <= data_in.sig_ilatx;
data_out.data_in_wr <= data_in.data_in_wr;
data_out.data_in_data <= data_in.data_in_data;


DUT :  entity work.b2l_encoder_original  port map(

  clk => clk,
  b2clkup => data_out.b2clkup,
  b2ttup => data_out.b2ttup,
  b2ttversion => data_out.b2ttversion,
  trgtag => data_out.trgtag,
  trigen => data_out.trigen,
  linklost => data_out.linklost,
  parawe => data_out.parawe,
  paradata => data_out.paradata,
  en8 => data_out.en8,
  wr8 => data_out.wr8,
  rd8 => data_out.rd8,
  data8i => data_out.data8i,
  data8o => data_out.data8o,
  addr8 => data_out.addr8,
  en32 => data_out.en32,
  wr32 => data_out.wr32,
  rd32 => data_out.rd32,
  data32i => data_out.data32i,
  data32o => data_out.data32o,
  addr32 => data_out.addr32,
  ack => data_out.ack,
  regsimsbe => data_out.regsimsbe,
  regsimmbe => data_out.regsimmbe,
  regsemrst => data_out.regsemrst,
  regsimaddr => data_out.regsimaddr,
  cntsemscan => data_out.cntsemscan,
  cntsemsim => data_out.cntsemsim,
  cntsemdet => data_out.cntsemdet,
  cntsemack => data_out.cntsemack,
  cntsembusy => data_out.cntsembusy,
  semsbe => data_out.semsbe,
  semmbe => data_out.semmbe,
  semactiv => data_out.semactiv,
  sembusy => data_out.sembusy,
  semcrc => data_out.semcrc,
  semess => data_out.semess,
  neventout => data_out.neventout,
  nwordout => data_out.nwordout,
  sig_ilatx => data_out.sig_ilatx,
  sig_ila => data_out.sig_ila,
  data_in_wr => data_out.data_in_wr,
  data_in_data => data_out.data_in_data
    );

end behavior;
---------------------------------------------------------------------------------------------------
    