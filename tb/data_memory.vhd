LIBRARY ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;
--use ieee.std_logic_arith.all;

ENTITY data_mem IS
    PORT(
        rst_n: in std_logic;
        address : in std_logic_vector(31 downto 0);
        WriteData : in std_logic_vector(31 downto 0);

        MemWrite : in std_logic;
        MemRead  : in std_logic;

        ReadData    : out std_logic_vector(31 downto 0)
        
        );
end data_mem;

architecture behavioral of data_mem is

type RAM is array (4095 downto 0) of std_logic_vector (7 downto 0);

signal DATA_RAM: RAM;
signal internal_address : std_logic_vector(15 downto 0);

begin

    internal_address <= address(15 downto 0);

FILL_MEM_P: process (rst_n, Memwrite, MemRead, internal_address)
    file mem_fp: text;
    variable file_line : line;
    variable index : integer := 0;
    variable tmp_data_u : std_logic_vector(31 downto 0);
begin
    if (rst_n = '0') then
        file_open (mem_fp, "datamem.hex", READ_MODE);
        while (not endfile(mem_fp)) loop
            readline (mem_fp, file_line);
            hread (file_line, tmp_data_u);            
            DATA_RAM(index*4 ) <=  tmp_data_u(7 downto 0);
            DATA_RAM(index*4 + 1) <=  tmp_data_u(15 downto 8);
            DATA_RAM(index*4 + 2) <=  tmp_data_u(23 downto 16);
            DATA_RAM(index*4 + 3) <=  tmp_data_u(31 downto 24);  
            index := index +1;
        end loop;
    elsif (rst_n = '1') THEN
    if ((MemWrite = '1') and (MemRead = '0')) then
                    DATA_RAM(to_integer(unsigned(internal_address))) <= WriteData(7 downto 0);
                    DATA_RAM(to_integer(unsigned(internal_address))+1) <= WriteData(15 downto 8);
                    DATA_RAM(to_integer(unsigned(internal_address))+2) <= WriteData(23 downto 16);
                    DATA_RAM(to_integer(unsigned(internal_address))+3) <= WriteData(31 downto 24);
                elsif ((MemRead = '1') and Memwrite = '0') then
                    ReadData(7 downto 0) <= DATA_RAM(to_integer(unsigned(internal_address)));
                    ReadData(15 downto 8) <= DATA_RAM(to_integer(unsigned(internal_address))+1);
                    ReadData(23 downto 16) <= DATA_RAM(to_integer(unsigned(internal_address))+2);
                    ReadData(31 downto 24) <= DATA_RAM(to_integer(unsigned(internal_address))+3);
                
                else
                    ReadData <= (others => '0');
                end if;
    end if;
end process FILL_MEM_P;


            -- ReadData(7 downto 0) <= DATA_RAM(to_integer(unsigned(internal_address))) when MemRead = '1' else (others => '0');                         
            -- ReadData(15 downto 8) <= DATA_RAM(to_integer(unsigned(internal_address))+1) when MemRead = '1' else (others => '0');
            -- ReadData(23 downto 16) <= DATA_RAM(to_integer(unsigned(internal_address))+2) when MemRead = '1' else (others => '0');
            -- ReadData(31 downto 24) <= DATA_RAM(to_integer(unsigned(internal_address))+3) when MemRead = '1' else (others => '0');


            -- DATA_RAM(to_integer(unsigned(internal_address))) <= WriteData(7 downto 0) when Memwrite = '1';
            -- DATA_RAM(to_integer(unsigned(internal_address))+1) <= WriteData(15 downto 8) when Memwrite = '1';
            -- DATA_RAM(to_integer(unsigned(internal_address))+2) <= WriteData(23 downto 16) when Memwrite = '1';
            -- DATA_RAM(to_integer(unsigned(internal_address))+3) <= WriteData(31 downto 24) when Memwrite = '1';


-- writeORread : process (rst_n, internal_address)
--     begin
--      if (rst_n = '1') then
--         if ((MemWrite = '1') and (MemRead = '0')) then
--             DATA_RAM(to_integer(unsigned(internal_address))) <= WriteData(7 downto 0);
--             DATA_RAM(to_integer(unsigned(internal_address))+1) <= WriteData(15 downto 8);
--             DATA_RAM(to_integer(unsigned(internal_address))+2) <= WriteData(23 downto 16);
--             DATA_RAM(to_integer(unsigned(internal_address))+3) <= WriteData(31 downto 24);
--         elsif ((MemRead = '1') and Memwrite = '0') then
--             ReadData(7 downto 0) <= DATA_RAM(to_integer(unsigned(internal_address)));
--             ReadData(15 downto 8) <= DATA_RAM(to_integer(unsigned(internal_address))+1);
--             ReadData(23 downto 16) <= DATA_RAM(to_integer(unsigned(internal_address))+2);
--             ReadData(31 downto 24) <= DATA_RAM(to_integer(unsigned(internal_address))+3);
        
--         else
--             ReadData <= (others => '0');
--         end if;
--     end if;
-- end process writeORread; 


end behavioral;
