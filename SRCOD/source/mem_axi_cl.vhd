library ieee;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_unsigned.all;
------------------------------------------------------------------------
---- AXI FIFO with common clock
------------------------------------------------------------------------

  use work.xgen_axistream_32.all;


entity fifo_cc_axi_32 is
  generic(

    DEPTH : natural := 5 
  ); 

  port(
    clk       : in   std_logic := '0'; 
    rst       : in  std_logic := '0'; 
    RX_m2s  : in   axisStream_32_m2s := axisStream_32_m2s_null;
    RX_s2m  : out  axisStream_32_s2m := axisStream_32_s2m_null;

    TX_m2s  : out   axisStream_32_m2s := axisStream_32_m2s_null;
    TX_s2m   : in  axisStream_32_s2m   := axisStream_32_s2m_null


  );
end entity;

architecture rtl of fifo_cc_axi_32 is
begin

fifo_cc : entity work.fifo_cc_axi generic map (
  DATA_WIDTH =>  32,
  DEPTH  => DEPTH
  
) port map (
  clk        => clk ,
  rst        => rst,
  RX_Data    => RX_m2s.data,
  RX_Valid   => RX_m2s.valid, 
  RX_Last    => RX_m2s.last, 
  RX_Ready   => RX_s2m.ready,
  TX_Data    => TX_m2s.data, 
  TX_Valid   => TX_m2s.valid,
  TX_Last    => TX_m2s.last,
  TX_Ready  => TX_s2m.ready 
);
end rtl;