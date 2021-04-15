library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity memory_stage is
    port(
        --clk, rst : in std_logic;

        RegDest         :   in std_logic_vector (4 downto 0);
        ALU_output      :   in std_logic_vector (31 downto 0);

        ex_mem_write_DATA : in std_logic_vector (31 downto 0);
        ex_mem_reg_Rs2  :  in std_logic_vector(4 downto 0);

        mem_wb_reg_Rd   :   in std_logic_vector (4 downto 0);
        mem_wb_data_IN  :   in std_logic_vector (31 downto 0);

        
        RegWrite        :   in std_logic;
        MemWrite        :   in std_logic;
        MemRead         :   in std_logic;
        MemtoReg        :   in std_logic;  
        Jump            :   in std_logic;
        
        next_PC              :   in std_logic_vector (31 downto 0);

        --outputs
        RegDest_out  :   out std_logic_vector (4 downto 0);
      --  Read_DATA    :   out std_logic_vector(31 downto 0);
        ALU_output_out:  out std_logic_vector(31 downto 0);
        WriteData          :   out std_logic_vector(31 downto 0);


         MemRead_out         : out std_logic;
         Memwrite_out        : out std_logic;
        RegWrite_out        :   out std_logic;
        MemtoReg_out        :   out std_logic;
        Jump_out            :   out std_logic;  

        --PC_out              :   out std_logic_vector (31 downto 0);
        PC_next_out         :   out std_logic_vector (31 downto 0)

    );
end memory_stage;

architecture structural of memory_stage is

component writedata_mux 
    port(
        WriteData       : in std_logic_vector (31 downto 0);
        Forwarded_Data  : in std_logic_vector (31 downto 0);

        forwardMEM      : in std_logic;

        out_to_DataMem  : out std_logic_vector (31 downto 0)
    );
end component;

component mem_forwarding 
    port (
        MemWrite   : in std_logic;
        --Read_data  : in std_logic_vector (31 downto 0);
        
        ex_mem_reg_Rs2 : in std_logic_vector (4 downto 0);
        mem_wb_reg_Rd : in std_logic_vector (4 downto 0);

        forwardMEM  : out std_logic
        --forward_data: out std_logic_vector (31 downto 0)

    );

end component;

signal forwardMEM : std_logic;
--signal write_DATA : std_logic_vector(31 downto 0);


begin


fwd_control : mem_forwarding port map (MemWrite, ex_mem_reg_Rs2, mem_wb_reg_Rd, forwardMEM);
fwd_mux     : writedata_mux  port map (ex_mem_write_DATA, mem_wb_data_IN, forwardMEM, WriteData);

memwrite_out <= Memwrite;
memread_out <= memread;
RegDest_out <= RegDest;
ALU_output_out <= ALU_output;
RegWrite_out <= RegWrite;
MemtoReg_out <= MemtoReg;
PC_next_out <= next_PC;
Jump_out <= Jump;




end structural;