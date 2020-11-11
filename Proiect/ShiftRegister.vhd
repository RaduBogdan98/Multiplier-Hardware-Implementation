library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY shiftRegister IS
	GENERIC( n: INTEGER := 8);
	PORT(clock: IN STD_LOGIC;
		intrare: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		iesire: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0));
		
END shiftRegister;

ARCHITECTURE behave OF shiftRegister IS
--declaratii de semnale, componente, etc
BEGIN

PROCESS( clock)
	VARIABLE temp: INTEGER;
BEGIN
     	IF clock='1' AND clock'EVENT and clock'LAST_VALUE='0' THEN
		iesire <= (others => '0');
		iesire(n-2 downto 0) <= intrare(n-1 downto 1);	
	END IF;
END PROCESS;

END ARCHITECTURE behave;
