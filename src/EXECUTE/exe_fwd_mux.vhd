library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity forward_mux is
    port(
        regfile_in  : in  std_logic_vector (31 downto 0);
        ex_mem_in   : in  std_logic_vector (31 downto 0);
        mem_wb_in   : in  std_logic_vector (31 downto 0);

        forward_sel : in  std_logic_vector (1 downto 0);

        output      : out std_logic_vector (31 downto 0)
    );
end forward_mux;


architecture behavioral of forward_mux is

begin
    
    FWD_MUX: process (regfile_in, ex_mem_in, mem_wb_in, forward_sel)
        begin   
            case forward_sel is
                when "00" => output <= regfile_in;
                when "10" => output <= ex_mem_in;
                when "01" => output <= mem_wb_in;
                when others => output <= (others => '0');
            end case;
        end process;
        

end behavioral;