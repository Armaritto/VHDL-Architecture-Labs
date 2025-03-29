LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;

ENTITY register_file IS
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
END register_file;

ARCHITECTURE behavioral OF register_file IS
    TYPE register_array IS ARRAY (0 TO 31) OF std_logic_vector(31 DOWNTO 0);
    SIGNAL registers : register_array := (others => (others => '0'));
BEGIN
    write_process: PROCESS(clk)
    BEGIN
        IF falling_edge(clk) THEN
            IF write_enable = '1' THEN
      		registers(to_integer(unsigned(write_addr))) <= write_data;                
            END IF;
        END IF;
    END PROCESS;

    read_process: PROCESS(read_addr1, read_addr2, registers)
    BEGIN
        read_data1 <= registers(to_integer(unsigned(read_addr1)));
        read_data2 <= registers(to_integer(unsigned(read_addr2)));
    END PROCESS;
END behavioral;