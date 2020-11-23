library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY ShiftRegister IS
	GENERIC( n: integer:=8);
	PORT(clock, reset, load, shift, intr: IN STD_LOGIC;
		intrare: in STD_LOGIC_VECTOR(n-1 downto 0);
	     	iesire: OUT STD_LOGIC_VECTOR(n-1 downto 0));
END ShiftRegister;

ARCHITECTURE behave OF ShiftRegister IS

	SIGNAL temp: STD_LOGIC_VECTOR(n-1 downto 0); 
BEGIN

PROCESS( clock, reset)	 
BEGIN
	IF reset='0' THEN
		temp <= (others =>  '0');
	ELSIF clock='1' AND clock'EVENT AND clock'LAST_VALUE='0' THEN
		if load='1' then
			temp<=intrare;
		elsif shift='1' then 
			temp(n-2 downto 0) <= temp(n-1 downto 1);
			temp(n-1) <= intr;
			-- aceste instructiuni trebuie sa fie in aceasta ordine, altfel pierzi informatii din registru
		end if;
	END IF;

	iesire <= temp;

END PROCESS;
END ARCHITECTURE behave;
