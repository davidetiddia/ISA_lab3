library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- for clarifications, read chapter 4.7 of
-- "computer organization and design, risc-v edition"


entity forwarding_unit is
    port (
        id_ex_reg_rs1        :   in std_logic_vector (4 downto 0);
        id_ex_reg_rs2        :   in std_logic_vector (4 downto 0);
        ex_mem_reg_Rd        :   in std_logic_vector (4 downto 0);
        mem_wb_reg_Rd        :   in std_logic_vector (4 downto 0);

        ex_mem_RegWrite      :   in std_logic;
        mem_wb_RegWrite      :   in std_logic;

        forwardA             :   out std_logic_vector (1 downto 0);
        forwardB             :   out std_logic_vector (1 downto 0)
    );
end forwarding_unit;

architecture behavioral of forwarding_unit is

 

begin

    -- forwarding: process (id_ex_reg_rs1, id_ex_reg_rs2, ex_mem_reg_Rd, mem_wb_reg_Rd, ex_mem_RegWrite, mem_wb_RegWrite)
    -- begin
    --     -- EX stage hazard
    --     if ((ex_mem_RegWrite = '1') and (ex_mem_reg_Rd /= "00000") and (ex_mem_reg_Rd = id_ex_reg_rs1)) then -- x0 is reg 00000
    --         forwardA <= "10";
    --     elsif  ((ex_mem_RegWrite = '1') and (ex_mem_reg_Rd /= "00000") and (ex_mem_reg_Rd = id_ex_reg_rs2)) then 
    --         forwardB <= "10";
        
    --     -- MEM stage hazard
    --     elsif ((mem_wb_RegWrite ='1') and (mem_wb_reg_Rd /= "00000") and not((ex_mem_RegWrite='1') and (ex_mem_reg_Rd /= "00000") and (ex_mem_reg_Rd = id_ex_reg_rs1)) and (mem_wb_reg_Rd = id_ex_reg_rs1)) then
    --         forwardA <= "01";
    --     elsif ((mem_wb_RegWrite ='1') and (mem_wb_reg_Rd /= "00000") and not((ex_mem_RegWrite='1') and (ex_mem_reg_Rd /= "00000") and (ex_mem_reg_Rd = id_ex_reg_rs2)) and (mem_wb_reg_Rd = id_ex_reg_rs2)) then
    --         forwardB <= "01";

    --     else 
    --         forwardA <= "00";
    --         forwardB <= "00";
    --     end if;
    -- end process;


    forwarding_alu_src_1: process (id_ex_reg_rs1, ex_mem_reg_Rd, mem_wb_reg_Rd, ex_mem_RegWrite, mem_wb_RegWrite)
begin
    -- EX stage hazard
    if ((ex_mem_RegWrite = '1') and (ex_mem_reg_Rd /= "00000") and (ex_mem_reg_Rd = id_ex_reg_rs1)) then -- x0 is reg 00000
        forwardA <= "10";
    
    -- MEM stage hazard
    elsif ((mem_wb_RegWrite ='1') and (mem_wb_reg_Rd /= "00000") and not((ex_mem_RegWrite='1') and (ex_mem_reg_Rd /= "00000") and (ex_mem_reg_Rd = id_ex_reg_rs1)) and (mem_wb_reg_Rd = id_ex_reg_rs1)) then
        forwardA <= "01";

    else 
        forwardA <= "00";
    end if;
end process;


forwarding_alu_src_2 : process (id_ex_reg_rs2, ex_mem_reg_rd, mem_wb_reg_Rd, ex_mem_RegWrite, mem_wb_RegWrite)
begin
    -- EX stage hazard
    if ((ex_mem_RegWrite = '1') and (ex_mem_reg_Rd /= "00000") and (ex_mem_reg_Rd = id_ex_reg_rs2)) then 
        forwardB <= "10";
    
    -- MEM stage hazard
    elsif ((mem_wb_RegWrite ='1') and (mem_wb_reg_Rd /= "00000") and not((ex_mem_RegWrite='1') and (ex_mem_reg_Rd /= "00000") and (ex_mem_reg_Rd = id_ex_reg_rs2)) and (mem_wb_reg_Rd = id_ex_reg_rs2)) then
        forwardB <= "01";

    else 
        forwardB <= "00";
    end if;
end process;


end behavioral;