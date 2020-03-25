library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;
  use ieee.std_logic_unsigned.all;

  use work.roling_register_p.all;

  use work.xgen_edgeDetection.all;
  use work.xgen_axistream_32.all;
  use work.klm_scint_globals.all;
  use work.xgen_klm_scrod_bus.all;

entity TX_DAC_control_w_regInterface is

  port (
    globals :  in globals_t := globals_t_null;


    TX_DAC_control_out : out  TX_DAC_control := TX_DAC_control_null
    
  );
end entity;

architecture rtl of TX_DAC_control_w_regInterface is
  constant BufferSize : integer := 100;
  signal regBuffer: registerT_a(BufferSize downto 0) := (others =>  registerT_null);
  
  
  
  signal  reg_data_m2s : axisStream_32_m2s := axisStream_32_m2s_null;  
  signal  reg_data_s2m : axisStream_32_s2m := axisStream_32_s2m_null;  



  signal reset_register_val : std_logic_vector(15 downto 0) := (others => '0');

  signal   i_reg           :  registerT:= registerT_null;
  signal   i_reg1         :  registerT:= registerT_null;
  signal   i_reg2         :  registerT:= registerT_null;
begin

  DUT :  entity work.tx_dac_control_axi port map(
    clk => globals.clk,
    regin => globals.reg,
    reg_data_m2s => reg_data_m2s,
    reg_data_s2m => reg_data_s2m,
    sin  => TX_DAC_control_out.SIN,
    sclk => TX_DAC_control_out.SCLK,
    pclk => TX_DAC_control_out.PCLK
  );


  process(globals.clk) is
    variable regTX : axisStream_32_master := axisStream_32_master_null;
    variable REG_DATA :  STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    variable reg_address : integer := 0; 
  begin
    if rising_edge(globals.clk) then 
      pull(regTx, reg_data_s2m);
      i_reg1 <= registerT_null;
        reg_address := to_integer(signed(i_reg.address));
			if reg_address < BufferSize then 
        if regBuffer(reg_address).value /= i_reg.value and ready_to_send(regTX)  then
          REG_DATA := (others => '0');
          REG_DATA(18 downto 12) := i_reg.address(6 downto 0);
          REG_DATA(11 downto 0)  := i_reg.value(11 downto 0);
          send_data(regTX, REG_DATA);
          i_reg1 <= i_reg;

        end if;
		end if;
        push(regTx,reg_data_m2s);
    end if;
  end process;

process(globals.clk) is
    variable reg_address : integer := 0; 

    variable  reset_register : edgeDetection:=edgeDetection_null;
begin 
 if rising_edge(globals.clk) then
        pull(reset_register, reset_register_val(0));
       reg_address := to_integer(signed(i_reg2.address));
       regBuffer(reg_address) <= i_reg2;

       read_data_s  (i_reg2, reset_register_val,  register_val.DAC_full_reset );
             
       if rising_edge(reset_register) then
         regBuffer <= (others => registerT_null);
       end if;
end if;

end process;  
  

    reg_buffer_out : entity work.registerBuffer generic map (
        Depth =>  5
  ) port map (
    
    clk =>globals.clk,
    registersIn   => i_reg1,
    registersOut  => i_reg2
  );

  
  
  reg_buffer : entity work.registerBuffer generic map (
        Depth =>  5
  ) port map (
    
    clk =>globals.clk,
    registersIn   => globals.reg,
    registersOut  => i_reg
  );
end architecture;