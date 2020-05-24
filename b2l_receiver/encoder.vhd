library ieee;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_unsigned.all;
  use ieee.numeric_std.all;
library IEEE;
library UNISIM;
library work;
  use IEEE.numeric_std.all;
  use IEEE.std_logic_1164.all;

  use ieee.std_logic_unsigned.all;
library work;
  use work.register8bit.all;
  use work.register32bit.all;

  use work.axisStream_slv16.all;
--use work.b2l_defs.all;

entity b2l_encoder is
  generic (
    -- don't touch these parameters here:
    --   B2LVERSION is set in belle2link.vhd
    --   others are set in the top level design file
    B2LVERSION : integer := 0;

    FWTYPE     : integer := 0;    -- 4 bit
    VERSION    : integer := 0;    -- 12 bit
    DATE       : integer := 0 );  -- decimal YYYYMMDD
  port (

    -- from/to GTP




    clk              : in  std_logic;

    -- from/to b2tt
    b2clkup              : in  std_logic;
    b2ttup               : in  std_logic;

    b2ttversion          : in  std_logic_vector (15 downto 0);
    trgtag               : in  std_logic_vector (31 downto 0);
    -- status
    trigen               : out std_logic;
    linklost             : out std_logic; --  also used as reset
    -- to b2l_transmitter
    parawe               : out std_logic;
    paradata             : out std_logic_vector (15 downto 0);
    -- from/to register I/O (A7D8 version)

    reg8_m2s             : out register8Bit_m2s;
    reg8_s2m             : in  register8Bit_s2m;
    
    
    
    -- from/to register I/O (A16D32 version)
    reg32_m2s            : out register32Bit_m2s;
    reg32_s2m            : in  register32Bit_s2m;
    

    -- sem
    regsimsbe            : out std_logic;
    regsimmbe            : out std_logic;
    regsemrst            : out std_logic;
    regsimaddr           : out std_logic_vector (39 downto 0);
    cntsemscan           : in  std_logic_vector (15 downto 0);
    cntsemsim            : in  std_logic_vector (15 downto 0);
    cntsemdet            : in  std_logic_vector (15 downto 0);
    cntsemack            : in  std_logic_vector (15 downto 0);
    cntsembusy           : in  std_logic_vector (15 downto 0);
    semsbe               : in  std_logic;
    semmbe               : in  std_logic;
    semactiv             : in  std_logic;
    sembusy              : in  std_logic;
    semcrc               : in  std_logic;
    semess               : in  std_logic;
    -- for debug
    neventout            : in  std_logic_vector (31 downto 0);
    nwordout             : in  std_logic_vector (31 downto 0);
    sig_ilatx            : in  std_logic_vector (95 downto 0);


    Axi_in_s2m :  out  axiStream_slv16_s2m := axiStream_slv16_s2m_null;
    Axi_in_m2s :  in  axiStream_slv16_m2s := axiStream_slv16_m2s_null;

    clr_crcerr       :  out std_logic := '0';

    sig_linklost     : in std_logic := '0'


  );

end b2l_encoder;

architecture implementation of b2l_encoder is

  type alayer_pcs_t is (
    reset_state,
    select_operation,
    write8_start,
    write8_addr,
    write8_data,
    read8_start,
    read8_addr,
    read8_DATA,
    a16d32_write,
    read32,
    stream
  );
  signal b2ttclk              :   std_logic;

  signal cnt_crcerr       : std_logic_vector (7  downto 0) := (others => '0');


  signal Axi_out_s2m :  axiStream_slv16_s2m := axiStream_slv16_s2m_null;
  signal Axi_out_m2s :  axiStream_slv16_m2s := axiStream_slv16_m2s_null;





  signal reg8_s2m_local             :   register8Bit_s2m;

  signal rxstate          : std_logic_vector (3  downto 0) := (others => '0');

  -- watchdog (about 33.5 second)
  signal cnt_watchdog     : std_logic_vector (31 downto 0) := (others => '0');

  -- A16D32 support


  signal cnt_d32          : std_logic_vector (3  downto 0) := (others => '0');
  signal buf_dead         : std_logic_vector (15 downto 0) := (others => '0');
  signal parastate        : alayer_pcs_t := reset_state;


  

  -- from/to register I/O (A16D32 version)
  signal i_reg32_m2s            : register32Bit_m2s;
  signal i_reg32_s2m            : register32Bit_s2m;

  type b2l_data_out_t is record 
    write_Enable       : std_logic;
    data               : std_logic_vector (15 downto 0);  
  end record;


  constant b2l_data_out_t_null : b2l_data_out_t := (
    write_Enable => '0',
    data => (others => '0')
  );


  signal b2l_out : b2l_data_out_t := b2l_data_out_t_null;



  procedure reset (signal b2l_out_local : out b2l_data_out_t)is 
  begin 
    b2l_out_local <= b2l_data_out_t_null;
  end procedure;

  procedure send_data(signal b2l_out_local : out b2l_data_out_t; data_in : in std_logic_vector)is 
  begin 
    b2l_out_local.write_Enable <= '1';
    b2l_out_local.data <= data_in;

  end procedure;


  signal sig_resettx      : std_logic := '0';
  signal reg_trigen       : std_logic := '1';
  signal cnt_ackwait      : std_logic_vector (7  downto 0) := (others => '0');

  signal vercode          : std_logic_vector (31 downto 0) := x"00000000";


  constant token_write8 : std_logic_vector(15 downto 0) :=  x"ffff" ;
  constant token_read8 : std_logic_vector(15 downto 0) :=   x"fffe" ;
  constant token_stream_write  : std_logic_vector(15 downto 0) := x"fffd" ;
  constant token_write32 : std_logic_vector(15 downto 0) :=  x"fffc" ;
  constant token_read32 : std_logic_vector(15 downto 0) := x"fffb"  ;

  -- eeee is received when address is missing at HSLB
  -- for fee8 read
  constant token_end_of_frame : std_logic_vector(15 downto 0) := x"eeee"; 

  constant token_read8_timeOut : std_logic_vector(7 downto 0) :=  x"ff";
  constant token_read8_header  : std_logic_vector(7 downto 0) :=  x"07";




  signal buf_id : std_logic_vector (31 downto 0) := x"42324c20"; -- "B2L "



  type slv7_a is array (natural range <>) of std_logic_vector(6 downto 0);

  constant local_register_cnt_crcerr_reset : std_logic_vector(6 downto 0) := std_logic_vector(to_unsigned( 16#68#,    7)) ;
  constant local_register : std_logic_vector(6 downto 0) := std_logic_vector(to_unsigned( 16#69#,    7)) ;
  constant local_register_vercode_31_downto_24 : std_logic_vector(6 downto 0) := std_logic_vector(to_unsigned( 16#77#,    7)) ; 
  constant local_register_vercode_23_downto_16 : std_logic_vector(6 downto 0) := std_logic_vector(to_unsigned( 16#78#,    7)) ;  
  constant local_register_vercode_15_downto_8 : std_logic_vector(6 downto 0) := std_logic_vector(to_unsigned( 16#79#,    7)) ; 
  constant local_register_vercode_7_downto_0 : std_logic_vector(6 downto 0) := std_logic_vector(to_unsigned(  16#7a#,    7)) ; 

  constant write8_addr_veto : slv7_a(1 downto 0) :=(
    local_register_cnt_crcerr_reset,
    local_register
  );
  constant read8_local_Register : slv7_a(4 downto 0) :=(
    local_register_cnt_crcerr_reset, 
    local_register_vercode_31_downto_24,
    local_register_vercode_23_downto_16,
    local_register_vercode_15_downto_8,
    local_register_vercode_7_downto_0
  );
  function isInList(dataIn : std_logic_vector(6 downto 0) ; DataList : slv7_a) return boolean is
  begin 
    for i in 0 to DataList'length - 1 loop
      if dataIn = DataList(i) then 
        return True;
      end if;
    end loop;
    return False;
  end function;

  function get_version_code(dataIn : std_logic_vector(6 downto 0);cnt_crcerr_local : std_logic_vector; vercode_local : std_logic_vector ) return STD_LOGIC_VECTOR is
    variable ret: std_logic_vector(7 downto 0);
  begin 
    if dataIn = local_register_cnt_crcerr_reset then
      ret := cnt_crcerr_local;
    elsif dataIn = local_register_vercode_31_downto_24 then
      ret :=  vercode_local(31 downto 24);
    elsif dataIn = local_register_vercode_23_downto_16 then
      ret := vercode_local(23 downto 16);
    elsif dataIn = local_register_vercode_15_downto_8 then
      ret := vercode_local(15 downto 8);
    elsif dataIn = local_register_vercode_7_downto_0 then
      ret := vercode_local(7  downto 0);
    end if;

    return ret;
  end function;

  procedure handle_local_registers(reg8Local_addr8 : in STD_LOGIC_VECTOR; dataIn : in STD_LOGIC_VECTOR; signal clr_crcerr_local : out std_logic ; signal sig_resettx_local : out std_logic; signal reg_trigen_local : out std_logic) is 
  begin 

    -- intercept register decoding
    if reg8Local_addr8 = local_register_cnt_crcerr_reset then
      clr_crcerr_local <= '1';
    elsif reg8Local_addr8 = local_register then
      if dataIn(7 downto 0) = x"01" then
        sig_resettx_local <= '1';
      elsif dataIn(7 downto 0) = x"03" then
        reg_trigen_local <= '0';
      elsif dataIn(7 downto 0) = x"04" then
        reg_trigen_local <= '1';
      end if;
    end if;
  end procedure;



  function isTimedOut(counter : std_logic_vector) return boolean is
  begin 
    return (not counter) = 0;

  end function;

  procedure reset(signal data : out std_logic_vector) is 
  begin
    data <= (others => '0');
  end procedure;


  procedure do_read8_addr(
    rx           : inout axiStream_slv16_slave; 
    NextState    : inout alayer_pcs_t;  
    reg8         : inout register8Bit; 
    data_out8    : inout optional_slv8 ;
    signal cnt_ackwait  : out std_logic_vector (7  downto 0)

  ) is 
    variable rx_buffer : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    variable addr8   : STD_LOGIC_VECTOR(6 downto 0);
  begin
    reset(cnt_ackwait);
    if not isReceivingData_0(rx) then
      return;
    end if;

    read_data_00(rx, rx_buffer);

    if rx_buffer = token_end_of_frame then
      send_data(b2l_out, token_end_of_frame);
      NextState    := reset_state;
      return;
    end if;


    cnt_ackwait  <= cnt_ackwait + 1;
    send_data(b2l_out,  rx_buffer);
    addr8 := rx_buffer(6 downto 0);
    NextState    := read8_DATA;

    if isInList(addr8, read8_local_Register) then 
      return;
    end if;

    request_data(reg8, addr8 , data_out8);

  end procedure;


  procedure do_read8_DATA(
    rx: inout axiStream_slv16_slave; 
    NextState  : inout alayer_pcs_t; 
    reg8  : inout register8Bit := register8Bit_null; 
    data_out8 : inout optional_slv8 ;
    signal b2l_out : out b2l_data_out_t := b2l_data_out_t_null;
    signal cnt_ackwait  : inout std_logic_vector (7  downto 0);
    signal cnt_crcerr       : in std_logic_vector (7  downto 0);
    signal vercode          : in std_logic_vector (31 downto 0) 
  ) is begin
    cnt_ackwait  <= cnt_ackwait + 1;
    if isTimedOut(cnt_ackwait)  then
      send_data(b2l_out, token_read8_header & token_read8_timeOut);
      NextState    := reset_state;
      return;
    end if;

    NextState    := read8_addr;

    if isInList(reg8.addr8 , read8_local_Register)  then
      send_data(b2l_out, token_read8_header  & get_version_code(reg8.addr8, cnt_crcerr, vercode));
      return;
    end if;


    request_data_current_addr(reg8, data_out8); 
    if not isValid(data_out8) then 
      return;
    end if;

    send_data(b2l_out, token_read8_header &  data_out8.data);

  end procedure;

  procedure do_stream(
    rx: inout axiStream_slv16_slave; 
    NextState  : inout alayer_pcs_t; 
    reg8  : inout register8Bit := register8Bit_null; 
    signal cnt_watchdog  : out std_logic_vector
  ) is 

    variable rx_buffer : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
  begin 

    if not isReceivingData_0(rx) then 
      return;
    end if;

    read_data_00(rx, rx_buffer);

    if rx_buffer = token_end_of_frame then
      NextState    := reset_state;
      return;
    end if;

    if not  hasStreamHeader(rx_buffer) then
      return;
    end if;

    stream_data(reg8 ,rx_buffer);
    reset(cnt_watchdog);

  end procedure;


  procedure do_a16d32_write(
    rx : inout axiStream_slv16_slave := axiStream_slv16_slave_null ;   
    NextState      : inout alayer_pcs_t := reset_state; 
    signal i_reg32_m2s  :  inout register32Bit_m2s;
    signal i_reg32_s2m  : in register32Bit_s2m
  ) is 
    variable rx_buffer : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
  begin
    if not isReceivingData_0(rx)  then
      return;
    end if;

    read_data_00(rx, rx_buffer);




    if rx_buffer /= token_end_of_frame then
      cnt_d32  <= cnt_d32 + 1;
      i_reg32_m2s.addr32 <= i_reg32_m2s.addr32(7  downto 0) & i_reg32_m2s.data32o(31 downto 24);
      
      i_reg32_m2s.data32o <= i_reg32_m2s.data32o(23 downto 0) & rx_buffer(7 downto 0);
      return;
    end if;

   i_reg32_m2s.wr32     <= '1';
    -- intercept first 16 addresses
    if cnt_d32 /= 6 then
      -- not valid address/data
    elsif i_reg32_m2s.addr32 = 0 then
      -- 32-bit address 0 is to test read/write
      buf_id     <= i_reg32_m2s.data32o;
    elsif i_reg32_m2s.addr32 = 8 then
      regsimsbe  <= i_reg32_m2s.data32o(0);
      regsimmbe  <= i_reg32_m2s.data32o(4);
      regsemrst  <= i_reg32_m2s.data32o(8);
      regsimaddr(39 downto 32) <= i_reg32_m2s.data32o(31 downto 24);
    elsif i_reg32_m2s.addr32 = 9 then
      regsimaddr(31 downto 0) <= i_reg32_m2s.data32o;
    elsif i_reg32_m2s.addr32(15 downto 4) /= 0 then
     i_reg32_m2s.en32   <= '1';
    end if;
   i_reg32_m2s.addr32       <= i_reg32_m2s.addr32;
   i_reg32_m2s.data32o      <= i_reg32_m2s.data32o;

    NextState    := reset_state;


  end procedure;
begin

  b2ttclk<= clk;


  inputFIFO : entity work.axiFifo  port map (
    clk => b2ttclk,


    Axi_in_s2m => Axi_in_s2m,
    Axi_in_m2s => Axi_in_m2s,


    Axi_out_s2m => Axi_out_s2m,
    Axi_out_m2s => Axi_out_m2s 
  );




  alayer_pcs : process (b2ttclk)--bmk
    variable NextState      : alayer_pcs_t := reset_state;
  variable CurrentState   : alayer_pcs_t := reset_state;
  variable reg8     : register8Bit := register8Bit_null;
  variable rx : axiStream_slv16_slave := axiStream_slv16_slave_null;
  variable rx_buffer : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
  variable addr8 : STD_LOGIC_VECTOR(6 downto 0) := (others => '0');
  variable data_out8 :  optional_slv8 := optional_slv8_null;
begin
  if rising_edge(b2ttclk) then
    pull(reg8 , reg8_s2m_local);
    pull(rx, Axi_out_m2s);
    reset(b2l_out);


    CurrentState := NextState;
    parastate <= CurrentState;
    sig_resettx <= '0';


    -- main state machine
    if sig_linklost = '1' then
      NextState  := reset_state;
      CurrentState := reset_state
     i_reg32_m2s.en32   <= '0';
    end if;


    case CurrentState is
      when reset_state =>
        -- reset state, no point of waiting here
        reset(cnt_watchdog);
        reset(cnt_ackwait);

        reg8.addr8 := (others => '0');


       i_reg32_m2s.en32     <= '0';

       i_reg32_m2s.wr32     <= '0';

        i_reg32_m2s.rd32     <= '0';


        i_reg32_m2s.addr32      <= (others => '0');

        cnt_d32      <= (others => '0');
        buf_dead     <= x"DEAD";

        regsimsbe    <= '0';
        regsimmbe    <= '0';
        regsemrst    <= '0';


        NextState    := select_operation;

      when select_operation => -- choose write/read/file (waiting for action)
        clr_crcerr <= '0';
        if isReceivingData_0(rx) then
          read_data_00(rx, rx_buffer);
          -- go to the next state only when the next data is ready

          if  rx_buffer = token_write8  then -- write (state 2,3,4)
            set2write(reg8);
            NextState    := write8_start;
          elsif rx_buffer =token_read8 then -- read (state 5,6,7)

            send_data(b2l_out, token_write8);
            NextState    := read8_start;
          elsif rx_buffer = token_stream_write then -- stream write (state 10)

            set2write(reg8);
            NextState    := stream;
          elsif rx_buffer = token_write32 then -- a16d32 write (state 8)
           i_reg32_m2s.wr32     <= '1';
            NextState    := a16d32_write;
          elsif rx_buffer= token_read32 then -- a16d32 read (state 9)
           i_reg32_m2s.wr32     <= '0';
            NextState    := read32;
          else
            -- no action, just skip junks
          end if;
        end if;


        ---------------------------------------------------------------------------------
      when write8_start => -- write start (first data is ignored)
        set2write(reg8);
        if isReceivingData_0(rx) then -- else stay at write8_start
          read_data_00(rx, rx_buffer);
          NextState    := write8_addr;
        end if;

      when write8_addr =>
        set2write(reg8);
        if isReceivingData_0(rx) then 
          read_data_00(rx, rx_buffer);
          if  rx_buffer /= token_end_of_frame then
            set_addr(reg8, rx_buffer);
            NextState    := write8_data;
          else 
            NextState    := reset_state;
          end if;

        end if;

      when write8_data => 
        set2write(reg8);
        if isReceivingData_0(rx) then
          read_data_00(rx, rx_buffer);
          set_data(reg8, rx_buffer);

          -- intercept register decoding
          handle_local_registers(reg8.addr8,rx_buffer, clr_crcerr,sig_resettx,reg_trigen);

          if not isInList(reg8.addr8,write8_addr_veto) then 
            send_data(reg8);
          end if;

          NextState    := write8_addr;
        end if;






        --------------------------------------------------------------------------------
      when read8_start => -- read start (first data (feetype) is ignored)

        if isReceivingData_0(rx) then
          read_data_00(rx, rx_buffer);
          send_data(b2l_out, rx_buffer);
          NextState    := read8_addr;
        end if;

      when read8_addr => -- read loop between 6(Addr) and 7(Data?)

        do_read8_addr(
          rx => rx, 
          NextState => NextState, 
          reg8 => reg8, 
          data_out8 => data_out8,
          cnt_ackwait => cnt_ackwait

        );


      when read8_DATA =>
        do_read8_DATA(
          rx => rx, 
          NextState => NextState, 
          reg8 => reg8, 
          data_out8 => data_out8,
          cnt_ackwait => cnt_ackwait,
          cnt_crcerr => cnt_crcerr ,
          vercode    => vercode   
        );


      when a16d32_write => 
        -- This sequence should receive 6 words and eeee at the end

        if isReceivingData_0(rx)  then
          read_data_00(rx, rx_buffer);
        end if;


        if not isReceivingData_0(rx)  then

          -- stay at write32 until next data

        elsif rx_buffer = token_end_of_frame then
         i_reg32_m2s.wr32     <= '1';
          -- intercept first 16 addresses
          if cnt_d32 /= 6 then
            -- not valid address/data
          elsif i_reg32_m2s.addr32 = 0 then
            -- 32-bit address 0 is to test read/write
            buf_id     <= i_reg32_m2s.data32o;
          elsif i_reg32_m2s.addr32 = 8 then
            regsimsbe  <= i_reg32_m2s.data32o(0);
            regsimmbe  <= i_reg32_m2s.data32o(4);
            regsemrst  <= i_reg32_m2s.data32o(8);
            regsimaddr(39 downto 32) <= i_reg32_m2s.data32o(31 downto 24);
          elsif i_reg32_m2s.addr32 = 9 then
            regsimaddr(31 downto 0) <= i_reg32_m2s.data32o;
          elsif i_reg32_m2s.addr32(15 downto 4) /= 0 then
           i_reg32_m2s.en32   <= '1';
          end if;
         i_reg32_m2s.addr32       <= i_reg32_m2s.addr32;
         i_reg32_m2s.data32o      <= i_reg32_m2s.data32o;

          NextState    := reset_state;

        else
          cnt_d32  <= cnt_d32 + 1;
          i_reg32_m2s.addr32 <= i_reg32_m2s.addr32(7  downto 0) & i_reg32_m2s.data32o(31 downto 24);
          i_reg32_m2s.data32o <= i_reg32_m2s.data32o(23 downto 0) & rx_buffer(7 downto 0);
        end if;

      when read32 => -- a16d32 read
        if isReceivingData_0(rx) then 
          read_data_00(rx, rx_buffer);

        end if;
        if (not cnt_watchdog) = 0 then
          NextState := reset_state;

          send_data(b2l_out, token_end_of_frame);

        elsif cnt_d32 < 3 then -- read address from fifo_out.data

          if not isReceivingData_0(rx) then
            -- stay at read32 and same cnt_d32
          elsif rx_buffer = token_end_of_frame or cnt_d32 = 2 then
           i_reg32_m2s.wr32   <= '0';
            if rx_buffer /= token_end_of_frame then
              i_reg32_m2s.addr32  <= x"000f"; -- error, to return x"DEAFxxxx"
            elsif cnt_d32 /= 2 then
              i_reg32_m2s.addr32  <= x"000d"; -- error, to return x"DEADxxxx"
            elsif i_reg32_m2s.addr32(15 downto 4) /= 0 then
              i_reg32_m2s.rd32     <= '1';

             i_reg32_m2s.addr32       <= i_reg32_m2s.addr32;
            end if;
            cnt_d32    <= "0011"; -- 3
          else
            buf_dead   <= rx_buffer;
            cnt_d32    <= cnt_d32 + 1;
            i_reg32_m2s.addr32    <= i_reg32_m2s.addr32(7 downto 0) & rx_buffer(7 downto 0);
          end if;

        elsif cnt_d32 = 3 then
          if i_reg32_m2s.rd32 = '0' or (not cnt_ackwait) = 0 or ack = '1' then
            send_data(b2l_out, token_write8);

            i_reg32_m2s.rd32   <= '0';
            cnt_d32    <= cnt_d32 + 1;
          else
            cnt_ackwait <= cnt_ackwait + 1;
          end if;

        elsif cnt_d32 = 4 then
          -- starting tx fifo filling here will not make a time gap
          -- in b2l_transmitter state machine

          cnt_d32 <= cnt_d32 + 1;
          -- intercept first 16 addresses
          if (not cnt_ackwait) = 0 then
            i_reg32_m2s.data32o <= x"a16d32ff"; -- timeout
          elsif i_reg32_m2s.addr32 = 0 then
            -- 32-bit address 0 is to test read/write
            -- default is ascii code "42324c20" = "B2L "
            i_reg32_m2s.data32o <= buf_id;
          elsif i_reg32_m2s.addr32 = 1 then
            i_reg32_m2s.data32o <= b2ttversion &
              std_logic_vector(to_unsigned(B2LVERSION, 16));
          elsif i_reg32_m2s.addr32 = 2 then
            i_reg32_m2s.data32o <= std_logic_vector(to_unsigned(DATE, 32));
          elsif i_reg32_m2s.addr32 = 3 then
            i_reg32_m2s.data32o <= trgtag;
          elsif i_reg32_m2s.addr32 = 4 then
            i_reg32_m2s.data32o(31 downto 25) <= (others => '0');
            i_reg32_m2s.data32o(24 downto 20) <= sig_ilatx(4  downto  0); -- txstate
            i_reg32_m2s.data32o(19 downto 16) <= sig_ilatx(95 downto 92); -- b2lstate
            i_reg32_m2s.data32o(15 downto 12) <= (others => '0');
            i_reg32_m2s.data32o(11 downto  8) <= rxstate;
            i_reg32_m2s.data32o(7  downto  5) <= (others => '0');
            i_reg32_m2s.data32o(4) <= sig_resettx;
            i_reg32_m2s.data32o(3) <= sig_linklost;
            i_reg32_m2s.data32o(2) <= reg_trigen;
            i_reg32_m2s.data32o(1) <= b2ttup;
            i_reg32_m2s.data32o(0) <= b2clkup;
          elsif i_reg32_m2s.addr32 = 5 then
            i_reg32_m2s.data32o  <= neventout;
          elsif i_reg32_m2s.addr32 = 6 then
            i_reg32_m2s.data32o  <= nwordout;
          elsif i_reg32_m2s.addr32 = 8 then
            i_reg32_m2s.data32o(31 downto 16) <= cntsemdet;
            i_reg32_m2s.data32o(15 downto 0)  <= cntsemscan;

          elsif i_reg32_m2s.addr32 = 9 then
            i_reg32_m2s.data32o(31 downto 16) <= cntsemsim;
            i_reg32_m2s.data32o(15 downto 0)  <= cntsemack;

          elsif i_reg32_m2s.addr32 = 10 then
            i_reg32_m2s.data32o(31 downto 16) <= cntsembusy;
            i_reg32_m2s.data32o(15 downto 8)  <= x"00";
            i_reg32_m2s.data32o(7  downto 4)  <= "0" & semcrc & semmbe & semsbe;
            i_reg32_m2s.data32o(3  downto 0)  <= "0" & semess & sembusy & semactiv;

          elsif i_reg32_m2s.addr32(15 downto 4) /= 0 then
            i_reg32_m2s.data32o   <=  reg32_s2m.data32i;
            reg32_m2s.en32 <= '1';
          else
            i_reg32_m2s.data32o <= x"DEA" & i_reg32_m2s.addr32(3 downto 0) & buf_dead;
          end if;

        elsif cnt_d32 < 9 then -- 5,6,7,8 to send 4 bytes
          cnt_d32 <= cnt_d32 + 1;
         i_reg32_m2s.en32   <= '0';
          send_data(b2l_out, x"1" & (10 - cnt_d32) & i_reg32_m2s.data32o(31 downto 24) );
          -- (10 - cnt_d32) to be compatible with belle2link 0.12 and
          -- hslb_feecontrol of hslb0.52: 5,6,7,8 => 5,4,3,2

          i_reg32_m2s.data32o <= i_reg32_m2s.data32o(23 downto 0) & x"00";

        elsif cnt_d32 = 9 then
          send_data(b2l_out, token_end_of_frame);

          NextState    := reset_state;

        end if;

      when stream => 

        do_stream(rx, NextState, reg8,cnt_watchdog);

      when others => 
        NextState := reset_state;
    end case;



  end if; -- resetreg8

  cnt_watchdog <= cnt_watchdog + 1;

  if isTimedOut(cnt_watchdog) then
    if CurrentState = write8_start or CurrentState = write8_addr or  CurrentState = write8_data then
      NextState := reset_state;


    elsif CurrentState = read8_start or CurrentState = read8_addr or  CurrentState = read8_DATA then
      NextState    := reset_state;
      send_data(b2l_out, token_end_of_frame);

    elsif CurrentState = stream then
      NextState := reset_state;

    elsif CurrentState = a16d32_write then 
      NextState := reset_state;
    end if;




    push(reg8 , reg8_m2s);
    push(rx, Axi_out_s2m);
  end if; -- rising_edge
end process;


reg8_s2m_local.data8i <= reg8_s2m.data8i;
reg8_s2m_local.ack <= ack;
-- out
linklost   <= sig_linklost or sig_resettx;
trigen     <= reg_trigen;
parawe     <= b2l_out.write_Enable;
paradata   <= b2l_out.data;




reg32_m2s <= i_reg32_m2s;
i_reg32_s2m <= reg32_s2m;




end implementation;