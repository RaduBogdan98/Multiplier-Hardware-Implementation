library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY adder IS
	PORT(clock, c_in: IN STD_LOGIC;
		x,y: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		z: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		c_out: OUT STD_LOGIC);
END adder;

ARCHITECTURE behave OF adder IS
--declaratii de semnale, componente, etc
	SIGNAL temp: STD_LOGIC_VECTOR(8 DOWNTO 0);
BEGIN
PROCESS( clock)
BEGIN
	temp<=('0' & x) + ('0' & y) + c_in;
	z<=temp(7 downto 0);
	c_out<=temp(8);
END PROCESS;

END ARCHITECTURE behave;
