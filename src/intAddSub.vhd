--------------------------------------------------------------------------------
--                        IntAddSub_w32_XcY_comb_uid2
-- VHDL generated for DummyFPGA @ 0MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Martin Kumm
--------------------------------------------------------------------------------
-- combinatorial
-- Clock period (ns): inf
-- Target frequency (MHz): 0
-- Input signals: X Y negY
-- Output signals: R
--  approx. input signal timings: X: 0.000000nsY: 0.000000nsnegY: 0.000000ns
--  approx. output signal timings: R: 0.000000ns

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity IntAddSub_w32_XcY_comb_uid2 is
    port (X : in  std_logic_vector(31 downto 0);
          Y : in  std_logic_vector(31 downto 0);
          negY : in  std_logic;
          R : out  std_logic_vector(32 downto 0)   );
end entity;

architecture arch of IntAddSub_w32_XcY_comb_uid2 is
signal X_int :  std_logic_vector(32 downto 0);
   -- timing of X_int: 0.000000ns
signal Y_int :  std_logic_vector(32 downto 0);
   -- timing of Y_int: 0.000000ns
begin
   X_int <= std_logic_vector(resize(signed(X),33));
   Y_int <= std_logic_vector(-resize(signed(Y),33)) when negY='1' else std_logic_vector(resize(signed(Y),33));
   R <= std_logic_vector(resize(signed(X_int),33) + resize(signed(Y_int),33));
end architecture;

