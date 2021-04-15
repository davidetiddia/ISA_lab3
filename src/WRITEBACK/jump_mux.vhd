library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity jump_mux is --2 to 1 , 32 bit
    port (
        return_address : in  std_logic_vector (31 downto 0);
        alu_out        : in  std_logic_vector (31 downto 0);

        jump  : in  std_logic;

        output : out std_logic_vector (31 downto 0)

    );

end jump_mux;

architecture behavioral of jump_mux is
    begin
        output <= return_address when (jump = '1') else alu_out;

    end behavioral;