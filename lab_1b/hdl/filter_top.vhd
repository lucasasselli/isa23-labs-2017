library ieee; 
use ieee.std_logic_1164.all; 

package filter_pkg is
    constant NB : integer := 8;
    constant NT : integer := 10;
    constant NU : integer := 3;
    type t_bus is array(natural range <>) of std_logic_vector(NB-1 downto 0);
end package;

library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use work.filter_pkg.all;

entity filter_top is 
    port ( 
        A     : in std_logic_vector((NT)*(NB)-1 downto 0);
        B     : in std_logic_vector((NT+1)*(NB)-1 downto 0);
        DIN0   : in std_logic_vector(NB-1 downto 0);
        DIN1   : in std_logic_vector(NB-1 downto 0);
        DIN2   : in std_logic_vector(NB-1 downto 0);
        VIN   : in std_logic;
        RST_n : in std_logic;
        CLK   : in std_logic;
        DOUT0   : out std_logic_vector(NB-1 downto 0);
        DOUT1   : out std_logic_vector(NB-1 downto 0);
        DOUT2   : out std_logic_vector(NB-1 downto 0);
        VOUT  : out std_logic);
end filter_top; 

architecture behavioral of filter_top is

    type t_temp is array(0 to NT) of std_logic_vector(2*NB-1 downto 0);

    -- I=0 Block
    signal y0 : t_bus(0 to NT);
    signal mul_bus0 : t_bus(0 to NT);
    signal sum_bus0 : t_bus(0 to NT);
    signal temp_bus0 : t_temp;

    -- I=1 Block
    signal y1 : t_bus(0 to NT);
    signal mul_bus1 : t_bus(0 to NT);
    signal sum_bus1 : t_bus(0 to NT);
    signal temp_bus1 : t_temp;

    -- I=2 Block
    signal y2 : t_bus(0 to NT);
    signal mul_bus2 : t_bus(0 to NT);
    signal sum_bus2 : t_bus(0 to NT);
    signal temp_bus2 : t_temp;

    signal in_ff : t_bus(0 to NT);
    signal x_ff_in : t_bus(0 to NT);
    signal x_ff_out : t_bus(0 to NT);
begin

    -- Input flip-flop bank
    in_ff_bank : process (CLK, RST_n)
    begin
        if CLK'event and CLK = '1' then
            if RST_n = '0' then
                for i in 0 to NU-1 loop
                    in_ff(i) <= (others => '0');
                end loop;
            elsif VIN = '1' then
                in_ff(0) <= DIN0;
                in_ff(1) <= DIN1;
                in_ff(2) <= DIN2;
            end if;
        end if;
    end process;

    -- Internal flip-flop bank
    x_ff_bank : process (CLK, RST_n)
    begin
        if CLK'event and CLK = '1' then
            if RST_n = '0' then
                for i in 0 to NT-1 loop
                    x_ff_out(i) <= (others => '0');
                end loop;
            elsif VIN = '1' then
                for i in 0 to NT-1 loop
                    x_ff_out(i) <= x_ff_in(i);
                end loop;
            end if;
        end if;
    end process;

    -- VOUT flip-flop
    vout_p : process (CLK, RST_n)
    begin
        if CLK'event and CLK = '1' then
            if RST_n = '0' then
                VOUT <= '1';
            else
                VOUT <= VIN;
            end if;
        end if;
    end process;

    gen_mul_bus : for i in 0 to NT generate
        -- Block 0
        temp_bus0(i) <= y0(i) * B((NT+1)*(NB)-NB*i-1 downto (NT+1)*(NB)-NB*(i+1));
        mul_bus0(i) <= temp_bus0(i)(2*NB-2 downto NB-1);
        -- Block 1
        temp_bus1(i) <= y1(i) * B((NT+1)*(NB)-NB*i-1 downto (NT+1)*(NB)-NB*(i+1));
        mul_bus1(i) <= temp_bus1(i)(2*NB-2 downto NB-1);
        -- Block 2
        temp_bus2(i) <= y2(i) * B((NT+1)*(NB)-NB*i-1 downto (NT+1)*(NB)-NB*(i+1));
        mul_bus2(i) <= temp_bus2(i)(2*NB-2 downto NB-1);
    end generate;

    sum_bus0(0) <= mul_bus0(0);
    sum_bus1(0) <= mul_bus1(0);
    sum_bus2(0) <= mul_bus2(0);
    gen_sum_bus : for i in 1 to NT generate
        -- Block 0
        sum_bus0(i) <= mul_bus0(i) + sum_bus0(i-1);
        -- Block 1
        sum_bus1(i) <= mul_bus1(i) + sum_bus1(i-1);
        -- Block 2
        sum_bus2(i) <= mul_bus2(i) + sum_bus2(i-1);
    end generate;

    y0(0) <= in_ff(0);
    y1(0) <= in_ff(1);
    y2(0) <= in_ff(2);
    gen_wires : for i in 0 to NT-1 generate
        y0(i+1) <= x_ff_out(i);
        y1(i+1) <= y0(i);
        y2(i+1) <= y1(i);
        x_ff_in(i) <= y2(i);
    end generate;

    DOUT0 <= sum_bus0(NT);
    DOUT1 <= sum_bus1(NT);
    DOUT2 <= sum_bus2(NT);

end behavioral;
