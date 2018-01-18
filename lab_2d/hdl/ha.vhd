library ieee; 
use ieee.std_logic_1164.all; 

entity FA is 
    port ( A : in std_logic;
           B : in std_logic;
           C_in : in std_logic;
           S : out std_logic;
           C_out : out std_logic);
end FA; 

architecture behavioral of FA is

begin

    S <= A xor B xor C_in;
    C_out <= (A and B) or (B and C_in) or (A and C_in);

end behavioral;
