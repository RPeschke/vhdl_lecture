-- <header>Header; Nr_of_streams; recording TimeStamp; Operation; Number of packets; packateNr; Sending TimeStamp; ped_data; ped_data_address; data_in_m2s_last; data_in_m2s_valid; data_in_m2s_data; data_in_s2m_ready; data_out_m2s_last; data_out_m2s_valid; data_out_m2s_data; data_out_s2m_ready; Tail</header>



library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

library UNISIM;
  use UNISIM.VComponents.all;
  use work.UtilityPkg.all;

  use work.pedestal_substraction_IO_pgk.all;
  use work.type_conversions_pgk.all;
  use work.Imp_test_bench_pgk.all;
  use work.xgen_klm_scrod_bus.all;
  use work.klm_scint_globals.all;

entity pedestal_substraction_eth is
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

architecture rtl of pedestal_substraction_eth is
  
  constant Throttel_max_counter : integer  := 10;
  constant Throttel_wait_time : integer := 100000;

  -- User Data interfaces

  signal clk : std_logic := '0';

  signal  i_TxDataChannels :  DWORD := (others => '0');
  signal  i_TxDataValids   :  sl := '0';
  signal  i_TxDataLasts    :  sl := '0';
  signal  i_TxDataReadys   :  sl := '0';

  constant FIFO_DEPTH : integer := 10;
  constant COLNum : integer := 6;
  signal i_data :  Word32Array(COLNum -1 downto 0) := (others => (others => '0'));
  signal i_controls_out    : Imp_test_bench_reader_Control_t  := Imp_test_bench_reader_Control_t_null;
  signal i_valid      : sl := '0';
   
  constant COLNum_out : integer := 10;
  signal i_data_out :  Word32Array(COLNum_out -1 downto 0) := (others => (others => '0'));
   

  signal data_in  : pedestal_substraction_reader_rec := pedestal_substraction_reader_rec_null;
  signal data_out : pedestal_substraction_writer_rec := pedestal_substraction_writer_rec_null;
  
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
    DUT :  entity work.pedestal_substraction port map(
  clk => globals.clk,
  ped_data => data_out.ped_data,
  ped_data_address => data_out.ped_data_address,
  data_in_m2s => data_out.data_in_m2s,
  data_in_s2m => data_out.data_in_s2m,
  data_out_m2s => data_out.data_out_m2s,
  data_out_s2m => data_out.data_out_s2m
);
-- </DUT>


--  <data_out_converter>

slv_to_slv(data_out.ped_data, i_data_out(0) );
slv_to_slv(data_out.ped_data_address, i_data_out(1) );
sl_to_slv(data_out.data_in_m2s.last, i_data_out(2) );
sl_to_slv(data_out.data_in_m2s.valid, i_data_out(3) );
slv_to_slv(data_out.data_in_m2s.data, i_data_out(4) );
sl_to_slv(data_out.data_in_s2m.ready, i_data_out(5) );
sl_to_slv(data_out.data_out_m2s.last, i_data_out(6) );
sl_to_slv(data_out.data_out_m2s.valid, i_data_out(7) );
slv_to_slv(data_out.data_out_m2s.data, i_data_out(8) );
sl_to_slv(data_out.data_out_s2m.ready, i_data_out(9) );

--  </data_out_converter>

-- <data_in_converter> 

slv_to_slv(i_data(0), data_in.ped_data);
slv_to_slv(i_data(1), data_in.ped_data_address);
slv_to_sl(i_data(2), data_in.data_in_m2s.last);
slv_to_sl(i_data(3), data_in.data_in_m2s.valid);
slv_to_slv(i_data(4), data_in.data_in_m2s.data);
slv_to_sl(i_data(5), data_in.data_out_s2m.ready);

--</data_in_converter>

-- <connect_input_output>

data_out.ped_data <= data_in.ped_data;
data_out.ped_data_address <= data_in.ped_data_address;
data_out.data_in_m2s <= data_in.data_in_m2s;
data_out.data_out_s2m <= data_in.data_out_s2m;

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

  
entity pedestal_substraction_top is
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

architecture rtl of pedestal_substraction_top is

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
  
 
  
  
  
  u_dut  : entity work.pedestal_substraction_eth
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

