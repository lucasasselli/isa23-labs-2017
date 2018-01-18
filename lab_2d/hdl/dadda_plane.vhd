library ieee; 
use ieee.std_logic_1164.all; 
use work.booth_mult_pkg.all;

entity dadda_plane is 
    port ( 
        par_bus : in t_par_bus;
        P : out std_logic_vector(15 downto 0));
end dadda_plane; 

architecture behavioral of dadda_plane is

    -- Signals
    signal rca_in0 : std_logic_vector(15 downto 0);
    signal rca_in1 : std_logic_vector(15 downto 0);
    signal rca_C_out : std_logic;

    -- Components
    component HA is 
        port ( A : in std_logic;
               B : in std_logic;
               S : out std_logic;
               C_out : out std_logic);
    end component; 

    component FA is 
        port ( A : in std_logic;
               B : in std_logic;
               C_in : in std_logic;
               S : out std_logic;
               C_out : out std_logic);
    end component; 

    component ftt_compressor is 
        port ( A : in std_logic;
               B : in std_logic;
               C : in std_logic;
               D : in std_logic;
               S : out std_logic;
               C_out : out std_logic);
    end component; 

    component RCA is 
        generic(NBIT: integer);
        port (A: in std_logic_vector(NBIT-1 downto 0);
              B: in std_logic_vector(NBIT-1 downto 0);
              C_in: in std_logic;
              S: out std_logic_vector(NBIT-1 downto 0);
              C_out: out std_logic);
    end component; 

begin

    rca_in0(0) <= par_bus(0)(0);
    rca_in1(0) <= '0';

    rca_in0(1) <= par_bus(0)(1);
    rca_in1(1) <= '0';

    rca_in0(2) <= par_bus(0)(2);
    rca_in1(2) <= par_bus(1)(0);

    rca_in0(3) <= par_bus(0)(3);
    rca_in1(3) <= par_bus(1)(1);

    HA_0 : HA
    port map (
        A  => par_bus(0)(4),
        B  => par_bus(1)(2),
        S  => rca_in0(4),
        C_out  => rca_in0(5));
    rca_in1(4) <= par_bus(2)(0);

    FA_0 : FA
    port map (
        A  => par_bus(0)(5),
        B  => par_bus(1)(3),
        C_in  => par_bus(2)(1),
        S  => rca_in1(5),
        C_out  => rca_in0(6));

    ftt_compressor_0 : ftt_compressor
    port map (
        A  => par_bus(0)(6),
        B  => par_bus(1)(4),
        C  => par_bus(2)(2),
        D  => par_bus(3)(0),
        S  => rca_in1(6),
        C_out  => rca_in0(7));

    ftt_compressor_1 : ftt_compressor
    port map (
        A  => par_bus(0)(7),
        B  => par_bus(1)(5),
        C  => par_bus(2)(3),
        D  => par_bus(3)(1),
        S  => rca_in1(7),
        C_out  => rca_in0(8));

    ftt_compressor_2 : ftt_compressor
    port map (
        A  => par_bus(0)(8),
        B  => par_bus(1)(6),
        C  => par_bus(2)(4),
        D  => par_bus(3)(2),
        S  => rca_in1(8),
        C_out  => rca_in0(9));

    ftt_compressor_3 : ftt_compressor
    port map (
        A  => par_bus(0)(9),
        B  => par_bus(1)(7),
        C  => par_bus(2)(5),
        D  => par_bus(3)(3),
        S  => rca_in1(9),
        C_out  => rca_in0(10));

    ftt_compressor_4 : ftt_compressor
    port map (
        A  => par_bus(0)(9),
        B  => par_bus(1)(8),
        C  => par_bus(2)(6),
        D  => par_bus(3)(4),
        S  => rca_in1(10),
        C_out  => rca_in0(11));

    ftt_compressor_5 : ftt_compressor
    port map (
        A  => par_bus(0)(9),
        B  => par_bus(1)(9),
        C  => par_bus(2)(7),
        D  => par_bus(3)(5),
        S  => rca_in1(11),
        C_out  => rca_in0(12));

    ftt_compressor_6 : ftt_compressor
    port map (
        A  => par_bus(0)(9),
        B  => par_bus(1)(9),
        C  => par_bus(2)(8),
        D  => par_bus(3)(6),
        S  => rca_in1(12),
        C_out  => rca_in0(13));

    ftt_compressor_7 : ftt_compressor
    port map (
        A  => par_bus(0)(9),
        B  => par_bus(1)(9),
        C  => par_bus(2)(9),
        D  => par_bus(3)(7),
        S  => rca_in1(13),
        C_out  => rca_in0(14));

    ftt_compressor_8 : ftt_compressor
    port map (
        A  => par_bus(0)(9),
        B  => par_bus(1)(9),
        C  => par_bus(2)(9),
        D  => par_bus(3)(8),
        S  => rca_in1(14),
        C_out  => rca_in0(15));

    ftt_compressor_9 : ftt_compressor
    port map (
        A  => par_bus(0)(9),
        B  => par_bus(1)(9),
        C  => par_bus(2)(9),
        D  => par_bus(3)(9),
        S  => rca_in1(15),
        C_out  => open);

    RCA_i : RCA
    generic map(
        NBIT => 16 )
    port map(
        A => rca_in0,
        B => rca_in1,
        C_in => '0',
        S => P,
        C_out => rca_C_out );

end behavioral;
