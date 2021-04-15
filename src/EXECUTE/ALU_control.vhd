library ieee;
use IEEE.numeric_std.all;
use ieee.std_logic_1164.all;
use work.instruction_types.all;

entity alu_control is
    port (
        ALUOp : in std_logic_vector (2 downto 0);
        func3 : in std_logic_vector (2 downto 0);
        func7: in std_logic;

        operation: out std_logic_vector (3 downto 0)
    );

end alu_control;

architecture behavioral of alu_control is

begin

    control_alu: process (ALUop, func3, func7)
    begin
        case ALUop is
            when "000"  => operation <= alu_add; -- U operations, LUI / AUIPC, UJ operations, JAL
            when "011"  => if (func3 = LW) then operation <= alu_add;
							else operation <= alu_add;                            
							end if;
            when "100"  => if (func3 = SW) then operation <= alu_add;
else operation <= alu_add;
                            end if;
            when "101"  => if (func3 = ADDI) then operation <= alu_add;
                            elsif (func3 = ANDI) then operation <= alu_and;
                            elsif (func3 = SRI ) then 
                                if (func7 = '1') then operation <= alu_shift_r_a;
								else operation<= alu_add;                                
								end if;
else operation <= alu_add;
                            end if;
            when "110"  => if (func3 = ADD_R) then 
                                if (func7 = '0') then operation <= alu_add;
								else operation<= alu_add;                                
								end if;
                            elsif (func3 = SLT) then operation <= alu_slt;
                            elsif (func3 = XOR_R) then operation <= alu_xor;
else operation <= alu_add;
                            end if;
            when others => operation <= alu_add;
            end case;
    end process;
        

end behavioral;
