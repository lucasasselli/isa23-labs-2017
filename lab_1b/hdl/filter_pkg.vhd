library ieee; 
use ieee.std_logic_1164.all; 

package filter_pkg is
    constant NB : integer := 8;
    constant NT : integer := 10;
    constant NU : integer := 3;
    type t_bus is array(natural range <>) of std_logic_vector(NB-1 downto 0);
end package;
