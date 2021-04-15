library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity mux_32_1 is
    port(
        x0 : in std_logic_vector(31 downto 0);
        x1 : in std_logic_vector(31 downto 0);
        x2 : in std_logic_vector(31 downto 0);
        x3 : in std_logic_vector(31 downto 0);
        x4 : in std_logic_vector(31 downto 0);
        x5 : in std_logic_vector(31 downto 0);
        x6 : in std_logic_vector(31 downto 0);
        x7 : in std_logic_vector(31 downto 0);
        x8 : in std_logic_vector(31 downto 0);
        x9 : in std_logic_vector(31 downto 0);
        x10 : in std_logic_vector(31 downto 0);
        x11 : in std_logic_vector(31 downto 0);
        x12 : in std_logic_vector(31 downto 0);
        x13 : in std_logic_vector(31 downto 0);
        x14 : in std_logic_vector(31 downto 0);
        x15 : in std_logic_vector(31 downto 0);
        x16 : in std_logic_vector(31 downto 0);
        x17 : in std_logic_vector(31 downto 0);
        x18: in std_logic_vector(31 downto 0);
        x19 : in std_logic_vector(31 downto 0);
        x20 : in std_logic_vector(31 downto 0);
        x21 : in std_logic_vector(31 downto 0);
        x22 : in std_logic_vector(31 downto 0);
        x23 : in std_logic_vector(31 downto 0);
        x24: in std_logic_vector(31 downto 0);
        x25: in std_logic_vector(31 downto 0);
        x26 : in std_logic_vector(31 downto 0);
        x27 : in std_logic_vector(31 downto 0);
        x28 : in std_logic_vector(31 downto 0);
        x29 : in std_logic_vector(31 downto 0);
        x30 : in std_logic_vector(31 downto 0);
        x31 : in std_logic_vector(31 downto 0);

        address: in std_logic_vector(4 downto 0);

        output : out std_logic_vector(31 downto 0)
    );

end mux_32_1;

architecture behavioral of mux_32_1 is

begin
   with address select
   output <= 
  
  x0 when "00000"    ,  
  x1 when "00001"    ,
  x2 when "00010"        ,
  x3 when "00011"        ,
   x4 when "00100"        ,
  x5 when "00101"        ,
  x6 when "00110"        ,
  x7 when "00111"       ,
  x8 when "01000"      ,  
  x9 when "01001"     ,   
  x10 when "01010"    ,  
  x11 when "01011"    ,  
  x12 when "01100"    ,    
  x13 when "01101"   ,    
  x14 when "01110"   ,   
  x15 when "01111"    ,    
  x16 when  "10000"   ,    
  x17 when  "10001"   ,    
  x18 when  "10010"   ,    
  x19 when  "10011"   ,  
  x20 when  "10100"     ,  
  x21  when  "10101"     ,
  x22 when  "10110"         ,
  x23 when  "10111"         ,
  x24 when  "11000"         ,
  x25 when  "11001"         ,
  x26 when  "11010"         ,
  x27 when  "11011"        , 
  x28 when  "11100"       ,  
 x29  when  "11101"      ,   
 x30  when  "11110"     ,  
 x31  when  "11111"    ,
 x0 when others;  

    -- when 0 => output <= x0;
    -- when 1 => output <= x1;
    -- when 2 => output <= x2;
    -- when 3 => output <= x3;
    -- when 4 => output <= x4;
    -- when 5 => output <= x5;
    -- when 6 => output <= x6;
    -- when 7 => output <= x7;
    -- when 8 => output <= x8;
    -- when 9 => output <= x9;
    -- when 10 => output <= x10;
    -- when 11 => output <= x11;
    -- when 12 => output <= x12;
    -- when 13 => output <= x13;
    -- when 14 => output <= x14;
    -- when 15 => output <= x15;
    -- when 16 => output <= x16;
    -- when 17 => output <= x17;
    -- when 18 => output <= x18;
    -- when 19 => output <= x19;
    -- when 20 => output <= x20;
    -- when 21 => output <= x21;
    -- when 22 => output <= x22;
    -- when 23 => output <= x23;
    -- when 24 => output <= x24;
    -- when 25 => output <= x25;
    -- when 26 => output <= x26;
    -- when 27 => output <= x27;
    -- when 28 => output <= x28;
    -- when 29 => output <= x29;
    -- when 30 => output <= x30;
    -- when 31 => output <= x31;


end behavioral;