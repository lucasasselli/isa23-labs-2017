library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use work.filter_pkg.all;

entity mul is 
    port ( 
        A     : in std_logic_vector(FILTER_NB-1 downto 0);
        B     : in std_logic_vector(FILTER_NB-1 downto 0);
        P     : out std_logic_vector(2*FILTER_NB-1 downto 0));
end mul; 

architecture behavioral of mul is

begin
    P <= A * B;

end behavioral;
