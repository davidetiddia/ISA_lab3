library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity mem_wb_mux is
    port (
        memory_out : in  std_logic_vector (31 downto 0);
        alu_or_PC  : in  std_logic_vector (31 downto 0);

        MemtoReg   : in  std_logic;

        out_to_reg : out std_logic_vector (31 downto 0)

    );

end mem_wb_mux;

architecture behavioral of mem_wb_mux is
    begin
        out_to_reg <= memory_out when (MemtoReg = '1') else alu_or_PC;

    end behavioral;