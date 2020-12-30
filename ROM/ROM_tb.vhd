library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
----------------------------------------------------------------------------------
entity ROM_tb is
    end ROM_tb;
----------------------------------------------------------------------------------   
architecture testbench of ROM_tb is

component ROM
     port (ROM_in : in std_logic_vector (3 downto 0);
          ROM_out: out std_logic_vector (7 downto 0));
    end component;
    ------Signal Declaration:------
   signal ROM_in_tb : std_logic_vector (3 downto 0);
   signal ROM_out_tb : std_logic_vector (7 downto 0);
begin
 
     ------ DUT Instantiation:------
    dut: ROM Port map(ROM_in => ROM_in_tb, ROM_out => ROM_out_tb);   

     ----- Stimuli Generation:------
   ROM_in_tb <=        "0000",
                       "0001" AFTER 3ns,
                       "0010" AFTER 6ns,
                       "0011" AFTER 9ns, 
                       "0100" AFTER 12ns,
                       "0101" AFTER 15ns,
                       "0110" AFTER 18ns,
                       "0111" AFTER 21ns,
                       "1000" AFTER 24ns,
                       "1001" AFTER 27ns,
                       "1010" AFTER 30ns,
                       "1011" AFTER 33ns,
                       "1100" AFTER 36ns,
                       "1101" AFTER 39ns,
                       "1110" AFTER 42ns,
                       "1111" AFTER 45ns;

end testbench;
----------------------------------------------------------------------------------