library ieee; 
use ieee.std_logic_1164.all; 

package filter_pkg is
    constant FILTER_NB : integer := 8;
    constant FILTER_NT : integer := 10;
    constant FILTER_NU : integer := 3;
    type t_bus is array(natural range <>) of std_logic_vector(FILTER_NB-1 downto 0);
end package;
