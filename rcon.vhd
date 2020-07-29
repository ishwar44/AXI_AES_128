----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.07.2020 19:09:00
-- Design Name: 
-- Module Name: rcon - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity rcon is
    Port (input_byte : in STD_LOGIC_VECTOR (7 downto 0);
           rcon : out STD_LOGIC_VECTOR (7 downto 0));
end rcon;

architecture Behavioral of rcon is

begin
	lut : process (input_byte) is
	begin
		case input_byte is
			when x"00" => rcon <= x"00";
			when x"01" => rcon <= x"01";
			when x"02" => rcon <= x"02";
			when x"03" => rcon <= x"04";
			when x"04" => rcon <= x"08";
			when x"05" => rcon <= x"10";
			when x"06" => rcon <= x"20";
			when x"07" => rcon <= x"40";
			when x"08" => rcon <= x"80";
			when x"09" => rcon <= x"1B";
			when x"0a" => rcon <= x"36";
			when x"0b" => rcon <= x"6c";
			when x"0c" => rcon <= x"D8";
			when others => null; -- GHDL complains without this statement
		end case;
    end process;

end Behavioral;
