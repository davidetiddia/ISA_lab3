library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.instruction_types.all;


entity control_unit is
    port(
        -- pag 294 shows control connection
        -- pag 309 clarifications on different placement for BEQ check
        -- pag 314 shows the final datapath
        opcode     		: in std_logic_vector(6 downto 0); --instruction bits (6:0)
		Jump			: out std_logic;		
		PCZ				: out std_logic;		
		ALUSrcA         : out std_logic;		
		ALUSrcB         : out std_logic;
		MemtoReg        : out std_logic;
		RegWrite        : out std_logic;
		MemRead         : out std_logic;
		MemWrite        : out std_logic;
		Branch			: out std_logic;
        ALUOp           : out std_logic_vector(2 downto 0)
    );

end control_unit;


architecture behavioral of control_unit is
	
	signal ctrl_word : std_logic_vector(11 downto 0);   

begin

	Jump <= ctrl_word(11);	
	PCZ <= ctrl_word(10);
	ALUSrcA <= ctrl_word(9);
	ALUSrcB <= ctrl_word(8);
	MemtoReg <= ctrl_word(7);
	RegWrite <= ctrl_word(6);
	MemRead <= ctrl_word(5);
	MemWrite <= ctrl_word(4);
	Branch <= ctrl_word(3);
    ALUOp <= ctrl_word(2 downto 0); 
	
	p_opcode : process(opcode)
	begin
		case opcode is
			when R_type 		=> ctrl_word <= "000001000110";
			when I_type 		=> ctrl_word <= "000101000101";
			when AUIPC_U_type 	=> ctrl_word <= "010101000000";
			when LUI_U_type 	=> ctrl_word <= "001101000000";
			when load_type 		=> ctrl_word <= "000111100011"; 
			when S_type 		=> ctrl_word <= "000100010100"; 
			when SB_type 		=> ctrl_word <= "000000001000";
			when UJ_type 		=> ctrl_word <= "100001000000"; 
			when others    		=> ctrl_word <= "000000000000"; 
		end case;
	end process p_opcode;
	
	-- p_opcode  : process(opcode)
	-- 	case opcode(4 downto 2) is
	-- 		when "000" => 
	-- 			case opcode(6 downto 5) is
	-- 				when "00" => ctrl_word <= "000111100011";
	-- 				when "01" => ctrl_word <= "000100010100";
	-- 				when "11" => ctrl_word <= "000000001000";
	-- 				when others => ctrl_word <= (others => '0');
	-- 			end case;
	-- 		when "001" => ctrl_word <= (others => '0');
	-- 		when "011" => if (opcode (6 downto 5) = "11") then
	-- 							ctrl_word <= "100001000000";
	-- 						else ctrl_word <= (others => '0');
	-- 						end if; 
	-- 		when "100" => 
	



end behavioral;
