----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
----------------------------------------------------------------------------------
entity RAM is
    port (clock, reset : in std_logic; -- system control.
            MDR_bus, load_MDR, load_MAR, CS, -- Send mdr to RAM_out, load RAM_in to mdr, load RAM_in to mar, activate RAM.
            WeDM : in std_logic; -- Write enable.
            RAM_in_addr : in std_logic_vector (3 downto 0); -- RAM address input.
            RAM_in_data : in std_logic_vector (7 downto 0); -- RAM data input. 
            RAM_out : out std_logic_vector (7 downto 0));-- RAM output.
end entity RAM;
----------------------------------------------------------------------------------
architecture Behavioral of RAM is
    signal mdr : std_logic_vector(7 downto 0); -- 8-bit data register.
    signal mar : unsigned(3 downto 0); -- 4-bit address register.

begin
    RAM_out <= mdr when MDR_bus = '1' else (others => 'Z'); --MDR to bus activated send data register to RAM_out
    process (clock, reset) is
        type ram_array is array (0 to 15) of std_logic_vector(7 downto 0); -- 16x8 Memory
    variable mem: ram_array;
    begin
        if reset = '1' then -- When reset 0 both registers
            mdr <= (others => '0');
            mar <= (others => '0');
        elsif rising_edge(clock) then
            if load_MAR = '1' then -- RAM_in to address register
                mar <= unsigned(RAM_in_addr);
            elsif load_MDR = '1' then -- RAM_in to data register
                mdr <= RAM_in_data;
            elsif CS = '1' then -- If ram activated
                if WeDM = '1' then -- write is enable ->write data register to memory location indicated by address register.
                    mem(to_integer(mar)) := mdr;
                else
                    mdr <= mem(to_integer(mar));  -- Read -> assign data from memory location indicated by address register to data register.
                end if;
           end if;
        end if;
    end process;
end Behavioral;
----------------------------------------------------------------------------------