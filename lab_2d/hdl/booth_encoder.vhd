library ieee;
use ieee.std_logic_1164.all;

-- Encoder used in a Booth's multiplier to control both adder and multiplexer
-- SIGN is the add/sub signal of the adder
-- SEL is the control signal of the mux. Signals must be wired according to this table: 
--      SEL="00" --> 0
--      SEL="01" --> A
--      SEL="10" --> 2*A
--      SEL="11" --> Unused

entity booth_encoder3 is 
    port(
        B : in std_logic_vector(2 downto 0);
        SIGN : out std_logic;
        SEL : out std_logic_vector(1 downto 0));
end booth_encoder3;

architecture behavioral of booth_encoder3 is
begin
    SIGN <= B(2);
    SEL(1) <= '1' when (B = "011" or B = "100") else '0';
    SEL(0) <= B(1) xor B(0);
end behavioral; 
