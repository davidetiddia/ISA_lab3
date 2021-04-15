library  IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity branch_forward_mux is
    port(
        regfile_data_IN  : in  std_logic_vector (31 downto 0);
        ex_mem_data_IN   : in  std_logic_vector (31 downto 0);
        mem_wb_data_IN   : in  std_logic_vector (31 downto 0);

        forward_sel : in  std_logic_vector (1 downto 0);

        output      : out std_logic_vector (31 downto 0)
    );
end branch_forward_mux;


architecture behavioral of branch_forward_mux is

begin
    
    FWD_MUX: process (regfile_data_IN, ex_mem_data_IN, mem_wb_data_IN, forward_sel)
        begin   
            case forward_sel is
                when "00" => output <= regfile_data_IN;
                when "10" => output <= ex_mem_data_IN;
                when "01" => output <= mem_wb_data_IN;
                when others => output <= regfile_data_IN;
            end case;
        end process;
        

end behavioral;