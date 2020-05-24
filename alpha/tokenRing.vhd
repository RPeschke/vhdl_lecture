library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;
  use work.TokenParser_p.all;
entity tokenRing is
  port (
    clk: in  std_logic;
    rst: in  std_logic;
    asic_a_dummy_data : in  STD_LOGIC_VECTOR(31 downto 0);
    asic_b_dummy_data : in  STD_LOGIC_VECTOR(31 downto 0);
    asic_c_dummy_data : in  STD_LOGIC_VECTOR(31 downto 0);
    asic_d_dummy_data : in  STD_LOGIC_VECTOR(31 downto 0);
    Data_out          : out STD_LOGIC_VECTOR(31 downto 0)
  );
end entity;

architecture rtl of tokenRing is
  
  signal ASIC_AA_tx_m2s :  tokenring_interface_m2s :=tokenring_interface_m2s_null;
  signal ASIC_AA_tx_s2m :  tokenring_interface_s2m :=tokenring_interface_s2m_null;
      
  signal ASIC_BB_tx_m2s :  tokenring_interface_m2s :=tokenring_interface_m2s_null;
  signal ASIC_BB_tx_s2m :  tokenring_interface_s2m :=tokenring_interface_s2m_null;
  
  
  signal ASIC_CC_tx_m2s :  tokenring_interface_m2s :=tokenring_interface_m2s_null;
  signal ASIC_CC_tx_s2m :  tokenring_interface_s2m :=tokenring_interface_s2m_null;
  
  signal ASIC_DD_tx_m2s :  tokenring_interface_m2s :=tokenring_interface_m2s_null;
  signal ASIC_DD_tx_s2m :  tokenring_interface_s2m :=tokenring_interface_s2m_null;
  
 -- signal FPGA_tx_m2s :  tokenring_interface_m2s :=tokenring_interface_m2s_null;
  signal FPGA_tx_s2m :  tokenring_interface_s2m :=tokenring_interface_s2m_null;
begin
  
  ASIC_AA: entity work.TokenParser_ASIC generic map(
      ASIC_HEADER => ASIC_A
    ) port map (
      clk => clk,
      rst => rst,

      dummy_data => asic_a_dummy_data,
    
      rx_s2m => FPGA_tx_s2m,
      
      tx_m2s => ASIC_AA_tx_m2s,
      tx_s2m => ASIC_AA_tx_s2m

    );
  
  ASIC_BB: entity work.TokenParser_ASIC generic map(
    ASIC_HEADER => ASIC_B
  ) port map (
    clk => clk,
    rst => rst,

    dummy_data => asic_b_dummy_data,
    rx_m2s => ASIC_AA_tx_m2s,
    rx_s2m => ASIC_AA_tx_s2m,
    
    
    tx_m2s => ASIC_BB_tx_m2s,
    tx_s2m => ASIC_BB_tx_s2m
    

    
  );
  
  ASIC_CC: entity work.TokenParser_ASIC generic map(
    ASIC_HEADER => ASIC_C
  ) port map (
    clk => clk,
    rst => rst,

    dummy_data => asic_c_dummy_data,
    rx_m2s => ASIC_BB_tx_m2s,
    rx_s2m => ASIC_BB_tx_s2m,


    tx_m2s => ASIC_CC_tx_m2s,
    tx_s2m => ASIC_CC_tx_s2m
  );
  
  ASIC_DD: entity work.TokenParser_ASIC generic map(
    ASIC_HEADER => ASIC_D
  ) port map (
    clk => clk,
    rst => rst,

    dummy_data => asic_d_dummy_data,
    rx_m2s => ASIC_CC_tx_m2s,
    rx_s2m => ASIC_CC_tx_s2m,


    tx_m2s => ASIC_DD_tx_m2s,
    tx_s2m => ASIC_DD_tx_s2m
  );

  handler : entity work.tokingRingHandler_FPGA port map(
      clk => clk,
      rst => rst,
      dummy_data   => Data_out,    

      
      rx_m2s => ASIC_DD_tx_m2s,
      rx_s2m => ASIC_DD_tx_s2m,


    
      tx_s2m => FPGA_tx_s2m
    );
  
end architecture;