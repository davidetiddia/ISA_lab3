LIBRARY ieee;
use IEEE.std_logic_1164.all;
--use IEEE.numeric_std.all;
use ieee.std_logic_arith.all;
use std.textio.all;
use ieee.std_logic_textio.all;

ENTITY instruction_mem IS
    PORT(
        RST_n: in std_logic;
        PC: in std_logic_vector (31 downto 0);   
        instruction  : out std_logic_vector (31 downto 0)
        
        );
end instruction_mem;


architecture behavioral of instruction_mem is

type RAM is array (87 downto 0) of std_logic_vector (7 downto 0);

signal IM: RAM;
signal internal_PC : std_logic_vector(21 downto 0);

 begin
    internal_PC <= PC(21 downto 0);

    instruction(7 downto 0) <= IM(conv_integer(unsigned(internal_PC)));
    instruction(15 downto 8) <= IM(conv_integer(unsigned(internal_PC))+1);
    instruction(23 downto 16) <= IM(conv_integer(unsigned(internal_PC))+2);
    instruction(31 downto 24) <= IM(conv_integer(unsigned(internal_PC))+3);

FILL_MEM_P: process (RST_n)
    file mem_fp: text;
    variable file_line : line;
    variable index : integer :=0;
    variable block_index : integer := 0;
    variable tmp_data_u : std_logic_vector(31 downto 0); -- := (others => '0');
begin
    if (rst_n = '0') then
        file_open (mem_fp, "progmem.hex", READ_MODE);
        while (not endfile(mem_fp)) loop
            readline (mem_fp, file_line);
            hread (file_line, tmp_data_u);
            IM(index*4 ) <= std_logic_vector(unsigned(tmp_data_u(7 downto 0)));
            IM(index*4 + 1) <= std_logic_vector(unsigned(tmp_data_u(15 downto 8)));
            IM(index*4 + 2) <= std_logic_vector(unsigned(tmp_data_u(23 downto 16)));
            IM(index*4 + 3) <= std_logic_vector(unsigned(tmp_data_u(31 downto 24)));
            index := index +1;
        end loop;
    end if;
end process;


end behavioral;
