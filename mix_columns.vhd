----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.07.2020 18:25:44
-- Design Name: 
-- Module Name: mix_columns - Behavioral
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

entity mix_columns is
    Port ( clk : in STD_LOGIC;
           --enable : in STD_LOGIC;
           round_in : in STD_LOGIC_VECTOR (127 downto 0);
           round_out : out STD_LOGIC_VECTOR (127 downto 0));
end mix_columns;

architecture Behavioral of mix_columns is

component mix_column is
    Port ( clk : in STD_LOGIC;
           --enable : in STD_LOGIC;
           word_in : in STD_LOGIC_VECTOR (31 downto 0);
           word_out : out STD_LOGIC_VECTOR (31 downto 0));
end component;

begin

inst_mix_column_0 : mix_column
port map
(
    clk   => clk,
    --enable => enable,
    word_in => round_in(31 downto 0),
    word_out => round_out(31 downto 0)
);
inst_mix_column_1 : mix_column
port map
(
    clk   => clk,
    --enable => enable,
    word_in => round_in(63 downto 32),
    word_out => round_out(63 downto 32)
);
inst_mix_column_2 : mix_column
port map
(
    clk   => clk,
    --enable => enable,
    word_in => round_in(95 downto 64),
    word_out => round_out(95 downto 64)
);
inst_mix_column_3 : mix_column
port map
(
    clk   => clk,
    --enable => enable,
    word_in => round_in(127 downto 96),
    word_out => round_out(127 downto 96)
);


end Behavioral;
