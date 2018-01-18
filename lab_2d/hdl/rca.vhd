library ieee; 
use ieee.std_logic_1164.all; 

entity RCA is 
    generic(NBIT: integer);
    port (A: in std_logic_vector(NBIT-1 downto 0);
          B: in std_logic_vector(NBIT-1 downto 0);
          C_in: in std_logic;
          S: out std_logic_vector(NBIT-1 downto 0);
          C_out: out std_logic);
end RCA; 

architecture structural of RCA is

    signal S_i : std_logic_vector(NBIT-1 downto 0); -- S internal bus
    signal C_i : std_logic_vector(NBIT downto 0);   -- Cross FA carry signals

    component FA 
        Port ( A: in std_logic;
               B: in std_logic;
               C_in : in std_logic;
               S: out std_logic;
               C_out : out std_logic);
    end component; 

begin

    C_i(0) <= C_in;
    S <= S_i;
    C_out <= C_i(NBIT);

    adder_i : for I in 0 to NBIT-1 generate
        FA_i : FA
        port map (
            A => A(I),
            B => B(I),
            C_in => C_i(I),
            S => S_i(I),
            C_out => C_i(I+1));
    end generate;

end structural;
