library  IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity decode_hazard_mux is
    port(
        RegWrite_in     : in std_logic;
        MemWrite_in     : in std_logic;

        stall           : in std_logic;

        RegWrite_out    : out std_logic;
        MemWrite_out    : out std_logic
    );
end decode_hazard_mux;

architecture behavioral of decode_hazard_mux is
begin
    mux_proc: process (RegWrite_in, MemWrite_in, stall)
    begin
        if (stall = '1') then
            RegWrite_out <= '0';
            MemWrite_out <= '0';
        else
            RegWrite_out <= RegWrite_in;
            MemWrite_out <= MemWrite_in;
        end if;
    end process;

end behavioral;
