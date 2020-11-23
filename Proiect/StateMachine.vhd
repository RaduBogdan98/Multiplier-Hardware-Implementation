library IEEE;
USE ieee.std_logic_1164.all;

ENTITY StateMachine is
PORT (
      --clock : 	IN STD_LOGIC;
      --reset : 	IN STD_LOGIC;
      inbus :	IN STD_LOGIC_VECTOR (15 DOWNTO 0):=x"97A7";
      outbus :	OUT STD_LOGIC_VECTOR (15 DOWNTO 0));
END ENTITY;

-- Architecture definition for the SimpleFSM entity
Architecture behave of StateMachine is
TYPE State_type IS (INIT, TEST1, ADD, TEST_COUNT7, RSHIFT, TEST2, CORRECTION, OUTPUT, STOP);  -- Define the states
	SIGNAL State : State_Type;    -- Create a signal that uses the different states

-- Mandatory signals
	SIGNAL A,Q,M: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL f,count7,c0,c1,c2,c3,c4,c5,c6,end_sgn: STD_LOGIC := '0';
	SIGNAL count: INTEGER;

-- Non-standard signals
	SIGNAL A_S : std_logic_vector(7 downto 0);
	SIGNAL shift_in, shift_out : std_logic_vector(15 downto 0);
	SIGNAL clock, reset :  STD_LOGIC:='1';
	SIGNAL shift_reset, c_out : STD_LOGIC:='0'; 
	
-- Component declarations region				    
COMPONENT adder IS
	PORT(c_in, load: IN STD_LOGIC;
		x,y: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		z: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		c_out: OUT STD_LOGIC);
END COMPONENT;

COMPONENT shiftRegister IS
	GENERIC( n: INTEGER);
	PORT(clock, reset, load, shift,intr: IN STD_LOGIC;
		intrare: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		iesire: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0));
END COMPONENT;
-- end region

BEGIN 
reset<='1', '0' after 30 ns;
clock<=Not clock after 50 ns;

-- Component instantiation
shiftReg: shiftRegister 
	generic map ( n => 16 )
	port map (clock => clock,
		reset => shift_reset,
		load => c5,
		shift => c6,
		intr => '1',
		intrare => shift_in,
		iesire => shift_out);

adder_entity: adder 
	port map( c_in => c4,
		load => c2,
		x => a,
		y => m,
		z => a_s,
		c_out => c_out);
--end region


  PROCESS (clock, reset) 
	VARIABLE aux, at_end: STD_LOGIC := '0';

  BEGIN 
    IF (reset = '1') THEN            -- upon reset, set the state to INIT
    	State <= INIT;
 
    ELSIF rising_edge(clock) THEN   

		CASE State IS

			WHEN INIT => 
				at_end:='0';
				end_sgn<='0';
				c0<='1';
				c1<='1';
				
				f<= '0';
				A<= x"00";
				count<=1;
				M<=inbus(15 downto 8);
				Q<=inbus(7 downto 0);
				
				State<=TEST1;		

			WHEN TEST1 => 
				c0<='0';
				c1<='0';
				c3<='0';

				IF q(0)='1' THEN 
					c2<='1';
					State <= ADD; 
				ELSE
					State <= RSHIFT;
				END IF; 

			WHEN ADD => 
				a<=a_s;
				f<=f or (m(7) AND q(0));
				State <= RSHIFT;

			WHEN RSHIFT => 
				c2<='0';	
				c3<='1';		

				aux:=a(0);
				a(6 downto 0)<=a(7 downto 1);
				a(7)<=f;
				q(6 downto 0)<=q(7 downto 1);
				q(7)<=aux;

				count<=count+1;
				if(count = 7) then count7<='1'; end if;

				State<= TEST_COUNT7;

			WHEN TEST_COUNT7 => 
				c3<='0';

				IF count7='0' THEN 
					State <= TEST1; 
				ELSE 
					State <= TEST2; 
				END IF; 

			WHEN TEST2 => 
				IF q(0) = '0' THEN
					State <= OUTPUT;
				ELSE
					c2<='1';
					c4<='1';
					State <= CORRECTION;
				END IF;
				
			WHEN CORRECTION =>
				a<=a_s;
				q(0)<= '0';
				
				at_end:='1';
				c2<='0';
				c4<='0';

				State <= OUTPUT;
			
			WHEN OUTPUT => 
				c5<='1';
				c6<='1';

				Outbus(15 downto 8) <= a;
				Outbus(7 downto 0) <= q;
				State <= STOP; 
				
			WHEN STOP =>
				c5<='0';
				c6<='0';
				end_sgn<='1';

			WHEN others =>
				State <= INIT;
		END CASE; 
    END IF; 
  END PROCESS;
  
END behave;
