----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.07.2020 20:33:52
-- Design Name: 
-- Module Name: key_store - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity key_store is
    Port ( clk : in STD_LOGIC;
           sub_key : in STD_LOGIC_VECTOR (127 downto 0);
           wr : in STD_LOGIC;
           addr_in_w : in unsigned (3 downto 0);
           addr_in_r : in unsigned (3 downto 0);
           sub_key_out : out STD_LOGIC_VECTOR (127 downto 0));
end key_store;

architecture Behavioral of key_store is
subtype key is std_logic_vector(127 downto 0);
type sub_keys_arr is array (0 to 10) of key;
signal sub_keys : sub_keys_arr := (others => (others => '0'));
begin
process(clk)
begin
    if(rising_edge(clk)) then
        if(wr = '1') then
            sub_keys(to_integer(addr_in_w)) <= sub_key;
        else
            sub_key_out <= sub_keys(to_integer(addr_in_r));
        end if;
    end if;
end process;


end Behavioral;
