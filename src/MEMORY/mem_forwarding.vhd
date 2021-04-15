library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- used to avoid stalls in case of store after load on the same register.
 -- read page 302 of the book, elaboration paragraph.
    -- check for rd = rs and if a store is performed right after a load using the Rd of the load for the
    -- computation of the address, activate the forwarding path. 

entity mem_forwarding is
    port (
        MemWrite   : in std_logic;
        --Read_data  : in std_logic_vector (31 downto 0);
        
        ex_mem_reg_Rs2 : in std_logic_vector (4 downto 0);
        mem_wb_reg_Rd : in std_logic_vector (4 downto 0);

        forwardMEM  : out std_logic
        --forward_data: out std_logic_vector (31 downto 0)

    );

end mem_forwarding;

architecture behavioral of mem_forwarding is

begin
    memory_forwarding: process (MemWrite, ex_mem_reg_Rs2, mem_wb_reg_Rd)
begin
    if (MemWrite = '1') and (mem_wb_reg_Rd /= "00000") and (ex_mem_reg_Rs2 = mem_wb_reg_Rd) then
        forwardMEM <= '1';
    else forwardMEM <= '0';
    end if;
end process;


end behavioral;     