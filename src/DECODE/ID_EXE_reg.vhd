library  IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity ID_EXE_reg is
    port (
        -- inputs
        CLK, RST_n        :   in std_logic;

        RegSource1      :   in std_logic_vector (4 downto 0);
        RegSource2      :   in std_logic_vector (4 downto 0);
        RegDest         :   in std_logic_vector (4 downto 0);

        Rs1_DATA        :   in std_logic_vector (31 downto 0);
        Rs2_DATA        :   in std_logic_vector (31 downto 0);
        Immediate       :   in std_logic_vector (31 downto 0);

        func3           :   in std_logic_vector (2 downto 0);
        func7           :   in std_logic;

        RegWrite        :   in std_logic;
        ALUSrcA         :   in std_logic;
		ALUSrcB         :   in std_logic;
		PCZ				:	in std_logic;        
		ALUOp           :   in std_logic_vector (2 downto 0);
        MemWrite        :   in std_logic;
        MemRead         :   in std_logic;
        MemtoReg        :   in std_logic;  --  page 257
        Jump            :   in std_logic;

        PC              :   in std_logic_vector (31 downto 0);
        PC_NEXT         :   in std_logic_vector(31 downto 0);
        -- outputs
        
        RegSource1_out  :   out std_logic_vector (4 downto 0);
        RegSource2_out  :   out std_logic_vector (4 downto 0);
        RegDest_out  :   out std_logic_vector (4 downto 0);


        Rs1_DATA_out        :   out std_logic_vector (31 downto 0);
        Rs2_DATA_out        :   out std_logic_vector (31 downto 0);
        Immediate_out    :   out std_logic_vector (31 downto 0);

        func3_out           :   out std_logic_vector (2 downto 0);
        func7_out           :   out std_logic;

        RegWrite_out        :   out std_logic;
        ALUSrcA_out        :   out std_logic;
        ALUSrcB_out         :  out std_logic;
        PCZ_out                 :  out std_logic;
        ALUOp_out           :   out std_logic_vector (2 downto 0);
        MemWrite_out        :   out std_logic;
        MemRead_out         :   out std_logic;
        MemtoReg_out        :   out std_logic;  --  page 257
        jump_out            :   out std_logic;

        PC_out              :   out std_logic_vector (31 downto 0);
        PC_next_out         :   out std_logic_vector(31 downto 0)
    );

end ID_EXE_reg;

architecture behavioral of ID_EXE_reg is

begin
    process (CLK, RST_n)
    begin
        if (RST_n = '0') then
            RegSource1_out <= (others => '0');
            RegSource2_out <= (others => '0');
            RegDest_out <= (others => '0');
            Rs1_DATA_out<= (others => '0');
            Rs2_DATA_out<= (others => '0');
            Immediate_out<= (others => '0');
            func3_out   <= (others => '0');
            func7_out   <= '0';
            PCZ_out <= '0';
            RegWrite_out <= '0';
            ALUSrcA_out<= '0';
            ALUSrcB_out<= '0';
            ALUOp_out <= (others => '0');
            MemWrite_out<= '0';
            MemRead_out<= '0';
            MemtoReg_out<= '0';
            jump_out <= '0';
            PC_out <= (others => '0');
            PC_next_out <= (others => '0');
        else
            if (rising_edge (CLK)) then
            RegSource1_out <= RegSource1;
            RegSource2_out <= RegSource2;
            RegDest_out <= RegDest;
            Rs1_DATA_out<= Rs1_DATA;
            Rs2_DATA_out<= Rs2_DATA;
            Immediate_out<= Immediate;
            func3_out <= func3;
            func7_out <= func7; 
            PCZ_out <= PCZ;
            RegWrite_out <= RegWrite;
            ALUSrcA_out<= ALUSrcA;
            ALUSrcB_out<= ALUSrcB;
            ALUOp_out <= ALUOp;
            MemWrite_out<= MemWrite;
            MemRead_out<= MemRead;
            MemtoReg_out<= MemtoReg;
            jump_out <= jump;
            PC_out <= PC;
            PC_next_out <= PC_NEXT;
        end if;
    end if;
    end process;

end behavioral;
                
