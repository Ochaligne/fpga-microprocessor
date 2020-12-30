----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
----------------------------------------------------------------------------------
entity ALU is
  Port (clock : in std_logic; -- System Clock.
        ALU_in : in std_logic_vector(7 downto 0); -- ALU Data input.
        load_Acc, load_Data_reg, ALU_Execute, Acc_bus: in std_logic;-- ALU data control code: ALU_in to Acc, ALU_in to Data_reg, ALU operation to Acc, Acc to ALU_out
        ALU_res, ALU_inc, ALU_add, ALU_sub, ALU_mul, ALU_shl, ALU_shr, ALU_xor: in std_logic; -- ALU Operation requests.
        ALU_out : out std_logic_vector(7 downto 0); -- Data register input.
        data_reg_out : out std_logic_vector(8 downto 0); -- for testing
        output_ovr : out integer; -- for testing
        ZFL, OVR, AED : out std_logic); -- Flags: Zero, Overload, Acc = Data_Reg.
end ALU;
----------------------------------------------------------------------------------
architecture Behavioral of ALU is
signal Acc: unsigned(8 downto 0); -- Accumulator register.
signal output_Over : integer; -- Acc conversion to integer for Overflow.
signal Data_reg : unsigned(8 downto 0); -- Data register input.
 
------------Arithmetic/Logic Operations-------------------------------------------
begin

   Data_reg <= unsigned('0' & ALU_in) when load_Data_reg ='1'; --data input to Data register
 
    process (clock) is
    begin
     if ALU_res ='1' then
        Acc <= "000000000"; -- RES 0
     elsif rising_edge(clock) then
        if load_Acc = '1' then 
           Acc <= unsigned('0' & ALU_in); --data input to Accumulator
        elsif ALU_Execute = '1' then 
                if ALU_inc ='1' then
                    Acc <= (Acc + 1); -- INC 1
                elsif ALU_add ='1' then
                    Acc <= (Acc + Data_reg); -- ADD 2
                elsif ALU_sub ='1' then
                    Acc <= (Acc - Data_reg); -- SUB 3
                elsif ALU_mul ='1' then
                   Acc <= resize(Acc * Data_reg,9); -- MUL 4
                elsif ALU_shl ='1' then
                  Acc <= (Acc sll to_integer(Data_reg)); -- SHL 5
                elsif ALU_shr ='1' then
                Acc <= (Acc srl to_integer(Data_reg)); -- SHR 6
                elsif ALU_xor ='1' then
                    Acc <= Acc XOR Data_reg; -- XOR 8
                end if;
               end if;                       
            end if;
      end process; 
ALU_out <= std_logic_vector(Acc(7 downto 0)) when ACC_bus = '1'; 
-------------Flags Operations-----------------------------------------------------                          
ZFL <= '1' when Acc = "00000000" else '0'; -- Zero in Acc flag.
AED <= '1' when Acc = Data_reg else '0'; -- Acc = Data_reg flag.
output_Over <= to_integer(Acc); 
output_ovr <= output_Over; -- for testing
data_reg_out <= std_logic_vector(Data_reg); -- for testing
OVR <= '1' when output_Over > 255 -- Overload flag 
    else '0';
----------------------------------------------------------------------------------
end architecture Behavioral;
