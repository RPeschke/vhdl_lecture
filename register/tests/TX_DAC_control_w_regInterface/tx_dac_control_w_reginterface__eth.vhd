

library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

library UNISIM;
  use UNISIM.VComponents.all;
  use work.UtilityPkg.all;

  use work.tx_dac_control_w_reginterface_writer_pgk.all;
  use work.tx_dac_control_w_reginterface_reader_pgk.all;
  use work.type_conversions_pgk.all;
  use work.Imp_test_bench_pgk.all;
  
entity tx_dac_control_w_reginterface_eth is
  port (
    clk : in std_logic;
    TxDataChannel : out  DWORD := (others => '0');
    TxDataValid   : out  sl := '0';
    TxDataLast    : out  sl := '0';
    TxDataReady   : in   sl := '0';
    RxDataChannel : in   DWORD := (others => '0');
    RxDataValid   : in   sl := '0';
    RxDataLast    : in   sl := '0';
    RxDataReady   : out  sl := '0'
  );
end entity;

architecture rtl of tx_dac_control_w_reginterface_eth is
  
  constant Throttel_max_counter : integer  := 10;
  constant Throttel_wait_time : integer := 100000;

  -- User Data interfaces



  signal  i_TxDataChannels :  DWORD := (others => '0');
  signal  i_TxDataValids   :  sl := '0';
  signal  i_TxDataLasts    :  sl := '0';
  signal  i_TxDataReadys   :  sl := '0';

  constant FIFO_DEPTH : integer := 10;
  constant COLNum : integer := 3;
  signal i_data :  Word32Array(COLNum -1 downto 0) := (others => (others => '0'));
  signal i_controls_out    : Imp_test_bench_reader_Control_t  := Imp_test_bench_reader_Control_t_null;
  signal i_valid      : sl := '0';
   
  constant COLNum_out : integer := 7;
  signal i_data_out :  Word32Array(COLNum_out -1 downto 0) := (others => (others => '0'));
   

  signal data_in  : tx_dac_control_w_reginterface_reader_rec := tx_dac_control_w_reginterface_reader_rec_null;
  signal data_out : tx_dac_control_w_reginterface_writer_rec := tx_dac_control_w_reginterface_writer_rec_null;
  
begin
  
  
  
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
    DUT :  entity work.tx_dac_control_w_reginterface port map(
  clk => clk,
  regin => data_out.regin,
  sin => data_out.sin,
  sclk => data_out.sclk,
  pclk => data_out.pclk,
  reg_clr => data_out.reg_clr
);
-- </DUT>


--  <data_out_converter>

slv_to_slv(data_out.regin.address, i_data_out(0) );
slv_to_slv(data_out.regin.value, i_data_out(1) );
sl_to_slv(data_out.regin.clk, i_data_out(2) );
sl_to_slv(data_out.sin, i_data_out(3) );
sl_to_slv(data_out.sclk, i_data_out(4) );
sl_to_slv(data_out.pclk, i_data_out(5) );
sl_to_slv(data_out.reg_clr, i_data_out(6) );

--  </data_out_converter>

-- <data_in_converter> 

slv_to_slv(i_data(0), data_in.regin.address);
slv_to_slv(i_data(1), data_in.regin.value);
slv_to_sl(i_data(2), data_in.regin.clk);

--</data_in_converter>

-- <connect_input_output>

data_out.regin <= data_in.regin;

-- </connect_input_output>


end architecture;

