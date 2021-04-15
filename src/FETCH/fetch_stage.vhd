library  IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity fetch_stage is
    port (
        CLK, RST_n        : in std_logic;
        branch_jump_PC  : in std_logic_vector (31 downto 0);

        PCSrc           : in std_logic;
        PCWrite         : in std_logic;

        --instruction     : out std_logic_vector (31 downto 0);

        PC              : out std_logic_vector (31 downto 0);
        PC_next         : out std_logic_vector (31 downto 0)
    );
end fetch_stage;

architecture structural of fetch_stage is

    signal PC_internal : std_logic_vector (31 downto 0);
    signal PC_out       : std_logic_vector(31 downto 0);
    signal PC_next_internal   : std_logic_vector (31 downto 0);

  component  mux21_32b 
        port(
            A    : in std_logic_vector (31 downto 0);
            B    : in std_logic_vector (31 downto 0);
            SEL  : in std_logic;
            OUTPUT  : out std_logic_vector (31 downto 0)
        );
    end component;
component  regPC    
	port (
        CLK: in std_logic;
        RST_n: in std_logic;
		PCWrite: in std_logic;
		datain: in std_logic_vector(31 downto 0);
		dataout: out std_logic_vector(31 downto 0)
    );
end component;

component PC_adder is
    port (
        PC : in std_logic_vector (31 downto 0);

        PC_next: out std_logic_vector(31 downto 0)
    );
end component;

begin
   
    
    -- branch_jump_PC selected when PCSrc = 1
    PC_mux: mux21_32b port map (PC_next_internal, branch_jump_PC, PCSrc, PC_internal);

    PC_reg: regPC port map (CLK , RST_n,PCWrite, PC_internal, PC_out);

    PC_add: PC_adder port map (PC_out,PC_next_internal);
    PC_next <= PC_next_internal;
    PC <= PC_out;
end structural;