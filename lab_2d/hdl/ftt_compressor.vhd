library ieee; 
use ieee.std_logic_1164.all; 

entity ftt_compressor is 
    port ( A : in std_logic;
           B : in std_logic;
           C : in std_logic;
           D : in std_logic;
           S : out std_logic;
           C_out : out std_logic);
end ftt_compressor; 

architecture behavioral of ftt_compressor is

begin

    S <= (A xnor B) or (C xnor D);
    C_out <= (A nor B) nor (C nor D);

end behavioral;
