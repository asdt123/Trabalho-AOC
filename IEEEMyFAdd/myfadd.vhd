--------------------------------------------------------------------------------
--                  RightShifterSticky26_by_max_25_comb_uid4
-- VHDL generated for DummyFPGA @ 0MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca (2008-2011), Florent de Dinechin (2008-2019)
--------------------------------------------------------------------------------
-- combinatorial
-- Clock period (ns): inf
-- Target frequency (MHz): 0
-- Input signals: X S
-- Output signals: R Sticky
--  approx. input signal timings: X: 2.250000nsS: 4.360000ns
--  approx. output signal timings: R: 5.460000nsSticky: 7.750000ns

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity RightShifterSticky26_by_max_25_comb_uid4 is
    port (X : in  std_logic_vector(25 downto 0);
          S : in  std_logic_vector(4 downto 0);
          R : out  std_logic_vector(25 downto 0);
          Sticky : out  std_logic   );
end entity;

architecture arch of RightShifterSticky26_by_max_25_comb_uid4 is
signal ps :  std_logic_vector(4 downto 0);
   -- timing of ps: 4.360000ns
signal Xpadded :  std_logic_vector(25 downto 0);
   -- timing of Xpadded: 2.250000ns
signal level5 :  std_logic_vector(25 downto 0);
   -- timing of level5: 2.250000ns
signal stk4 :  std_logic;
   -- timing of stk4: 4.950000ns
signal level4 :  std_logic_vector(25 downto 0);
   -- timing of level4: 4.360000ns
signal stk3 :  std_logic;
   -- timing of stk3: 5.520000ns
signal level3 :  std_logic_vector(25 downto 0);
   -- timing of level3: 4.910000ns
signal stk2 :  std_logic;
   -- timing of stk2: 6.080000ns
signal level2 :  std_logic_vector(25 downto 0);
   -- timing of level2: 4.910000ns
signal stk1 :  std_logic;
   -- timing of stk1: 6.640000ns
signal level1 :  std_logic_vector(25 downto 0);
   -- timing of level1: 5.460000ns
signal stk0 :  std_logic;
   -- timing of stk0: 7.200000ns
signal level0 :  std_logic_vector(25 downto 0);
   -- timing of level0: 5.460000ns
signal stk :  std_logic;
   -- timing of stk: 7.750000ns
begin
   ps<= S;
   Xpadded <= X;
   level5<= Xpadded;
   stk4 <= '1' when (level5(15 downto 0)/="0000000000000000" and ps(4)='1')   else '0';
   level4 <=  level5 when  ps(4)='0'    else (15 downto 0 => '0') & level5(25 downto 16);
   stk3 <= '1' when (level4(7 downto 0)/="00000000" and ps(3)='1') or stk4 ='1'   else '0';
   level3 <=  level4 when  ps(3)='0'    else (7 downto 0 => '0') & level4(25 downto 8);
   stk2 <= '1' when (level3(3 downto 0)/="0000" and ps(2)='1') or stk3 ='1'   else '0';
   level2 <=  level3 when  ps(2)='0'    else (3 downto 0 => '0') & level3(25 downto 4);
   stk1 <= '1' when (level2(1 downto 0)/="00" and ps(1)='1') or stk2 ='1'   else '0';
   level1 <=  level2 when  ps(1)='0'    else (1 downto 0 => '0') & level2(25 downto 2);
   stk0 <= '1' when (level1(0 downto 0)/="0" and ps(0)='1') or stk1 ='1'   else '0';
   level0 <=  level1 when  ps(0)='0'    else (0 downto 0 => '0') & level1(25 downto 1);
   stk <= stk0;
   R <= level0;
   Sticky <= stk;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_27_comb_uid6
-- VHDL generated for DummyFPGA @ 0MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- combinatorial
-- Clock period (ns): inf
-- Target frequency (MHz): 0
-- Input signals: X Y Cin
-- Output signals: R
--  approx. input signal timings: X: 2.250000nsY: 6.010000nsCin: 7.750000ns
--  approx. output signal timings: R: 9.010000ns

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_27_comb_uid6 is
    port (X : in  std_logic_vector(26 downto 0);
          Y : in  std_logic_vector(26 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(26 downto 0)   );
end entity;

architecture arch of IntAdder_27_comb_uid6 is
signal Rtmp :  std_logic_vector(26 downto 0);
   -- timing of Rtmp: 9.010000ns
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                              LZC_26_comb_uid8
-- VHDL generated for DummyFPGA @ 0MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Florent de Dinechin, Bogdan Pasca (2007)
--------------------------------------------------------------------------------
-- combinatorial
-- Clock period (ns): inf
-- Target frequency (MHz): 0
-- Input signals: I
-- Output signals: O
--  approx. input signal timings: I: 9.010000ns
--  approx. output signal timings: O: 12.930000ns

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity LZC_26_comb_uid8 is
    port (I : in  std_logic_vector(25 downto 0);
          O : out  std_logic_vector(4 downto 0)   );
end entity;

architecture arch of LZC_26_comb_uid8 is
signal level5 :  std_logic_vector(30 downto 0);
   -- timing of level5: 9.010000ns
signal digit4 :  std_logic;
   -- timing of digit4: 9.600000ns
signal level4 :  std_logic_vector(14 downto 0);
   -- timing of level4: 10.150000ns
signal digit3 :  std_logic;
   -- timing of digit3: 10.720000ns
signal level3 :  std_logic_vector(6 downto 0);
   -- timing of level3: 11.270000ns
signal digit2 :  std_logic;
   -- timing of digit2: 11.830000ns
signal level2 :  std_logic_vector(2 downto 0);
   -- timing of level2: 12.380000ns
signal lowBits :  std_logic_vector(1 downto 0);
   -- timing of lowBits: 12.930000ns
signal outHighBits :  std_logic_vector(2 downto 0);
   -- timing of outHighBits: 11.830000ns
begin
   -- pad input to the next power of two minus 1
   level5 <= I & "11111";
   -- Main iteration for large inputs
   digit4<= '1' when level5(30 downto 15) = "0000000000000000" else '0';
   level4<= level5(14 downto 0) when digit4='1' else level5(30 downto 16);
   digit3<= '1' when level4(14 downto 7) = "00000000" else '0';
   level3<= level4(6 downto 0) when digit3='1' else level4(14 downto 8);
   digit2<= '1' when level3(6 downto 3) = "0000" else '0';
   level2<= level3(2 downto 0) when digit2='1' else level3(6 downto 4);
   -- Finish counting with one LUT
   with level2  select  lowBits <= 
      "11" when "000",
      "10" when "001",
      "01" when "010",
      "01" when "011",
      "00" when others;
   outHighBits <= digit4 & digit3 & digit2 & "";
   O <= outHighBits & lowBits ;
end architecture;

--------------------------------------------------------------------------------
--                     LeftShifter27_by_max_26_comb_uid10
-- VHDL generated for DummyFPGA @ 0MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca (2008-2011), Florent de Dinechin (2008-2019)
--------------------------------------------------------------------------------
-- combinatorial
-- Clock period (ns): inf
-- Target frequency (MHz): 0
-- Input signals: X S
-- Output signals: R
--  approx. input signal timings: X: 9.010000nsS: 14.520000ns
--  approx. output signal timings: R: 16.727692ns

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity LeftShifter27_by_max_26_comb_uid10 is
    port (X : in  std_logic_vector(26 downto 0);
          S : in  std_logic_vector(4 downto 0);
          R : out  std_logic_vector(52 downto 0)   );
end entity;

architecture arch of LeftShifter27_by_max_26_comb_uid10 is
signal ps :  std_logic_vector(4 downto 0);
   -- timing of ps: 14.520000ns
signal level0 :  std_logic_vector(26 downto 0);
   -- timing of level0: 9.010000ns
signal level1 :  std_logic_vector(27 downto 0);
   -- timing of level1: 14.520000ns
signal level2 :  std_logic_vector(29 downto 0);
   -- timing of level2: 15.531538ns
signal level3 :  std_logic_vector(33 downto 0);
   -- timing of level3: 15.531538ns
signal level4 :  std_logic_vector(41 downto 0);
   -- timing of level4: 16.727692ns
signal level5 :  std_logic_vector(57 downto 0);
   -- timing of level5: 16.727692ns
begin
   ps<= S;
   level0<= X;
   level1<= level0 & (0 downto 0 => '0') when ps(0)= '1' else     (0 downto 0 => '0') & level0;
   level2<= level1 & (1 downto 0 => '0') when ps(1)= '1' else     (1 downto 0 => '0') & level1;
   level3<= level2 & (3 downto 0 => '0') when ps(2)= '1' else     (3 downto 0 => '0') & level2;
   level4<= level3 & (7 downto 0 => '0') when ps(3)= '1' else     (7 downto 0 => '0') & level3;
   level5<= level4 & (15 downto 0 => '0') when ps(4)= '1' else     (15 downto 0 => '0') & level4;
   R <= level5(52 downto 0);
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_31_comb_uid13
-- VHDL generated for DummyFPGA @ 0MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- combinatorial
-- Clock period (ns): inf
-- Target frequency (MHz): 0
-- Input signals: X Y Cin
-- Output signals: R
--  approx. input signal timings: X: 16.727692nsY: 0.000000nsCin: 18.317692ns
--  approx. output signal timings: R: 19.617692ns

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_31_comb_uid13 is
    port (X : in  std_logic_vector(30 downto 0);
          Y : in  std_logic_vector(30 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(30 downto 0)   );
end entity;

architecture arch of IntAdder_31_comb_uid13 is
signal Rtmp :  std_logic_vector(30 downto 0);
   -- timing of Rtmp: 19.617692ns
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                          IEEEFPAdd_8_23_comb_uid2
-- VHDL generated for DummyFPGA @ 0MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Florent de Dinechin, Valentin Huguet (2016)
--------------------------------------------------------------------------------
-- combinatorial
-- Clock period (ns): inf
-- Target frequency (MHz): 0
-- Input signals: X Y
-- Output signals: R
--  approx. input signal timings: X: 0.000000nsY: 0.000000ns
--  approx. output signal timings: R: 21.277692ns

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IEEEFPAdd_8_23_comb_uid2 is
    port (X : in  std_logic_vector(31 downto 0);
          Y : in  std_logic_vector(31 downto 0);
          R : out  std_logic_vector(31 downto 0)   );
end entity;

architecture arch of IEEEFPAdd_8_23_comb_uid2 is
   component RightShifterSticky26_by_max_25_comb_uid4 is
      port ( X : in  std_logic_vector(25 downto 0);
             S : in  std_logic_vector(4 downto 0);
             R : out  std_logic_vector(25 downto 0);
             Sticky : out  std_logic   );
   end component;

   component IntAdder_27_comb_uid6 is
      port ( X : in  std_logic_vector(26 downto 0);
             Y : in  std_logic_vector(26 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(26 downto 0)   );
   end component;

   component LZC_26_comb_uid8 is
      port ( I : in  std_logic_vector(25 downto 0);
             O : out  std_logic_vector(4 downto 0)   );
   end component;

   component LeftShifter27_by_max_26_comb_uid10 is
      port ( X : in  std_logic_vector(26 downto 0);
             S : in  std_logic_vector(4 downto 0);
             R : out  std_logic_vector(52 downto 0)   );
   end component;

   component IntAdder_31_comb_uid13 is
      port ( X : in  std_logic_vector(30 downto 0);
             Y : in  std_logic_vector(30 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(30 downto 0)   );
   end component;

signal expFracX :  std_logic_vector(30 downto 0);
   -- timing of expFracX: 0.000000ns
signal expFracY :  std_logic_vector(30 downto 0);
   -- timing of expFracY: 0.000000ns
signal expXmExpY :  std_logic_vector(8 downto 0);
   -- timing of expXmExpY: 1.080000ns
signal expYmExpX :  std_logic_vector(8 downto 0);
   -- timing of expYmExpX: 1.080000ns
signal swap :  std_logic;
   -- timing of swap: 1.150000ns
signal newX :  std_logic_vector(31 downto 0);
   -- timing of newX: 1.700000ns
signal newY :  std_logic_vector(31 downto 0);
   -- timing of newY: 1.700000ns
signal expDiff :  std_logic_vector(8 downto 0);
   -- timing of expDiff: 1.700000ns
signal expNewX :  std_logic_vector(7 downto 0);
   -- timing of expNewX: 1.700000ns
signal expNewY :  std_logic_vector(7 downto 0);
   -- timing of expNewY: 1.700000ns
signal signNewX :  std_logic;
   -- timing of signNewX: 1.700000ns
signal signNewY :  std_logic;
   -- timing of signNewY: 1.700000ns
signal EffSub :  std_logic;
   -- timing of EffSub: 2.250000ns
signal xExpFieldZero :  std_logic;
   -- timing of xExpFieldZero: 2.250000ns
signal yExpFieldZero :  std_logic;
   -- timing of yExpFieldZero: 2.250000ns
signal xExpFieldAllOnes :  std_logic;
   -- timing of xExpFieldAllOnes: 2.250000ns
signal yExpFieldAllOnes :  std_logic;
   -- timing of yExpFieldAllOnes: 2.250000ns
signal xSigFieldZero :  std_logic;
   -- timing of xSigFieldZero: 2.250000ns
signal ySigFieldZero :  std_logic;
   -- timing of ySigFieldZero: 2.250000ns
signal xIsNaN :  std_logic;
   -- timing of xIsNaN: 2.800000ns
signal yIsNaN :  std_logic;
   -- timing of yIsNaN: 2.800000ns
signal xIsInfinity :  std_logic;
   -- timing of xIsInfinity: 2.800000ns
signal yIsInfinity :  std_logic;
   -- timing of yIsInfinity: 2.800000ns
signal xIsZero :  std_logic;
   -- timing of xIsZero: 2.800000ns
signal yIsZero :  std_logic;
   -- timing of yIsZero: 2.800000ns
signal bothSubNormals :  std_logic;
   -- timing of bothSubNormals: 2.800000ns
signal resultIsNaN :  std_logic;
   -- timing of resultIsNaN: 3.350000ns
signal significandNewX :  std_logic_vector(23 downto 0);
   -- timing of significandNewX: 2.250000ns
signal significandNewY :  std_logic_vector(23 downto 0);
   -- timing of significandNewY: 2.250000ns
signal allShiftedOut :  std_logic;
   -- timing of allShiftedOut: 2.770000ns
signal rightShiftValue :  std_logic_vector(4 downto 0);
   -- timing of rightShiftValue: 3.320000ns
signal shiftCorrection :  std_logic;
   -- timing of shiftCorrection: 2.800000ns
signal finalRightShiftValue :  std_logic_vector(4 downto 0);
   -- timing of finalRightShiftValue: 4.360000ns
signal significandY00 :  std_logic_vector(25 downto 0);
   -- timing of significandY00: 2.250000ns
signal shiftedSignificandY :  std_logic_vector(25 downto 0);
   -- timing of shiftedSignificandY: 5.460000ns
signal stickyLow :  std_logic;
   -- timing of stickyLow: 7.750000ns
signal summandY :  std_logic_vector(26 downto 0);
   -- timing of summandY: 6.010000ns
signal summandX :  std_logic_vector(26 downto 0);
   -- timing of summandX: 2.250000ns
signal carryIn :  std_logic;
   -- timing of carryIn: 7.750000ns
signal significandZ :  std_logic_vector(26 downto 0);
   -- timing of significandZ: 9.010000ns
signal z1 :  std_logic;
   -- timing of z1: 9.010000ns
signal z0 :  std_logic;
   -- timing of z0: 9.010000ns
signal lzcZInput :  std_logic_vector(25 downto 0);
   -- timing of lzcZInput: 9.010000ns
signal lzc :  std_logic_vector(4 downto 0);
   -- timing of lzc: 12.930000ns
signal leftShiftVal :  std_logic_vector(4 downto 0);
   -- timing of leftShiftVal: 14.520000ns
signal normalizedSignificand :  std_logic_vector(52 downto 0);
   -- timing of normalizedSignificand: 16.727692ns
signal significandPreRound :  std_logic_vector(22 downto 0);
   -- timing of significandPreRound: 16.727692ns
signal lsb :  std_logic;
   -- timing of lsb: 16.727692ns
signal roundBit :  std_logic;
   -- timing of roundBit: 16.727692ns
signal stickyBit :  std_logic;
   -- timing of stickyBit: 17.767692ns
signal deltaExp :  std_logic_vector(7 downto 0);
   -- timing of deltaExp: 12.930000ns
signal fullCancellation :  std_logic;
   -- timing of fullCancellation: 13.930000ns
signal expPreRound :  std_logic_vector(7 downto 0);
   -- timing of expPreRound: 14.000000ns
signal expSigPreRound :  std_logic_vector(30 downto 0);
   -- timing of expSigPreRound: 16.727692ns
signal roundUpBit :  std_logic;
   -- timing of roundUpBit: 18.317692ns
signal expSigR :  std_logic_vector(30 downto 0);
   -- timing of expSigR: 19.617692ns
signal resultIsZero :  std_logic;
   -- timing of resultIsZero: 20.727692ns
signal resultIsInf :  std_logic;
   -- timing of resultIsInf: 20.727692ns
signal constInf :  std_logic_vector(30 downto 0);
   -- timing of constInf: 0.000000ns
signal constNaN :  std_logic_vector(30 downto 0);
   -- timing of constNaN: 0.000000ns
signal expSigR2 :  std_logic_vector(30 downto 0);
   -- timing of expSigR2: 21.277692ns
signal signR :  std_logic;
   -- timing of signR: 21.277692ns
signal computedR :  std_logic_vector(31 downto 0);
   -- timing of computedR: 21.277692ns
begin

   -- Exponent difference and swap
   expFracX <= X(30 downto 0);
   expFracY <= Y(30 downto 0);
   expXmExpY <= ('0' & X(30 downto 23)) - ('0'  & Y(30 downto 23)) ;
   expYmExpX <= ('0' & Y(30 downto 23)) - ('0'  & X(30 downto 23)) ;
   swap <= '0' when expFracX >= expFracY else '1';
   newX <= X when swap = '0' else Y;
   newY <= Y when swap = '0' else X;
   expDiff <= expXmExpY when swap = '0' else expYmExpX;
   expNewX <= newX(30 downto 23);
   expNewY <= newY(30 downto 23);
   signNewX <= newX(31);
   signNewY <= newY(31);
   EffSub <= signNewX xor signNewY;
   -- Special case dectection
   xExpFieldZero <= '1' when expNewX="00000000" else '0';
   yExpFieldZero <= '1' when expNewY="00000000" else '0';
   xExpFieldAllOnes <= '1' when expNewX="11111111" else '0';
   yExpFieldAllOnes <= '1' when expNewY="11111111" else '0';
   xSigFieldZero <= '1' when newX(22 downto 0)="00000000000000000000000" else '0';
   ySigFieldZero <= '1' when newY(22 downto 0)="00000000000000000000000" else '0';
   xIsNaN <= xExpFieldAllOnes and not xSigFieldZero;
   yIsNaN <= yExpFieldAllOnes and not ySigFieldZero;
   xIsInfinity <= xExpFieldAllOnes and xSigFieldZero;
   yIsInfinity <= yExpFieldAllOnes and ySigFieldZero;
   xIsZero <= xExpFieldZero and xSigFieldZero;
   yIsZero <= yExpFieldZero and ySigFieldZero;
   bothSubNormals <=  xExpFieldZero and yExpFieldZero;
   resultIsNaN <=  xIsNaN or yIsNaN  or  (xIsInfinity and yIsInfinity and EffSub);
   significandNewX <= not(xExpFieldZero) & newX(22 downto 0);
   significandNewY <= not(yExpFieldZero) & newY(22 downto 0);

   -- Significand alignment
   allShiftedOut <= '1' when (expDiff >= 26) else '0';
   rightShiftValue <= expDiff(4 downto 0) when allShiftedOut='0' else CONV_STD_LOGIC_VECTOR(26,5) ;
   shiftCorrection <= '1' when (yExpFieldZero='1' and xExpFieldZero='0') else '0'; -- only other cases are: both normal or both subnormal
   finalRightShiftValue <= rightShiftValue - ("0000" & shiftCorrection);
   significandY00 <= significandNewY & "00";
   RightShifterComponent: RightShifterSticky26_by_max_25_comb_uid4
      port map ( S => finalRightShiftValue,
                 X => significandY00,
                 R => shiftedSignificandY,
                 Sticky => stickyLow);
   summandY <= ('0' & shiftedSignificandY) xor (26 downto 0 => EffSub);


   -- Significand addition
   summandX <= '0' & significandNewX & '0' & '0';
   carryIn <= EffSub and not stickyLow;
   fracAdder: IntAdder_27_comb_uid6
      port map ( Cin => carryIn,
                 X => summandX,
                 Y => summandY,
                 R => significandZ);

   -- Cancellation detection, renormalization (see explanations in IEEEFPAdd.cpp) 
   z1 <=  significandZ(26); -- bit of weight 1
   z0 <=  significandZ(25); -- bit of weight 0
   lzcZInput <= significandZ(26 downto 1);
   IEEEFPAdd_8_23_comb_uid2LeadingZeroCounter: LZC_26_comb_uid8
      port map ( I => lzcZInput,
                 O => lzc);
   leftShiftVal <= 
      lzc when ((z1='1') or (z1='0' and z0='1' and xExpFieldZero='1') or (z1='0' and z0='0' and xExpFieldZero='0' and lzc<=expNewX)  or (xExpFieldZero='0' and lzc>=26) ) 
      else (expNewX(4 downto 0)) when (xExpFieldZero='0' and (lzc < 26) and (("000"&lzc)>=expNewX)) 
       else "0000"&'1';
   LeftShifterComponent: LeftShifter27_by_max_26_comb_uid10
      port map ( S => leftShiftVal,
                 X => significandZ,
                 R => normalizedSignificand);
   significandPreRound <= normalizedSignificand(25 downto 3); -- remove the implicit zero/one
   lsb <= normalizedSignificand(3);
   roundBit <= normalizedSignificand(2);
   stickyBit <= stickyLow or  normalizedSignificand(1)or  normalizedSignificand(0);
   deltaExp <=    -- value to subtract to exponent for normalization
      "00000000" when ( (z1='0' and z0='1' and xExpFieldZero='0')
          or  (z1='0' and z0='0' and xExpFieldZero='1') )
      else "11111111" when ( (z1='1')  or  (z1='0' and z0='1' and xExpFieldZero='1'))
      else ("000" & lzc)-'1' when (z1='0' and z0='0' and xExpFieldZero='0' and lzc<=expNewX and lzc<26)      else expNewX;
   fullCancellation <= '1' when (lzc>=26) else '0';
   expPreRound <= expNewX - deltaExp; -- we may have a first overflow here
   expSigPreRound <= expPreRound & significandPreRound; 
   -- Final rounding, with the mantissa overflowing in the exponent  
   roundUpBit <= '1' when roundBit='1' and (stickyBit='1' or (stickyBit='0' and lsb='1')) else '0';
   roundingAdder: IntAdder_31_comb_uid13
      port map ( Cin => roundUpBit,
                 X => expSigPreRound,
                 Y => "0000000000000000000000000000000",
                 R => expSigR);
   -- Final packing
   resultIsZero <= '1' when (fullCancellation='1' and expSigR(30 downto 23)="00000000") else '0';
   resultIsInf <= '1' when resultIsNaN='0' and (((xIsInfinity='1' and yIsInfinity='1'  and EffSub='0')  or (xIsInfinity='0' and yIsInfinity='1')  or (xIsInfinity='1' and yIsInfinity='0')  or  (expSigR(30 downto 23)="11111111"))) else '0';
   constInf <= "11111111" & "00000000000000000000000";
   constNaN <= "1111111111111111111111111111111";
   expSigR2 <= constInf when resultIsInf='1' else constNaN when resultIsNaN='1' else expSigR;
   signR <= '0' when ((resultIsNaN='1'  or (resultIsZero='1' and xIsInfinity='0' and yIsInfinity='0')) and (xIsZero='0' or yIsZero='0' or (signNewX /= signNewY)) )  else signNewX;
   computedR <= signR & expSigR2;
   R <= computedR;
end architecture;

--------------------------------------------------------------------------------
--               TestBench_IEEEFPAdd_8_23_comb_uid2_comb_uid15
-- VHDL generated for DummyFPGA @ 0MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Florent de Dinechin, Cristian Klein, Nicolas Brunie (2007-2010)
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity TestBench_IEEEFPAdd_8_23_comb_uid2_comb_uid15 is
end entity;

architecture behavorial of TestBench_IEEEFPAdd_8_23_comb_uid2_comb_uid15 is
   component IEEEFPAdd_8_23_comb_uid2 is
      port ( X : in  std_logic_vector(31 downto 0);
             Y : in  std_logic_vector(31 downto 0);
             R : out  std_logic_vector(31 downto 0)   );
   end component;
signal X :  std_logic_vector(31 downto 0);
   -- timing of X: 0.000000ns
signal Y :  std_logic_vector(31 downto 0);
   -- timing of Y: 0.000000ns
signal R :  std_logic_vector(31 downto 0);
   -- timing of R: 0.000000ns
signal clk :  std_logic;
   -- timing of clk: 0.000000ns
signal rst :  std_logic;
   -- timing of rst: 0.000000ns

 -- converts std_logic into a character
   function chr(sl: std_logic) return character is
      variable c: character;
   begin
      case sl is
         when 'U' => c:= 'U';
         when 'X' => c:= 'X';
         when '0' => c:= '0';
         when '1' => c:= '1';
         when 'Z' => c:= 'Z';
         when 'W' => c:= 'W';
         when 'L' => c:= 'L';
         when 'H' => c:= 'H';
         when '-' => c:= '-';
      end case;
      return c;
   end chr;

   -- converts bit to std_logic (1 to 1)
   function to_stdlogic(b : bit) return std_logic is
       variable sl : std_logic;
   begin
      case b is 
         when '0' => sl := '0';
         when '1' => sl := '1';
      end case;
      return sl;
   end to_stdlogic;

   -- converts std_logic into a string (1 to 1)
   function str(sl: std_logic) return string is
    variable s: string(1 to 1);
    begin
      s(1) := chr(sl);
      return s;
   end str;

   -- converts std_logic_vector into a string (binary base)
   -- (this also takes care of the fact that the range of
   --  a string is natural while a std_logic_vector may
   --  have an integer range)
   function str(slv: std_logic_vector) return string is
      variable result : string (1 to slv'length);
      variable r : integer;
   begin
      r := 1;
      for i in slv'range loop
         result(r) := chr(slv(i));
         r := r + 1;
      end loop;
      return result;
   end str;

   -- test isZero
   function iszero(a : std_logic_vector) return boolean is
   begin
      return	a = (a'high downto 0 => '0');
   end;

   -- FP IEEE compare function (found vs. real)
   function fp_equal_ieee(a : std_logic_vector; b : std_logic_vector; we : integer; wf : integer) return boolean is
   begin
      if a(wf+we downto wf) = b(wf+we downto wf) and b(we+wf-1 downto wf) = (we downto 1 => '1') then
         if iszero(b(wf-1 downto 0)) then return  iszero(a(wf-1 downto 0));
         else return not iszero(a(wf - 1 downto 0));
         end if;
      else
         return a(a'high downto 0) = b(b'high downto 0);
      end if;
   end;

   function fp_inf_or_equal_ieee(a : std_logic_vector; b : std_logic_vector; we : integer; wf : integer) return boolean is
   begin
      return false; -- TODO 
   end;

   -- FP subtypes for casting
   subtype fp32 is std_logic_vector(31 downto 0);
   function testLine(testCounter:integer; expectedOutputS: string(1 to 10000); expectedOutputSize: integer; R:  std_logic_vector(31 downto 0)) return boolean is
      variable expectedOutput: line;
      variable possibilityNumber : integer;
      variable testSuccess: boolean;
      variable errorMessage: string(1 to 10000);
      variable testSuccess_R: boolean;
      variable expected_R: bit_vector (31 downto 0); -- for list of values
      variable inf_R: bit_vector (31 downto 0); -- for intervals
      variable sup_R: bit_vector (31 downto 0); -- for intervals
   begin
      write(expectedOutput, expectedOutputS);
      read(expectedOutput, possibilityNumber); -- for R
      if possibilityNumber = 0 then
         -- TODO define what it means to have 0 possible output. Currently it means a test fails...
      end if;
      if possibilityNumber > 0 then -- a list of values
      testSuccess_R := false;
         for i in 1 to possibilityNumber loop
            read(expectedOutput, expected_R);
            if fp_equal_ieee(R, to_stdlogicvector(expected_R), 8, 23) then
               testSuccess_R := true;
            end if;
            end loop;
      end if;
      if possibilityNumber < 0  then -- an interval
         read(expectedOutput, inf_R);
         read(expectedOutput, sup_R);
         if possibilityNumber =-1  then -- an unsigned interval
            testSuccess_R := (R >= to_stdlogicvector(inf_R)) and (R <= to_stdlogicvector(sup_R));
         elsif possibilityNumber =-2  then -- a signed interval
            testSuccess_R := (signed(R) >= signed(to_stdlogicvector(inf_R))) and (signed(R) <= signed(to_stdlogicvector(sup_R)));
         elsif possibilityNumber =-3  then -- an IEEE floating-point interval
            testSuccess_R := fp_inf_or_equal_ieee(to_stdlogicvector(inf_R), R, 8, 23) and fp_inf_or_equal_ieee(R, to_stdlogicvector(sup_R), 8, 23);
         end if;
      end if;
      if testSuccess_R = false then
         report("Test #" & integer'image(testCounter) & ", incorrect output for R: " & lf & " expected values: " & expectedOutputS(1 to expectedOutputSize) & lf  & "          result:    " & str(R) ) severity error;
      end if;
      
      testSuccess := true and testSuccess_R;
      return testSuccess;
   end testLine;

begin
   -- Ticking clock signal
   process
   begin
      clk <= '0';
      wait for 5 ns;
      clk <= '1';
      wait for 5 ns;
   end process;

   test: IEEEFPAdd_8_23_comb_uid2
      port map ( X => X,
                 Y => Y,
                 R => R);
   -- Process that sets the inputs  (read from a file) 
   process
      variable input, expectedOutput : line; 
      variable tmpChar : character;
      file inputsFile : text is "test.input"; 
      variable V_X : bit_vector(31 downto 0);
      variable V_Y : bit_vector(31 downto 0);
      variable V_R : bit_vector(31 downto 0);
   begin
      -- Send reset
      rst <= '1';
      wait for 10 ns;
      rst <= '0';
      readline(inputsFile, input); -- skip the first line of advertising
      while not endfile(inputsFile) loop
         readline(inputsFile, input); -- skip the comment line
         readline(inputsFile, input);
         readline(inputsFile, expectedOutput); -- comment line, unused in this process
         readline(inputsFile, expectedOutput); -- unused in this process
         read(input ,V_X);
         read(input,tmpChar);
         X <= to_stdlogicvector(V_X);
         read(input ,V_Y);
         read(input,tmpChar);
         Y <= to_stdlogicvector(V_Y);
         wait for 10 ns;
      end loop;
         wait for 100 ns; -- wait for pipeline to flush (and some more)
   end process;

    -- Process that verifies the corresponding output
   process
      file inputsFile : text is "test.input"; 
      variable input, expectedOutput : line; 
      variable testCounter : integer := 1;
      variable errorCounter : integer := 0;
      variable expectedOutputString : string(1 to 10000);
      variable testSuccess: boolean;
   begin
      wait for 12 ns; -- wait for reset 
      readline(inputsFile, input); -- skip the first line of advertising
      while not endfile(inputsFile) loop
         readline(inputsFile, input); -- input comment, unused
         readline(inputsFile, input); -- input line, unused
         readline(inputsFile, expectedOutput); -- comment line, unused in this process
         readline(inputsFile, expectedOutput);
         expectedOutputString := expectedOutput.all & (expectedOutput'Length+1 to 10000 => ' ');
         testSuccess := testLine(testCounter, expectedOutputString, expectedOutput'Length, R);
         if not testSuccess then 
               errorCounter := errorCounter + 1; -- incrementing global error counter
         end if;
            testCounter := testCounter + 1; -- incrementing global error counter
         wait for 10 ns;
      end loop;
      report integer'image(errorCounter) & " error(s) encoutered." severity note;
      report "End of simulation after " & integer'image(testCounter-1) & " tests" severity note;
   end process;

end architecture;

