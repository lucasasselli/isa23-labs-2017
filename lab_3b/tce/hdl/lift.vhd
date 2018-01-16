library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity lift is
    port (
        clk : in std_logic;
        rstx : in std_logic;
        glock : in std_logic;
        opcode : in std_logic_vector(2 downto 0);
        t1data : in std_logic_vector(31 downto 0);
        t1load : in std_logic;
        t2data : in std_logic_vector(31 downto 0);
        t2load : in std_logic;
        r1data : out std_logic_vector(31 downto 0));
end lift;

architecture behavioral of lift is

    constant L1_8 : signed(31 downto 0) := conv_signed(51, 32);
    constant L2_8 : signed(31 downto 0) := conv_signed(98, 32);
    constant L1_16 : signed(31 downto 0) := conv_signed(25, 32);
    constant L2_16 : signed(31 downto 0) := conv_signed(50, 32);
    constant L1_316 : signed(31 downto 0) := conv_signed(78, 32);
    constant L2_316 : signed(31 downto 0) := conv_signed(142, 32);

    signal t2data_reg : std_logic_vector(31 downto 0);
    signal tmp_long : signed(63 downto 0);
    signal fact1 : signed(31 downto 0);
    signal fact2 : signed(31 downto 0);
    signal add : signed(31 downto 0);
    signal sub : signed(31 downto 0);
    signal tmp : signed(31 downto 0);
    signal result : signed(31 downto 0);

    signal sel : std_logic;

begin

    process (clk, rstx)
    begin  -- process
        if rstx = '0' then                  -- asynchronous reset (active low)
            t2data_reg <= (others => '0');
        elsif clk'event and clk = '1' then  -- rising clock edge
            if (glock = '0') then
                if (t2load = '1') then
                    t2data_reg <= t2data;
                end if;        
            end if;
        end if;
    end process;

    sel <= opcode(0);

    fact1 <= signed(t2data_reg) when (sel = '0') else signed(t1data);

    with opcode select fact2 <= L1_16  when "000",
                                L2_16  when "001",
                                L1_316 when "010",
                                L2_316 when "011",
                                L1_8   when "100",
                                L2_8   when "101",
                                conv_signed(0,32) when others;

    tmp_long <= fact1 * fact2;
    tmp <= tmp_long(39 downto 8);

    add <= signed(t1data)+tmp;
    sub <= signed(t2data_reg)-tmp;

    result <= add when (sel = '0') else sub;

    process (clk, rstx)
    begin  -- process
        if rstx = '0' then                  -- asynchronous reset (active low)
            r1data <= (others => '0');
        elsif clk'event and clk = '1' then  -- rising clock edge
            if (glock = '0') then
                if (t1load = '1') then
                    r1data <= std_logic_vector(result);
                end if;
            end if;
        end if;
    end process;

end behavioral;
