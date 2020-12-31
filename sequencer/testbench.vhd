--------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--------------------------------------------------------
entity Data_path_tb is
--  Port ( );
end Data_path_tb;
--------------------------------------------------------
architecture testbench of Data_path_tb is
component Data_path is
  Port (clock_sys, reset, Enable : in Std_logic; -- system control.
          --System_input : in std_logic_vector (7 downto 0); -- System data input.
          Output_F : out std_logic_vector (7 downto 0));
      end component;
------Signal Declaration:------
      
          signal clock_sys_tb : std_logic :='0'; -- System Clock.
          signal reset_tb : std_logic :='0';
          signal Enable_tb : std_logic :='0';
          signal System_input_tb :  std_logic_vector (7 downto 0);
          signal Output_F_tb :  std_logic_vector (7 downto 0);
begin

      ------ DUT Instantiation:------
  dut: Data_path Port map(clock_sys => clock_sys_tb, reset => reset_tb, Output_F => Output_F_tb, Enable => Enable_tb);    

   
clock_sys_tb <= not clock_sys_tb after 5 ns;
reset_tb <= '1' after 1ns, '0' after 6ns;

  stim_proc: process 
    begin
        Enable_tb <= '1';
           wait for 5 ns;
 
      end process;
      
end architecture testbench;
--------------------------------------------------------