library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registerfile is
  port (
    RS1 	: in std_logic_vector(4 downto 0);
	RS2		: in std_logic_vector(4 downto 0);
	RD		: in std_logic_vector(4 downto 0);
	RegWrite: in std_logic;
	DATAIN	: in std_logic_vector(31 downto 0);
    CLK     : in std_logic;
    RST_n   : in std_logic;
	OUT1	: out std_logic_vector(31 downto 0);
	OUT2	: out std_logic_vector(31 downto 0)
	);
end registerfile;

architecture behavioral of registerfile IS

component mux_32_1 
    port(
        x0 : in std_logic_vector(31 downto 0);
        x1 : in std_logic_vector(31 downto 0);
        x2 : in std_logic_vector(31 downto 0);
        x3 : in std_logic_vector(31 downto 0);
        x4 : in std_logic_vector(31 downto 0);
        x5 : in std_logic_vector(31 downto 0);
        x6 : in std_logic_vector(31 downto 0);
        x7 : in std_logic_vector(31 downto 0);
        x8 : in std_logic_vector(31 downto 0);
        x9 : in std_logic_vector(31 downto 0);
        x10 : in std_logic_vector(31 downto 0);
        x11 : in std_logic_vector(31 downto 0);
        x12 : in std_logic_vector(31 downto 0);
        x13 : in std_logic_vector(31 downto 0);
        x14 : in std_logic_vector(31 downto 0);
        x15 : in std_logic_vector(31 downto 0);
        x16 : in std_logic_vector(31 downto 0);
        x17 : in std_logic_vector(31 downto 0);
        x18: in std_logic_vector(31 downto 0);
        x19 : in std_logic_vector(31 downto 0);
        x20 : in std_logic_vector(31 downto 0);
        x21 : in std_logic_vector(31 downto 0);
        x22 : in std_logic_vector(31 downto 0);
        x23 : in std_logic_vector(31 downto 0);
        x24: in std_logic_vector(31 downto 0);
        x25: in std_logic_vector(31 downto 0);
        x26 : in std_logic_vector(31 downto 0);
        x27 : in std_logic_vector(31 downto 0);
        x28 : in std_logic_vector(31 downto 0);
        x29 : in std_logic_vector(31 downto 0);
        x30 : in std_logic_vector(31 downto 0);
        x31 : in std_logic_vector(31 downto 0);

        address: in std_logic_vector(4 downto 0);

        output : out std_logic_vector(31 downto 0)
    );
end component;

type regs is array (31 downto 0) of std_logic_vector(31 downto 0);
signal regfile : regs;


begin
	process (CLK,rst_n)
		begin
			if (rst_n = '0') then
				regfile <= (others => (others => '0'));
			elsif rising_edge(CLK) then
				if (RegWrite = '1') then
					if (RD = "00000") then
						regfile(0) <= (others => '0');
					else
					regfile(to_integer (unsigned(RD))) <= DATAIN;
					end if;
				end if;
			end if;
	end process;

	output_1 : mux_32_1 port map(
		x0 => regfile(0),
		x1 => regfile(1),
		x2 => regfile(2),
		x3 => regfile(3),
		x4 => regfile(4),
		x5 => regfile(5),
		x6 => regfile(6),
		x7 => regfile(7),
		x8 => regfile(8),
		x9 => regfile(9),
		x10 => regfile(10),
		x11 => regfile(11),
		x12 => regfile(12),
		x13 => regfile(13),
		x14 => regfile(14),
		x15 => regfile(15),
		x16 => regfile(16),
		x17 => regfile(17),
		x18 => regfile(18),
		x19 => regfile(19),
		x20 => regfile(20),
		x21 => regfile(21),
		x22 => regfile(22),
		x23 => regfile(23),
		x24 => regfile(24),
		x25 => regfile(25),
		x26 => regfile(26),
		x27 => regfile(27),
		x28 => regfile(28),
		x29 => regfile(29),
		x30 => regfile(30),
		x31 => regfile(31),
		address => RS1,
		output =>  out1
	);

	output_2 : mux_32_1 port map (
		x0 => regfile(0),
		x1 => regfile(1),
		x2 => regfile(2),
		x3 => regfile(3),
		x4 => regfile(4),
		x5 => regfile(5),
		x6 => regfile(6),
		x7 => regfile(7),
		x8 => regfile(8),
		x9 => regfile(9),
		x10 => regfile(10),
		x11 => regfile(11),
		x12 => regfile(12),
		x13 => regfile(13),
		x14 => regfile(14),
		x15 => regfile(15),
		x16 => regfile(16),
		x17 => regfile(17),
		x18 => regfile(18),
		x19 => regfile(19),
		x20 => regfile(20),
		x21 => regfile(21),
		x22 => regfile(22),
		x23 => regfile(23),
		x24 => regfile(24),
		x25 => regfile(25),
		x26 => regfile(26),
		x27 => regfile(27),
		x28 => regfile(28),
		x29 => regfile(29),
		x30 => regfile(30),
		x31 => regfile(31),
		address => RS2,
		output =>  out2
	);


end behavioral;


