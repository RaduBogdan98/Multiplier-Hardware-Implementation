library IEEE;
USE ieee.std_logic_1164.all;

ENTITY counter IS
	GENERIC( delay: TIME := 10ns);
	PORT(clock: IN STD_LOGIC;
		in_val: IN INTEGER;
		out_val: OUT INTEGER;
		count7: OUT STD_LOGIC);
END counter;

ARCHITECTURE behave OF counter IS
--declaratii de semnale, componente, etc
BEGIN

PROCESS( clock )
	VARIABLE temp: INTEGER := 0;
BEGIN

	IF clock='1' AND clock'EVENT and clock'LAST_VALUE='0' THEN
		temp:=in_val + 1;
		IF temp = 7 THEN
			count7<='1';
			temp:=0;
		ELSE
			count7<='0';
		END IF;
	END IF;

	out_val <= temp AFTER delay;
END PROCESS;

END ARCHITECTURE behave;

