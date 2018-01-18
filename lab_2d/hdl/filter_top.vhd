library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use work.filter_pkg.all;
use work.booth_mult_pkg.all;

entity filter_top is 
    port ( 
        A     : in std_logic_vector((FILTER_NT)*(FILTER_NB)-1 downto 0);
        B     : in std_logic_vector((FILTER_NT+1)*(FILTER_NB)-1 downto 0);
        DIN0   : in std_logic_vector(FILTER_NB-1 downto 0);
        DIN1   : in std_logic_vector(FILTER_NB-1 downto 0);
        DIN2   : in std_logic_vector(FILTER_NB-1 downto 0);
        VIN   : in std_logic;
        RST_n : in std_logic;
        CLK   : in std_logic;
        DOUT0   : out std_logic_vector(FILTER_NB-1 downto 0);
        DOUT1   : out std_logic_vector(FILTER_NB-1 downto 0);
        DOUT2   : out std_logic_vector(FILTER_NB-1 downto 0);
        VOUT  : out std_logic);
end filter_top; 

architecture behavioral of filter_top is

    type t_wire is array (0 to FILTER_NT) of std_logic;
    type t_temp is array (0 to FILTER_NU-1) of std_logic_vector(2*FILTER_NB-1 downto 0);
    type t_bus_arr is array(0 to FILTER_NT) of t_bus(0 to FILTER_NU-1);

    signal in_ff : t_bus(0 to FILTER_NU-1);

    signal x : t_bus_arr;
    signal s : t_bus_arr;
    signal v : t_wire;

    signal mul_temp : t_temp;


    component fir_stage is 
        port ( 
            B     : in std_logic_vector(FILTER_NB-1 downto 0);
            X_in  : in t_bus(0 to FILTER_NU-1);
            S_in  : in t_bus(0 to FILTER_NU-1);
            VIN   : in std_logic;
            RST_n : in std_logic;
            CLK   : in std_logic;
            X_out : out t_bus(0 to FILTER_NU-1);
            S_out : out t_bus(0 to FILTER_NU-1);
            VOUT  : out std_logic);
    end component; 

    component ff_gen is 
        generic(
            N : integer := 8
        );
        port ( 
            CLK   : in std_logic;
            RST   : in std_logic;
            EN    : in std_logic; 
            D     : in std_logic_vector(N-1 downto 0);
            Q     : out std_logic_vector(N-1 downto 0));
    end component;


    component booth_mult is 
        port(
            A : in std_logic_vector(NBIT-1 downto 0);
            B : in std_logic_vector(NBIT-1 downto 0);
            P : out std_logic_vector(2*NBIT-1 downto 0));
    end component;

begin

    -- Input flip-flop
    in_ff_p : process (CLK, RST_n)
    begin
        if CLK'event and CLK = '1' then
            if RST_n = '0' then
                for i in 0 to FILTER_NU-1 loop
                    in_ff(i) <= (others => '0');
                end loop;
            elsif VIN = '1' then
                in_ff(0) <= DIN0;
                in_ff(1) <= DIN1;
                in_ff(2) <= DIN2;
            end if;
        end if;
    end process;

    --------------------------------------------------
    -- STAGE 0
    --------------------------------------------------

    DIN_ff : ff_gen
    generic map (
        N  => 1
    )
    port map (
        CLK    => CLK,
        RST    => RST_n,
        EN     => '1',
        D(0)   => VIN,
        Q(0)   => v(0));

    x(0) <= in_ff;

    mul_gen : for i in 0 to FILTER_NU-1 generate

        mul_i : booth_mult
        port map (
            A      => x(0)(i),
            B      => B((FILTER_NT+1)*(FILTER_NB)-1 downto FILTER_NT*FILTER_NB),
            P      => mul_temp(i));

        s(0)(i) <= mul_temp(i)(2*FILTER_NB-2 downto FILTER_NB-1);
    end generate;

    --------------------------------------------------
    -- All the rest...
    --------------------------------------------------

    stage_gen : for i in 0 to FILTER_NT-1 generate
        fir_stage_0 : fir_stage
        port map (
            B      => B((FILTER_NT+1)*(FILTER_NB)-FILTER_NB*(i+1)-1 downto (FILTER_NT+1)*(FILTER_NB)-FILTER_NB*(i+2)),
            X_in  => x(i),
            S_in  => s(i),
            VIN    => v(i),
            RST_n  => RST_n,
            CLK    => CLK,
            S_out => s(i+1),
            X_out => x(i+1),
            VOUT   => v(i+1));
    end generate;

    DOUT0 <= s(FILTER_NT)(0);
    DOUT1 <= s(FILTER_NT)(1);
    DOUT2 <= s(FILTER_NT)(2);

    VOUT <= v(FILTER_NT);
end behavioral;
