----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.07.2020 22:19:14
-- Design Name: 
-- Module Name: shift_bytes - Behavioral
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

entity shift_bytes is
    Port ( clk : in STD_LOGIC;
           round_in : in STD_LOGIC_VECTOR (127 downto 0);
           round_out : out STD_LOGIC_VECTOR (127 downto 0));
end shift_bytes;

architecture Behavioral of shift_bytes is

begin
process(clk)
begin
    if(rising_edge(clk)) then
        round_out(7 downto 0) <=  round_in(7 downto 0);
        round_out(15 downto 8) <=  round_in(47 downto 40);
        round_out(23 downto 16) <=  round_in(87 downto 80);
        round_out(31 downto 24) <=  round_in(127 downto 120);
        
        round_out(39 downto 32) <=  round_in(39 downto 32);
        round_out(47 downto 40) <=  round_in(79 downto 72);
        round_out(55 downto 48) <=  round_in(119 downto 112);
        round_out(63 downto 56) <=  round_in(31 downto 24);
        
        round_out(71 downto 64) <=  round_in(71 downto 64);
        round_out(79 downto 72) <=  round_in(111 downto 104);
        round_out(87 downto 80) <=  round_in(23 downto 16);
        round_out(95 downto 88) <=  round_in(63 downto 56);
        
        round_out(103 downto 96) <=  round_in(103 downto 96);
        round_out(111 downto 104) <=  round_in(15 downto 8);
        round_out(119 downto 112) <=  round_in(55 downto 48);
        round_out(127 downto 120) <=  round_in(95 downto 88);
    end if;
end process;
end Behavioral;
