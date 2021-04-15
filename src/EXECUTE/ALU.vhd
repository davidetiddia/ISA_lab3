LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.instruction_types.all;

entity ALU is
    port (
        operand_1 : in std_logic_vector (31 downto 0);
        operand_2 : in std_logic_vector (31 downto 0);
        operation : in std_logic_vector (3 downto 0);
        --zero      : out std_logic;
        ALU_result: out std_logic_vector(31 downto 0)
    );
end ALU;


architecture behavioral of ALU is

signal tmp_alu_result : std_logic_vector (31 downto 0); 

begin
    P_ALU: process (operation, operand_1, operand_2)

begin
    case operation is -- ADD, SUB, XOR, AND, SHIFT_Right
        when alu_add => ALU_result <= std_logic_vector(signed(operand_1)+signed(operand_2));
                        --zero       <= '0';
       -- when alu_sub => ALU_result <= std_logic_vector(signed(operand_1)-signed(operand_2));
         --               zero       <= '1' when ALU_result = (others => '0');
           --                               else '0';
        when alu_xor => ALU_result <= operand_1 XOR operand_2;
                        --zero       <= '0';
        when alu_and => ALU_result <= operand_1 AND operand_2;
                        --zero       <= '0';
        when alu_shift_r_a => ALU_result <= std_logic_vector(SHIFT_RIGHT(signed(operand_1), to_integer(unsigned(operand_2))));
                        --zero       <= '0';
        when alu_slt => tmp_alu_result <= std_logic_vector(signed(operand_1) - signed(operand_2));
                        --ALU_result <= "0000000000000000000000000000000" & tmp_alu_result(31);
                        ALU_result <= std_logic_vector(SHIFT_Right(unsigned(signed(operand_1) - signed(operand_2)), 31));
        when others => ALU_result <= (others => '0');
    end case;
end process P_ALU;


end behavioral;

