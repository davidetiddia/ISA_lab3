library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity writedata_mux is
    port(
        WriteData       : in std_logic_vector (31 downto 0);
        Forwarded_Data  : in std_logic_vector (31 downto 0);

        forwardMEM      : in std_logic;

        out_to_DataMem  : out std_logic_vector (31 downto 0)
    );
end writedata_mux;

architecture behavioral of writedata_mux is
begin
    out_to_DataMem <= WriteData when (forwardMEM = '0') else Forwarded_Data;

end behavioral;