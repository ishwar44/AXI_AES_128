----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.07.2020 20:13:08
-- Design Name: 
-- Module Name: key_expander - Behavioral
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

entity key_expander is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           key_in : in STD_LOGIC_VECTOR (127 downto 0);
           new_key : in STD_LOGIC;
           addr_in : in STD_LOGIC_VECTOR (3 downto 0);
           key_valid : out STD_LOGIC;
           sub_key_out : out STD_LOGIC_VECTOR (127 downto 0));
end key_expander;

architecture Behavioral of key_expander is
COMPONENT s_box
  PORT (
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END COMPONENT;
COMPONENT key_store
      Port ( clk : in STD_LOGIC;
           sub_key : in STD_LOGIC_VECTOR (127 downto 0);
           wr : in STD_LOGIC;
           addr_in_w : in unsigned (3 downto 0);
           addr_in_r : in unsigned (3 downto 0);
           sub_key_out : out STD_LOGIC_VECTOR (127 downto 0));
END COMPONENT;
signal round_key_in :  std_logic_vector(127 downto 0) ;
signal substitued_sk : std_logic_vector(31 downto 0);
signal rcon_counter : unsigned(7 downto 0) := x"01";
signal rcon : std_logic_vector(7 downto 0) := (others => '0');
signal int_start : std_logic := '0';
signal wr_sig : std_logic := '0';
signal subkey :  std_logic_vector(127 downto 0) ;
signal addr_in_w :  unsigned(3 downto 0):= (others => '0') ;
begin

inst_key_store : key_store
    port map
    (
        clk => clk,
        sub_key => subkey,
        wr => wr_sig,
        addr_in_w => addr_in_w,
        addr_in_r => unsigned(addr_in),
        sub_key_out => sub_key_out
    );

gen_sboxes : for i in 12 to 15 generate
    inst_s_box : entity work.sbox
      PORT MAP (
        input_byte => round_key_in((i + 1)*8 - 1 downto i*8),
        output_byte => substitued_sk((i + 1 - 12)*8 - 1 downto (i - 12)*8)
      );
end generate gen_sboxes;
inst_rcon : entity work.rcon
      PORT MAP (
        input_byte => std_logic_vector(rcon_counter),
        rcon => rcon
      );

process(clk)
variable shifted_sk : std_logic_vector(31 downto 0);
variable w3, w2, w1, w0 : std_logic_vector(31 downto 0);
variable feedback : std_logic_vector(127 downto 0);
begin
    if(rising_edge(clk)) then
         if(new_key = '1' and int_start = '0') then
            round_key_in <= key_in;
            subkey <= key_in;
            int_start <=  '1';
            wr_sig <= '1';
            key_valid <= '0';
            --addr_in_w <= addr_in_w + 1;
        end if;
        if(int_start = '1') then
            shifted_sk := substitued_sk(7 downto 0) & substitued_sk(31 downto 8);
            w0(7 downto 0) := shifted_sk(7 downto 0) xor rcon xor round_key_in( 7 downto 0);
            w0(31 downto 8) := shifted_sk(31 downto 8) xor round_key_in(31 downto 8);
            w1 := round_key_in(63 downto 32) xor w0;
            w2 := round_key_in(95 downto 64) xor w1;
            w3 := round_key_in(127 downto 96) xor w2;
            subkey <= w3 & w2 & w1 & w0;
            feedback :=  w3 & w2 & w1 & w0;
            round_key_in <= feedback;
            addr_in_w <= addr_in_w + 1;
            if(rcon_counter = x"09") then
                --last_round <= '1';
            end if;
            if(rcon_counter = x"0b") then
                rcon_counter <= x"01";
                int_start <=  '0';
                wr_sig <= '0';
                addr_in_w <= (others => '0');
                key_valid <= '1';
                --round_key_in <= key;
                --done <= '1';
            else
                rcon_counter <= rcon_counter + 1;
            end if;
        end if;
    end if;

end process;


end Behavioral;
