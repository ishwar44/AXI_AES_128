----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.07.2020 15:32:29
-- Design Name: 
-- Module Name: aes_enc - Behavioral
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

entity aes_enc is
    Port ( clk : in STD_LOGIC;
           key_in : in STD_LOGIC_VECTOR (127 downto 0);
           data_in : in STD_LOGIC_VECTOR (127 downto 0);
           data_out : out STD_LOGIC_VECTOR (127 downto 0);
           key_expanded : out STD_LOGIC;
           busy : out STD_LOGIC;
           enable : in STD_LOGIC;
           new_key : in STD_LOGIC);
end aes_enc;

architecture Behavioral of aes_enc is

component key_expander is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           key_in : in STD_LOGIC_VECTOR (127 downto 0);
           new_key : in STD_LOGIC;
           addr_in : in STD_LOGIC_VECTOR (3 downto 0);
           key_valid : out STD_LOGIC;
           sub_key_out : out STD_LOGIC_VECTOR (127 downto 0));
end component;
component add_round_key is
    Port ( clk : in STD_LOGIC;
           round_key : in STD_LOGIC_VECTOR (127 downto 0);
           state : in STD_LOGIC_VECTOR (127 downto 0);
           state_round_key : out STD_LOGIC_VECTOR (127 downto 0));
end component;

component byte_sub is
    Port ( round : in STD_LOGIC_VECTOR (127 downto 0);
           sub_round : out STD_LOGIC_VECTOR (127 downto 0));
end component;

component shift_bytes is
    Port ( clk : in STD_LOGIC;
           round_in : in STD_LOGIC_VECTOR (127 downto 0);
           round_out : out STD_LOGIC_VECTOR (127 downto 0));
end component;

component mix_columns is
    Port ( clk : in STD_LOGIC;
           round_in : in STD_LOGIC_VECTOR (127 downto 0);
           round_out : out STD_LOGIC_VECTOR (127 downto 0));
end component;

signal key_addr : STD_LOGIC_VECTOR (3 downto 0) := x"0";
signal key_valid : STD_LOGIC :=  '0';
signal int_enable : STD_LOGIC :=  '0';
signal sub_key_out : STD_LOGIC_VECTOR (127 downto 0) := (others => '0');
signal data_in_buffer : STD_LOGIC_VECTOR (127 downto 0) := (others => '0');
signal added_round_key : STD_LOGIC_VECTOR (127 downto 0) := (others => '0');
signal shift_bytes_input : STD_LOGIC_VECTOR (127 downto 0) := (others => '0');
signal shift_bytes_output : STD_LOGIC_VECTOR (127 downto 0) := (others => '0');
signal sub_box_output : STD_LOGIC_VECTOR (127 downto 0) := (others => '0');
signal mix_columns_output : STD_LOGIC_VECTOR (127 downto 0) := (others => '0');
signal counter : unsigned (3 downto 0) := (others => '0');
begin

inst_key_expander : key_expander
port map
(
    clk => clk,
    rst => '1',
    key_in => key_in,
    new_key => new_key,
    addr_in => key_addr,
    key_valid => key_valid,
    sub_key_out => sub_key_out
);
    
inst_add_round_key : add_round_key
port map
(
    clk => clk,
    round_key => sub_key_out,
    state => data_in_buffer,
    state_round_key => added_round_key
);
inst_byte_sub : byte_sub
port map
(
    round => added_round_key,
    sub_round => sub_box_output
);

inst_shift_bytes : shift_bytes
port map
(
    clk   => clk,
    round_in => sub_box_output,
    round_out => shift_bytes_output
);

inst_mix_column : mix_columns
port map
(
    clk   => clk,
    round_in => shift_bytes_output,
    round_out => mix_columns_output
);

process(clk)
    begin
        if(rising_edge(clk)) then
            key_expanded <= key_valid;
            if(key_valid = '1' and enable = '1' and int_enable = '0') then
                data_in_buffer <= data_in;
                int_enable <= '1';
                busy <= '1';
            end if;
            if(int_enable = '1') then
                if(counter = 5) then
                    counter <= (others => '0');
                    data_in_buffer <= mix_columns_output;
                    if(key_addr = x"a") then
                        key_addr <= x"0";
                    else
                        key_addr <= std_logic_vector(unsigned(key_addr) + 1);
                    end if;
                 else
                    counter <= counter + 1;
                 end if;
                if(key_addr = x"a" and counter = 2) then
                    counter <= (others => '0');
                    busy <= '0';
                    key_addr <= x"0";
                    int_enable <= '0';
                    data_out <= added_round_key;
                end if;
            end if;
            if(key_addr = x"a") then
                data_in_buffer <= shift_bytes_output;   
            end if;
        end if;
    end process;


end Behavioral;
