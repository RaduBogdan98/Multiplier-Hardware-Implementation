library IEEE;
USE ieee.std_logic_1164.all;

ENTITY controlUnit IS
	PORT(clock, begin_sgn, q0, count7: IN STD_LOGIC;
		end_sgn,c0,c1,c2,c3,c4,c5,c6,c7,c8: OUT STD_LOGIC);
END controlUnit;

ARCHITECTURE behave OF controlUnit IS
--declaratii de semnale, componente, etc
BEGIN

PROCESS( clock)
	
BEGIN

END PROCESS;

END ARCHITECTURE behave;
