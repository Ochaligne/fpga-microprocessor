library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.ALL;
use IEEE.numeric_std.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PC_tb is

end PC_tb;

architecture testbench of PC_tb is

component PC
     port(clock,reset_PC : in Std_logic;
           Inc : in Std_logic;
           ROM_addr : out Std_logic_vector(3 downto 0));
    end component;
    ------Signal Declaration:------
        signal clock_tb, reset_PC_tb: Std_logic:='0';
        signal Inc_tb : Std_logic:='0';
        signal ROM_addr_tb :Std_logic_vector(3 downto 0);
   

begin
     ------ DUT Instantiation:------
    dut: PC Port map(clock => clock_tb, reset_PC => reset_PC_tb, Inc => Inc_tb, ROM_addr => ROM_addr_tb);   

     ----- Stimuli Generation:------
        clock_tb <= NOT clock_tb AFTER 5ns;
       
         stim_proc: process -- After reset switch input every 10ns
      begin 
      -------------------- write data to memory location 1
         reset_PC_tb <= '1';
            wait for 10 ns;
         reset_PC_tb <= '0';
            wait for 10 ns;  
         for i in 0 to 30 loop
             Inc_tb <= NOT Inc_tb;
                wait for 5 ns;
            -- Inc_tb <= '0'; 
            end loop;
            wait for 10 ns; 
       end process;
end testbench;