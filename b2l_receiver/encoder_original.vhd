library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
library IEEE;
library UNISIM;
library work;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use UNISIM.VComponents.all;
use ieee.std_logic_unsigned.all;
library work;
--use work.b2l_defs.all;

entity b2l_encoder_original is
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
    en8                  : out std_logic;
    wr8                  : out std_logic;
    rd8                  : out std_logic;
    data8i               : in  std_logic_vector (7  downto 0);
    data8o               : out std_logic_vector (7  downto 0);
    addr8                : out std_logic_vector (6  downto 0);
    -- from/to register I/O (A16D32 version)
    en32                 : out std_logic;
    wr32                 : out std_logic;
    rd32                 : out std_logic;
    data32i              : in  std_logic_vector (31 downto 0);
    data32o              : out std_logic_vector (31 downto 0);
    addr32               : out std_logic_vector (15 downto 0);
    -- from register I/O (common)
    ack                  : in  std_logic;
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
    sig_ila              : out std_logic_vector (95 downto 0);
    
    
    data_in_wr           : in  std_logic := '0';
    data_in_data         : in   std_logic_vector (15 downto 0) := (others => '0')
    
    
    );

end b2l_encoder_original;

architecture implementation of b2l_encoder_original is


    signal b2ttclk              :   std_logic;

    signal cnt_crcerr       : std_logic_vector (7  downto 0) := (others => '0');
    signal clr_crcerr       : std_logic := '0';




    signal sig_pararden     : std_logic := '0';
    signal DataParaOut      : std_logic_vector (15 downto 0) := (others => '0');
    signal sig_paravalid    : std_logic := '0';
    signal ParaFifoEmpty    : std_logic := '0';

    signal sta_pararden     : std_logic := '0';
    signal cnt_d8           : std_logic_vector (1 downto 0) := "00";
  
    signal rxstate          : std_logic_vector (3  downto 0) := (others => '0');
  
    -- watchdog (about 33.5 second)
    signal cnt_watchdog     : std_logic_vector (31 downto 0) := (others => '0');
    
    -- A16D32 support
    signal buf_a32          : std_logic_vector (15 downto 0) := (others => '0');
    signal buf_d32          : std_logic_vector (31 downto 0) := (others => '0');
    signal cnt_d32          : std_logic_vector (3  downto 0) := (others => '0');
    signal buf_dead         : std_logic_vector (15 downto 0) := (others => '0');
    signal parastate        : std_logic_vector (3  downto 0) := (others => '0');
    signal sig_en32         : std_logic := '0';
    signal sig_wr32         : std_logic := '0';
    signal sig_rd32         : std_logic := '0';
    signal buf_d8           : std_logic_vector (7  downto 0) := (others => '0');
    signal buf_a8           : std_logic_vector (6  downto 0) := (others => '0');
    signal sig_en8          : std_logic := '0';
    signal sig_wr8          : std_logic := '0';
    signal sig_rd8          : std_logic := '0';
    signal sig_parawe       : std_logic := '0';
    signal sig_paradata     : std_logic_vector (15 downto 0) := x"0000";
    signal sig_linklost     : std_logic := '0';
    signal sig_resettx      : std_logic := '0';
    signal reg_trigen       : std_logic := '1';
    signal cnt_ackwait      : std_logic_vector (7  downto 0) := (others => '0');
  
    signal vercode          : std_logic_vector (31 downto 0) := x"00000000";
    
  
    
    constant ZERO           : std_logic_vector (3  downto 0) := "0000";
    constant ONE            : std_logic_vector (3  downto 0) := "0001";
    constant TWO            : std_logic_vector (3  downto 0) := "0010";
    constant THREE          : std_logic_vector (3  downto 0) := "0011";
    constant FOUR           : std_logic_vector (3  downto 0) := "0100";
    constant FIVE           : std_logic_vector (3  downto 0) := "0101";
    constant SIX            : std_logic_vector (3  downto 0) := "0110";
    constant SEVEN          : std_logic_vector (3  downto 0) := "0111";
    constant EIGHT          : std_logic_vector (3  downto 0) := "1000";
    constant NINE           : std_logic_vector (3  downto 0) := "1001";
    constant TEN            : std_logic_vector (3  downto 0) := "1010";
  


	signal sig_NextState      : std_logic_vector (3 downto 0) := ZERO;
	signal sig_CurrentState   : std_logic_vector (3 downto 0) := ZERO;
    signal buf_id : std_logic_vector (31 downto 0) := x"42324c20"; -- "B2L "
begin



    inputFIFO : entity work.fifo_cc 
        generic map (
           DATA_WIDTH => 16,
           DEPTH => 10
        ) port map (
           clk   => clk, 
           rst   => '0',
           din  => data_in_data,
           wen   => data_in_wr,
           ren   => sig_pararden,
           dout  => DataParaOut,
           full  => open,
           empty => ParaFifoEmpty
    );
       
        
    b2ttclk<= clk;
    sig_pararden  <= sta_pararden and (not ParaFifoEmpty); -- async
    sig_paravalid <= (not ParaFifoEmpty); -- async

  alayer_pcs : process (b2ttclk)--bmk
    variable NextState      : std_logic_vector (3 downto 0) := ZERO;
    variable CurrentState   : std_logic_vector (3 downto 0) := ZERO;
  begin
    if rising_edge(b2ttclk) then

      CurrentState := NextState;
      parastate <= CurrentState;
		
		sig_CurrentState <= CurrentState;
		sig_NextState <= NextState;
      -- intercept register write
      if CurrentState = FOUR then
        if buf_a8 = 16#68# then
          clr_crcerr <= '1';
        elsif buf_a8 = 16#69# then
          if DataParaOut(7 downto 0) = x"01" then
            sig_resettx <= '1';
          elsif DataParaOut(7 downto 0) = x"03" then
            reg_trigen <= '0';
          elsif DataParaOut(7 downto 0) = x"04" then
            reg_trigen <= '1';
          end if;
        end if;
      elsif CurrentState = ONE then
        clr_crcerr <= '0';
      else
        sig_resettx <= '0';
      end if;
              
      -- main state machine
      if sig_linklost = '1' then
        NextState  := ZERO;
        sig_parawe <= '0';
        sig_en8    <= '0';
        sig_en32   <= '0';
        sta_pararden <= '0';
      else
        -- watchdog timer
        case CurrentState is
          when ZERO =>
            cnt_watchdog <= (others => '0');
          when TEN =>
            if sig_en8 = '1' then
              cnt_watchdog <= (others => '0');
            else
              cnt_watchdog <= cnt_watchdog + 1;
            end if;
          when others =>
            cnt_watchdog <= cnt_watchdog + 1;
        end case;
        
        case CurrentState is
          when ZERO =>
            -- reset state, no point of waiting here
            sig_parawe   <= '0';
            sig_en8      <= '0';
            sig_en32     <= '0';
            sig_wr8      <= '0';
            sig_wr32     <= '0';
            sig_rd8      <= '0';
            sig_rd32     <= '0';
            buf_a8       <= (others => '0');
            buf_a32      <= (others => '0');
            cnt_d8       <= (others => '0');
            cnt_d32      <= (others => '0');
            cnt_ackwait  <= (others => '0');
            buf_dead     <= x"DEAD";
            NextState    := ONE;
            sta_pararden <= '1';
            regsimsbe    <= '0';
            regsimmbe    <= '0';
            regsemrst    <= '0';
            
          when ONE => -- choose write/read/file (waiting for action)
            if sig_paravalid = '1' then
              -- go to the next state only when the next data is ready
              
              if DataParaOut = x"ffff" then -- write (state 2,3,4)
                sig_wr8      <= '1';
                NextState    := TWO;
              elsif DataParaOut = x"fffe" then -- read (state 5,6,7)
                sig_wr8      <= '0';
                --
                -- [20160222 nakao]
                -- starting write to b2l_transmitter fifo here is not
                -- a good idea since there could be an unpredictable
                -- timing gap while processing this state machine
                -- around state SIX and SEVEN....better to be revised.
                --
                sig_parawe   <= '1';
                sig_paradata <= x"ffff";
                NextState    := FIVE;
              elsif DataParaOut = x"fffd" then -- stream write (state 10)
                buf_a8       <= (others => '0');
                sig_wr8      <= '1';
                NextState    := TEN;
              elsif DataParaOut = x"fffc" then -- a16d32 write (state 8)
                sig_wr32     <= '1';
                NextState    := EIGHT;
              elsif DataParaOut = x"fffb" then -- a16d32 read (state 9)
                sig_wr32     <= '0';
                NextState    := NINE;
              else
                -- no action, just skip junks
              end if;
            end if;
            
          when TWO => -- write start (first data is ignored)
            if (not cnt_watchdog) = 0 then
              NextState := ZERO;
              sta_pararden <= '0';
            elsif sig_paravalid = '1' then -- else stay at TWO
              sig_wr8      <= '1';
              NextState    := THREE;
            end if;
            
          when THREE => -- write loop between 3(Addr) and 4(DATAo)
            sig_en8        <= '0';
            if (not cnt_watchdog) = 0 then
              NextState := ZERO;
              sta_pararden <= '0';
            elsif sig_paravalid = '0' then
              -- stay at THREE until next data comes in
            elsif DataParaOut = x"eeee" then
              sta_pararden <= '0';
              buf_d8       <= (others => '0');
              NextState    := ZERO;
            else
              buf_a8       <= DataParaOut(6 downto 0);
              NextState    := FOUR;
            end if;
            
          when FOUR => -- write loop between 3(Addr) and 4(DATAo)
            if (not cnt_watchdog) = 0 then
              NextState    := ZERO;
              sta_pararden <= '0';
            elsif sig_paravalid = '0' then
              -- stay at FOUR until next data comes in
            else
              buf_d8       <= DataParaOut(7 downto 0);
              -- intercept register decoding
              if buf_a8 /= 16#68# and buf_a8 /= 16#69# then
                sig_en8    <= '1';
              end if;
              NextState    := THREE;
            end if;
            
          when FIVE => -- read start (first data (feetype) is ignored)
            sig_wr8        <= '0';
            cnt_ackwait    <= (others => '0');
            
            if (not cnt_watchdog) = 0 then
              NextState    := ZERO;
              sig_parawe   <= '1';
              sig_paradata <= x"eeee";
            elsif sig_paravalid = '0' then
              -- stay at FIVE until next data comes in
              sig_parawe   <= '0';
            else
              sig_parawe   <= '1'; -- (but not really needed to send it back)
              sig_paradata <= DataParaOut;
              NextState    := SIX;
            end if;
            
          when SIX => -- read loop between 6(Addr) and 7(Data?)
            
            sig_wr8        <= '0';
            sig_en8        <= '0';
            
            if (not cnt_watchdog) = 0 then
              NextState    := ZERO;
              sta_pararden <= '0';
              sig_parawe   <= '1';
              sig_paradata <= x"eeee";

            elsif cnt_ackwait = 1 then
              if buf_a8 /= 16#68# and (buf_a8 < 16#77# or buf_a8 > 16#7a#) then
                sig_rd8 <= '1';
              end if;
                
              sta_pararden <= '0';
              sig_parawe   <= '0';
              cnt_ackwait <= cnt_ackwait + 1;

            elsif cnt_ackwait /= 0 then
              if sig_rd8 = '0' or (not cnt_ackwait) = 0 or ack = '1' then
                cnt_d8       <= "00";
                sig_rd8      <= '0';
                sta_pararden <= '1'; -- resume after two clocks
                NextState    := SEVEN;
              else
                cnt_ackwait <= cnt_ackwait + 1;
              end if;
              
            elsif sig_paravalid = '0' then
              sig_parawe   <= '0'; -- stay at SIX until next data comes in

            elsif DataParaOut = x"eeee" then
              -- eeee is received when address is missing at HSLB
              -- for fee8 read
              sig_parawe   <= '1';
              sig_paradata <= x"eeee";
              buf_d8       <= (others => '0');
              NextState    := ZERO;
              
            else
              buf_a8       <= DataParaOut(6 downto 0);
              cnt_ackwait  <= cnt_ackwait + 1;
              sig_parawe   <= '1';
              sig_paradata <= DataParaOut;
              sta_pararden <= '0'; -- suspend for two clocks
              
            end if;
            
          when SEVEN =>
            -- DataParaOut is dummy placeholder for a7d8 read
            sig_wr8        <= '0';
            cnt_ackwait    <= (others => '0');
            if (not cnt_watchdog) = 0 then
              NextState    := ZERO;
              sta_pararden <= '0';
              sig_parawe   <= '1';
              sig_paradata <= x"eeee";
            elsif sig_paravalid = '1' then -- else stay at SEVEN
              NextState    := SIX;
              
              sig_parawe   <= '1';
              sig_paradata(15 downto 8) <= x"07";
              
              -- copy data8i, except for a few addresses (68 and 77-7a)
              -- for which register decoding is intercepted
              if (not cnt_ackwait) = 0 then
                sig_paradata(7 downto 0) <= x"ff";
              elsif buf_a8 = 16#68# then
                sig_paradata(7 downto 0) <= cnt_crcerr;
              elsif buf_a8 = 16#77# then
                sig_paradata(7 downto 0) <= vercode(31 downto 24);
              elsif buf_a8 = 16#78# then
                sig_paradata(7 downto 0) <= vercode(23 downto 16);
              elsif buf_a8 = 16#79# then
                sig_paradata(7 downto 0) <= vercode(15 downto 8);
              elsif buf_a8 = 16#7a# then
                sig_paradata(7 downto 0) <= vercode(7  downto 0);
              else
                sig_en8 <= '1';
                sig_paradata(7 downto 0) <= data8i;
              end if;
              
            end if;
            
          when EIGHT => -- a16d32 write
            -- This sequence should receive 6 words and eeee at the end
            if (not cnt_watchdog) = 0 then
              NextState    := ZERO;
              sta_pararden <= '0';
              sig_parawe   <= '0';

            elsif sig_paravalid = '0' then
              sig_parawe   <= '0';
              -- stay at EIGHT until next data
              
            elsif DataParaOut = x"eeee" then
              sig_wr32     <= '1';
              -- intercept first 16 addresses
              if cnt_d32 /= 6 then
                -- not valid address/data
              elsif buf_a32 = 0 then
                -- 32-bit address 0 is to test read/write
                buf_id     <= buf_d32;
              elsif buf_a32 = 8 then
                regsimsbe  <= buf_d32(0);
                regsimmbe  <= buf_d32(4);
                regsemrst  <= buf_d32(8);
                regsimaddr(39 downto 32) <= buf_d32(31 downto 24);
              elsif buf_a32 = 9 then
                regsimaddr(31 downto 0) <= buf_d32;
              elsif buf_a32(15 downto 4) /= 0 then
                sig_en32   <= '1';
              end if;
              addr32       <= buf_a32;
              data32o      <= buf_d32;
              sta_pararden <= '0';
              NextState    := ZERO;

            else
              cnt_d32  <= cnt_d32 + 1;
              buf_a32 <= buf_a32(7  downto 0) & buf_d32(31 downto 24);
              buf_d32 <= buf_d32(23 downto 0) & DataParaOut(7 downto 0);
            end if;
            
          when NINE => -- a16d32 read
            if (not cnt_watchdog) = 0 then
              NextState := ZERO;
              sta_pararden <= '0';
              sig_parawe   <= '1';
              sig_paradata <= x"eeee";

            elsif cnt_d32 < 3 then -- read address from DataParaOut

              if sig_paravalid = '0' then
                -- stay at NINE and same cnt_d32
              elsif DataParaOut = x"eeee" or cnt_d32 = 2 then
                sig_wr32   <= '0';
                if DataParaOut /= x"eeee" then
                  buf_a32  <= x"000f"; -- error, to return x"DEAFxxxx"
                elsif cnt_d32 /= 2 then
                  buf_a32  <= x"000d"; -- error, to return x"DEADxxxx"
                elsif buf_a32(15 downto 4) /= 0 then
                  sig_rd32     <= '1';
                  addr32       <= buf_a32;
                end if;
                cnt_d32    <= "0011"; -- 3
              else
                buf_dead   <= DataParaOut;
                cnt_d32    <= cnt_d32 + 1;
                buf_a32    <= buf_a32(7 downto 0) & DataParaOut(7 downto 0);
              end if;
                
            elsif cnt_d32 = 3 then
              if sig_rd32 = '0' or (not cnt_ackwait) = 0 or ack = '1' then
                sig_parawe   <= '1';
                sig_paradata <= x"ffff";
                sig_rd32   <= '0';
                cnt_d32    <= cnt_d32 + 1;
              else
                cnt_ackwait <= cnt_ackwait + 1;
              end if;
              
            elsif cnt_d32 = 4 then
              -- starting tx fifo filling here will not make a time gap
              -- in b2l_transmitter state machine
              sta_pararden <= '0'; -- suspend fifo read
              cnt_d32 <= cnt_d32 + 1;
              -- intercept first 16 addresses
              if (not cnt_ackwait) = 0 then
                buf_d32 <= x"a16d32ff"; -- timeout
              elsif buf_a32 = 0 then
                -- 32-bit address 0 is to test read/write
                -- default is ascii code "42324c20" = "B2L "
                buf_d32 <= buf_id;
              elsif buf_a32 = 1 then
                buf_d32 <= b2ttversion &
                           std_logic_vector(to_unsigned(B2LVERSION, 16));
              elsif buf_a32 = 2 then
                buf_d32 <= std_logic_vector(to_unsigned(DATE, 32));
              elsif buf_a32 = 3 then
                buf_d32 <= trgtag;
              elsif buf_a32 = 4 then
                buf_d32(31 downto 25) <= (others => '0');
                buf_d32(24 downto 20) <= sig_ilatx(4  downto  0); -- txstate
                buf_d32(19 downto 16) <= sig_ilatx(95 downto 92); -- b2lstate
                buf_d32(15 downto 12) <= (others => '0');
                buf_d32(11 downto  8) <= rxstate;
                buf_d32(7  downto  5) <= (others => '0');
                buf_d32(4) <= sig_resettx;
                buf_d32(3) <= sig_linklost;
                buf_d32(2) <= reg_trigen;
                buf_d32(1) <= b2ttup;
                buf_d32(0) <= b2clkup;
              elsif buf_a32 = 5 then
                buf_d32  <= neventout;
              elsif buf_a32 = 6 then
                buf_d32  <= nwordout;
              elsif buf_a32 = 8 then
                buf_d32(31 downto 16) <= cntsemdet;
                buf_d32(15 downto 0)  <= cntsemscan;

              elsif buf_a32 = 9 then
                buf_d32(31 downto 16) <= cntsemsim;
                buf_d32(15 downto 0)  <= cntsemack;

              elsif buf_a32 = 10 then
                buf_d32(31 downto 16) <= cntsembusy;
                buf_d32(15 downto 8)  <= x"00";
                buf_d32(7  downto 4)  <= "0" & semcrc & semmbe & semsbe;
                buf_d32(3  downto 0)  <= "0" & semess & sembusy & semactiv;
                
              elsif buf_a32(15 downto 4) /= 0 then
                buf_d32  <= DATA32i;
                sig_en32 <= '1';
              else
                buf_d32 <= x"DEA" & buf_a32(3 downto 0) & buf_dead;
              end if;

            elsif cnt_d32 < 9 then -- 5,6,7,8 to send 4 bytes
              cnt_d32 <= cnt_d32 + 1;
              sig_en32   <= '0';
              sig_parawe <= '1';
              sig_paradata(15 downto 12) <= x"1";
              -- (10 - cnt_d32) to be compatible with belle2link 0.12 and
              -- hslb_feecontrol of hslb0.52: 5,6,7,8 => 5,4,3,2
              sig_paradata(11 downto  8) <= 10 - cnt_d32;
              sig_paradata(7  downto  0) <= buf_d32(31 downto 24);
              buf_d32 <= buf_d32(23 downto 0) & x"00";
              
            elsif cnt_d32 = 9 then
              sig_paradata <= x"eeee";
              NextState    := ZERO;
              
            end if;
            
          when others => -- TEN
            
            if (not cnt_watchdog) = 0 then
              NextState := ZERO;
              sta_pararden <= '0';
              sig_parawe   <= '0';

            elsif DataParaOut = x"eeee" then
              sig_en8      <= '0';
              buf_d8       <= (others => '0');
              NextState    := ZERO;
            elsif sig_paravalid = '0' then
              sig_en8      <= '0';
              buf_d8       <= (others => '0');
            else
              if DataParaOut(15 downto 8) = x"70" then
                buf_d8       <= DataParaOut(7 downto 0);
                sig_en8      <= '1';
              end if;
            end if;
        end case;
      end if; -- reset
      
    end if; -- rising_edge
  end process;

  -- out
  linklost   <= sig_linklost or sig_resettx;
  trigen     <= reg_trigen;
  parawe     <= sig_parawe;
  paradata   <= sig_paradata;
  addr8      <= buf_a8;
  data8o     <= buf_d8;
  en32       <= sig_en32;
  wr32       <= sig_wr32;
  rd32       <= sig_rd32;
  en8        <= sig_en8;
  wr8        <= sig_wr8;
  rd8        <= sig_rd8;



end implementation;