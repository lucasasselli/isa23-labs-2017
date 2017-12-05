library ieee; 
use ieee.std_logic_1164.all; 

package booth_mult_pkg is
    constant NBIT : integer := 8; -- Number of input bits
    constant EBIT : integer := 3; -- Number of encoder bits
    constant ECNT : integer := 4; -- Number of encoders
    type t_par_bus is array(0 to ECNT-1) of std_logic_vector(NBIT downto 0);
end package;
