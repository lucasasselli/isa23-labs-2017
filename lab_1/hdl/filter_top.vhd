library ieee; 
use ieee.std_logic_1164.all; 

package filter_pkg is
    constant NB : integer := 8;
    constant NT : integer := 10;
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
        DIN   : in std_logic_vector(NB-1 downto 0);
        VIN   : in std_logic;
        RST_n : in std_logic;
        CLK   : in std_logic;
        DOUT   : out std_logic_vector(NB-1 downto 0);
        VOUT  : out std_logic);
end filter_top; 

architecture behavioral of filter_top is

    type t_temp is array(NT downto 0) of std_logic_vector(2*NB-1 downto 0);

    signal x_ff : t_bus(NT downto 0);
    signal mul_bus : t_bus(NT downto 0);
    signal sum_bus : t_bus(NT downto 0);
    signal temp_bus : t_temp;

begin

    x_ff_bank : process (CLK, RST_n)
    begin
        if CLK'event and CLK = '1' then
            if RST_n = '0' then
                for i in NT downto 0 loop
                    x_ff(i) <= (others => '0');
                end loop;
            elsif VIN = '1' then
                x_ff(0) <= DIN;
                for i in NT downto 1 loop
                    x_ff(i) <= x_ff(i-1);
                end loop;
            end if;
        end if;
    end process;

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
        temp_bus(i) <= x_ff(i) * B((NT+1)*(NB)-NB*i-1 downto (NT+1)*(NB)-NB*(i+1));
        mul_bus(i) <= temp_bus(i)(2*NB-2 downto NB-1);
    end generate;

    sum_bus(NT) <= mul_bus(NT);
    gen_sum_bus : for i in 0 to NT-1 generate
        sum_bus(i) <= mul_bus(i) + sum_bus(i+1);
    end generate;

    DOUT <= sum_bus(0);

end behavioral;
