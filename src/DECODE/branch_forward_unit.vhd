library  IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity branch_forward_unit is
    port (
        --branch           : in std_logic;
        --RegSource1 and RegSource2 come from the instruction fields
        RegSource1       : in std_logic_vector (4 downto 0);
        RegSource2       : in std_logic_vector (4 downto 0);
        
        ex_mem_reg_Rd    : in std_logic_vector (4 downto 0);
        mem_wb_reg_Rd    : in std_logic_vector (4 downto 0);

        ex_mem_RegWrite  : in std_logic;
        mem_wb_RegWrite  : in std_logic;

        forward_1        : out std_logic_vector (1 downto 0);
        forward_2        : out std_logic_vector (1 downto 0)
        
    );
end branch_forward_unit;

architecture behavioral of branch_forward_unit is

begin
    -- forwarding_proc: process(RegSource1, RegSource2)
    -- begin
    --     --if(branch = '1') then
    --     -- ex/mem forwarding
    --     if ((ex_mem_RegWrite = '1') and (ex_mem_reg_Rd /= "00000") and (ex_mem_reg_Rd = RegSource1)) then
    --         forward_1 <= "10";
    --     elsif ((ex_mem_RegWrite = '1') and (ex_mem_reg_Rd /= "00000") and (ex_mem_reg_Rd = RegSource2)) then
    --         forward_2 <= "10";
        
    --     -- mem/wb forwarding
    --     elsif ((mem_wb_RegWrite ='1') and (mem_wb_reg_Rd /= "00000") and not((ex_mem_RegWrite='1') and (ex_mem_reg_Rd /= "00000") and (ex_mem_reg_Rd = RegSource1)) and (mem_wb_reg_Rd = RegSource1)) then
    --         forward_1 <= "01";
    --     elsif ((mem_wb_RegWrite ='1') and (mem_wb_reg_Rd /= "00000") and not((ex_mem_RegWrite='1') and (ex_mem_reg_Rd /= "00000") and (ex_mem_reg_Rd = RegSource2)) and (mem_wb_reg_Rd = RegSource2)) then
    --         forward_2 <= "01";
        
    --     else 
    --         -- read data from registers
    --         forward_1 <= "00";
    --         forward_2 <= "00";
    --     end if;
    --     -- else
    --     --     forward_1 <= "00";
    --     --     forward_2 <= "00";
    --    -- end if;
    -- end process;

    forwarding_RS1_out: process(RegSource1,ex_mem_reg_Rd, mem_wb_reg_Rd, ex_mem_RegWrite, mem_wb_RegWrite)
begin
    -- ex/mem forwarding
    if ((ex_mem_RegWrite = '1') and (ex_mem_reg_Rd /= "00000") and (ex_mem_reg_Rd = RegSource1)) then
        forward_1 <= "10";
    
    -- mem/wb forwarding
    elsif ((mem_wb_RegWrite ='1') and (mem_wb_reg_Rd /= "00000") and not((ex_mem_RegWrite='1') and (ex_mem_reg_Rd /= "00000") and (ex_mem_reg_Rd = RegSource1)) and (mem_wb_reg_Rd = RegSource1)) then
        forward_1 <= "01";
    
    else 
        -- read data from registers
        forward_1 <= "00";
    end if;

end process;

forwarding_RS2_out : process (RegSource2, ex_mem_reg_Rd, mem_wb_reg_Rd, ex_mem_RegWrite, mem_wb_RegWrite)
begin
    -- ex/mem forwarding
    if ((ex_mem_RegWrite = '1') and (ex_mem_reg_Rd /= "00000") and (ex_mem_reg_Rd = RegSource2)) then
        forward_2 <= "10";
    
    -- mem/wb forwarding
    elsif ((mem_wb_RegWrite ='1') and (mem_wb_reg_Rd /= "00000") and not((ex_mem_RegWrite='1') and (ex_mem_reg_Rd /= "00000") and (ex_mem_reg_Rd = RegSource2)) and (mem_wb_reg_Rd = RegSource2)) then
        forward_2 <= "01";
    
    else 
        -- read data from registers
        forward_2 <= "00";
    end if;
end process;


end behavioral;

