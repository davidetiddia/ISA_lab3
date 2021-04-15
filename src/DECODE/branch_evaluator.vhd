library  IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.instruction_types.all;

entity branch_evaluator is
    port (
        RegSource1    : in std_logic_vector (31 downto 0);
        RegSource2    : in std_logic_vector (31 downto 0);

        test_branch   : in std_logic;
        func3         : in std_logic_vector (2 downto 0);

        branch_res    : out std_logic
    );
end branch_evaluator;

architecture behavioral of branch_evaluator is

--signal tmp_res : std_logic_vector (31 downto 0);

begin

    branch: process(test_branch, RegSource1, RegSource2, func3)
    begin
        if (test_branch = '1') then
            case (func3) is
                when BEQ =>   if (RegSource1 = RegSource2) then
                              branch_res <= '1'; -- if the BEQ condition results satisfied, branch_res is asserted.
                              else branch_res <= '0'; 
                              end if;
                when others => branch_res <= '0';
                -- when BNE 
                -- fill with other instructions if needed
            end case;
        else branch_res <= '0';
        end if;
    end process;

end behavioral;