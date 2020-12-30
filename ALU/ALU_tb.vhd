----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

----------------------------------------------------------------------------------
entity ALU_tb is
end ALU_tb;
----------------------------------------------------------------------------------
architecture testbench of ALU_tb is
------ DUT Declaration:------
    component ALU is
  Port (clock : in std_logic; -- System Clock.
            ALU_in : in std_logic_vector(7 downto 0); -- ALU Data input.
            load_Acc, load_Data_reg, ALU_Execute, Acc_bus: in std_logic;-- ALU data control code: sysbus to Acc, ALU operation to Acc, Acc to sysbus 
            ALU_res, ALU_inc, ALU_add, ALU_sub, ALU_mul, ALU_shl, ALU_shr, ALU_nand, ALU_xor, ALU_set: in std_logic; -- ALU Operation requests: Load_ Data_Reg, Load_Acc, Execute, Reset
            ALU_out : out std_logic_vector(7 downto 0); -- Data register input.
            output_ovr : out integer; -- data overflow output (for testing).
            data_reg_out : out std_logic_vector(8 downto 0); -- for testing
            ZFL, OVR, AED : out std_logic); -- Flags: Zero, Overload, Acc = Data_Reg.
      end component;
    ------Signal Declaration:------

    signal clock_tb : std_logic :='0'; -- System Clock.
    signal ALU_in_tb : std_logic_vector(7 downto 0):="00000011"; -- System Bus from/to system.
    signal ALU_out_tb : std_logic_vector(7 downto 0);  
    --signal Data_reg_tb : unsigned(7 downto 0);--  Data reg input.
    signal load_Acc_tb, load_Data_reg_tb, ALU_Execute_tb, Acc_bus_tb: std_logic:='0';-- ALU data control code: sysbus to Acc, ALU operation to Acc, Acc to sysbus 
    signal ALU_res_tb, ALU_inc_tb, ALU_add_tb, ALU_sub_tb, ALU_mul_tb, ALU_shl_tb, ALU_shr_tb, ALU_nand_tb, ALU_xor_tb, ALU_set_tb: std_logic:='0'; -- ALU Operation requests
    signal ZFL_tb, OVR_tb, AED_tb : std_logic; -- Flags: Zero, Overload, Acc = Data_Reg.
    signal output_ovr_tb: integer;
    signal data_reg_out_tb: std_logic_vector(8 downto 0);
begin
    ------ DUT Instantiation:------
        dut: ALU Port map (clock => clock_tb, ALU_out => ALU_out_tb, ALU_in => ALU_in_tb, load_Data_reg => load_Data_reg_tb, load_Acc => load_Acc_tb, ALU_Execute => ALU_Execute_tb, Acc_bus => Acc_bus_tb, 
        ALU_res => ALU_res_tb, ALU_inc => ALU_inc_tb, ALU_add => ALU_add_tb, ALU_sub => ALU_sub_tb, ALU_mul => ALU_mul_tb, ALU_shl => ALU_shl_tb, ALU_shr => ALU_shr_tb,
        ALU_nand => ALU_nand_tb, ALU_xor => ALU_xor_tb, ALU_set => ALU_set_tb, ZFL => ZFL_tb, OVR => OVR_tb, AED => AED_tb, output_ovr=> output_ovr_tb, data_reg_out => data_reg_out_tb);
    ------ Stimuli Generation:------
        clock_tb <= not clock_tb after 5ns;
       
    stim_proc: process -- After reset switch input every 10ns
        begin
           ACC_bus_tb <= '1';
           load_Acc_tb <= '1';
            wait for 1 ns;
           load_Acc_tb <= '0';
           load_Data_reg_tb <= '1';
             wait for 10 ns;
           load_Data_reg_tb <= '0';
             wait for 10 ns;
           load_Acc_tb <= '1';
             wait for 10 ns;
            ---Start Calculations----- 
           ALU_Execute_tb <= '1';    
           ALU_inc_tb <= '1';
             wait for 10 ns;
           ALU_inc_tb <= '0';
             wait for 1 ns;
            ALU_add_tb <= '1'; 
             wait for 10 ns;
           ALU_add_tb <= '0';
              wait for 1 ns;
           ALU_sub_tb <= '1'; 
             wait for 10 ns;
           ALU_sub_tb <= '0';    
             wait for 1 ns;
           ALU_mul_tb <= '1'; 
             wait for 10 ns;
           ALU_mul_tb <= '0';
              wait for 1 ns;
           ALU_shl_tb <= '1'; 
             wait for 10 ns;
           ALU_shl_tb <= '0';
             wait for 1 ns; 
           ALU_shr_tb <= '1'; 
             wait for 10 ns;
           ALU_shr_tb <= '0';
             wait for 1 ns;
           ALU_nand_tb <= '1'; 
             wait for 10 ns;
           ALU_nand_tb <= '0';
             wait for 1 ns; 
           ALU_xor_tb <= '1'; 
             wait for 10 ns;
           ALU_xor_tb <= '0';
            wait for 1 ns;
           ALU_res_tb <= '1'; -- reset on
            wait for 10 ns;
           ALU_res_tb <= '0'; -- reset off
            wait for 1 ns;
          ALU_set_tb <= '1'; 
           wait for 10 ns;
          ALU_set_tb <= '0';       
           wait for 1 ns;
              wait;  
        end process;
end testbench;
----------------------------------------------------------------------------------
