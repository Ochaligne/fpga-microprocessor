----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
----------------------------------------------------------------------------------
entity PC is
    Port (clock,reset_PC : in Std_logic; -- system control
           Inc : in Std_logic; -- Increment the PC
           ROM_addr : out Std_logic_vector(3 downto 0)); -- PC 4-bit count output
end PC;
----------------------------------------------------------------------------------
architecture Behavioral of PC is
signal PC_count: unsigned(3 downto 0); -- 4-bit PC counter
begin
     process (clock, reset_PC) is
        begin
            if reset_PC = '1' then -- reset the PC to "0000"
                PC_count <= (others => '0');
                
             elsif rising_edge(clock) then
                if Inc = '1' then -- Increment trigger add "0001" to current count
                PC_count <= PC_count + "0001"; 
                end if;
            end if;
         end process;
ROM_addr <= Std_logic_vector(PC_count); -- output 4-bit sequence corresponding to ROM address.
end Behavioral;
----------------------------------------------------------------------------------

