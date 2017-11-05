library ieee; 
use ieee.std_logic_1164.all; 

entity ff_pipe_gen is 
    generic(
        N : integer := 8;
        S : integer := 2
    );
    port ( 
        CLK   : in std_logic;
        RST   : in std_logic;
        EN    : in std_logic; 
        D     : in std_logic_vector(N-1 downto 0);
        Q     : out std_logic_vector(N-1 downto 0));
end ff_pipe_gen; 

architecture behavioral of ff_pipe_gen is

    type t_I is array(0 to S) of std_logic_vector(N-1 downto 0);
    signal s_I : t_I;

    component ff_gen is 
        generic(
            N : integer := 8
        );
        port ( 
            CLK   : in std_logic;
            RST   : in std_logic;
            EN    : in std_logic; 
            D     : in std_logic_vector(N-1 downto 0);
            Q     : out std_logic_vector(N-1 downto 0));
    end component;

begin
    -- Input 
    s_I(0) <= D;

    -- Pipeline
    ff_pipe : for i in 0 to S-1 generate
        ff_gen_i : ff_gen
        generic map (
            N  => N
        )
        port map (
            CLK    => CLK,
            RST    => RST,
            EN     => EN,
            D      => s_I(i),
            Q      => s_I(i+1));
    end generate;

    -- Output
    Q <= s_I(S);
end architecture;
