LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;

ENTITY register_file_tb IS
END register_file_tb;

ARCHITECTURE tb OF register_file_tb IS
    COMPONENT register_file IS
        PORT (
            clk : IN std_logic;
            read_addr1 : IN std_logic_vector(4 DOWNTO 0);
            read_addr2 : IN std_logic_vector(4 DOWNTO 0);
            write_addr : IN std_logic_vector(4 DOWNTO 0);
            write_data : IN std_logic_vector(31 DOWNTO 0);
            write_enable : IN std_logic;
            read_data1 : OUT std_logic_vector(31 DOWNTO 0);
            read_data2 : OUT std_logic_vector(31 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL clk : std_logic := '0';
    SIGNAL read_addr1, read_addr2, write_addr : std_logic_vector(4 DOWNTO 0);
    SIGNAL write_data, read_data1, read_data2 : std_logic_vector(31 DOWNTO 0);
    SIGNAL write_enable : std_logic;

BEGIN
    UUT: register_file PORT MAP (
        clk => clk,
        read_addr1 => read_addr1,
        read_addr2 => read_addr2,
        write_addr => write_addr,
        write_data => write_data,
        write_enable => write_enable,
        read_data1 => read_data1,
        read_data2 => read_data2
    );

    clk_process: PROCESS
    BEGIN
        WHILE TRUE LOOP
            clk <= '1';
            WAIT FOR 5 ns;
            clk <= '0';
            WAIT FOR 5 ns;
        END LOOP;
    END PROCESS;


    stim_process: PROCESS
    BEGIN
	write_enable <= '0';
        read_addr1 <= "00000";
        read_addr2 <= "00000";
        write_addr <= "00000";
        write_data <= (others => '0');
        WAIT FOR 10 ns;

        -- Test 1: Write to register 1
        write_enable <= '1';
        write_addr <= "00001";
        write_data <= X"12345678";
        WAIT FOR 10 ns;

        -- Test 2: Read from register 1
        write_enable <= '0';
        read_addr1 <= "00001";
        WAIT FOR 10 ns;
        ASSERT read_data1 = X"12345678" REPORT "Register 1 read failed" SEVERITY ERROR;

        -- Test 3: Write to register 31
        write_enable <= '1';
        write_addr <= "11111";
        write_data <= X"ABCDEF01";
        WAIT FOR 10 ns;
        
        -- Test 4: Read from both ports
        write_enable <= '0';
        read_addr1 <= "00001";
        read_addr2 <= "11111";
        WAIT FOR 10 ns;
        ASSERT read_data1 = X"12345678" REPORT "Register 1 read failed" SEVERITY ERROR;
        ASSERT read_data2 = X"ABCDEF01" REPORT "Register 31 read failed" SEVERITY ERROR;
        
        -- Test 5: Verify other registers are unaffected
        read_addr1 <= "00001";
        read_addr2 <= "11111";
        WAIT FOR 10 ns;
        ASSERT read_data1 = X"12345678" REPORT "Register 1 corrupted" SEVERITY ERROR;
        ASSERT read_data2 = X"ABCDEF01" REPORT "Register 31 corrupted" SEVERITY ERROR;
        

	-- Test 6: Read and write in the same cycle from the same register
        write_enable <= '1';
        write_addr <= "00010";
        write_data <= X"DEADBEEF";
        read_addr2 <= "00010"; 
        WAIT FOR 10 ns;
        ASSERT read_data2 = X"DEADBEEF" REPORT "Register 2 write failed" SEVERITY ERROR;

        WAIT;
    END PROCESS;
END tb;