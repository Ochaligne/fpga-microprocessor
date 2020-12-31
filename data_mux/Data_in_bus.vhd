----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
----------------------------------------------------------------------------------
entity Data_in_bus is
    Port (LoadDM, clock, ACC_outSys : in Std_logic; -- Load data control
          Ext_Data_in : in Std_logic_vector (7 downto 0); -- Input exterior to system
          Acc_in : in Std_logic_vector (7 downto 0); -- Input from the Accumulator
          DM_out : out Std_logic_vector (7 downto 0); -- Mux Output to RAM.
          F : out Std_logic_vector (7 downto 0)); -- Mux Output to System output.
end Data_in_bus;
----------------------------------------------------------------------------------
architecture Behavioral of Data_in_bus is

begin
    process (clock) is
        begin
            if rising_edge(clock)then
                if LoadDM ='1' then -- Load the data to the system
                  DM_out <= Ext_Data_in;
                elsif ACC_outSys ='1' then -- If Calculations finished sent to system output
                  F <= Acc_in;  -- Load the Accumulator
                else
                  DM_out <= Acc_in;  -- Load the Accumulator
                end if;
             end if;
    end process;
end Behavioral;
----------------------------------------------------------------------------------