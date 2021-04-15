library  IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity hazard_unit is
    port (
        id_ex_MemRead      :  in std_logic;
        ex_mem_MemRead     :  in std_logic;
        id_ex_RegWrite     :  in std_logic;
        
        id_ex_Rd           :  in std_logic_vector (4 downto 0);
        ex_mem_Rd          :  in std_logic_vector (4 downto 0);

        if_id_register_Rs1 :  in std_logic_vector (4 downto 0);
        if_id_register_Rs2 :  in std_logic_vector (4 downto 0);
        
        branch_instruction :  in std_logic;

        stall              : out std_logic; -- controls muxing with ControlUnit
        PCWrite            : out std_logic;
        if_id_Write        : out std_logic
    );
end hazard_unit;

architecture behavioral of hazard_unit is
begin
    stall_pipeline: process (id_ex_MemRead, if_id_register_Rs1, if_id_register_Rs2, branch_instruction, ex_mem_MemRead, id_ex_Rd, ex_mem_Rd)  
    begin --if stall = 1 a nop is inserted into the pipeline, furthermore PC and if/id registers are not updated.
        if (branch_instruction = '1') THEN
        -- in case of a branch, we must stall (for one cycle) in case the previous operation writes to the same source register checked by the branch
          if ((id_ex_RegWrite = '1') and ((if_id_register_Rs1 = id_ex_Rd) or (if_id_register_Rs2 = id_ex_Rd))) then
            stall       <= '1';
            PCWrite     <= '0';
            if_id_Write <= '0';
    
        -- if the previous operation was a load, we must stall for two cycles.    
          -- first stall
          elsif ((id_ex_MemRead = '1') and ((id_ex_Rd = if_id_register_Rs1) or (id_ex_Rd = if_id_register_Rs2))) then
            stall       <= '1';
            PCWrite     <= '0';
            if_id_Write <= '0';
          -- second stall   
          elsif ((ex_mem_MemRead = '1') and ((ex_mem_Rd = if_id_register_Rs1) or (ex_mem_Rd = if_id_register_Rs2))) then
            stall       <= '1';
            PCWrite     <= '0';
            if_id_Write <= '0';
          
            else  stall       <= '0'; 
                PCWrite     <= '1';
                if_id_Write <= '1';

          end if;

        elsif (branch_instruction = '0') THEN
            if ((id_ex_MemRead = '1') and ((id_ex_Rd = if_id_register_Rs1) or (id_ex_Rd = if_id_register_Rs2))) then
                stall       <= '1';
                PCWrite     <= '0';
                if_id_Write <= '0';

            else stall       <= '0'; 
                 PCWrite     <= '1';
                 if_id_Write <= '1';
            end if;
    end if;
    end process;



-- entity hazard_unit is
--     port (
--         id_ex_MemRead      :  in std_logic;
        
--         id_ex_Rd           :  in std_logic_vector (4 downto 0);

--         if_id_register_Rs1 :  in std_logic_vector (4 downto 0);
--         if_id_register_Rs2 :  in std_logic_vector (4 downto 0);

--         stall              : out std_logic;
--         PCWrite            : out std_logic;
--         if_id_Write        : out std_logic
--     );
-- end hazard_unit;

-- architecture behavioral of hazard_unit is
-- begin
--     stall_pipeline: process (id_ex_MemRead, if_id_register_Rs1, if_id_register_Rs2)  
--     begin --if stall = 1 a nop is inserted into the pipeline, furthermore PC and if/id registers are not updated.
--         if ((id_ex_MemRead = '1') and ((id_ex_Rd = if_id_register_Rs1) or (id_ex_Rd = if_id_register_Rs2))) then
--             stall       <= '1';
--             PCWrite     <= '0';
--             if_id_Write <= '0';

--         else stall       <= '0'; 
--              PCWrite     <= '1';
--              if_id_Write <= '1';
--     end if;
--     end process;

end behavioral;