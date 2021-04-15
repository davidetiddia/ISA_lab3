library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity adder is
    port(
        current_PC       : in  std_logic_vector (31 downto 0);    
        jump_offset      : in  std_logic_vector (31 downto 0);
        branch_target_PC : out std_logic_vector (31 downto 0)
    );
end adder;

architecture behavioral of adder is

--signal shifted_offset : std_logic_vector (31 downto 0);
signal internal_output: std_logic_vector (31 downto 0);

begin
   -- shifted_offset <= std_logic_vector(shift_left(signed(jump_offset), 1));
    internal_output <= std_logic_vector(signed(current_PC)+signed(jump_offset));

    branch_target_PC <= internal_output(31 downto 0);


end behavioral;



