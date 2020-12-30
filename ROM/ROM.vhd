----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.std_logic_unsigned.ALL;
use IEEE.numeric_std.all;
----------------------------------------------------------------------------------
entity ROM is
    port (ROM_in : in std_logic_vector (3 downto 0); -- input 4 bit sequence from Programme Controller.
          ROM_out: out std_logic_vector (7 downto 0)); -- 8 bit output (Instruction/RAM address).
end entity ROM;
----------------------------------------------------------------------------------
architecture Behavioral of ROM is
      type rom_array is array (0 to 15) of std_logic_vector (7 downto 0);
         constant rom : rom_array := ( --Instruction/RAM address 4 bit each)
                   "11010000",
                   "10110001",
                   "00100010",
                   "00110011",
                   "11110100",
                   "00010101",
                   "11000110",
                   "10100111",
                   "01101000",
                   "11001001",
                   "01011010",
                   "10001011",
                   "10111100",
                   "11001101",
                   "11011110",
                   "11101111");
begin
    process (ROM_in)
       begin
           ROM_out <= rom(to_integer(unsigned(ROM_in))); -- output byte from ROM location
           end process; 
end architecture Behavioral;
----------------------------------------------------------------------------------
