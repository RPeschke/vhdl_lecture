-- XGEN: Autogenerated File



entity tb is 
end entity;



architecture rtl of tb is

--------------------------tb-----------------
-------------------------- end tb-----------------

begin
  -- begin architecture
  
-----------------------------------
proc : process(clk) is
  variable ram : ramBlock := ramBlock_null;
  begin
    if rising_edge(clk) then 
  set_data_011(self => ram, data => addr, addr => addr);
    end if;
  
  end process;
  -- end architecture

end architecture;