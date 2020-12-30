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

entity IR_tb is

end IR_tb;

architecture testbench of IR_tb is

component IR
     port(clock, reset: in Std_logic;
          Load_IR : in Std_logic;
          Data_ROM : in Std_logic_vector(7 downto 0);
          Operand : out Std_logic_vector(3 downto 0);
          RAM_addr : out Std_logic_vector(3 downto 0));
    end component;
    ------Signal Declaration:------
        signal clock_tb, reset_tb: Std_logic:='0';
        signal Load_IR_tb : Std_logic:='0';
        signal Data_ROM_tb : Std_logic_vector(7 downto 0):="00000000";
        signal Operand_tb : Std_logic_vector(3 downto 0);
        signal RAM_addr_tb : Std_logic_vector(3 downto 0);

begin

     ------ DUT Instantiation:------
    dut: IR Port map(clock => clock_tb, reset => reset_tb, Load_IR => Load_IR_tb, Data_ROM => Data_ROM_tb, Operand => Operand_tb, RAM_addr => RAM_addr_tb);   

     ----- Stimuli Generation:------
        clock_tb <= NOT clock_tb AFTER 5ns;
        
        stim_proc: process -- After reset switch input every 10ns
     begin 
     -------------------- write data to memory location 1
             for i in 0 to 14 loop
                 Data_ROM_tb <= Data_ROM_tb + "00010001"; -- set address index in bus
                     wait for 10ns;
                 Load_IR_tb <='1'; -- put to '0' to test ram output only.
                     wait for 10ns;
                 end loop;
       --Load_IR_tb <='0';
       reset_tb <='1';
          wait for 10ns;
       reset_tb <='0';
          wait for 10ns;
      end process;
end testbench;