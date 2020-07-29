----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.07.2020 17:25:33
-- Design Name: 
-- Module Name: mix_column - Behavioral
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

entity mix_column is
    Port ( clk : in STD_LOGIC;
           --enable : in STD_LOGIC;
           word_in : in STD_LOGIC_VECTOR (31 downto 0);
           word_out : out STD_LOGIC_VECTOR (31 downto 0));
end mix_column;

architecture Behavioral of mix_column is
component gf_mul_2 is
    Port ( clk : in STD_LOGIC;
           input_byte : in STD_LOGIC_VECTOR (7 downto 0);
           output_byte : out STD_LOGIC_VECTOR (7 downto 0));
end component;
signal gf_mul_out : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
signal word_in_buffer : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
begin
gen_gfmul : for i in 0 to 3 generate
    inst_gf_mul_0 : gf_mul_2
    PORT MAP
     ( 
         clk => clk,
         input_byte => word_in((i + 1)*8 - 1 downto i*8),
         output_byte => gf_mul_out((i + 1)*8 - 1 downto i*8)
     );
end generate gen_gfmul;
process(clk)
begin
    if(rising_edge(clk)) then
        word_in_buffer <= word_in;
        word_out(7 downto 0) <= gf_mul_out(7 downto 0) xor word_in_buffer(31 downto 24) xor word_in_buffer(23 downto 16) xor gf_mul_out(15 downto 8)  xor word_in_buffer(15 downto 8);
        word_out(15 downto 8) <= gf_mul_out(15 downto 8) xor word_in_buffer(7 downto 0) xor word_in_buffer(31 downto 24) xor gf_mul_out(23 downto 16)  xor word_in_buffer(23 downto 16);
        word_out(23 downto 16) <= gf_mul_out(23 downto 16) xor word_in_buffer(15 downto 8) xor word_in_buffer(7 downto 0) xor gf_mul_out(31 downto 24)  xor word_in_buffer(31 downto 24);
        word_out(31 downto 24) <= gf_mul_out(31 downto 24) xor word_in_buffer(23 downto 16) xor word_in_buffer(15 downto 8) xor gf_mul_out(7 downto 0)  xor word_in_buffer(7 downto 0);
    end if;
end process;
end Behavioral;
