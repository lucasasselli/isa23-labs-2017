library ieee; 
use ieee.std_logic_1164.all; 

entity HA is 
    port ( A : in std_logic;
           B : in std_logic;
           S : out std_logic;
           C_out : out std_logic);
end HA; 

architecture behavioral of HA is

begin

    S <= A xor B;
    C_out <= (A and B);

end behavioral;
