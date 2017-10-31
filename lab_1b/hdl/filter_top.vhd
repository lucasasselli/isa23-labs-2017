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

    type t_temp is array(0 to NT) of std_logic_vector(2*NB-1 downto 0);

    signal cnt : std_logic_vector(1 downto 0);

    -- I=0 Block
    signal input0 : std_logic_vector(NB-1 downto 0);
    signal y0 : t_bus(0 to NT);
    signal mul_bus0 : t_bus(0 to NT);
    signal sum_bus0 : t_bus(0 to NT);
    signal temp_bus0 : t_temp;

    -- I=1 Block
    signal input1 : std_logic_vector(NB-1 downto 0);
    signal y1 : t_bus(0 to NT);
    signal mul_bus1 : t_bus(0 to NT);
    signal sum_bus1 : t_bus(0 to NT);
    signal temp_bus1 : t_temp;

    -- I=2 Block
    signal input2 : std_logic_vector(NB-1 downto 0);
    signal y2 : t_bus(0 to NT);
    signal mul_bus2 : t_bus(0 to NT);
    signal sum_bus2 : t_bus(0 to NT);
    signal temp_bus2 : t_temp;

    signal ff_in : t_bus(0 to NT);
    signal ff_out : t_bus(0 to NT);
begin

    -- Counter
    counter : process (CLK, RST_n)
    begin
        if CLK'event and CLK = '1' then
            if RST_n = '0' then
                cnt <= (others => '0');
            elsif VIN = '1' then
                if cnt = 2 then
                    cnt <= (others => '0');
                else
                    cnt <= cnt + 1;
                end if;
            end if;
        end if;
    end process;

    -- Input muxed flip-flops
    mux_ff : process (CLK, RST_n)
    begin
        if CLK'event and CLK = '1' then
            if RST_n = '0' then
                input0 <= (others => '0');
                input1 <= (others => '0');
                input2 <= (others => '0');
            elsif VIN = '1' then
                case cnt is
                    when "00" => 
                        input0 <= DIN;
                        input1 <= input1;
                        input2 <= input2;
                    when "01" => 
                        input0 <= input0;
                        input1 <= DIN;
                        input2 <= input2;
                    when "10" => 
                        input0 <= input0;
                        input1 <= input1;
                        input2 <= DIN;
                    when others => 
                        input0 <= input0;
                        input1 <= input1;
                        input2 <= input2;
                end case;
            else 
                input0 <= input0;
                input1 <= input1;
                input2 <= input2;
            end if;
        end if;
    end process;


    -- Internal flip-flop bank
    x_ff_bank : process (CLK, RST_n)
    begin
        if CLK'event and CLK = '1' then
            if RST_n = '0' then
                for i in 0 to NT-1 loop
                    ff_out(i) <= (others => '0');
                end loop;
            elsif VIN = '1' then
                for i in 0 to NT-1 loop
                    ff_out(i) <= ff_in(i);
                end loop;
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

    y0(0) <= input0;
    y1(0) <= input1;
    y2(0) <= input2;
    gen_wires : for i in 0 to NT-1 generate
        y0(i+1) <= ff_out(i);
        y1(i+1) <= y0(i);
        y2(i+1) <= y1(i);
        ff_in(i) <= y2(i);
    end generate;

end behavioral;
