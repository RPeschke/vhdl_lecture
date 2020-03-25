

entity memory is
    port (
        clk : std_logic;
        write_enable   : in  std_logic;
        Write_address  : in  std_logic_vector(7 downto 0);
        Write_Data     : in  std_logic_vector(15 downto 0);
        -- Port B
        read_address  : in  std_logic_vector(7 downto 0);
        read_data     : out std_logic_vector(15 downto 0)
    );
end entity memory;

architecture rtl of memory is
    
begin
    
    
    
end architecture rtl;