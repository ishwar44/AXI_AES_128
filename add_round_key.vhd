----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.07.2020 19:41:32
-- Design Name: 
-- Module Name: add_round_key - Behavioral
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

entity add_round_key is
    Port ( clk : in STD_LOGIC;
           round_key : in STD_LOGIC_VECTOR (127 downto 0);
           state : in STD_LOGIC_VECTOR (127 downto 0);
           state_round_key : out STD_LOGIC_VECTOR (127 downto 0));
end add_round_key;

architecture Behavioral of add_round_key is

begin
process(clk)
begin
    if(rising_edge(clk)) then
        state_round_key <= round_key xor state;
    end if;
end process;

end Behavioral;
