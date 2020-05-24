
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.CSV_UtilityPkg.all;


-- Start Include user packages --
use work.register8bit.all;
use work.axisstream_slv16.all;

-- End Include user packages --

package b2l_encoder_IO_pgk is


  type b2l_encoder_writer_rec is record
    b2clkup : std_logic;  
    b2ttup : std_logic;  
    b2ttversion : std_logic_vector ( 15 downto 0 );  
    trgtag : std_logic_vector ( 31 downto 0 );  
    trigen : std_logic;  
    linklost : std_logic;  
    parawe : std_logic;  
    paradata : std_logic_vector ( 15 downto 0 );  
    reg8_m2s : register8bit_m2s;  
    reg8_s2m : register8bit_s2m;  
    en32 : std_logic;  
    wr32 : std_logic;  
    rd32 : std_logic;  
    data32i : std_logic_vector ( 31 downto 0 );  
    data32o : std_logic_vector ( 31 downto 0 );  
    addr32 : std_logic_vector ( 15 downto 0 );  
    ack : std_logic;  
    regsimsbe : std_logic;  
    regsimmbe : std_logic;  
    regsemrst : std_logic;  
    regsimaddr : std_logic_vector ( 39 downto 0 );  
    cntsemscan : std_logic_vector ( 15 downto 0 );  
    cntsemsim : std_logic_vector ( 15 downto 0 );  
    cntsemdet : std_logic_vector ( 15 downto 0 );  
    cntsemack : std_logic_vector ( 15 downto 0 );  
    cntsembusy : std_logic_vector ( 15 downto 0 );  
    semsbe : std_logic;  
    semmbe : std_logic;  
    semactiv : std_logic;  
    sembusy : std_logic;  
    semcrc : std_logic;  
    semess : std_logic;  
    neventout : std_logic_vector ( 31 downto 0 );  
    nwordout : std_logic_vector ( 31 downto 0 );  
    sig_ilatx : std_logic_vector ( 95 downto 0 );  
    sig_ila : std_logic_vector ( 95 downto 0 );  
    axi_in_s2m : axistream_slv16_s2m;  
    axi_in_m2s : axistream_slv16_m2s;  
    clr_crcerr : std_logic;  

  end record;

  constant b2l_encoder_writer_rec_null : b2l_encoder_writer_rec := ( 
    b2clkup => '0',
    b2ttup => '0',
    b2ttversion => (others => '0'),
    trgtag => (others => '0'),
    trigen => '0',
    linklost => '0',
    parawe => '0',
    paradata => (others => '0'),
    reg8_m2s => register8bit_m2s_null,
    reg8_s2m => register8bit_s2m_null,
    en32 => '0',
    wr32 => '0',
    rd32 => '0',
    data32i => (others => '0'),
    data32o => (others => '0'),
    addr32 => (others => '0'),
    ack => '0',
    regsimsbe => '0',
    regsimmbe => '0',
    regsemrst => '0',
    regsimaddr => (others => '0'),
    cntsemscan => (others => '0'),
    cntsemsim => (others => '0'),
    cntsemdet => (others => '0'),
    cntsemack => (others => '0'),
    cntsembusy => (others => '0'),
    semsbe => '0',
    semmbe => '0',
    semactiv => '0',
    sembusy => '0',
    semcrc => '0',
    semess => '0',
    neventout => (others => '0'),
    nwordout => (others => '0'),
    sig_ilatx => (others => '0'),
    sig_ila => (others => '0'),
    axi_in_s2m => axistream_slv16_s2m_null,
    axi_in_m2s => axistream_slv16_m2s_null,
    clr_crcerr => '0'
  );
    


  type b2l_encoder_reader_rec is record
    b2clkup : std_logic;  
    b2ttup : std_logic;  
    b2ttversion : std_logic_vector ( 15 downto 0 );  
    trgtag : std_logic_vector ( 31 downto 0 );  
    reg8_s2m : register8bit_s2m;  
    data32i : std_logic_vector ( 31 downto 0 );  
    ack : std_logic;  
    cntsemscan : std_logic_vector ( 15 downto 0 );  
    cntsemsim : std_logic_vector ( 15 downto 0 );  
    cntsemdet : std_logic_vector ( 15 downto 0 );  
    cntsemack : std_logic_vector ( 15 downto 0 );  
    cntsembusy : std_logic_vector ( 15 downto 0 );  
    semsbe : std_logic;  
    semmbe : std_logic;  
    semactiv : std_logic;  
    sembusy : std_logic;  
    semcrc : std_logic;  
    semess : std_logic;  
    neventout : std_logic_vector ( 31 downto 0 );  
    nwordout : std_logic_vector ( 31 downto 0 );  
    sig_ilatx : std_logic_vector ( 95 downto 0 );  
    axi_in_m2s : axistream_slv16_m2s;  

  end record;

  constant b2l_encoder_reader_rec_null : b2l_encoder_reader_rec := ( 
    b2clkup => '0',
    b2ttup => '0',
    b2ttversion => (others => '0'),
    trgtag => (others => '0'),
    reg8_s2m => register8bit_s2m_null,
    data32i => (others => '0'),
    ack => '0',
    cntsemscan => (others => '0'),
    cntsemsim => (others => '0'),
    cntsemdet => (others => '0'),
    cntsemack => (others => '0'),
    cntsembusy => (others => '0'),
    semsbe => '0',
    semmbe => '0',
    semactiv => '0',
    sembusy => '0',
    semcrc => '0',
    semess => '0',
    neventout => (others => '0'),
    nwordout => (others => '0'),
    sig_ilatx => (others => '0'),
    axi_in_m2s => axistream_slv16_m2s_null
  );
    
end b2l_encoder_IO_pgk;

package body b2l_encoder_IO_pgk is

end package body b2l_encoder_IO_pgk;

    