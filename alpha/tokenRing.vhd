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
  
  signal  asic_a_desi_chain_out  : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
  signal  asic_b_desi_chain_out  : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
  signal  asic_c_desi_chain_out  : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
  signal  asic_d_desi_chain_out  : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
  signal  handler_desi_chain_out  : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
      
begin
  
  ASIC_AA: entity work.TokenParser generic map(
      ASIC_HEADER => ASIC_A
    ) port map (
      clk => clk,
      rst => rst,

      dummy_data => asic_a_dummy_data,
      desi_chain_in  => handler_desi_chain_out,
      desi_chain_out  => asic_a_desi_chain_out
    );
  
  ASIC_BB: entity work.TokenParser generic map(
    ASIC_HEADER => ASIC_B
  ) port map (
    clk => clk,
    rst => rst,

    dummy_data => asic_b_dummy_data,
    desi_chain_in  => asic_a_desi_chain_out,
    desi_chain_out  => asic_b_desi_chain_out
  );
  
  ASIC_CC: entity work.TokenParser generic map(
    ASIC_HEADER => ASIC_C
  ) port map (
    clk => clk,
    rst => rst,

    dummy_data => asic_c_dummy_data,
    desi_chain_in  => asic_b_desi_chain_out,
    desi_chain_out  => asic_c_desi_chain_out
  );
  
  ASIC_DD: entity work.TokenParser generic map(
    ASIC_HEADER => ASIC_D
  ) port map (
    clk => clk,
    rst => rst,

    dummy_data => asic_d_dummy_data,
    desi_chain_in  => asic_c_desi_chain_out,
    desi_chain_out  => asic_d_desi_chain_out
  );

  handler : entity work.tokingRingHandler port map(
      clk => clk,
      rst => rst,
      dummy_data   => Data_out,    
      desi_chain_in   => asic_d_desi_chain_out,
      desi_chain_out  => handler_desi_chain_out
    );
  
end architecture;