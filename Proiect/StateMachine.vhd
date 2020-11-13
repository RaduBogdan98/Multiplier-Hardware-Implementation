-- NOTE: Change the file extension from .txt to .vhd

-- include libraries
library IEEE;
USE ieee.std_logic_1164.all;

ENTITY SimpleFSM is
PORT (
      clock : 	IN STD_LOGIC;
      reset : 	IN STD_LOGIC;
      inbus :	IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      outbus :	OUT STD_LOGIC_VECTOR (7 DOWNTO 0));
END ENTITY;

-- Architecture definition for the SimpleFSM entity
Architecture RTL of SimpleFSM is
TYPE State_type IS (INIT, TEST1, ADD, SUB, Q0, TEST_COUNT7, SHIFT, TEST2, OUTPUT, STOP);  -- Define the states
	SIGNAL State : State_Type;    -- Create a signal that uses the different states
	SIGNAL A,Q,M: STD_LOGIC_VECTOR(7 DOWNTO 0);
							    
COMPONENT adder IS
	PORT(clock, c_in: IN STD_LOGIC;
		x,y: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		z: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		c_out: OUT STD_LOGIC);
END COMPONENT;

COMPONENT shiftRegister IS
	GENERIC( n: INTEGER);
	PORT(clock: IN STD_LOGIC;
		intrare: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		iesire: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0));
END COMPONENT;

COMPONENT controlUnit IS
	PORT(clock, begin_sgn, q0, count7: IN BIT;
		end_sgn,c0,c1,c2,c3,c4,c5,c6,c7,c8: OUT BIT);
END COMPONENT;

COMPONENT counter IS
	PORT(clock: IN STD_LOGIC;
		in_val: IN INTEGER;
		out_val: OUT INTEGER;
		count7: OUT STD_LOGIC);
END COMPONENT;

	SIGNAL s: STD_LOGIC;
	SIGNAL sum_out, compl2 : std_logic_vector(7 downto 0);
	SIGNAL shift_in, shift_out : std_logic_vector(15 downto 0);

BEGIN 
  PROCESS (clock, reset) 
	VARIABLE c0,c1,c2,c3,c4,c5,c6,c7,c8,count7,at_end: STD_LOGIC := '0';
	VARIABLE counter: INTEGER := 0;


  BEGIN 
    IF (reset = '1') THEN            -- upon reset, set the state to INIT
    	State <= INIT;
 
    ELSIF rising_edge(clock) THEN   

		CASE State IS

			WHEN INIT => 
				at_end:='0';
				A<=inbus;
				s<='0';
				counter:=0;
				Q(7 downto 1)<=inbus(7 downto 1);
				Q(0)<='0';
				M<=inbus;
				State<=TEST1;

			WHEN TEST1 => 
				IF s='1' THEN 
					State <= ADD; 
				ELSE
					State <= SUB;
				END IF; 

			WHEN ADD => 
				add: adder 
				port map(clock => clock, 
					c_in => '0',
					x => a,
					y => m,
					z => a,
					c_out => s);

				IF (at_end = '1') THEN
					State <= OUTPUT;
				ELSE
					State <=Q0;
				END IF; 

			WHEN SUB => 
				compl2 <= m;
				sub: adder 
				port map(clock => clock, 
					c_in => '0',
					x => a,
					y => compl2,
					z => a,
					c_out => s);
				State <= Q0; 

			WHEN Q0 => 
				Q(0) <= NOT s; 

			WHEN TEST_COUNT7 => 
				IF count7='1' THEN 
					State <= SHIFT; 
				ELSE 
					State <= TEST2; 
				END IF; 

			WHEN SHIFT => 
				shift_in(15 downto 8)<=a;
				shift_in(7 downto 0)<=q;

				shiftReg: shiftRegister 
				generic map ( n => 16 )
				port map (clock => clock,
					intrare => shift_in,
					iesire => shift_out);
				
				s<=shift_out(15);
				a<=shift_out(14 downto 7);
				q(7 downto 1)<=shift_out(6 downto 0);

			WHEN TEST2 => 
				IF s='1' THEN 
					at_end:='1';
					State <= ADD; 
				ELSE 
					State <= OUTPUT; 
				END IF; 
			
			WHEN OUTPUT => 
				Outbus <= Q;
				Outbus <= A;
				State <= STOP; 
				

			WHEN STOP => 
				 

			WHEN others =>
				State <= INIT;
		END CASE; 
    END IF; 
  END PROCESS;
  
  -- Decode the current state to create the output
  -- if the current state is D, R is 1 otherwise R is 0
  --R <= '1' WHEN State=D ELSE '0';
  
END rtl;
