library ieee; 
use ieee.std_logic_1164.all; 

entity ff_gen is 
    generic(
        N : integer := 8
    );
    port ( 
        CLK   : in std_logic;
        RST   : in std_logic;
        EN    : in std_logic; 
        D     : in std_logic_vector(N-1 downto 0);
        Q     : out std_logic_vector(N-1 downto 0));
end ff_gen; 

architecture behavioral of ff_gen is

begin
    ff_p : process(CLK, RST)
    begin
        if CLK'event and CLK = '1' then
            if RST = '0' then
                Q <= (others => '0');
            else
                if (EN = '1') then
                    Q <= D;
                end if;
            end if;
        end if;
    end process;
end architecture;
