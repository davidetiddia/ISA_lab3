LIBRARY ieee;
USE ieee.std_logic_1164.all;


entity regPC is  
	port (
        CLK: in std_logic;
        RST_n: in std_logic;
		PCWrite: in std_logic;
		datain: in std_logic_vector(31 downto 0);
		dataout: out std_logic_vector(31 downto 0)
    );
end regPC;

architecture beh of regPC is

BEGIN

	process (CLK, rst_n)
    begin
        if (RST_n = '0') then
			 dataout <= x"00400000";
			--dataout <= x"00000000";
		elsif (rising_edge (CLK)) then
			if (PCWrite = '1') then
				dataout <= datain;
			end if;
		end if;
	end process;

end beh;
