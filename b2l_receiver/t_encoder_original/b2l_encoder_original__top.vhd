-- <header>Header; Nr_of_streams; recording TimeStamp; Operation; Number of packets; packateNr; Sending TimeStamp; b2clkup; b2ttup; b2ttversion; trgtag; trigen; linklost; parawe; paradata; en8; wr8; rd8; data8i; data8o; addr8; en32; wr32; rd32; data32i; data32o; addr32; ack; regsimsbe; regsimmbe; regsemrst; regsimaddr; cntsemscan; cntsemsim; cntsemdet; cntsemack; cntsembusy; semsbe; semmbe; semactiv; sembusy; semcrc; semess; neventout; nwordout; sig_ilatx; sig_ila; data_in_wr; data_in_data; Tail</header>



library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

library UNISIM;
  use UNISIM.VComponents.all;
  use work.UtilityPkg.all;

  use work.b2l_encoder_original_IO_pgk.all;
  use work.type_conversions_pgk.all;
  use work.Imp_test_bench_pgk.all;
  use work.xgen_klm_scrod_bus.all;
  use work.klm_scint_globals.all;

entity b2l_encoder_original_eth is
  port (
    globals :  in globals_t := globals_t_null;
    
    TxDataChannel : out  DWORD := (others => '0');
    TxDataValid   : out  sl := '0';
    TxDataLast    : out  sl := '0';
    TxDataReady   : in   sl := '0';
    RxDataChannel : in   DWORD := (others => '0');
    RxDataValid   : in   sl := '0';
    RxDataLast    : in   sl := '0';
    RxDataReady   : out  sl := '0';

    TXBus_m2s     : in   DataBus_m2s_a(1 downto 0) := (others => DataBus_m2s_null);
    TXBus_s2m     : out  DataBus_s2m_a(1 downto 0) := (others => DataBus_s2m_null)
  );
end entity;

architecture rtl of b2l_encoder_original_eth is
  
  constant Throttel_max_counter : integer  := 10;
  constant Throttel_wait_time : integer := 100000;

  -- User Data interfaces

  signal clk : std_logic := '0';

  signal  i_TxDataChannels :  DWORD := (others => '0');
  signal  i_TxDataValids   :  sl := '0';
  signal  i_TxDataLasts    :  sl := '0';
  signal  i_TxDataReadys   :  sl := '0';

  constant FIFO_DEPTH : integer := 10;
  constant COLNum : integer := 23;
  signal i_data :  Word32Array(COLNum -1 downto 0) := (others => (others => '0'));
  signal i_controls_out    : Imp_test_bench_reader_Control_t  := Imp_test_bench_reader_Control_t_null;
  signal i_valid      : sl := '0';
   
  constant COLNum_out : integer := 42;
  signal i_data_out :  Word32Array(COLNum_out -1 downto 0) := (others => (others => '0'));
   

  signal data_in  : b2l_encoder_original_reader_rec := b2l_encoder_original_reader_rec_null;
  signal data_out : b2l_encoder_original_writer_rec := b2l_encoder_original_writer_rec_null;
  
begin
  
  clk <= globals.clk;
  
  u_reader : entity work.Imp_test_bench_reader
    generic map (
      COLNum => COLNum ,
      FIFO_DEPTH => FIFO_DEPTH
    ) port map (
      Clk          => clk,
      -- Incoming data
      rxData       => RxDataChannel,
      rxDataValid  => RxDataValid,
      rxDataLast   => RxDataLast,
      rxDataReady  => RxDataReady,
      -- outgoing data
      data_out     => i_data,
      valid        => i_valid,
      controls_out => i_controls_out
    );

  u_writer : entity work.Imp_test_bench_writer 
    generic map (
      COLNum => COLNum_out,
      FIFO_DEPTH => FIFO_DEPTH
    ) port map (
      Clk      => clk,
      -- Outgoing  data
      tXData      =>  i_TxDataChannels,
      txDataValid =>  i_TxDataValids,
      txDataLast  =>  i_TxDataLasts,
      txDataReady =>  i_TxDataReadys,
      -- incomming data 
      data_in    => i_data_out,
      controls_in => i_controls_out,
      Valid      => i_valid
    );
throttel : entity work.axiStreamThrottle 
    generic map (
        max_counter => Throttel_max_counter,
        wait_time   => Throttel_wait_time
    ) port map (
        clk           => clk,

        rxData         =>  i_TxDataChannels,
        rxDataValid    =>  i_TxDataValids,
        rxDataLast     =>  i_TxDataLasts,
        rxDataReady    =>  i_TxDataReadys,

        tXData          => TxDataChannel,
        txDataValid     => TxDataValid,
        txDataLast      => TxDataLast,
        txDataReady     =>  TxDataReady
    );
-- <DUT>
    DUT :  entity work.b2l_encoder_original port map(
  clk => globals.clk,
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
-- </DUT>


--  <data_out_converter>

sl_to_slv(data_out.b2clkup, i_data_out(0) );
sl_to_slv(data_out.b2ttup, i_data_out(1) );
slv_to_slv(data_out.b2ttversion, i_data_out(2) );
slv_to_slv(data_out.trgtag, i_data_out(3) );
sl_to_slv(data_out.trigen, i_data_out(4) );
sl_to_slv(data_out.linklost, i_data_out(5) );
sl_to_slv(data_out.parawe, i_data_out(6) );
slv_to_slv(data_out.paradata, i_data_out(7) );
sl_to_slv(data_out.en8, i_data_out(8) );
sl_to_slv(data_out.wr8, i_data_out(9) );
sl_to_slv(data_out.rd8, i_data_out(10) );
slv_to_slv(data_out.data8i, i_data_out(11) );
slv_to_slv(data_out.data8o, i_data_out(12) );
slv_to_slv(data_out.addr8, i_data_out(13) );
sl_to_slv(data_out.en32, i_data_out(14) );
sl_to_slv(data_out.wr32, i_data_out(15) );
sl_to_slv(data_out.rd32, i_data_out(16) );
slv_to_slv(data_out.data32i, i_data_out(17) );
slv_to_slv(data_out.data32o, i_data_out(18) );
slv_to_slv(data_out.addr32, i_data_out(19) );
sl_to_slv(data_out.ack, i_data_out(20) );
sl_to_slv(data_out.regsimsbe, i_data_out(21) );
sl_to_slv(data_out.regsimmbe, i_data_out(22) );
sl_to_slv(data_out.regsemrst, i_data_out(23) );
slv_to_slv(data_out.regsimaddr, i_data_out(24) );
slv_to_slv(data_out.cntsemscan, i_data_out(25) );
slv_to_slv(data_out.cntsemsim, i_data_out(26) );
slv_to_slv(data_out.cntsemdet, i_data_out(27) );
slv_to_slv(data_out.cntsemack, i_data_out(28) );
slv_to_slv(data_out.cntsembusy, i_data_out(29) );
sl_to_slv(data_out.semsbe, i_data_out(30) );
sl_to_slv(data_out.semmbe, i_data_out(31) );
sl_to_slv(data_out.semactiv, i_data_out(32) );
sl_to_slv(data_out.sembusy, i_data_out(33) );
sl_to_slv(data_out.semcrc, i_data_out(34) );
sl_to_slv(data_out.semess, i_data_out(35) );
slv_to_slv(data_out.neventout, i_data_out(36) );
slv_to_slv(data_out.nwordout, i_data_out(37) );
slv_to_slv(data_out.sig_ilatx, i_data_out(38) );
slv_to_slv(data_out.sig_ila, i_data_out(39) );
sl_to_slv(data_out.data_in_wr, i_data_out(40) );
slv_to_slv(data_out.data_in_data, i_data_out(41) );

--  </data_out_converter>

-- <data_in_converter> 

slv_to_sl(i_data(0), data_in.b2clkup);
slv_to_sl(i_data(1), data_in.b2ttup);
slv_to_slv(i_data(2), data_in.b2ttversion);
slv_to_slv(i_data(3), data_in.trgtag);
slv_to_slv(i_data(4), data_in.data8i);
slv_to_slv(i_data(5), data_in.data32i);
slv_to_sl(i_data(6), data_in.ack);
slv_to_slv(i_data(7), data_in.cntsemscan);
slv_to_slv(i_data(8), data_in.cntsemsim);
slv_to_slv(i_data(9), data_in.cntsemdet);
slv_to_slv(i_data(10), data_in.cntsemack);
slv_to_slv(i_data(11), data_in.cntsembusy);
slv_to_sl(i_data(12), data_in.semsbe);
slv_to_sl(i_data(13), data_in.semmbe);
slv_to_sl(i_data(14), data_in.semactiv);
slv_to_sl(i_data(15), data_in.sembusy);
slv_to_sl(i_data(16), data_in.semcrc);
slv_to_sl(i_data(17), data_in.semess);
slv_to_slv(i_data(18), data_in.neventout);
slv_to_slv(i_data(19), data_in.nwordout);
slv_to_slv(i_data(20), data_in.sig_ilatx);
slv_to_sl(i_data(21), data_in.data_in_wr);
slv_to_slv(i_data(22), data_in.data_in_data);

--</data_in_converter>

-- <connect_input_output>

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

-- </connect_input_output>


end architecture;



library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

library UNISIM;
  use UNISIM.VComponents.all;

  use work.UtilityPkg.all;
  use work.Eth1000BaseXPkg.all;
  use work.GigabitEthPkg.all;


  use work.type_conversions_pgk.all;
  use work.Imp_test_bench_pgk.all;
  
  use work.UtilityPkg.all;
  use work.Eth1000BaseXPkg.all;
  use work.GigabitEthPkg.all;
  use work.xgen_klm_scrod_bus.all;
  use work.klm_scint_globals.all;
  use work.tdc_pkg.all;

  
entity b2l_encoder_original_top is
   port (
    -- Direct GT connections
    gtTxP        : out sl;
    gtTxN        : out sl;
    gtRxP        :  in sl;
    gtRxN        :  in sl;
    gtClkP       :  in sl;
    gtClkN       :  in sl;
    -- Alternative clock input
    fabClkP      :  in sl;
    fabClkN      :  in sl;
    -- SFP transceiver disable pin
    txDisable    : out sl;

    SCLK         : out std_logic_vector(9 downto 0) := (others =>'0');
    SHOUT        : in std_logic_vector(9 downto 0) := (others =>'0');
    SIN          : out std_logic_vector(9 downto 0) := (others =>'0');
    PCLK         : out std_logic_vector(9 downto 0) := (others =>'0');
 
    BUSA_CLR            : out sl := '0';
    BUSA_RAMP           :out sl := '0';
    BUSA_WR_ADDRCLR     :out sl := '0'; 
    BUSA_DO             : in std_logic_vector(15 downto 0) := (others =>'0');
    BUSA_RD_COLSEL_S    : out std_logic_vector(5 downto 0) := (others =>'0');
    BUSA_RD_ENA         : out sl := '0';
    BUSA_RD_ROWSEL_S    : out std_logic_vector(2 downto 0) := (others =>'0');
    BUSA_SAMPLESEL_S    : out std_logic_vector(4 downto 0) := (others =>'0');
    BUSA_SR_CLEAR       : out sl := '0';
    BUSA_SR_SEL         : out sl := '0';
    
    --Bus B Specific Signals
    BUSB_WR_ADDRCLR          : out std_logic := '0';
    BUSB_RD_ENA              : out std_logic := '0';
    BUSB_RD_ROWSEL_S         : out std_logic_vector(2 downto 0) := (others =>'0');
    BUSB_RD_COLSEL_S         : out std_logic_vector(5 downto 0) := (others =>'0');
    BUSB_CLR                 : out std_logic := '0';
    BUSB_RAMP                : out std_logic := '0';
    BUSB_SAMPLESEL_S         : out std_logic_vector(4 downto 0):= (others =>'0');
    BUSB_SR_CLEAR            : out std_logic := '0';
    BUSB_SR_SEL              : out std_logic := '0';
    BUSB_DO                  : in  std_logic_vector(15 downto 0):= (others =>'0');

    BUS_REGCLR      : out sl := '0' ; -- not connected
    SAMPLESEL_ANY   : out std_logic_vector(9 downto 0)  := (others => '0') ;
    SR_CLOCK        : out std_logic_vector(9 downto 0)  := (others => '0') ; 
    WR1_ENA         : out std_logic_vector(9 downto 0)  := (others => '0')  ;
    WR2_ENA         : out std_logic_vector(9 downto 0)  := (others => '0')  ;

    
       -- MPPC HV DAC
   BUSA_SCK_DAC		       : out std_logic := '0';
   BUSA_DIN_DAC		       : out std_logic := '0';
   BUSB_SCK_DAC		       : out std_logic := '0';
   BUSB_DIN_DAC		       : out std_logic := '0';
   --
   -- TRIGGER SIGNALS
   -- TARGET_TB                : in tb_vec_type;
   
   TDC_DONE                 : in STD_LOGIC_VECTOR(9 downto 0) := (others => '0')  ; -- move to readout signals
   TDC_MON_TIMING           : in STD_LOGIC_VECTOR(9 downto 0) := (others => '0')  ;  -- add the ref to the programming of the TX chip
   
    WL_CLK_N : out STD_LOGIC_VECTOR (9 downto 0) := (others => '0')  ;
    WL_CLK_P  : out STD_LOGIC_VECTOR (9 downto 0) := (others => '0')  ;
    SSTIN_N :  out STD_LOGIC_VECTOR (9 downto 0) := (others => '0')  ;
    SSTIN_P :  out STD_LOGIC_VECTOR (9 downto 0) := (others => '0')  
  );
end entity;

architecture rtl of b2l_encoder_original_top is

  signal TXBus_m2s : DataBus_m2s_a(1 downto 0) := (others => DataBus_m2s_null);
  signal TXBus_s2m : DataBus_s2m_a(1 downto 0) := (others => DataBus_s2m_null);


  signal fabClk       : sl := '0';
  -- User Data interfaces




  signal globals :   globals_t := globals_t_null;
  signal TX_DAC_control_out :   TX_DAC_control := TX_DAC_control_null;

  constant NUM_IP_G        : integer := 2;
     

  
  signal ethClk125    : sl;
  --signal ethClk62    : sl;



  signal ethCoreMacAddr : MacAddrType := MAC_ADDR_DEFAULT_C;
     
  signal userRst     : sl;
  signal ethCoreIpAddr  : IpAddrType  := IP_ADDR_DEFAULT_C;
  constant ethCoreIpAddr1 : IpAddrType  := (3 => x"C0", 2 => x"A8", 1 => x"01", 0 => x"21");
  constant udpPort        :  slv(15 downto 0):=  x"07D1" ;  -- 0x7d1

     
  signal will_clk: std_logic := '0';
  signal SST_clk_proto: std_logic := '0';
  signal SST_clk      : std_logic := '0';
     
     
  -- User Data interfaces
  signal userTxDataChannels : Word32Array(NUM_IP_G-1 downto 0);
  signal userTxDataValids   : slv(NUM_IP_G-1 downto 0);
  signal userTxDataLasts    : slv(NUM_IP_G-1 downto 0);
  signal userTxDataReadys   : slv(NUM_IP_G-1 downto 0);
  signal userRxDataChannels : Word32Array(NUM_IP_G-1 downto 0);
  signal userRxDataValids   : slv(NUM_IP_G-1 downto 0);
  signal userRxDataLasts    : slv(NUM_IP_G-1 downto 0);
  signal userRxDataReadys   : slv(NUM_IP_G-1 downto 0);
    
begin
  
  U_IBUFGDS : IBUFGDS port map ( I => fabClkP, IB => fabClkN, O => fabClk);




-- <Connecting the BUS to the pseudo class>
  

 objectMaker: entity work.TX_InterfaceObjectMaker port map(
   

   BUSA_CLR          =>  BUSA_CLR,           
   BUSA_RAMP         =>  BUSA_RAMP,          
   BUSA_WR_ADDRCLR   =>  BUSA_WR_ADDRCLR    ,
   BUSA_DO           =>  BUSA_DO            ,
   BUSA_RD_COLSEL_S  =>  BUSA_RD_COLSEL_S   ,
   BUSA_RD_ENA       =>  BUSA_RD_ENA        ,
   BUSA_RD_ROWSEL_S  =>  BUSA_RD_ROWSEL_S   ,
   BUSA_SAMPLESEL_S  =>  BUSA_SAMPLESEL_S   ,
   BUSA_SR_CLEAR     =>  BUSA_SR_CLEAR      ,
   BUSA_SR_SEL       =>  BUSA_SR_SEL        ,

   --Bus B Specific Signals
   BUSB_WR_ADDRCLR        =>BUSB_WR_ADDRCLR      ,
   BUSB_RD_ENA            =>BUSB_RD_ENA          ,
   BUSB_RD_ROWSEL_S       =>BUSB_RD_ROWSEL_S     ,
   BUSB_RD_COLSEL_S       =>BUSB_RD_COLSEL_S     ,
   BUSB_CLR               =>BUSB_CLR             ,
   BUSB_RAMP              =>BUSB_RAMP            ,
   BUSB_SAMPLESEL_S       =>BUSB_SAMPLESEL_S     ,
   BUSB_SR_CLEAR          =>BUSB_SR_CLEAR        ,
   BUSB_SR_SEL            =>BUSB_SR_SEL          ,
   BUSB_DO                =>BUSB_DO              ,

   BUS_REGCLR      => BUS_REGCLR     ,
   SAMPLESEL_ANY   => SAMPLESEL_ANY  ,
   SR_CLOCK        => SR_CLOCK       ,
   WR1_ENA         => WR1_ENA        ,
   WR2_ENA         => WR2_ENA        ,

   TXBus_m2s => TXBus_m2s,
   TXBus_s2m => TXBus_s2m

 );

  
-- </Connecting the BUS to the pseudo class>


  --------------------------------
  -- Gigabit Ethernet Interface --
  --------------------------------
  U_S6EthTop : entity work.S6EthTop
    generic map (
      NUM_IP_G     => NUM_IP_G
    )
    port map (
      -- Direct GT connections
      gtTxP           => gtTxP,
      gtTxN           => gtTxN,
      gtRxP           => gtRxP,
      gtRxN           => gtRxN,
      gtClkP          => gtClkP,
      gtClkN          => gtClkN,
      -- Alternative clock input from fabric
      fabClkIn        => fabClk,
      -- SFP transceiver disable pin
      txDisable       => txDisable,
      -- Clocks out from Ethernet core
      ethUsrClk62     => open,
      ethUsrClk125    => ethClk125,
      -- Status and diagnostics out
      ethSync         => open,
      ethReady        => open,
      led             => open,
      -- Core settings in 
      macAddr         => ethCoreMacAddr,
      ipAddrs         => (0 => ethCoreIpAddr, 1 => ethCoreIpAddr1),
      udpPorts        => (0 => x"07D0",       1 => udpPort), --x7D0 = 2000,
      -- User clock inputs
      userClk         => ethClk125,
      userRstIn       => '0',
      userRstOut      => userRst,
      -- User data interfaces
      userTxData      => userTxDataChannels,
      userTxDataValid => userTxDataValids,
      userTxDataLast  => userTxDataLasts,
      userTxDataReady => userTxDataReadys,
      userRxData      => userRxDataChannels,
      userRxDataValid => userRxDataValids,
      userRxDataLast  => userRxDataLasts,
      userRxDataReady => userRxDataReadys
    );
  
  

    register_handler : entity work.roling_register_eth port map(
    clk => ethClk125,

    TxDataChannel =>   userTxDataChannels(0),
    TxDataValid  =>   userTxDataValids(0),  
    TxDataLast  =>   userTxDataLasts(0) ,
    TxDataReady   => userTxDataReadys(0),
    RxDataChannel =>userRxDataChannels(0),
    RxDataValid  => userRxDataValids(0),
    RxDataLast   => userRxDataLasts(0),
    RxDataReady  => userRxDataReadys(0),


    globals => globals,
    TX_DAC_control_out => TX_DAC_control_out
  );
  
 
  
  
  
  u_dut  : entity work.b2l_encoder_original_eth
    port map (
      globals => globals,
      -- Incoming data
      RxDataChannel => userRxDataChannels(1),
      rxDataValid   => userRxDataValids(1),
      rxDataLast    => userRxDataLasts(1),
      rxDataReady   =>  userRxDataReadys(1),
      -- outgoing data  
      TxDataChannel   => userTxDataChannels(1),
      TxDataValid     => userTxDataValids(1),
      txDataLast      => userTxDataLasts(1) ,
      TxDataReady     =>  userTxDataReadys(1),
      TXBus_m2s => TXBus_m2s,
      TXBus_s2m => TXBus_s2m
    );


  REG_DAC : 
  for I in 0 to 9 generate
    SCLK(I) <= TX_DAC_control_out.SCLK;     
    --SHOUT <= TX_DAC_control_out.
    SIN(I)  <= TX_DAC_control_out.SIN;     
    PCLK(I) <= TX_DAC_control_out.PCLK;
    
  end generate ;
  
  
  
  process(ethClk125) 
  begin 
    if rising_edge( ethClk125) then
      will_clk <= not will_clk;
    end if;
  end process;


  process(will_clk) 
  begin 
    if rising_edge( will_clk) then
      SST_clk_proto <= not SST_clk_proto;
    end if;
  end process;

  process(SST_clk_proto) 
  begin 
    if rising_edge( SST_clk_proto) then
      SST_clk <= not SST_clk;
    end if;
  end process;

  will_clk_gen : 
  for I in 0 to 9 generate
    willk_out_clk : OBUFDS
      generic map (
        IOSTANDARD => "LVDS_25")
      port map (
        O =>  WL_CLK_p(I),    -- Diff_p output (connect directly to top-level port
        OB => WL_CLK_N(I),   -- Diff_n output (connect directly to top-level port)
        I =>  will_clk     -- Buffer input 

      );      
  end generate ;
  GEN_REG : 
  for I in 0 to 9 generate
    sst_out : OBUFDS
      generic map (
        IOSTANDARD => "LVDS_25")
      port map (
        O =>  SSTIN_P(I),    -- Diff_p output (connect directly to top-level port
        OB => SSTIN_N(I),     -- Diff_n output (connect directly to top-level port)
        I =>  SST_clk         -- Buffer input 

      );   
  end generate GEN_REG;


end architecture;

