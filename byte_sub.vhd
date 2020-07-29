----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.07.2020 21:43:14
-- Design Name: 
-- Module Name: byte_sub - Behavioral
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

entity byte_sub is
    Port ( round : in STD_LOGIC_VECTOR (127 downto 0);
           sub_round : out STD_LOGIC_VECTOR (127 downto 0));
end byte_sub;

architecture Behavioral of byte_sub is

begin
    gen_sboxes : for i in 0 to 15 generate
    inst_s_box : entity work.sbox
      PORT MAP (
        input_byte => round((i + 1)*8 - 1 downto i*8),
        output_byte => sub_round((i + 1)*8 - 1 downto i*8)
      );
    end generate gen_sboxes;

end Behavioral;
