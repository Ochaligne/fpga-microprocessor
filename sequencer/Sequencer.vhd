----------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
----------------------------------------------------------------------------------
entity sequencer is
port (clock, reset, Enable : in std_logic; -- system controls
      opcode: in Std_logic_vector(3 downto 0); -- Op code input from IR
      load_Acc, load_Data_reg, ALU_Execute, Acc_bus, ACC_outSys, -- Control Outputs
      load_IR, load_MAR, MDR_bus, load_MDR, loadDM,CS, WeDM, INC_PC, Reset_PC, ALU_res, -- Control Outputs
      ALU_inc, ALU_add, ALU_sub, ALU_mul, ALU_shl, ALU_shr, ALU_xor : out std_logic);-- Arithmetic Outputs
 
end entity sequencer;
----------------------------------------------------------------------------------
architecture Behavior of sequencer is
        type state is (s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14); -- Programme states
        signal present_state, next_state : state;
begin
    sequence : process (clock, reset) is ------------------------------ Sequencer
    begin
        if reset = '1' then
            present_state <= s0;
        elsif rising_edge(clock) then
            present_state <= next_state;
        end if;
    end process sequence;
---------------------------------------------------------------------------------- 
    programme : process (Enable, present_state, opcode) is ------------ Application Programme
    variable count : integer range 0 TO 255;
    variable Calculation_Cycle: integer range 0 TO 255;
    begin
       if Enable <='1' then
       ACC_bus <= '0';
       ACC_outSys <= '0';
       load_ACC <= '0';
       load_Data_reg <= '0';
       load_IR <= '0';
       load_MAR <= '0';
       loadDM <='0';
       MDR_bus <= '0';
       load_MDR <= '0';
       ALU_Execute <= '0';
       INC_PC <= '0';
       CS <= '0';
       WeDM <= '0';
       ALU_res <= '0';
       ALU_inc <= '0';
       ALU_add <= '0';
       ALU_sub <= '0';
       ALU_mul <= '0';
       ALU_shl <= '0';
       ALU_shr <= '0';
       ALU_xor <= '0';
       Reset_PC <= '0';
       ALU_res <= '0';  
        case present_state is
            when s0 => -- Reset state
            Reset_PC <= '1';
            ALU_res <= '1';
            count := 0;
            Calculation_Cycle:= 0; 
            next_state <= s1;
            when s1 =>
                Load_MAR <='1';
                load_IR  <='1';
                next_state <= s2;
            when s2 =>
                
                if opcode = "1101" then -- STE writing to RAM actions. 
                    loadDM <='1'; -- load data from data_mux - RAM allocation according to ROM address:{ROM 0:V, ROM 1:W, ROM 2:X, ROM 3:Y, ROM 4:Z)
                    WeDM  <='1';-- Enable writting.
                    CS  <='1';-- Activate RAM.
                    next_state <= s3;
                elsif opcode = "1100" then --STA writing to RAM actions.
                      Acc_bus <='1'; -- From ROM 8 and PC is 1 - go to ram address in ROM 6 and Store result of :"(W plus Z)/2"
                      
                      next_state <= s3;
                elsif opcode = "1010" then -- LDA reading from RAM actions.
                    if Calculation_cycle = 0 then
                         Reset_PC <='1'; -- PC is 0                                                                  
                         CS <= '1'; -- Activate RAM
                         next_state <= s5;
                     end if;
                elsif opcode = "1011" then -- LDD reading from RAM actions.
                    next_state <= s5;
                else
                    next_state <= s8; 
                end if;
            when s3 => -- Store.
                if opcode = "1101" then -- if STE - ROM location 0 -> Store External Data to RAM.
                    load_MDR <='1'; -- load data from RAM_data_in to MDR
                    if count = 5 then 
                      WeDM  <='1';-- Enable writting.
                      CS  <='1';-- Activate RAM.
                      count := 0; 
                      next_state <= s1;  
                    else
                      next_state <= s4;
                    end if;  
                elsif opcode = "1100" then -- if STA - ROM location 6 or 7 -> Store Acc to RAM. 
                   -- Store "00000001" from Acc in RAM address according to ROM 6. 
                     if count = 1 and Calculation_Cycle = 0  then 
                        Acc_bus <='1'; 
                        load_MDR <='1';
                        next_state <= s14;
                  -- From ROM 0 and PC is 0 - go to ram address in ROM 8 and Store result of :"(W plus Z)/2" 
                      elsif Calculation_Cycle = 2  then
                        Acc_bus <='1'; 
                        load_MDR <='1';
                        Reset_PC <='1';
                        next_state <= s14; 
                       else
                          next_state <= s4;
                     end if;
                 end if;
            when s4 => -- increment PC and load address to RAM
                INC_PC <='1';
                Load_MAR <='1';
                count := count + 1;
                next_state <= s2;
            when s5 => -- Load.
                 if opcode = "1010" then -- if LDA - ROM location 7 -> Load Acc from Data RAM.
                    -- go to ram address in ROM 1 and load W
                    if count = 3 and Calculation_Cycle = 0 then                                 
                       CS <='1';
                       count := 0;
                       Reset_PC <= '1';
                       next_state <= s11; 
                    elsif count = 3 and Calculation_Cycle = 1 then
                     -- go to ram address in ROM 2 and load X
                       load_ACC <= '1';
                       count := 0;
                       Reset_PC <= '1';
                       INC_PC <= '1';
                       next_state <= s1;  
                    else
                        next_state <= s12;  -- to Load Counter/Selector 
                    end if;
                elsif opcode = "1011" then -- if LDD - ROM location 1 -> Load Data_reg from Data RAM.
                    -- go to ram address in ROM 4 and load Z
                    if count = 4 and Calculation_Cycle = 0 then     
                      CS <='1';                             
                      count := 0;                                           
                      Reset_PC <='1';
                      next_state <= s13; -- to RAM_out->ALU_in->Data_reg
                    elsif count = 6 and Calculation_Cycle = 1 then -- go to ram address in ROM 6 and load "00000001" (in calculation cycle 1)
                      CS <='1';                             
                      count := 0;                                           
                      next_state <= s13; -- to RAM_out->ALU_in->Data_reg
        --Still to be Debugged            
        --            elsif count = 3 and Calculation_Cycle =2 then  
        --            -- go to ram address in ROM 3 and load Y   
        --              load_Data_reg <= '1';
        --              count := 0;
        --              next_state <= s1;
        --            elsif count = 4 and Calculation_Cycle =3 then -- PC is 1 - go to ram address in ROM 5 and load "00000001" (in calculation cycle 2)
        --              load_Data_reg <= '1';
        --              count := 0;
        --              INC_PC <='1';
        --              next_state <= s9;
        --            elsif count = 5 and Calculation_Cycle =4 then -- PC is 1 - go to ram address in ROM 9 and load "(W+Z)/2" (in calculation cycle 3)
        --                load_Data_reg <= '1';
        --                count := 0;
        --               INC_PC <='1'; 
        --                next_state <= s9; -- PC is 7                       
        --            elsif Calculation_Cycle = 5 then -- PC is 1 - go to ram address in ROM 0 and load "V" (in calculation cycle 4)
        --                Reset_PC <='1';
        --               Load_MAR <='1';
        --                load_Data_reg <= '1';
        --                INC_PC <='1';
        --                next_state <= s9; -- PC is 1 
                    else
                      next_state <= s4; 
                    end if;
                end if;
            when s6 =>
                    INC_PC <='1'; -- LDD-ROM 1 
                    -- go to ram address in ROM 6 and load "00000001"
                    next_state <= s1;
            when s7 =>
         --Still to be debugged
         --         --Load_IR <='1'; --STA-ROM 9
         --         Reset_PC <='1';
         --         next_state <= s2;
            when s8 => -- Calculations Selection/ALU opcode interpretation.
               ALU_Execute <= '1';
                   if opcode = "0001" then -- ROM location 5
                        ALU_inc <= '1';
                        INC_PC <='1';
                        next_state <= s1;
                   elsif opcode = "0010" then -- ROM location 2 
                        ALU_add <= '1';
                        Reset_PC <= '1'; -- Reset to send to LDD-ROM 1
                        Calculation_Cycle := Calculation_Cycle +1; -- calculation cycle 0 "(W+Z)" done
                        next_state <= s6;
                   elsif opcode = "0110" then -- ROM location 8
                        ALU_shr <= '1';
                        Calculation_Cycle := Calculation_Cycle +1; -- calculation cycle 1 "(W+Z)/2" done.
                        INC_PC <='1';
                        next_state <= s1; 
       --Still to be Debugged 
       --            elsif opcode = "0011" then -- ROM location 3
       --                 ALU_sub <= '1';
       --                Reset_PC <= '1';
       --                 Calculation_Cycle := Calculation_Cycle +1; -- calculation cyle 2 "(X-Y)" done.
       --                 next_state <= s1;
       --            elsif opcode = "0100" then -- ROM location 11
       --                ALU_mul <= '1';
       --                 Calculation_Cycle := Calculation_Cycle +1; -- calculation cyle 5 "([(X-Y)*2] XOR [(W+Z)/2])*V" done.
       --                 next_state <= s10;
       --            elsif opcode = "0101" then -- ROM location 9
       --                 ALU_shl <= '1';
       --                 Reset_PC <= '1';
       --                 Calculation_Cycle := Calculation_Cycle +1; -- calculation cycle 3 "(X-Y)*2" done.
       --                 next_state <= s1;
       --            elsif opcode = "1000"  then -- ROM location 10
       --                ALU_xor <= '1';
       --                Calculation_Cycle := Calculation_Cycle +1; -- calculation cycle 4 "[(X-Y)*2] XOR [(W+Z)/2]" done.
       --                 Reset_PC <= '1';
       --                 next_state <= s1;
                   else
                        INC_PC <='1';
                        next_state <= s1;
                   end if;
            when s9 => -- PC is 6 (in calculation cycle 3) - PC is 7 (in calculation cycle 4)
        --Still to be Debugged   
        --        if count = 3 and (Calculation_Cycle = 2 or Calculation_Cycle = 3) then -- PC 6 -> 9. -- PC 7 -> 10.
        --           count := 0;
        --           next_state <= s1; -- Load SHL in ROM 9 -- Load XOR in ROM 10.
        --        elsif count = 10 and Calculation_Cycle = 4 then -- PC is 1 (in calculation cycle 4)
        --           count := 0;
        --           next_state <= s1; -- Load MUL in ROM 11.       
        --        else
        --          count := count +1; 
        --          next_state <= s11;
        --        end if;
            when s10 => -- Acc -> Output F
        --        ACC_bus <= '1';
        --        ACC_outSys <= '1';
            when s11 => -- MDR to RAM output to Acc.
                 count := 0;
                 MDR_bus <= '1';  
                 load_ACC <= '1';
                 INC_PC <='1';                                 
                 next_state <= s1;                              
            when s12 => -- Load Counter/Selector. 
                 INC_PC <='1';
                 Load_MAR <='1';
                 count := count + 1;
                 next_state <= s5;
            when s13 => -- MDR to RAM output to Data_Reg.
                  count := 0;
                  MDR_bus <= '1';  
                  load_Data_reg <= '1';
                  INC_PC <='1';
                  if Calculation_Cycle = 0 then                               
                    next_state <= s8; -- send to calculations selection to hit the INC_PC
                  elsif Calculation_Cycle = 1 then 
                    next_state <= s1;
                  end if;
            when s14 => -- write to ram
                  WeDM  <='1';-- Enable writting.
                  CS  <='1';-- Activate RAM.
                  next_state <= s1;     -- In Calculation Cycle 2 this is the point where debugging stopped
         end case;
        end if;
    end process programme;
end architecture Behavior;
----------------------------------------------------------------------------------
