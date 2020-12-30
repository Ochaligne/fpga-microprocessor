----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.std_logic_unsigned.ALL;
use IEEE.numeric_std.all;
----------------------------------------------------------------------------------
entity Ram_tb is
end Ram_tb;
----------------------------------------------------------------------------------
------ DUT Declaration:------ 
architecture testbench OF Ram_tb is 
 
    component RAM
     port (clock, reset : in std_logic;
            MDR_bus, load_MDR, load_MAR, CS,
            WeDM : in std_logic;
            RAM_in_data : in std_logic_vector (7 downto 0);
            RAM_in_addr : in std_logic_vector (3 downto 0);
            RAM_out : out std_logic_vector (7 downto 0));
    end component;
    
    ------Signal Declaration:------
   signal WeDM_tb, load_MDR_tb, load_MAR_tb, CS_tb: std_logic:= '0';
   signal MDR_bus_tb : std_logic:= '0';
   signal clock_tb, reset_tb : std_logic := '0';
   signal RAM_in_addr_tb : std_logic_vector(3 downto 0);
   signal RAM_in_data_tb : std_logic_vector(7 downto 0);
   signal RAM_out_tb : std_logic_vector(7 downto 0);

begin
 
     ------ DUT Instantiation:------
    dut: RAM Port map(clock => clock_tb, reset => reset_tb, WeDM => WeDM_tb, MDR_bus => MDR_bus_tb, 
    load_MDR => load_MDR_tb, load_MAR => load_MAR_tb, CS => CS_tb, RAM_out=> RAM_out_tb, RAM_in_addr=> RAM_in_addr_tb, RAM_in_data=> RAM_in_data_tb);   

     ----- Stimuli Generation:------
   clock_tb <= NOT clock_tb AFTER 5ns;
   stim_proc: process -- After reset switch input every 10ns
begin 
-------------------- write data to memory location 1
    reset_tb <='1';
        wait for 10ns;
    reset_tb <='0';
        wait for 10ns;
    RAM_in_addr_tb <="0001"; -- set address index in bus
        wait for 10ns;
    load_MAR_tb <= '1'; -- load address to MAR
        wait for 10ns;
    load_MAR_tb <= '0';
        wait for 10ns;
    RAM_in_data_tb <= x"07"; -- set data to write in bus
        wait for 10ns;
    WeDM_tb  <= '1';
    load_MDR_tb <= '1'; -- load data to MDR
        wait for 10ns;
    load_MDR_tb <= '0';
        wait for 10ns;
    CS_tb <= '1'; -- write MDR to memory(mar) location.
        wait for 10ns;
    CS_tb <= '0';
    WeDM_tb  <= '0';
    RAM_in_data_tb <="00000000"; -- reset the bus
    RAM_in_addr_tb <="0000"; -- reset address index in bus
        wait for 20ns;

-------------------- read data from memory location 1   
    RAM_in_addr_tb <="0001"; -- set address index in bus
        wait for 10ns;
    load_MAR_tb <= '1'; -- load address to MAR
        wait for 10ns;
    load_MAR_tb <= '0';
    RAM_in_data_tb <="00000000"; -- reset bus to wait for read data
        wait for 10ns;
    WeDM_tb <= '0'; -- set RAM to read
        wait for 10ns;
    CS_tb <= '1'; -- read from memory(mar) location to mdr.
        wait for 10ns;
    CS_tb <= '0'; -- Close RAM
        wait for 10ns;
    MDR_bus_tb <= '1'; -- send mdr to sysbus
        wait for 10ns;
    MDR_bus_tb <= '0'; -- close mdr to sysbus
           
    end process;
end testbench;
----------------------------------------------------------------------------------
