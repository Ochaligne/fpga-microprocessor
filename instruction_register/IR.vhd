----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

----------------------------------------------------------------------------------
entity IR is
    Port (clock, reset: in Std_logic;
          Load_IR : in Std_logic;
          Data_ROM : in Std_logic_vector(7 downto 0); -- 8-bit Input data from the ROM
          Operand : out Std_logic_vector(3 downto 0); -- 4-bit Op Code output
          RAM_addr : out Std_logic_vector(3 downto 0));-- 4-bit RAM address.
end IR;
----------------------------------------------------------------------------------
architecture Behavioral of IR is

begin
    process (clock, reset) is
        begin
            if reset = '1' then -- if reset 0 the outputs
                Operand <= (others => '0');
                RAM_addr <= (others => '0');
            elsif rising_edge(clock) then
                if load_IR = '1' then -- if load the opcode output bits 7 to 4 from the input
                Operand <= Data_ROM(7 downto 4); 
                end if;
                RAM_addr <= Data_ROM(3 downto 0); -- always output the bits 3 to 0 from the input
            end if;
        end process;
end Behavioral;
----------------------------------------------------------------------------------
