library verilog;
use verilog.vl_types.all;
entity riscv is
    port(
        CLK             : in     vl_logic;
        RST_n           : in     vl_logic;
        Instruction     : in     vl_logic_vector(31 downto 0);
        PC              : out    vl_logic_vector(31 downto 0);
        READ_DATA       : in     vl_logic_vector(31 downto 0);
        MemRead         : out    vl_logic;
        MemWrite        : out    vl_logic;
        R_W_address     : out    vl_logic_vector(31 downto 0);
        WRITE_DATA      : out    vl_logic_vector(31 downto 0)
    );
end riscv;
