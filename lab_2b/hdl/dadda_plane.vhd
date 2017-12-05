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
    signal l2_0_4 : std_logic;
    signal l2_1_4 : std_logic;
    signal l2_0_5 : std_logic;
    signal l2_0_8 : std_logic;
    signal l2_1_8 : std_logic;
    signal l2_2_4 : std_logic;
    signal l2_0_6 : std_logic;
    signal l2_2_5 : std_logic;
    signal l2_0_7 : std_logic;
    signal l2_1_6 : std_logic;
    signal l2_1_5 : std_logic;
    signal l2_2_6 : std_logic;
    signal l2_2_7 : std_logic;
    signal l2_2_8 : std_logic;
    signal l2_0_10 : std_logic;
    signal l2_2_9 : std_logic;
    signal l2_1_10 : std_logic;
    signal l2_1_9 : std_logic;
    signal l2_0_11 : std_logic;
    signal l2_2_10 : std_logic;
    signal l2_0_9 : std_logic;
    signal l2_2_11 : std_logic;
    signal l2_2_12 : std_logic;
    signal l2_0_14 : std_logic;
    signal l2_2_13 : std_logic;
    signal l2_0_12 : std_logic;
    signal l2_1_13 : std_logic;
    signal l2_1_14 : std_logic;
    signal l2_1_12 : std_logic;
    signal l2_0_13 : std_logic;
    signal l2_1_7 : std_logic;
    signal l2_1_11 : std_logic;
    signal l2_0_15 : std_logic;
    signal l2_2_14 : std_logic;
    signal rca_in0 : std_logic_vector(15 downto 0);
    signal rca_in1 : std_logic_vector(15 downto 0);
    signal rca_S : std_logic_vector(15 downto 0);
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

    component RCA is 
        generic(NBIT: integer);
        port (A: in std_logic_vector(NBIT-1 downto 0);
              B: in std_logic_vector(NBIT-1 downto 0);
              C_in: in std_logic;
              S: out std_logic_vector(NBIT-1 downto 0);
              C_out: out std_logic);
    end component; 

begin


    --Connections
    rca_in0(0) <= par_bus(0)(0);
    rca_in0(1) <= par_bus(0)(1);
    rca_in0(2) <= par_bus(0)(2);
    rca_in1(2) <= par_bus(1)(0);
    rca_in0(3) <= par_bus(0)(3);
    rca_in1(3) <= par_bus(1)(1);
    l2_0_4 <= par_bus(0)(4);
    l2_1_4 <= par_bus(1)(2);
    l2_2_4 <= par_bus(2)(0);
    l2_0_5 <= par_bus(0)(5);
    l2_1_5 <= par_bus(1)(3);
    l2_2_5 <= par_bus(2)(1);
    l2_1_6 <= par_bus(2)(2);
    l2_2_6 <= par_bus(3)(0);
    l2_2_7 <= par_bus(3)(1);
    l2_2_8 <= par_bus(3)(2);
    l2_2_9 <= par_bus(3)(3);
    l2_2_10 <= par_bus(3)(4);
    l2_2_11 <= par_bus(3)(5);
    l2_2_12 <= par_bus(3)(6);
    l2_2_13 <= par_bus(3)(7);
    l2_2_14 <= par_bus(3)(8);
    rca_in1(4) <= l2_2_4;
    rca_in1(0) <= '0';
    rca_in1(1) <= '0';
    rca_in1(15) <= '0';
    P <= rca_S(14) & rca_S(14 downto 0);

    --Instances
    C0 : HA port map (
        A => par_bus(0)(6),
        B => par_bus(1)(4),
        S => l2_0_6,
        C_out => l2_0_7);

    C1 : FA port map (
        C_in => par_bus(0)(7),
        A => par_bus(1)(5),
        B => par_bus(2)(3),
        S => l2_1_7,
        C_out => l2_0_8);

    C2 : FA port map (
        C_in => par_bus(0)(8),
        A => par_bus(1)(6),
        B => par_bus(2)(4),
        S => l2_1_8,
        C_out => l2_0_9);

    C3 : FA port map (
        C_in => par_bus(0)(8),
        A => par_bus(1)(7),
        B => par_bus(2)(5),
        S => l2_1_9,
        C_out => l2_0_10);

    C4 : FA port map (
        C_in => par_bus(0)(8),
        A => par_bus(1)(8),
        B => par_bus(2)(6),
        S => l2_1_10,
        C_out => l2_0_11);

    C5 : FA port map (
        C_in => par_bus(0)(8),
        A => par_bus(1)(8),
        B => par_bus(2)(7),
        S => l2_1_11,
        C_out => l2_0_12);

    C6 : FA port map (
        C_in => par_bus(0)(8),
        A => par_bus(1)(8),
        B => par_bus(2)(8),
        S => l2_1_12,
        C_out => l2_0_13);

    C7 : FA port map (
        C_in => par_bus(0)(8),
        A => par_bus(1)(8),
        B => par_bus(2)(8),
        S => l2_1_13,
        C_out => l2_0_14);

    C8 : FA port map (
        C_in => par_bus(0)(8),
        A => par_bus(1)(8),
        B => par_bus(2)(8),
        S => l2_1_14,
        C_out => l2_0_15);

    C9 : HA port map (
        A => l2_0_4,
        B => l2_1_4,
        S => rca_in0(4),
        C_out => rca_in0(5));

    C10 : FA port map (
        C_in => l2_0_5,
        A => l2_1_5,
        B => l2_2_5,
        S => rca_in1(5),
        C_out => rca_in0(6));

    C11 : FA port map (
        C_in => l2_0_6,
        A => l2_1_6,
        B => l2_2_6,
        S => rca_in1(6),
        C_out => rca_in0(7));

    C12 : FA port map (
        C_in => l2_0_7,
        A => l2_1_7,
        B => l2_2_7,
        S => rca_in1(7),
        C_out => rca_in0(8));

    C13 : FA port map (
        C_in => l2_0_8,
        A => l2_1_8,
        B => l2_2_8,
        S => rca_in1(8),
        C_out => rca_in0(9));

    C14 : FA port map (
        C_in => l2_0_9,
        A => l2_1_9,
        B => l2_2_9,
        S => rca_in1(9),
        C_out => rca_in0(10));

    C15 : FA port map (
        C_in => l2_0_10,
        A => l2_1_10,
        B => l2_2_10,
        S => rca_in1(10),
        C_out => rca_in0(11));

    C16 : FA port map (
        C_in => l2_0_11,
        A => l2_1_11,
        B => l2_2_11,
        S => rca_in1(11),
        C_out => rca_in0(12));

    C17 : FA port map (
        C_in => l2_0_12,
        A => l2_1_12,
        B => l2_2_12,
        S => rca_in1(12),
        C_out => rca_in0(13));

    C18 : FA port map (
        C_in => l2_0_13,
        A => l2_1_13,
        B => l2_2_13,
        S => rca_in1(13),
        C_out => rca_in0(14));

    C19 : FA port map (
        C_in => l2_0_14,
        A => l2_1_14,
        B => l2_2_14,
        S => rca_in1(14),
        C_out => rca_in0(15));

    RCA_i : RCA
    generic map(
        NBIT => 16 )
    port map(
        A => rca_in0,
        B => rca_in1,
        C_in => '0',
        S => rca_S,
        C_out => rca_C_out );


end behavioral;
