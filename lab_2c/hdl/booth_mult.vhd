library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.booth_mult_pkg.all;

entity booth_mult is 
    port(
        A : in std_logic_vector(NBIT-1 downto 0);
        B : in std_logic_vector(NBIT-1 downto 0);
        P : out std_logic_vector(2*NBIT-1 downto 0));
end booth_mult;

architecture behavioral of booth_mult is

    type t_sel_bus is array(0 to ECNT-1) of std_logic_vector(1 downto 0);
    type t_sgn_bus is array(0 to ECNT-1) of std_logic;

    -- Signals
    signal tmp_bus : t_par_bus;
    signal par_bus : t_par_bus;
    signal sel_bus : t_sel_bus;
    signal sgn_bus : t_sgn_bus;

    signal enc1 : std_logic_vector(EBIT-1 downto 0);
    signal A_big : std_logic_vector(NBIT+1 downto 0);
    signal P_dadda : std_logic_vector(10 downto 0);

    component booth_encoder3 is 
        port(
            B : in std_logic_vector(2 downto 0);
            sign : out std_logic;
            sel : out std_logic_vector(1 downto 0));
    end component;

    component dadda_plane is 
        port ( 
            par_bus : in t_par_bus;
            P : out std_logic_vector(10 downto 0));
    end component; 

begin

    A_big <= std_logic_vector(resize(signed(A),A_big'length)); 
    enc1 <= B(1 downto 0) & '0';

    enc_gen_loop : for i in 0 to ECNT-1 generate
        enc_first : if (i = 0) generate
            enc_gen_first : booth_encoder3
            port map (
                B  => enc1,
                sign  => sgn_bus(i),
                sel  => sel_bus(i));
        end  generate;
        enc_all : if (i /= 0) generate
            enc_gen_all : booth_encoder3
            port map (
                B  => B((i)*(EBIT-1)+1 downto (i-1)*(EBIT-1)+1),
                sign  => sgn_bus(i),
                sel  => sel_bus(i));
        end generate;

        -- Complement
        with sgn_bus(i) select tmp_bus(i) <=
                A_big when '0',
                std_logic_vector(-signed(A_big)) when '1',
                (others => '0') when others;

        -- Shift
        with sel_bus(i) select par_bus(i) <=
                (tmp_bus(i)) when "01",
                (tmp_bus(i)(tmp_bus(i)'left-1 downto 0) & '0') when "10",
                (others => '0') when others;


    end generate;

    
    dadda_plane_i : dadda_plane
    port map (
        par_bus  => par_bus,
        P  => P_dadda );

    P(2*NBIT-1 downto 5) <= P_dadda;

end behavioral; 
