library  IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.instruction_types.all;

entity imm_gen is
    port(
        instruction         :  in std_logic_vector (31 downto 0);

        immediate           : out std_logic_vector (31 downto 0)
    );
end imm_gen;

architecture behavioral of imm_gen is
--signal tmp_immediate : std_logic_vector (31 downto 0);


begin   
    proc_imm: process (instruction)
        begin
            case (instruction(6 downto 0)) is
                when LUI_U_type => immediate <= instruction (31 downto 12) & x"000";
                    --               immediate <= tmp_immediate;

                when AUIPC_U_type =>immediate <= instruction (31 downto 12) & x"000";
                      --              immediate <= tmp_immediate;

                when UJ_type => immediate <= std_logic_vector(resize(signed( instruction (31) & instruction (19 downto 12) & instruction (20) & instruction (30 downto 21) & '0'), immediate'length));
                        --        immediate <= tmp_immediate;

                when SB_type => immediate <= std_logic_vector(resize(signed(instruction (31) & instruction (7) & instruction (30 downto 25) & instruction (11 downto 8) & '0'), immediate'length));
                          --      immediate <= tmp_immediate;

                when load_type => immediate <= std_logic_vector(resize(signed(instruction (31 downto 20)), immediate'length)) ;
                           --     immediate <= tmp_immediate;

                when s_type  =>  immediate <= std_logic_vector(resize(signed( instruction (31 downto 25) & instruction(11 downto 7)),immediate'length));
                            --    immediate <= tmp_immediate;

                when I_type => immediate <= std_logic_vector(resize(signed(instruction (31 downto 20)), immediate'length));
                              --  immediate <= tmp_immediate;

                when others => immediate <= (others => '0');
            end case;
           -- immediate <= tmp_immediate;
    end process;

end behavioral;

