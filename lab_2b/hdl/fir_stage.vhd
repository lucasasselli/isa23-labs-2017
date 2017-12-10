library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use work.filter_pkg.all;
use work.booth_mult_pkg.all;

entity fir_stage is 
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
end fir_stage; 

architecture behavioral of fir_stage is

    type t_temp is array(0 to FILTER_NT) of std_logic_vector(2*FILTER_NB-1 downto 0);

    signal temp_bus   : t_temp;           -- Stores mul 2*FILTER_NB result
    signal mul_bus    : t_bus(0 to FILTER_NU-1); -- Stores mul FILTER_NB result
    signal S_pipe_in  : t_bus(0 to FILTER_NU-1);
    signal S_pipe_out : t_bus(0 to FILTER_NU-1);
    signal y          : t_bus(0 to FILTER_NU-1);

    component ff_pipe_gen is 
        generic(
            N : integer := 8;
            S : integer := 2
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

    --------------------------------------------------
    -- VOUT PIPELINE
    --------------------------------------------------

    vout_pipe_g : ff_pipe_gen
    generic map (
        N  => 1,
        S  => 1
    )
    port map (
        CLK    => CLK,
        RST    => RST_n,
        EN     => '1',
        D(0)   => VIN,
        Q(0)   => VOUT);


    --------------------------------------------------
    -- SUM INPUT PIPELINE
    --------------------------------------------------

    S_pipe_in <= S_in;

    S_pipe_g : for i in 0 to FILTER_NU-1 generate
        S_pipe : ff_pipe_gen
        generic map (
            N  => FILTER_NB,
            S  => 1
        )
        port map (
            CLK    => CLK,
            RST    => RST_n,
            EN     => VIN,
            D      => S_pipe_in(i),
            Q      => S_pipe_out(i));
    end generate;

    S_out(0) <= mul_bus(0) + S_pipe_out(0);
    S_out(1) <= mul_bus(1) + S_pipe_out(1);
    S_out(2) <= mul_bus(2) + S_pipe_out(2);

    --------------------------------------------------
    -- X INPUT PIPELINE
    --------------------------------------------------

    X01_pipe : ff_pipe_gen
    generic map (
        N  => FILTER_NB,
        S  => 1
    )
    port map (
        CLK    => CLK,
        RST    => RST_n,
        EN     => VIN,
        D      => X_in(0),
        Q      => y(1));

    X12_pipe : ff_pipe_gen
    generic map (
        N  => FILTER_NB,
        S  => 1
    )
    port map (
        CLK    => CLK,
        RST    => RST_n,
        EN     => VIN,
        D      => X_in(1),
        Q      => y(2));

    X20_pipe : ff_pipe_gen
    generic map (
        N  => FILTER_NB,
        S  => 2
    )
    port map (
        CLK    => CLK,
        RST    => RST_n,
        EN     => VIN,
        D      => X_in(2),
        Q      => y(0));

    X_out(0) <= y(0);
    X_out(1) <= y(1);
    X_out(2) <= y(2);

    -- Multiply and trim
    gen_mul_bus : for i in 0 to FILTER_NU-1 generate

        mul_i : booth_mult
        port map (
            A      => y(i),
            B      => B,
            P      => temp_bus(i));

        mul_bus(i) <= temp_bus(i)(2*FILTER_NB-2 downto FILTER_NB-1);
    end generate;

end behavioral;
