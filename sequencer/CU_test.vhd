--------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--------------------------------------------------------
entity Data_path is
    Port (clock_sys, reset, Enable : in Std_logic; -- system control.
          --System_input : in std_logic_vector (7 downto 0); -- System data input.
          Output_F : out std_logic_vector (7 downto 0));-- System Output.
end Data_path;
--------------------------------------------------------
architecture Behavioral of Data_path is
--------------Connecting Signals------------------------
signal CU_to_PC : Std_logic;
signal CU_to_IR : Std_logic;
signal CU_to_Reset_PC : Std_logic;
signal CU_LoadDM : Std_logic;
signal CU_to_WeDM : Std_logic;
signal CU_to_CS : Std_logic;
signal CU_to_MAR : Std_logic;
signal CU_to_MDR : Std_logic;
signal CU_MDR_bus : Std_logic;
signal CU_load_Acc : Std_logic;
signal CU_load_Data_reg : Std_logic;
signal CU_ALU_Execute : Std_logic;
signal CU_Acc_bus : Std_logic;
signal CU_ACC_outSys : Std_logic;
signal CU_ALU_res : Std_logic;
signal CU_ALU_inc : Std_logic;
signal CU_ALU_add : Std_logic;
signal CU_ALU_sub : Std_logic;
signal CU_ALU_mul : Std_logic;
signal CU_ALU_shl : Std_logic;
signal CU_ALU_shr : Std_logic;
signal CU_ALU_xor : Std_logic;
signal PC_to_ROM : Std_logic_vector(3 downto 0);
signal ROM_to_IR : Std_logic_vector(7 downto 0);
signal IR_to_CU : Std_logic_vector(3 downto 0); --opcode
signal IR_to_RAM : Std_logic_vector(7 downto 0); --ram address/data
signal RAM_to_ALU : Std_logic_vector(7 downto 0);
signal ALU_to_DM : Std_logic_vector(7 downto 0);
signal DM_to_RAM : Std_logic_vector(7 downto 0);
--------------Connecting Modules------------------------
begin
   CU: entity work.sequencer port map(clock => clock_sys,
                                      reset => reset,
                                      Enable => Enable,
                                      opcode =>IR_to_CU,
                                      load_Acc => CU_load_Acc,
                                      load_Data_reg => CU_load_Data_reg,
                                      ALU_Execute => CU_ALU_Execute,
                                      Acc_bus => CU_Acc_bus,
                                      ACC_outSys => CU_ACC_outSys,
                                      load_IR => CU_to_IR,
                                      load_MAR => CU_to_MAR,
                                      MDR_bus => CU_MDR_bus,
                                      load_MDR => CU_to_MDR,
                                      loadDM => CU_loadDM,
                                      CS => CU_to_CS,
                                      WeDM => CU_to_WeDM,
                                      INC_PC => CU_to_PC,
                                      Reset_PC => CU_to_Reset_PC,
                                      ALU_res => CU_ALU_res,
                                      ALU_inc => CU_ALU_inc,
                                      ALU_add => CU_ALU_add,
                                      ALU_sub => CU_ALU_sub,
                                      ALU_mul => CU_ALU_mul,
                                      ALU_shl => CU_ALU_shl,
                                      ALU_shr => CU_ALU_shr,
                                      ALU_xor => CU_ALU_xor);

   PC: entity work.PC port map(clock => clock_sys,
                                 reset_PC => reset,
                                 Inc => CU_to_PC,
                                 ROM_addr => PC_to_ROM); -- PC count "xxxx" to the ROM input
                                 
   ROM: entity work.ROM port map(ROM_in =>PC_to_ROM,
                                 ROM_out => ROM_to_IR);-- Output of the PC to the ROM and output connect to the Instruction Register.
   -- IR connected to the output of ROM and spliting between Opcode and RAM
   
   IR: entity work.IR port map(clock => clock_sys,
                                 reset => reset,
                                 Load_IR => CU_to_IR,
                                 Data_ROM => ROM_to_IR,
                                 Operand => IR_to_CU,
                                 RAM_addr => IR_to_RAM);
                                 
end Behavioral;
--------------------------------------------------------