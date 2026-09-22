-- Copyright (C) 2018  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details.

-- VENDOR "Altera"
-- PROGRAM "Quartus Prime"
-- VERSION "Version 18.1.0 Build 625 09/12/2018 SJ Lite Edition"

-- DATE "03/18/2025 13:50:50"

-- 
-- Device: Altera 5CGXFC7C7F23C8 Package FBGA484
-- 

-- 
-- This VHDL file should be used for ModelSim-Altera (VHDL) only
-- 

LIBRARY ALTERA_LNSIM;
LIBRARY CYCLONEV;
LIBRARY IEEE;
USE ALTERA_LNSIM.ALTERA_LNSIM_COMPONENTS.ALL;
USE CYCLONEV.CYCLONEV_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	chaos2 IS
    PORT (
	A : IN std_logic_vector(15 DOWNTO 0);
	B : IN std_logic_vector(15 DOWNTO 0);
	C_in : IN std_logic;
	F : OUT std_logic_vector(15 DOWNTO 0);
	Gm : OUT std_logic;
	Pm : OUT std_logic;
	C_out : OUT std_logic
	);
END chaos2;

-- Design Ports Information
-- F[0]	=>  Location: PIN_M7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- F[1]	=>  Location: PIN_V6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- F[2]	=>  Location: PIN_T7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- F[3]	=>  Location: PIN_M9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- F[4]	=>  Location: PIN_P12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- F[5]	=>  Location: PIN_AB13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- F[6]	=>  Location: PIN_V13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- F[7]	=>  Location: PIN_AB11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- F[8]	=>  Location: PIN_V10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- F[9]	=>  Location: PIN_U7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- F[10]	=>  Location: PIN_AA12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- F[11]	=>  Location: PIN_R11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- F[12]	=>  Location: PIN_N8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- F[13]	=>  Location: PIN_R7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- F[14]	=>  Location: PIN_AA10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- F[15]	=>  Location: PIN_N6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Gm	=>  Location: PIN_AB7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Pm	=>  Location: PIN_R5,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- C_out	=>  Location: PIN_P6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- A[0]	=>  Location: PIN_R12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- B[0]	=>  Location: PIN_V9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- C_in	=>  Location: PIN_W8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- A[1]	=>  Location: PIN_W9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- B[1]	=>  Location: PIN_U8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- A[2]	=>  Location: PIN_AB5,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- B[2]	=>  Location: PIN_AA7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- A[3]	=>  Location: PIN_T8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- B[3]	=>  Location: PIN_U6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- A[4]	=>  Location: PIN_AB12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- B[4]	=>  Location: PIN_P9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- A[5]	=>  Location: PIN_U12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- B[5]	=>  Location: PIN_U13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- A[6]	=>  Location: PIN_Y10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- B[6]	=>  Location: PIN_Y11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- A[7]	=>  Location: PIN_U11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- B[7]	=>  Location: PIN_AB10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- A[8]	=>  Location: PIN_P7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- B[8]	=>  Location: PIN_AA8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- A[9]	=>  Location: PIN_Y9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- B[9]	=>  Location: PIN_R9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- A[10]	=>  Location: PIN_T10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- B[10]	=>  Location: PIN_N9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- A[11]	=>  Location: PIN_R10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- B[11]	=>  Location: PIN_AA9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- A[12]	=>  Location: PIN_AB6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- B[12]	=>  Location: PIN_M6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- A[13]	=>  Location: PIN_P8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- B[13]	=>  Location: PIN_AB8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- A[14]	=>  Location: PIN_U10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- B[14]	=>  Location: PIN_T9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- A[15]	=>  Location: PIN_R6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- B[15]	=>  Location: PIN_M8,	 I/O Standard: 2.5 V,	 Current Strength: Default


ARCHITECTURE structure OF chaos2 IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL ww_A : std_logic_vector(15 DOWNTO 0);
SIGNAL ww_B : std_logic_vector(15 DOWNTO 0);
SIGNAL ww_C_in : std_logic;
SIGNAL ww_F : std_logic_vector(15 DOWNTO 0);
SIGNAL ww_Gm : std_logic;
SIGNAL ww_Pm : std_logic;
SIGNAL ww_C_out : std_logic;
SIGNAL \~QUARTUS_CREATED_GND~I_combout\ : std_logic;
SIGNAL \C_in~input_o\ : std_logic;
SIGNAL \B[0]~input_o\ : std_logic;
SIGNAL \A[0]~input_o\ : std_logic;
SIGNAL \A0|u1|f~combout\ : std_logic;
SIGNAL \B[1]~input_o\ : std_logic;
SIGNAL \A[1]~input_o\ : std_logic;
SIGNAL \A0|u2|f~combout\ : std_logic;
SIGNAL \A0|u3|f~0_combout\ : std_logic;
SIGNAL \B[2]~input_o\ : std_logic;
SIGNAL \A[2]~input_o\ : std_logic;
SIGNAL \A0|u3|f~1_combout\ : std_logic;
SIGNAL \A[3]~input_o\ : std_logic;
SIGNAL \B[3]~input_o\ : std_logic;
SIGNAL \A0|u4|f~0_combout\ : std_logic;
SIGNAL \B[4]~input_o\ : std_logic;
SIGNAL \A0|uut|Gm~0_combout\ : std_logic;
SIGNAL \A0|uut|Ci~0_combout\ : std_logic;
SIGNAL \A[4]~input_o\ : std_logic;
SIGNAL \A1|u1|f~combout\ : std_logic;
SIGNAL \B[5]~input_o\ : std_logic;
SIGNAL \A[5]~input_o\ : std_logic;
SIGNAL \A1|u2|f~combout\ : std_logic;
SIGNAL \A[6]~input_o\ : std_logic;
SIGNAL \B[6]~input_o\ : std_logic;
SIGNAL \A1|u3|f~0_combout\ : std_logic;
SIGNAL \A1|u3|f~1_combout\ : std_logic;
SIGNAL \A[7]~input_o\ : std_logic;
SIGNAL \A1|u3|f~2_combout\ : std_logic;
SIGNAL \B[7]~input_o\ : std_logic;
SIGNAL \A1|u4|f~0_combout\ : std_logic;
SIGNAL \A1|uut|Gm~0_combout\ : std_logic;
SIGNAL \A1|uut|Ci~0_combout\ : std_logic;
SIGNAL \A1|uut|Gm~1_combout\ : std_logic;
SIGNAL \B[8]~input_o\ : std_logic;
SIGNAL \A[8]~input_o\ : std_logic;
SIGNAL \A1|uut|Pm~0_combout\ : std_logic;
SIGNAL \A3|u1|f~combout\ : std_logic;
SIGNAL \B[9]~input_o\ : std_logic;
SIGNAL \A[9]~input_o\ : std_logic;
SIGNAL \A3|u2|f~0_combout\ : std_logic;
SIGNAL \A3|u2|f~combout\ : std_logic;
SIGNAL \A[10]~input_o\ : std_logic;
SIGNAL \A3|uut|Ci[1]~0_combout\ : std_logic;
SIGNAL \B[10]~input_o\ : std_logic;
SIGNAL \A3|u3|f~0_combout\ : std_logic;
SIGNAL \B[11]~input_o\ : std_logic;
SIGNAL \A[11]~input_o\ : std_logic;
SIGNAL \A3|u4|f~0_combout\ : std_logic;
SIGNAL \A3|u4|f~1_combout\ : std_logic;
SIGNAL \A3|uut|Gm~0_combout\ : std_logic;
SIGNAL \A3|uut|Ci~2_combout\ : std_logic;
SIGNAL \A3|uut|Ci~1_combout\ : std_logic;
SIGNAL \A3|uut|Gm~1_combout\ : std_logic;
SIGNAL \A3|uut|Pm~0_combout\ : std_logic;
SIGNAL \A[12]~input_o\ : std_logic;
SIGNAL \B[12]~input_o\ : std_logic;
SIGNAL \A4|u1|f~0_combout\ : std_logic;
SIGNAL \A4|u1|f~combout\ : std_logic;
SIGNAL \B[13]~input_o\ : std_logic;
SIGNAL \AAt|Ci[3]~0_combout\ : std_logic;
SIGNAL \A[13]~input_o\ : std_logic;
SIGNAL \A4|u2|f~combout\ : std_logic;
SIGNAL \A[14]~input_o\ : std_logic;
SIGNAL \B[14]~input_o\ : std_logic;
SIGNAL \A4|u3|f~0_combout\ : std_logic;
SIGNAL \A4|u3|f~1_combout\ : std_logic;
SIGNAL \A4|u3|f~2_combout\ : std_logic;
SIGNAL \A[15]~input_o\ : std_logic;
SIGNAL \B[15]~input_o\ : std_logic;
SIGNAL \A4|u4|f~0_combout\ : std_logic;
SIGNAL \A4|uut|Ci~0_combout\ : std_logic;
SIGNAL \AAt|Gm~0_combout\ : std_logic;
SIGNAL \AAt|Gm~1_combout\ : std_logic;
SIGNAL \AAt|Ci~1_combout\ : std_logic;
SIGNAL \A0|uut|Gm~1_combout\ : std_logic;
SIGNAL \AAt|Gm~2_combout\ : std_logic;
SIGNAL \AAt|Pm~0_combout\ : std_logic;
SIGNAL \AAt|Ci\ : std_logic_vector(4 DOWNTO 1);
SIGNAL \ALT_INV_B[15]~input_o\ : std_logic;
SIGNAL \ALT_INV_A[15]~input_o\ : std_logic;
SIGNAL \ALT_INV_B[14]~input_o\ : std_logic;
SIGNAL \ALT_INV_A[14]~input_o\ : std_logic;
SIGNAL \ALT_INV_B[13]~input_o\ : std_logic;
SIGNAL \ALT_INV_A[13]~input_o\ : std_logic;
SIGNAL \ALT_INV_B[12]~input_o\ : std_logic;
SIGNAL \ALT_INV_A[12]~input_o\ : std_logic;
SIGNAL \ALT_INV_B[11]~input_o\ : std_logic;
SIGNAL \ALT_INV_A[11]~input_o\ : std_logic;
SIGNAL \ALT_INV_B[10]~input_o\ : std_logic;
SIGNAL \ALT_INV_A[10]~input_o\ : std_logic;
SIGNAL \ALT_INV_B[9]~input_o\ : std_logic;
SIGNAL \ALT_INV_A[9]~input_o\ : std_logic;
SIGNAL \ALT_INV_B[8]~input_o\ : std_logic;
SIGNAL \ALT_INV_A[8]~input_o\ : std_logic;
SIGNAL \ALT_INV_B[7]~input_o\ : std_logic;
SIGNAL \ALT_INV_A[7]~input_o\ : std_logic;
SIGNAL \ALT_INV_B[6]~input_o\ : std_logic;
SIGNAL \ALT_INV_A[6]~input_o\ : std_logic;
SIGNAL \ALT_INV_B[5]~input_o\ : std_logic;
SIGNAL \ALT_INV_A[5]~input_o\ : std_logic;
SIGNAL \ALT_INV_B[4]~input_o\ : std_logic;
SIGNAL \ALT_INV_A[4]~input_o\ : std_logic;
SIGNAL \ALT_INV_B[3]~input_o\ : std_logic;
SIGNAL \ALT_INV_A[3]~input_o\ : std_logic;
SIGNAL \ALT_INV_B[2]~input_o\ : std_logic;
SIGNAL \ALT_INV_A[2]~input_o\ : std_logic;
SIGNAL \ALT_INV_B[1]~input_o\ : std_logic;
SIGNAL \ALT_INV_A[1]~input_o\ : std_logic;
SIGNAL \ALT_INV_C_in~input_o\ : std_logic;
SIGNAL \ALT_INV_B[0]~input_o\ : std_logic;
SIGNAL \ALT_INV_A[0]~input_o\ : std_logic;
SIGNAL \AAt|ALT_INV_Pm~0_combout\ : std_logic;
SIGNAL \AAt|ALT_INV_Gm~2_combout\ : std_logic;
SIGNAL \AAt|ALT_INV_Gm~1_combout\ : std_logic;
SIGNAL \AAt|ALT_INV_Gm~0_combout\ : std_logic;
SIGNAL \AAt|ALT_INV_Ci~1_combout\ : std_logic;
SIGNAL \A4|uut|ALT_INV_Ci~0_combout\ : std_logic;
SIGNAL \A0|uut|ALT_INV_Gm~1_combout\ : std_logic;
SIGNAL \A4|u3|ALT_INV_f~2_combout\ : std_logic;
SIGNAL \A4|u3|ALT_INV_f~0_combout\ : std_logic;
SIGNAL \AAt|ALT_INV_Ci[3]~0_combout\ : std_logic;
SIGNAL \A4|u1|ALT_INV_f~0_combout\ : std_logic;
SIGNAL \A3|uut|ALT_INV_Gm~1_combout\ : std_logic;
SIGNAL \A3|uut|ALT_INV_Gm~0_combout\ : std_logic;
SIGNAL \A3|uut|ALT_INV_Ci~2_combout\ : std_logic;
SIGNAL \A3|uut|ALT_INV_Pm~0_combout\ : std_logic;
SIGNAL \A3|uut|ALT_INV_Ci~1_combout\ : std_logic;
SIGNAL \A3|u4|ALT_INV_f~0_combout\ : std_logic;
SIGNAL \A3|uut|ALT_INV_Ci[1]~0_combout\ : std_logic;
SIGNAL \A3|u2|ALT_INV_f~0_combout\ : std_logic;
SIGNAL \A1|uut|ALT_INV_Gm~1_combout\ : std_logic;
SIGNAL \A1|uut|ALT_INV_Gm~0_combout\ : std_logic;
SIGNAL \A1|uut|ALT_INV_Pm~0_combout\ : std_logic;
SIGNAL \A1|uut|ALT_INV_Ci~0_combout\ : std_logic;
SIGNAL \A1|u3|ALT_INV_f~2_combout\ : std_logic;
SIGNAL \A1|u3|ALT_INV_f~0_combout\ : std_logic;
SIGNAL \AAt|ALT_INV_Ci\ : std_logic_vector(1 DOWNTO 1);
SIGNAL \A0|uut|ALT_INV_Gm~0_combout\ : std_logic;
SIGNAL \A0|uut|ALT_INV_Ci~0_combout\ : std_logic;
SIGNAL \A0|u3|ALT_INV_f~0_combout\ : std_logic;

BEGIN

ww_A <= A;
ww_B <= B;
ww_C_in <= C_in;
F <= ww_F;
Gm <= ww_Gm;
Pm <= ww_Pm;
C_out <= ww_C_out;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;
\ALT_INV_B[15]~input_o\ <= NOT \B[15]~input_o\;
\ALT_INV_A[15]~input_o\ <= NOT \A[15]~input_o\;
\ALT_INV_B[14]~input_o\ <= NOT \B[14]~input_o\;
\ALT_INV_A[14]~input_o\ <= NOT \A[14]~input_o\;
\ALT_INV_B[13]~input_o\ <= NOT \B[13]~input_o\;
\ALT_INV_A[13]~input_o\ <= NOT \A[13]~input_o\;
\ALT_INV_B[12]~input_o\ <= NOT \B[12]~input_o\;
\ALT_INV_A[12]~input_o\ <= NOT \A[12]~input_o\;
\ALT_INV_B[11]~input_o\ <= NOT \B[11]~input_o\;
\ALT_INV_A[11]~input_o\ <= NOT \A[11]~input_o\;
\ALT_INV_B[10]~input_o\ <= NOT \B[10]~input_o\;
\ALT_INV_A[10]~input_o\ <= NOT \A[10]~input_o\;
\ALT_INV_B[9]~input_o\ <= NOT \B[9]~input_o\;
\ALT_INV_A[9]~input_o\ <= NOT \A[9]~input_o\;
\ALT_INV_B[8]~input_o\ <= NOT \B[8]~input_o\;
\ALT_INV_A[8]~input_o\ <= NOT \A[8]~input_o\;
\ALT_INV_B[7]~input_o\ <= NOT \B[7]~input_o\;
\ALT_INV_A[7]~input_o\ <= NOT \A[7]~input_o\;
\ALT_INV_B[6]~input_o\ <= NOT \B[6]~input_o\;
\ALT_INV_A[6]~input_o\ <= NOT \A[6]~input_o\;
\ALT_INV_B[5]~input_o\ <= NOT \B[5]~input_o\;
\ALT_INV_A[5]~input_o\ <= NOT \A[5]~input_o\;
\ALT_INV_B[4]~input_o\ <= NOT \B[4]~input_o\;
\ALT_INV_A[4]~input_o\ <= NOT \A[4]~input_o\;
\ALT_INV_B[3]~input_o\ <= NOT \B[3]~input_o\;
\ALT_INV_A[3]~input_o\ <= NOT \A[3]~input_o\;
\ALT_INV_B[2]~input_o\ <= NOT \B[2]~input_o\;
\ALT_INV_A[2]~input_o\ <= NOT \A[2]~input_o\;
\ALT_INV_B[1]~input_o\ <= NOT \B[1]~input_o\;
\ALT_INV_A[1]~input_o\ <= NOT \A[1]~input_o\;
\ALT_INV_C_in~input_o\ <= NOT \C_in~input_o\;
\ALT_INV_B[0]~input_o\ <= NOT \B[0]~input_o\;
\ALT_INV_A[0]~input_o\ <= NOT \A[0]~input_o\;
\AAt|ALT_INV_Pm~0_combout\ <= NOT \AAt|Pm~0_combout\;
\AAt|ALT_INV_Gm~2_combout\ <= NOT \AAt|Gm~2_combout\;
\AAt|ALT_INV_Gm~1_combout\ <= NOT \AAt|Gm~1_combout\;
\AAt|ALT_INV_Gm~0_combout\ <= NOT \AAt|Gm~0_combout\;
\AAt|ALT_INV_Ci~1_combout\ <= NOT \AAt|Ci~1_combout\;
\A4|uut|ALT_INV_Ci~0_combout\ <= NOT \A4|uut|Ci~0_combout\;
\A0|uut|ALT_INV_Gm~1_combout\ <= NOT \A0|uut|Gm~1_combout\;
\A4|u3|ALT_INV_f~2_combout\ <= NOT \A4|u3|f~2_combout\;
\A4|u3|ALT_INV_f~0_combout\ <= NOT \A4|u3|f~0_combout\;
\AAt|ALT_INV_Ci[3]~0_combout\ <= NOT \AAt|Ci[3]~0_combout\;
\A4|u1|ALT_INV_f~0_combout\ <= NOT \A4|u1|f~0_combout\;
\A3|uut|ALT_INV_Gm~1_combout\ <= NOT \A3|uut|Gm~1_combout\;
\A3|uut|ALT_INV_Gm~0_combout\ <= NOT \A3|uut|Gm~0_combout\;
\A3|uut|ALT_INV_Ci~2_combout\ <= NOT \A3|uut|Ci~2_combout\;
\A3|uut|ALT_INV_Pm~0_combout\ <= NOT \A3|uut|Pm~0_combout\;
\A3|uut|ALT_INV_Ci~1_combout\ <= NOT \A3|uut|Ci~1_combout\;
\A3|u4|ALT_INV_f~0_combout\ <= NOT \A3|u4|f~0_combout\;
\A3|uut|ALT_INV_Ci[1]~0_combout\ <= NOT \A3|uut|Ci[1]~0_combout\;
\A3|u2|ALT_INV_f~0_combout\ <= NOT \A3|u2|f~0_combout\;
\A1|uut|ALT_INV_Gm~1_combout\ <= NOT \A1|uut|Gm~1_combout\;
\A1|uut|ALT_INV_Gm~0_combout\ <= NOT \A1|uut|Gm~0_combout\;
\A1|uut|ALT_INV_Pm~0_combout\ <= NOT \A1|uut|Pm~0_combout\;
\A1|uut|ALT_INV_Ci~0_combout\ <= NOT \A1|uut|Ci~0_combout\;
\A1|u3|ALT_INV_f~2_combout\ <= NOT \A1|u3|f~2_combout\;
\A1|u3|ALT_INV_f~0_combout\ <= NOT \A1|u3|f~0_combout\;
\AAt|ALT_INV_Ci\(1) <= NOT \AAt|Ci\(1);
\A0|uut|ALT_INV_Gm~0_combout\ <= NOT \A0|uut|Gm~0_combout\;
\A0|uut|ALT_INV_Ci~0_combout\ <= NOT \A0|uut|Ci~0_combout\;
\A0|u3|ALT_INV_f~0_combout\ <= NOT \A0|u3|f~0_combout\;

-- Location: IOOBUF_X8_Y0_N2
\F[0]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \A0|u1|f~combout\,
	devoe => ww_devoe,
	o => ww_F(0));

-- Location: IOOBUF_X6_Y0_N36
\F[1]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \A0|u2|f~combout\,
	devoe => ww_devoe,
	o => ww_F(1));

-- Location: IOOBUF_X6_Y0_N19
\F[2]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \A0|u3|f~1_combout\,
	devoe => ww_devoe,
	o => ww_F(2));

-- Location: IOOBUF_X32_Y0_N2
\F[3]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \A0|u4|f~0_combout\,
	devoe => ww_devoe,
	o => ww_F(3));

-- Location: IOOBUF_X36_Y0_N36
\F[4]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \A1|u1|f~combout\,
	devoe => ww_devoe,
	o => ww_F(4));

-- Location: IOOBUF_X50_Y0_N93
\F[5]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \A1|u2|f~combout\,
	devoe => ww_devoe,
	o => ww_F(5));

-- Location: IOOBUF_X50_Y0_N59
\F[6]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \A1|u3|f~1_combout\,
	devoe => ww_devoe,
	o => ww_F(6));

-- Location: IOOBUF_X38_Y0_N36
\F[7]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \A1|u4|f~0_combout\,
	devoe => ww_devoe,
	o => ww_F(7));

-- Location: IOOBUF_X26_Y0_N42
\F[8]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \A3|u1|f~combout\,
	devoe => ww_devoe,
	o => ww_F(8));

-- Location: IOOBUF_X2_Y0_N93
\F[9]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \A3|u2|f~combout\,
	devoe => ww_devoe,
	o => ww_F(9));

-- Location: IOOBUF_X40_Y0_N36
\F[10]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \A3|u3|f~0_combout\,
	devoe => ww_devoe,
	o => ww_F(10));

-- Location: IOOBUF_X38_Y0_N2
\F[11]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \A3|u4|f~1_combout\,
	devoe => ww_devoe,
	o => ww_F(11));

-- Location: IOOBUF_X28_Y0_N2
\F[12]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \A4|u1|f~combout\,
	devoe => ww_devoe,
	o => ww_F(12));

-- Location: IOOBUF_X8_Y0_N53
\F[13]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \A4|u2|f~combout\,
	devoe => ww_devoe,
	o => ww_F(13));

-- Location: IOOBUF_X32_Y0_N53
\F[14]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \A4|u3|f~1_combout\,
	devoe => ww_devoe,
	o => ww_F(14));

-- Location: IOOBUF_X4_Y0_N2
\F[15]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \A4|u4|f~0_combout\,
	devoe => ww_devoe,
	o => ww_F(15));

-- Location: IOOBUF_X28_Y0_N36
\Gm~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \AAt|Gm~2_combout\,
	devoe => ww_devoe,
	o => ww_Gm);

-- Location: IOOBUF_X2_Y0_N42
\Pm~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \AAt|Pm~0_combout\,
	devoe => ww_devoe,
	o => ww_Pm);

-- Location: IOOBUF_X4_Y0_N19
\C_out~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \AAt|Ci\(4),
	devoe => ww_devoe,
	o => ww_C_out);

-- Location: IOIBUF_X4_Y0_N52
\C_in~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_C_in,
	o => \C_in~input_o\);

-- Location: IOIBUF_X26_Y0_N58
\B[0]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_B(0),
	o => \B[0]~input_o\);

-- Location: IOIBUF_X36_Y0_N52
\A[0]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_A(0),
	o => \A[0]~input_o\);

-- Location: LABCELL_X29_Y1_N0
\A0|u1|f\ : cyclonev_lcell_comb
-- Equation(s):
-- \A0|u1|f~combout\ = ( \A[0]~input_o\ & ( !\C_in~input_o\ $ (\B[0]~input_o\) ) ) # ( !\A[0]~input_o\ & ( !\C_in~input_o\ $ (!\B[0]~input_o\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0110011001100110011001100110011010011001100110011001100110011001",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_C_in~input_o\,
	datab => \ALT_INV_B[0]~input_o\,
	dataf => \ALT_INV_A[0]~input_o\,
	combout => \A0|u1|f~combout\);

-- Location: IOIBUF_X2_Y0_N75
\B[1]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_B(1),
	o => \B[1]~input_o\);

-- Location: IOIBUF_X4_Y0_N35
\A[1]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_A(1),
	o => \A[1]~input_o\);

-- Location: LABCELL_X29_Y1_N3
\A0|u2|f\ : cyclonev_lcell_comb
-- Equation(s):
-- \A0|u2|f~combout\ = ( \A[0]~input_o\ & ( !\B[1]~input_o\ $ (!\A[1]~input_o\ $ (((\B[0]~input_o\) # (\C_in~input_o\)))) ) ) # ( !\A[0]~input_o\ & ( !\B[1]~input_o\ $ (!\A[1]~input_o\ $ (((\C_in~input_o\ & \B[0]~input_o\)))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0001111011100001000111101110000101111000100001110111100010000111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_C_in~input_o\,
	datab => \ALT_INV_B[0]~input_o\,
	datac => \ALT_INV_B[1]~input_o\,
	datad => \ALT_INV_A[1]~input_o\,
	dataf => \ALT_INV_A[0]~input_o\,
	combout => \A0|u2|f~combout\);

-- Location: LABCELL_X29_Y1_N36
\A0|u3|f~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \A0|u3|f~0_combout\ = ( \C_in~input_o\ & ( (!\B[1]~input_o\ & (\A[1]~input_o\ & ((\B[0]~input_o\) # (\A[0]~input_o\)))) # (\B[1]~input_o\ & (((\A[1]~input_o\) # (\B[0]~input_o\)) # (\A[0]~input_o\))) ) ) # ( !\C_in~input_o\ & ( (!\B[1]~input_o\ & 
-- (\A[0]~input_o\ & (\B[0]~input_o\ & \A[1]~input_o\))) # (\B[1]~input_o\ & (((\A[0]~input_o\ & \B[0]~input_o\)) # (\A[1]~input_o\))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000100011111000000010001111100000111011111110000011101111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_A[0]~input_o\,
	datab => \ALT_INV_B[0]~input_o\,
	datac => \ALT_INV_B[1]~input_o\,
	datad => \ALT_INV_A[1]~input_o\,
	dataf => \ALT_INV_C_in~input_o\,
	combout => \A0|u3|f~0_combout\);

-- Location: IOIBUF_X28_Y0_N52
\B[2]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_B(2),
	o => \B[2]~input_o\);

-- Location: IOIBUF_X26_Y0_N75
\A[2]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_A(2),
	o => \A[2]~input_o\);

-- Location: LABCELL_X29_Y1_N15
\A0|u3|f~1\ : cyclonev_lcell_comb
-- Equation(s):
-- \A0|u3|f~1_combout\ = ( \A[2]~input_o\ & ( !\A0|u3|f~0_combout\ $ (\B[2]~input_o\) ) ) # ( !\A[2]~input_o\ & ( !\A0|u3|f~0_combout\ $ (!\B[2]~input_o\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0101101001011010010110100101101010100101101001011010010110100101",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \A0|u3|ALT_INV_f~0_combout\,
	datac => \ALT_INV_B[2]~input_o\,
	dataf => \ALT_INV_A[2]~input_o\,
	combout => \A0|u3|f~1_combout\);

-- Location: IOIBUF_X6_Y0_N1
\A[3]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_A(3),
	o => \A[3]~input_o\);

-- Location: IOIBUF_X6_Y0_N52
\B[3]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_B(3),
	o => \B[3]~input_o\);

-- Location: LABCELL_X29_Y1_N12
\A0|u4|f~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \A0|u4|f~0_combout\ = ( \A[2]~input_o\ & ( !\A[3]~input_o\ $ (!\B[3]~input_o\ $ (((\B[2]~input_o\) # (\A0|u3|f~0_combout\)))) ) ) # ( !\A[2]~input_o\ & ( !\A[3]~input_o\ $ (!\B[3]~input_o\ $ (((\A0|u3|f~0_combout\ & \B[2]~input_o\)))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0001111011100001000111101110000101111000100001110111100010000111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \A0|u3|ALT_INV_f~0_combout\,
	datab => \ALT_INV_B[2]~input_o\,
	datac => \ALT_INV_A[3]~input_o\,
	datad => \ALT_INV_B[3]~input_o\,
	dataf => \ALT_INV_A[2]~input_o\,
	combout => \A0|u4|f~0_combout\);

-- Location: IOIBUF_X40_Y0_N18
\B[4]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_B(4),
	o => \B[4]~input_o\);

-- Location: LABCELL_X29_Y1_N54
\A0|uut|Gm~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \A0|uut|Gm~0_combout\ = ( \B[1]~input_o\ & ( \B[2]~input_o\ & ( (!\B[3]~input_o\ & (\A[3]~input_o\ & ((\A[2]~input_o\) # (\A[1]~input_o\)))) # (\B[3]~input_o\ & (((\A[2]~input_o\) # (\A[3]~input_o\)) # (\A[1]~input_o\))) ) ) ) # ( !\B[1]~input_o\ & ( 
-- \B[2]~input_o\ & ( (!\B[3]~input_o\ & (\A[3]~input_o\ & \A[2]~input_o\)) # (\B[3]~input_o\ & ((\A[2]~input_o\) # (\A[3]~input_o\))) ) ) ) # ( \B[1]~input_o\ & ( !\B[2]~input_o\ & ( (!\B[3]~input_o\ & (\A[1]~input_o\ & (\A[3]~input_o\ & \A[2]~input_o\))) # 
-- (\B[3]~input_o\ & (((\A[1]~input_o\ & \A[2]~input_o\)) # (\A[3]~input_o\))) ) ) ) # ( !\B[1]~input_o\ & ( !\B[2]~input_o\ & ( (\B[3]~input_o\ & \A[3]~input_o\) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000010100000101000001010001011100000101010111110001011101011111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_B[3]~input_o\,
	datab => \ALT_INV_A[1]~input_o\,
	datac => \ALT_INV_A[3]~input_o\,
	datad => \ALT_INV_A[2]~input_o\,
	datae => \ALT_INV_B[1]~input_o\,
	dataf => \ALT_INV_B[2]~input_o\,
	combout => \A0|uut|Gm~0_combout\);

-- Location: LABCELL_X29_Y1_N48
\A0|uut|Ci~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \A0|uut|Ci~0_combout\ = ( \B[1]~input_o\ & ( \B[2]~input_o\ & ( (\A[3]~input_o\) # (\B[3]~input_o\) ) ) ) # ( !\B[1]~input_o\ & ( \B[2]~input_o\ & ( (\A[1]~input_o\ & ((\A[3]~input_o\) # (\B[3]~input_o\))) ) ) ) # ( \B[1]~input_o\ & ( !\B[2]~input_o\ & ( 
-- (\A[2]~input_o\ & ((\A[3]~input_o\) # (\B[3]~input_o\))) ) ) ) # ( !\B[1]~input_o\ & ( !\B[2]~input_o\ & ( (\A[1]~input_o\ & (\A[2]~input_o\ & ((\A[3]~input_o\) # (\B[3]~input_o\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000010011000000000101111100010011000100110101111101011111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_B[3]~input_o\,
	datab => \ALT_INV_A[1]~input_o\,
	datac => \ALT_INV_A[3]~input_o\,
	datad => \ALT_INV_A[2]~input_o\,
	datae => \ALT_INV_B[1]~input_o\,
	dataf => \ALT_INV_B[2]~input_o\,
	combout => \A0|uut|Ci~0_combout\);

-- Location: LABCELL_X29_Y1_N39
\AAt|Ci[1]\ : cyclonev_lcell_comb
-- Equation(s):
-- \AAt|Ci\(1) = ( \A0|uut|Ci~0_combout\ & ( (!\A0|uut|Gm~0_combout\ & ((!\A[0]~input_o\ & ((!\B[0]~input_o\) # (!\C_in~input_o\))) # (\A[0]~input_o\ & (!\B[0]~input_o\ & !\C_in~input_o\)))) ) ) # ( !\A0|uut|Ci~0_combout\ & ( !\A0|uut|Gm~0_combout\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1111111100000000111111110000000011101000000000001110100000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_A[0]~input_o\,
	datab => \ALT_INV_B[0]~input_o\,
	datac => \ALT_INV_C_in~input_o\,
	datad => \A0|uut|ALT_INV_Gm~0_combout\,
	dataf => \A0|uut|ALT_INV_Ci~0_combout\,
	combout => \AAt|Ci\(1));

-- Location: IOIBUF_X50_Y0_N75
\A[4]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_A(4),
	o => \A[4]~input_o\);

-- Location: LABCELL_X36_Y1_N3
\A1|u1|f\ : cyclonev_lcell_comb
-- Equation(s):
-- \A1|u1|f~combout\ = ( \A[4]~input_o\ & ( !\B[4]~input_o\ $ (!\AAt|Ci\(1)) ) ) # ( !\A[4]~input_o\ & ( !\B[4]~input_o\ $ (\AAt|Ci\(1)) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1111000000001111111100000000111100001111111100000000111111110000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \ALT_INV_B[4]~input_o\,
	datad => \AAt|ALT_INV_Ci\(1),
	dataf => \ALT_INV_A[4]~input_o\,
	combout => \A1|u1|f~combout\);

-- Location: IOIBUF_X50_Y0_N41
\B[5]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_B(5),
	o => \B[5]~input_o\);

-- Location: IOIBUF_X36_Y0_N1
\A[5]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_A(5),
	o => \A[5]~input_o\);

-- Location: LABCELL_X36_Y1_N9
\A1|u2|f\ : cyclonev_lcell_comb
-- Equation(s):
-- \A1|u2|f~combout\ = ( \A[5]~input_o\ & ( !\B[5]~input_o\ $ (((!\A[4]~input_o\ & (!\AAt|Ci\(1) & \B[4]~input_o\)) # (\A[4]~input_o\ & ((!\AAt|Ci\(1)) # (\B[4]~input_o\))))) ) ) # ( !\A[5]~input_o\ & ( !\B[5]~input_o\ $ (((!\A[4]~input_o\ & 
-- ((!\B[4]~input_o\) # (\AAt|Ci\(1)))) # (\A[4]~input_o\ & (\AAt|Ci\(1) & !\B[4]~input_o\)))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0110010110100110011001011010011010011010010110011001101001011001",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_B[5]~input_o\,
	datab => \ALT_INV_A[4]~input_o\,
	datac => \AAt|ALT_INV_Ci\(1),
	datad => \ALT_INV_B[4]~input_o\,
	dataf => \ALT_INV_A[5]~input_o\,
	combout => \A1|u2|f~combout\);

-- Location: IOIBUF_X34_Y0_N92
\A[6]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_A(6),
	o => \A[6]~input_o\);

-- Location: IOIBUF_X40_Y0_N52
\B[6]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_B(6),
	o => \B[6]~input_o\);

-- Location: LABCELL_X36_Y1_N15
\A1|u3|f~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \A1|u3|f~0_combout\ = !\A[6]~input_o\ $ (!\B[6]~input_o\)

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0110011001100110011001100110011001100110011001100110011001100110",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_A[6]~input_o\,
	datab => \ALT_INV_B[6]~input_o\,
	combout => \A1|u3|f~0_combout\);

-- Location: LABCELL_X36_Y1_N48
\A1|u3|f~1\ : cyclonev_lcell_comb
-- Equation(s):
-- \A1|u3|f~1_combout\ = ( \AAt|Ci\(1) & ( \A[4]~input_o\ & ( !\A1|u3|f~0_combout\ $ (((!\B[5]~input_o\ & ((!\A[5]~input_o\) # (!\B[4]~input_o\))) # (\B[5]~input_o\ & (!\A[5]~input_o\ & !\B[4]~input_o\)))) ) ) ) # ( !\AAt|Ci\(1) & ( \A[4]~input_o\ & ( 
-- !\A1|u3|f~0_combout\ $ (((!\B[5]~input_o\ & !\A[5]~input_o\))) ) ) ) # ( \AAt|Ci\(1) & ( !\A[4]~input_o\ & ( !\A1|u3|f~0_combout\ $ (((!\B[5]~input_o\) # (!\A[5]~input_o\))) ) ) ) # ( !\AAt|Ci\(1) & ( !\A[4]~input_o\ & ( !\A1|u3|f~0_combout\ $ 
-- (((!\B[5]~input_o\ & ((!\A[5]~input_o\) # (!\B[4]~input_o\))) # (\B[5]~input_o\ & (!\A[5]~input_o\ & !\B[4]~input_o\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0011011001101100001101100011011001101100011011000011011001101100",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_B[5]~input_o\,
	datab => \A1|u3|ALT_INV_f~0_combout\,
	datac => \ALT_INV_A[5]~input_o\,
	datad => \ALT_INV_B[4]~input_o\,
	datae => \AAt|ALT_INV_Ci\(1),
	dataf => \ALT_INV_A[4]~input_o\,
	combout => \A1|u3|f~1_combout\);

-- Location: IOIBUF_X36_Y0_N18
\A[7]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_A(7),
	o => \A[7]~input_o\);

-- Location: LABCELL_X36_Y1_N0
\A1|u3|f~2\ : cyclonev_lcell_comb
-- Equation(s):
-- \A1|u3|f~2_combout\ = ( \B[5]~input_o\ & ( ((!\B[4]~input_o\ & (\A[4]~input_o\ & !\AAt|Ci\(1))) # (\B[4]~input_o\ & ((!\AAt|Ci\(1)) # (\A[4]~input_o\)))) # (\A[5]~input_o\) ) ) # ( !\B[5]~input_o\ & ( (\A[5]~input_o\ & ((!\B[4]~input_o\ & (\A[4]~input_o\ 
-- & !\AAt|Ci\(1))) # (\B[4]~input_o\ & ((!\AAt|Ci\(1)) # (\A[4]~input_o\))))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000011100000001000001110000000101111111000111110111111100011111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_B[4]~input_o\,
	datab => \ALT_INV_A[4]~input_o\,
	datac => \ALT_INV_A[5]~input_o\,
	datad => \AAt|ALT_INV_Ci\(1),
	dataf => \ALT_INV_B[5]~input_o\,
	combout => \A1|u3|f~2_combout\);

-- Location: IOIBUF_X38_Y0_N52
\B[7]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_B(7),
	o => \B[7]~input_o\);

-- Location: LABCELL_X36_Y1_N12
\A1|u4|f~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \A1|u4|f~0_combout\ = ( \B[7]~input_o\ & ( !\A[7]~input_o\ $ (((!\A[6]~input_o\ & (\B[6]~input_o\ & \A1|u3|f~2_combout\)) # (\A[6]~input_o\ & ((\A1|u3|f~2_combout\) # (\B[6]~input_o\))))) ) ) # ( !\B[7]~input_o\ & ( !\A[7]~input_o\ $ (((!\A[6]~input_o\ & 
-- ((!\B[6]~input_o\) # (!\A1|u3|f~2_combout\))) # (\A[6]~input_o\ & (!\B[6]~input_o\ & !\A1|u3|f~2_combout\)))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0001111001111000000111100111100011100001100001111110000110000111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_A[6]~input_o\,
	datab => \ALT_INV_B[6]~input_o\,
	datac => \ALT_INV_A[7]~input_o\,
	datad => \A1|u3|ALT_INV_f~2_combout\,
	dataf => \ALT_INV_B[7]~input_o\,
	combout => \A1|u4|f~0_combout\);

-- Location: LABCELL_X36_Y1_N24
\A1|uut|Gm~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \A1|uut|Gm~0_combout\ = ( \B[6]~input_o\ & ( (!\B[7]~input_o\ & (\A[6]~input_o\ & \A[7]~input_o\)) # (\B[7]~input_o\ & ((\A[7]~input_o\) # (\A[6]~input_o\))) ) ) # ( !\B[6]~input_o\ & ( (\B[7]~input_o\ & \A[7]~input_o\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000110011000000000011001100000011001111110000001100111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datab => \ALT_INV_B[7]~input_o\,
	datac => \ALT_INV_A[6]~input_o\,
	datad => \ALT_INV_A[7]~input_o\,
	dataf => \ALT_INV_B[6]~input_o\,
	combout => \A1|uut|Gm~0_combout\);

-- Location: LABCELL_X36_Y1_N27
\A1|uut|Ci~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \A1|uut|Ci~0_combout\ = ( \B[6]~input_o\ & ( (!\B[7]~input_o\ & !\A[7]~input_o\) ) ) # ( !\B[6]~input_o\ & ( (!\A[6]~input_o\) # ((!\B[7]~input_o\ & !\A[7]~input_o\)) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1110111010101010111011101010101011001100000000001100110000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_A[6]~input_o\,
	datab => \ALT_INV_B[7]~input_o\,
	datad => \ALT_INV_A[7]~input_o\,
	dataf => \ALT_INV_B[6]~input_o\,
	combout => \A1|uut|Ci~0_combout\);

-- Location: LABCELL_X36_Y1_N30
\A1|uut|Gm~1\ : cyclonev_lcell_comb
-- Equation(s):
-- \A1|uut|Gm~1_combout\ = ( \A1|uut|Ci~0_combout\ & ( \B[5]~input_o\ & ( !\A1|uut|Gm~0_combout\ ) ) ) # ( !\A1|uut|Ci~0_combout\ & ( \B[5]~input_o\ & ( (!\A1|uut|Gm~0_combout\ & (!\A[5]~input_o\ & ((!\B[4]~input_o\) # (!\A[4]~input_o\)))) ) ) ) # ( 
-- \A1|uut|Ci~0_combout\ & ( !\B[5]~input_o\ & ( !\A1|uut|Gm~0_combout\ ) ) ) # ( !\A1|uut|Ci~0_combout\ & ( !\B[5]~input_o\ & ( (!\A1|uut|Gm~0_combout\ & ((!\B[4]~input_o\) # ((!\A[5]~input_o\) # (!\A[4]~input_o\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1010101010101000101010101010101010100000100000001010101010101010",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \A1|uut|ALT_INV_Gm~0_combout\,
	datab => \ALT_INV_B[4]~input_o\,
	datac => \ALT_INV_A[5]~input_o\,
	datad => \ALT_INV_A[4]~input_o\,
	datae => \A1|uut|ALT_INV_Ci~0_combout\,
	dataf => \ALT_INV_B[5]~input_o\,
	combout => \A1|uut|Gm~1_combout\);

-- Location: IOIBUF_X30_Y0_N52
\B[8]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_B(8),
	o => \B[8]~input_o\);

-- Location: IOIBUF_X8_Y0_N35
\A[8]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_A(8),
	o => \A[8]~input_o\);

-- Location: LABCELL_X36_Y1_N6
\A1|uut|Pm~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \A1|uut|Pm~0_combout\ = ( \A[5]~input_o\ & ( (!\A1|uut|Ci~0_combout\ & ((\B[4]~input_o\) # (\A[4]~input_o\))) ) ) # ( !\A[5]~input_o\ & ( (\B[5]~input_o\ & (!\A1|uut|Ci~0_combout\ & ((\B[4]~input_o\) # (\A[4]~input_o\)))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0001000001010000000100000101000000110000111100000011000011110000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_B[5]~input_o\,
	datab => \ALT_INV_A[4]~input_o\,
	datac => \A1|uut|ALT_INV_Ci~0_combout\,
	datad => \ALT_INV_B[4]~input_o\,
	dataf => \ALT_INV_A[5]~input_o\,
	combout => \A1|uut|Pm~0_combout\);

-- Location: LABCELL_X30_Y1_N30
\A3|u1|f\ : cyclonev_lcell_comb
-- Equation(s):
-- \A3|u1|f~combout\ = ( \A1|uut|Pm~0_combout\ & ( !\B[8]~input_o\ $ (!\A[8]~input_o\ $ (((!\A1|uut|Gm~1_combout\) # (!\AAt|Ci\(1))))) ) ) # ( !\A1|uut|Pm~0_combout\ & ( !\A1|uut|Gm~1_combout\ $ (!\B[8]~input_o\ $ (!\A[8]~input_o\)) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1010010101011010101001010101101011100001000111101110000100011110",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \A1|uut|ALT_INV_Gm~1_combout\,
	datab => \AAt|ALT_INV_Ci\(1),
	datac => \ALT_INV_B[8]~input_o\,
	datad => \ALT_INV_A[8]~input_o\,
	dataf => \A1|uut|ALT_INV_Pm~0_combout\,
	combout => \A3|u1|f~combout\);

-- Location: IOIBUF_X34_Y0_N41
\B[9]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_B(9),
	o => \B[9]~input_o\);

-- Location: IOIBUF_X34_Y0_N75
\A[9]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_A(9),
	o => \A[9]~input_o\);

-- Location: LABCELL_X35_Y1_N30
\A3|u2|f~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \A3|u2|f~0_combout\ = ( !\B[9]~input_o\ & ( \A[9]~input_o\ ) ) # ( \B[9]~input_o\ & ( !\A[9]~input_o\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111111111111111111111111111110000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datae => \ALT_INV_B[9]~input_o\,
	dataf => \ALT_INV_A[9]~input_o\,
	combout => \A3|u2|f~0_combout\);

-- Location: LABCELL_X30_Y1_N6
\A3|u2|f\ : cyclonev_lcell_comb
-- Equation(s):
-- \A3|u2|f~combout\ = ( \A[8]~input_o\ & ( \A1|uut|Gm~1_combout\ & ( !\A3|u2|f~0_combout\ $ (((!\B[8]~input_o\ & ((!\A1|uut|Pm~0_combout\) # (\AAt|Ci\(1)))))) ) ) ) # ( !\A[8]~input_o\ & ( \A1|uut|Gm~1_combout\ & ( !\A3|u2|f~0_combout\ $ 
-- (((!\A1|uut|Pm~0_combout\) # ((!\B[8]~input_o\) # (\AAt|Ci\(1))))) ) ) ) # ( \A[8]~input_o\ & ( !\A1|uut|Gm~1_combout\ & ( !\A3|u2|f~0_combout\ ) ) ) # ( !\A[8]~input_o\ & ( !\A1|uut|Gm~1_combout\ & ( !\A3|u2|f~0_combout\ $ (!\B[8]~input_o\) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0101101001011010101010101010101001010110010101010110101001011010",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \A3|u2|ALT_INV_f~0_combout\,
	datab => \A1|uut|ALT_INV_Pm~0_combout\,
	datac => \ALT_INV_B[8]~input_o\,
	datad => \AAt|ALT_INV_Ci\(1),
	datae => \ALT_INV_A[8]~input_o\,
	dataf => \A1|uut|ALT_INV_Gm~1_combout\,
	combout => \A3|u2|f~combout\);

-- Location: IOIBUF_X34_Y0_N58
\A[10]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_A(10),
	o => \A[10]~input_o\);

-- Location: LABCELL_X30_Y1_N33
\A3|uut|Ci[1]~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \A3|uut|Ci[1]~0_combout\ = ( \A1|uut|Pm~0_combout\ & ( (!\B[8]~input_o\ & ((!\A[8]~input_o\) # ((\A1|uut|Gm~1_combout\ & \AAt|Ci\(1))))) # (\B[8]~input_o\ & (\A1|uut|Gm~1_combout\ & (\AAt|Ci\(1) & !\A[8]~input_o\))) ) ) # ( !\A1|uut|Pm~0_combout\ & ( 
-- (!\A1|uut|Gm~1_combout\ & (!\B[8]~input_o\ & !\A[8]~input_o\)) # (\A1|uut|Gm~1_combout\ & ((!\B[8]~input_o\) # (!\A[8]~input_o\))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1111010101010000111101010101000011110001000100001111000100010000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \A1|uut|ALT_INV_Gm~1_combout\,
	datab => \AAt|ALT_INV_Ci\(1),
	datac => \ALT_INV_B[8]~input_o\,
	datad => \ALT_INV_A[8]~input_o\,
	dataf => \A1|uut|ALT_INV_Pm~0_combout\,
	combout => \A3|uut|Ci[1]~0_combout\);

-- Location: IOIBUF_X40_Y0_N1
\B[10]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_B(10),
	o => \B[10]~input_o\);

-- Location: LABCELL_X36_Y1_N36
\A3|u3|f~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \A3|u3|f~0_combout\ = ( \B[10]~input_o\ & ( !\A[10]~input_o\ $ (((!\A3|uut|Ci[1]~0_combout\ & ((\A[9]~input_o\) # (\B[9]~input_o\))) # (\A3|uut|Ci[1]~0_combout\ & (\B[9]~input_o\ & \A[9]~input_o\)))) ) ) # ( !\B[10]~input_o\ & ( !\A[10]~input_o\ $ 
-- (((!\A3|uut|Ci[1]~0_combout\ & (!\B[9]~input_o\ & !\A[9]~input_o\)) # (\A3|uut|Ci[1]~0_combout\ & ((!\B[9]~input_o\) # (!\A[9]~input_o\))))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0101100110011010010110011001101010100110011001011010011001100101",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_A[10]~input_o\,
	datab => \A3|uut|ALT_INV_Ci[1]~0_combout\,
	datac => \ALT_INV_B[9]~input_o\,
	datad => \ALT_INV_A[9]~input_o\,
	dataf => \ALT_INV_B[10]~input_o\,
	combout => \A3|u3|f~0_combout\);

-- Location: IOIBUF_X32_Y0_N35
\B[11]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_B(11),
	o => \B[11]~input_o\);

-- Location: IOIBUF_X38_Y0_N18
\A[11]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_A(11),
	o => \A[11]~input_o\);

-- Location: LABCELL_X36_Y1_N39
\A3|u4|f~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \A3|u4|f~0_combout\ = ( \A[11]~input_o\ & ( !\B[11]~input_o\ ) ) # ( !\A[11]~input_o\ & ( \B[11]~input_o\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000111100001111000011110000111111110000111100001111000011110000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \ALT_INV_B[11]~input_o\,
	dataf => \ALT_INV_A[11]~input_o\,
	combout => \A3|u4|f~0_combout\);

-- Location: LABCELL_X36_Y1_N42
\A3|u4|f~1\ : cyclonev_lcell_comb
-- Equation(s):
-- \A3|u4|f~1_combout\ = ( \A3|uut|Ci[1]~0_combout\ & ( \B[10]~input_o\ & ( !\A3|u4|f~0_combout\ $ (((!\A[10]~input_o\ & ((!\A[9]~input_o\) # (!\B[9]~input_o\))))) ) ) ) # ( !\A3|uut|Ci[1]~0_combout\ & ( \B[10]~input_o\ & ( !\A3|u4|f~0_combout\ $ 
-- (((!\A[10]~input_o\ & (!\A[9]~input_o\ & !\B[9]~input_o\)))) ) ) ) # ( \A3|uut|Ci[1]~0_combout\ & ( !\B[10]~input_o\ & ( !\A3|u4|f~0_combout\ $ (((!\A[10]~input_o\) # ((!\A[9]~input_o\) # (!\B[9]~input_o\)))) ) ) ) # ( !\A3|uut|Ci[1]~0_combout\ & ( 
-- !\B[10]~input_o\ & ( !\A3|u4|f~0_combout\ $ (((!\A[10]~input_o\) # ((!\A[9]~input_o\ & !\B[9]~input_o\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0001010111101010000000011111111001111111100000000101011110101000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_A[10]~input_o\,
	datab => \ALT_INV_A[9]~input_o\,
	datac => \ALT_INV_B[9]~input_o\,
	datad => \A3|u4|ALT_INV_f~0_combout\,
	datae => \A3|uut|ALT_INV_Ci[1]~0_combout\,
	dataf => \ALT_INV_B[10]~input_o\,
	combout => \A3|u4|f~1_combout\);

-- Location: LABCELL_X36_Y1_N54
\A3|uut|Gm~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \A3|uut|Gm~0_combout\ = ( \A[9]~input_o\ & ( \B[10]~input_o\ & ( (!\B[11]~input_o\ & (\A[11]~input_o\ & ((\B[9]~input_o\) # (\A[10]~input_o\)))) # (\B[11]~input_o\ & (((\A[11]~input_o\) # (\B[9]~input_o\)) # (\A[10]~input_o\))) ) ) ) # ( !\A[9]~input_o\ & 
-- ( \B[10]~input_o\ & ( (!\A[10]~input_o\ & (\B[11]~input_o\ & \A[11]~input_o\)) # (\A[10]~input_o\ & ((\A[11]~input_o\) # (\B[11]~input_o\))) ) ) ) # ( \A[9]~input_o\ & ( !\B[10]~input_o\ & ( (!\B[11]~input_o\ & (\A[10]~input_o\ & (\B[9]~input_o\ & 
-- \A[11]~input_o\))) # (\B[11]~input_o\ & (((\A[10]~input_o\ & \B[9]~input_o\)) # (\A[11]~input_o\))) ) ) ) # ( !\A[9]~input_o\ & ( !\B[10]~input_o\ & ( (\B[11]~input_o\ & \A[11]~input_o\) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000110011000000010011011100010001011101110001001101111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_A[10]~input_o\,
	datab => \ALT_INV_B[11]~input_o\,
	datac => \ALT_INV_B[9]~input_o\,
	datad => \ALT_INV_A[11]~input_o\,
	datae => \ALT_INV_A[9]~input_o\,
	dataf => \ALT_INV_B[10]~input_o\,
	combout => \A3|uut|Gm~0_combout\);

-- Location: LABCELL_X30_Y1_N48
\A3|uut|Ci~2\ : cyclonev_lcell_comb
-- Equation(s):
-- \A3|uut|Ci~2_combout\ = (\B[8]~input_o\ & \A[8]~input_o\)

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000001111000000000000111100000000000011110000000000001111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \ALT_INV_B[8]~input_o\,
	datad => \ALT_INV_A[8]~input_o\,
	combout => \A3|uut|Ci~2_combout\);

-- Location: LABCELL_X36_Y1_N18
\A3|uut|Ci~1\ : cyclonev_lcell_comb
-- Equation(s):
-- \A3|uut|Ci~1_combout\ = ( \A[9]~input_o\ & ( \B[10]~input_o\ & ( (\A[11]~input_o\) # (\B[11]~input_o\) ) ) ) # ( !\A[9]~input_o\ & ( \B[10]~input_o\ & ( (\B[9]~input_o\ & ((\A[11]~input_o\) # (\B[11]~input_o\))) ) ) ) # ( \A[9]~input_o\ & ( 
-- !\B[10]~input_o\ & ( (\A[10]~input_o\ & ((\A[11]~input_o\) # (\B[11]~input_o\))) ) ) ) # ( !\A[9]~input_o\ & ( !\B[10]~input_o\ & ( (\A[10]~input_o\ & (\B[9]~input_o\ & ((\A[11]~input_o\) # (\B[11]~input_o\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000100000101000100010101010100000011000011110011001111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_A[10]~input_o\,
	datab => \ALT_INV_B[11]~input_o\,
	datac => \ALT_INV_B[9]~input_o\,
	datad => \ALT_INV_A[11]~input_o\,
	datae => \ALT_INV_A[9]~input_o\,
	dataf => \ALT_INV_B[10]~input_o\,
	combout => \A3|uut|Ci~1_combout\);

-- Location: LABCELL_X30_Y1_N54
\A3|uut|Gm~1\ : cyclonev_lcell_comb
-- Equation(s):
-- \A3|uut|Gm~1_combout\ = (!\A3|uut|Gm~0_combout\ & ((!\A3|uut|Ci~2_combout\) # (!\A3|uut|Ci~1_combout\)))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1010101010100000101010101010000010101010101000001010101010100000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \A3|uut|ALT_INV_Gm~0_combout\,
	datac => \A3|uut|ALT_INV_Ci~2_combout\,
	datad => \A3|uut|ALT_INV_Ci~1_combout\,
	combout => \A3|uut|Gm~1_combout\);

-- Location: LABCELL_X30_Y1_N15
\A3|uut|Pm~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \A3|uut|Pm~0_combout\ = ( \B[8]~input_o\ & ( \A3|uut|Ci~1_combout\ ) ) # ( !\B[8]~input_o\ & ( (\A[8]~input_o\ & \A3|uut|Ci~1_combout\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000001111000000000000111100000000111111110000000011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \ALT_INV_A[8]~input_o\,
	datad => \A3|uut|ALT_INV_Ci~1_combout\,
	dataf => \ALT_INV_B[8]~input_o\,
	combout => \A3|uut|Pm~0_combout\);

-- Location: IOIBUF_X26_Y0_N92
\A[12]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_A(12),
	o => \A[12]~input_o\);

-- Location: IOIBUF_X8_Y0_N18
\B[12]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_B(12),
	o => \B[12]~input_o\);

-- Location: LABCELL_X30_Y1_N57
\A4|u1|f~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \A4|u1|f~0_combout\ = !\A[12]~input_o\ $ (!\B[12]~input_o\)

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0011110000111100001111000011110000111100001111000011110000111100",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datab => \ALT_INV_A[12]~input_o\,
	datac => \ALT_INV_B[12]~input_o\,
	combout => \A4|u1|f~0_combout\);

-- Location: LABCELL_X30_Y1_N0
\A4|u1|f\ : cyclonev_lcell_comb
-- Equation(s):
-- \A4|u1|f~combout\ = ( \A4|u1|f~0_combout\ & ( \A1|uut|Pm~0_combout\ & ( (\A3|uut|Gm~1_combout\ & ((!\A3|uut|Pm~0_combout\) # ((\AAt|Ci\(1) & \A1|uut|Gm~1_combout\)))) ) ) ) # ( !\A4|u1|f~0_combout\ & ( \A1|uut|Pm~0_combout\ & ( (!\A3|uut|Gm~1_combout\) # 
-- ((\A3|uut|Pm~0_combout\ & ((!\AAt|Ci\(1)) # (!\A1|uut|Gm~1_combout\)))) ) ) ) # ( \A4|u1|f~0_combout\ & ( !\A1|uut|Pm~0_combout\ & ( (\A3|uut|Gm~1_combout\ & ((!\A3|uut|Pm~0_combout\) # (\A1|uut|Gm~1_combout\))) ) ) ) # ( !\A4|u1|f~0_combout\ & ( 
-- !\A1|uut|Pm~0_combout\ & ( (!\A3|uut|Gm~1_combout\) # ((!\A1|uut|Gm~1_combout\ & \A3|uut|Pm~0_combout\)) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1010101011111010010101010000010110101010111111100101010100000001",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \A3|uut|ALT_INV_Gm~1_combout\,
	datab => \AAt|ALT_INV_Ci\(1),
	datac => \A1|uut|ALT_INV_Gm~1_combout\,
	datad => \A3|uut|ALT_INV_Pm~0_combout\,
	datae => \A4|u1|ALT_INV_f~0_combout\,
	dataf => \A1|uut|ALT_INV_Pm~0_combout\,
	combout => \A4|u1|f~combout\);

-- Location: IOIBUF_X30_Y0_N35
\B[13]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_B(13),
	o => \B[13]~input_o\);

-- Location: LABCELL_X30_Y1_N12
\AAt|Ci[3]~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \AAt|Ci[3]~0_combout\ = ( \A3|uut|Pm~0_combout\ & ( (\A1|uut|Gm~1_combout\ & (\A3|uut|Gm~1_combout\ & ((!\A1|uut|Pm~0_combout\) # (\AAt|Ci\(1))))) ) ) # ( !\A3|uut|Pm~0_combout\ & ( \A3|uut|Gm~1_combout\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000111100001111000011110000111100000101000000010000010100000001",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \A1|uut|ALT_INV_Gm~1_combout\,
	datab => \AAt|ALT_INV_Ci\(1),
	datac => \A3|uut|ALT_INV_Gm~1_combout\,
	datad => \A1|uut|ALT_INV_Pm~0_combout\,
	dataf => \A3|uut|ALT_INV_Pm~0_combout\,
	combout => \AAt|Ci[3]~0_combout\);

-- Location: IOIBUF_X28_Y0_N18
\A[13]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_A(13),
	o => \A[13]~input_o\);

-- Location: LABCELL_X30_Y1_N51
\A4|u2|f\ : cyclonev_lcell_comb
-- Equation(s):
-- \A4|u2|f~combout\ = ( \A[13]~input_o\ & ( !\B[13]~input_o\ $ (((!\B[12]~input_o\ & (!\AAt|Ci[3]~0_combout\ & \A[12]~input_o\)) # (\B[12]~input_o\ & ((!\AAt|Ci[3]~0_combout\) # (\A[12]~input_o\))))) ) ) # ( !\A[13]~input_o\ & ( !\B[13]~input_o\ $ 
-- (((!\B[12]~input_o\ & ((!\A[12]~input_o\) # (\AAt|Ci[3]~0_combout\))) # (\B[12]~input_o\ & (\AAt|Ci[3]~0_combout\ & !\A[12]~input_o\)))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0110010110100110011001011010011010011010010110011001101001011001",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_B[13]~input_o\,
	datab => \ALT_INV_B[12]~input_o\,
	datac => \AAt|ALT_INV_Ci[3]~0_combout\,
	datad => \ALT_INV_A[12]~input_o\,
	dataf => \ALT_INV_A[13]~input_o\,
	combout => \A4|u2|f~combout\);

-- Location: IOIBUF_X30_Y0_N1
\A[14]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_A(14),
	o => \A[14]~input_o\);

-- Location: IOIBUF_X30_Y0_N18
\B[14]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_B(14),
	o => \B[14]~input_o\);

-- Location: LABCELL_X30_Y1_N39
\A4|u3|f~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \A4|u3|f~0_combout\ = ( \B[14]~input_o\ & ( !\A[14]~input_o\ ) ) # ( !\B[14]~input_o\ & ( \A[14]~input_o\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000011111111000000001111111111111111000000001111111100000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datad => \ALT_INV_A[14]~input_o\,
	dataf => \ALT_INV_B[14]~input_o\,
	combout => \A4|u3|f~0_combout\);

-- Location: LABCELL_X30_Y1_N42
\A4|u3|f~1\ : cyclonev_lcell_comb
-- Equation(s):
-- \A4|u3|f~1_combout\ = ( \B[12]~input_o\ & ( \A4|u3|f~0_combout\ & ( (!\B[13]~input_o\ & ((!\A[13]~input_o\) # ((!\A[12]~input_o\ & \AAt|Ci[3]~0_combout\)))) # (\B[13]~input_o\ & (!\A[12]~input_o\ & (!\A[13]~input_o\ & \AAt|Ci[3]~0_combout\))) ) ) ) # ( 
-- !\B[12]~input_o\ & ( \A4|u3|f~0_combout\ & ( (!\B[13]~input_o\ & ((!\A[12]~input_o\) # ((!\A[13]~input_o\) # (\AAt|Ci[3]~0_combout\)))) # (\B[13]~input_o\ & (!\A[13]~input_o\ & ((!\A[12]~input_o\) # (\AAt|Ci[3]~0_combout\)))) ) ) ) # ( \B[12]~input_o\ & ( 
-- !\A4|u3|f~0_combout\ & ( (!\B[13]~input_o\ & (\A[13]~input_o\ & ((!\AAt|Ci[3]~0_combout\) # (\A[12]~input_o\)))) # (\B[13]~input_o\ & (((!\AAt|Ci[3]~0_combout\) # (\A[13]~input_o\)) # (\A[12]~input_o\))) ) ) ) # ( !\B[12]~input_o\ & ( !\A4|u3|f~0_combout\ 
-- & ( (!\B[13]~input_o\ & (\A[12]~input_o\ & (\A[13]~input_o\ & !\AAt|Ci[3]~0_combout\))) # (\B[13]~input_o\ & (((\A[12]~input_o\ & !\AAt|Ci[3]~0_combout\)) # (\A[13]~input_o\))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0001011100000101010111110001011111101000111110101010000011101000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_B[13]~input_o\,
	datab => \ALT_INV_A[12]~input_o\,
	datac => \ALT_INV_A[13]~input_o\,
	datad => \AAt|ALT_INV_Ci[3]~0_combout\,
	datae => \ALT_INV_B[12]~input_o\,
	dataf => \A4|u3|ALT_INV_f~0_combout\,
	combout => \A4|u3|f~1_combout\);

-- Location: LABCELL_X30_Y1_N36
\A4|u3|f~2\ : cyclonev_lcell_comb
-- Equation(s):
-- \A4|u3|f~2_combout\ = ( \AAt|Ci[3]~0_combout\ & ( (!\A[13]~input_o\ & (\B[12]~input_o\ & (\B[13]~input_o\ & \A[12]~input_o\))) # (\A[13]~input_o\ & (((\B[12]~input_o\ & \A[12]~input_o\)) # (\B[13]~input_o\))) ) ) # ( !\AAt|Ci[3]~0_combout\ & ( 
-- (!\A[13]~input_o\ & (\B[13]~input_o\ & ((\A[12]~input_o\) # (\B[12]~input_o\)))) # (\A[13]~input_o\ & (((\A[12]~input_o\) # (\B[13]~input_o\)) # (\B[12]~input_o\))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0001011101011111000101110101111100000101000101110000010100010111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_A[13]~input_o\,
	datab => \ALT_INV_B[12]~input_o\,
	datac => \ALT_INV_B[13]~input_o\,
	datad => \ALT_INV_A[12]~input_o\,
	dataf => \AAt|ALT_INV_Ci[3]~0_combout\,
	combout => \A4|u3|f~2_combout\);

-- Location: IOIBUF_X2_Y0_N58
\A[15]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_A(15),
	o => \A[15]~input_o\);

-- Location: IOIBUF_X32_Y0_N18
\B[15]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_B(15),
	o => \B[15]~input_o\);

-- Location: LABCELL_X29_Y1_N33
\A4|u4|f~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \A4|u4|f~0_combout\ = ( \B[15]~input_o\ & ( !\A[15]~input_o\ $ (((!\B[14]~input_o\ & (\A4|u3|f~2_combout\ & \A[14]~input_o\)) # (\B[14]~input_o\ & ((\A[14]~input_o\) # (\A4|u3|f~2_combout\))))) ) ) # ( !\B[15]~input_o\ & ( !\A[15]~input_o\ $ 
-- (((!\B[14]~input_o\ & ((!\A4|u3|f~2_combout\) # (!\A[14]~input_o\))) # (\B[14]~input_o\ & (!\A4|u3|f~2_combout\ & !\A[14]~input_o\)))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0001111001111000000111100111100011100001100001111110000110000111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_B[14]~input_o\,
	datab => \A4|u3|ALT_INV_f~2_combout\,
	datac => \ALT_INV_A[15]~input_o\,
	datad => \ALT_INV_A[14]~input_o\,
	dataf => \ALT_INV_B[15]~input_o\,
	combout => \A4|u4|f~0_combout\);

-- Location: LABCELL_X29_Y1_N42
\A4|uut|Ci~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \A4|uut|Ci~0_combout\ = ( \B[13]~input_o\ & ( \B[15]~input_o\ & ( (\A[14]~input_o\) # (\B[14]~input_o\) ) ) ) # ( !\B[13]~input_o\ & ( \B[15]~input_o\ & ( (\A[13]~input_o\ & ((\A[14]~input_o\) # (\B[14]~input_o\))) ) ) ) # ( \B[13]~input_o\ & ( 
-- !\B[15]~input_o\ & ( (\A[15]~input_o\ & ((\A[14]~input_o\) # (\B[14]~input_o\))) ) ) ) # ( !\B[13]~input_o\ & ( !\B[15]~input_o\ & ( (\A[15]~input_o\ & (\A[13]~input_o\ & ((\A[14]~input_o\) # (\B[14]~input_o\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000010011000100110001001100000000010111110101111101011111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_B[14]~input_o\,
	datab => \ALT_INV_A[15]~input_o\,
	datac => \ALT_INV_A[14]~input_o\,
	datad => \ALT_INV_A[13]~input_o\,
	datae => \ALT_INV_B[13]~input_o\,
	dataf => \ALT_INV_B[15]~input_o\,
	combout => \A4|uut|Ci~0_combout\);

-- Location: LABCELL_X30_Y1_N24
\AAt|Gm~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \AAt|Gm~0_combout\ = ( \B[12]~input_o\ & ( \A3|uut|Ci~2_combout\ & ( (\A4|uut|Ci~0_combout\ & (((\A3|uut|Ci~1_combout\) # (\A[12]~input_o\)) # (\A3|uut|Gm~0_combout\))) ) ) ) # ( !\B[12]~input_o\ & ( \A3|uut|Ci~2_combout\ & ( (\A[12]~input_o\ & 
-- (\A4|uut|Ci~0_combout\ & ((\A3|uut|Ci~1_combout\) # (\A3|uut|Gm~0_combout\)))) ) ) ) # ( \B[12]~input_o\ & ( !\A3|uut|Ci~2_combout\ & ( (\A4|uut|Ci~0_combout\ & ((\A[12]~input_o\) # (\A3|uut|Gm~0_combout\))) ) ) ) # ( !\B[12]~input_o\ & ( 
-- !\A3|uut|Ci~2_combout\ & ( (\A3|uut|Gm~0_combout\ & (\A[12]~input_o\ & \A4|uut|Ci~0_combout\)) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000010001000000000111011100000000000100110000000001111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \A3|uut|ALT_INV_Gm~0_combout\,
	datab => \ALT_INV_A[12]~input_o\,
	datac => \A3|uut|ALT_INV_Ci~1_combout\,
	datad => \A4|uut|ALT_INV_Ci~0_combout\,
	datae => \ALT_INV_B[12]~input_o\,
	dataf => \A3|uut|ALT_INV_Ci~2_combout\,
	combout => \AAt|Gm~0_combout\);

-- Location: LABCELL_X29_Y1_N18
\AAt|Gm~1\ : cyclonev_lcell_comb
-- Equation(s):
-- \AAt|Gm~1_combout\ = ( \B[13]~input_o\ & ( \B[15]~input_o\ & ( ((!\B[14]~input_o\ & (\A[14]~input_o\ & \A[13]~input_o\)) # (\B[14]~input_o\ & ((\A[13]~input_o\) # (\A[14]~input_o\)))) # (\A[15]~input_o\) ) ) ) # ( !\B[13]~input_o\ & ( \B[15]~input_o\ & ( 
-- ((\B[14]~input_o\ & \A[14]~input_o\)) # (\A[15]~input_o\) ) ) ) # ( \B[13]~input_o\ & ( !\B[15]~input_o\ & ( (\A[15]~input_o\ & ((!\B[14]~input_o\ & (\A[14]~input_o\ & \A[13]~input_o\)) # (\B[14]~input_o\ & ((\A[13]~input_o\) # (\A[14]~input_o\))))) ) ) ) 
-- # ( !\B[13]~input_o\ & ( !\B[15]~input_o\ & ( (\B[14]~input_o\ & (\A[15]~input_o\ & \A[14]~input_o\)) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000100000001000000010001001100110111001101110011011101111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_B[14]~input_o\,
	datab => \ALT_INV_A[15]~input_o\,
	datac => \ALT_INV_A[14]~input_o\,
	datad => \ALT_INV_A[13]~input_o\,
	datae => \ALT_INV_B[13]~input_o\,
	dataf => \ALT_INV_B[15]~input_o\,
	combout => \AAt|Gm~1_combout\);

-- Location: LABCELL_X30_Y1_N18
\AAt|Ci~1\ : cyclonev_lcell_comb
-- Equation(s):
-- \AAt|Ci~1_combout\ = ( \A4|uut|Ci~0_combout\ & ( \B[12]~input_o\ & ( (\A3|uut|Ci~1_combout\ & ((\B[8]~input_o\) # (\A[8]~input_o\))) ) ) ) # ( \A4|uut|Ci~0_combout\ & ( !\B[12]~input_o\ & ( (\A3|uut|Ci~1_combout\ & (\A[12]~input_o\ & ((\B[8]~input_o\) # 
-- (\A[8]~input_o\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000001010100000000000000000001010100010101",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \A3|uut|ALT_INV_Ci~1_combout\,
	datab => \ALT_INV_A[8]~input_o\,
	datac => \ALT_INV_B[8]~input_o\,
	datad => \ALT_INV_A[12]~input_o\,
	datae => \A4|uut|ALT_INV_Ci~0_combout\,
	dataf => \ALT_INV_B[12]~input_o\,
	combout => \AAt|Ci~1_combout\);

-- Location: LABCELL_X29_Y1_N6
\A0|uut|Gm~1\ : cyclonev_lcell_comb
-- Equation(s):
-- \A0|uut|Gm~1_combout\ = ( \A0|uut|Ci~0_combout\ & ( (!\A0|uut|Gm~0_combout\ & ((!\A[0]~input_o\) # (!\B[0]~input_o\))) ) ) # ( !\A0|uut|Ci~0_combout\ & ( !\A0|uut|Gm~0_combout\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1111000011110000111100001111000011100000111000001110000011100000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_A[0]~input_o\,
	datab => \ALT_INV_B[0]~input_o\,
	datac => \A0|uut|ALT_INV_Gm~0_combout\,
	dataf => \A0|uut|ALT_INV_Ci~0_combout\,
	combout => \A0|uut|Gm~1_combout\);

-- Location: LABCELL_X29_Y1_N24
\AAt|Gm~2\ : cyclonev_lcell_comb
-- Equation(s):
-- \AAt|Gm~2_combout\ = ( \A1|uut|Pm~0_combout\ & ( \A0|uut|Gm~1_combout\ & ( (((!\A1|uut|Gm~1_combout\ & \AAt|Ci~1_combout\)) # (\AAt|Gm~1_combout\)) # (\AAt|Gm~0_combout\) ) ) ) # ( !\A1|uut|Pm~0_combout\ & ( \A0|uut|Gm~1_combout\ & ( 
-- (((!\A1|uut|Gm~1_combout\ & \AAt|Ci~1_combout\)) # (\AAt|Gm~1_combout\)) # (\AAt|Gm~0_combout\) ) ) ) # ( \A1|uut|Pm~0_combout\ & ( !\A0|uut|Gm~1_combout\ & ( ((\AAt|Ci~1_combout\) # (\AAt|Gm~1_combout\)) # (\AAt|Gm~0_combout\) ) ) ) # ( 
-- !\A1|uut|Pm~0_combout\ & ( !\A0|uut|Gm~1_combout\ & ( (((!\A1|uut|Gm~1_combout\ & \AAt|Ci~1_combout\)) # (\AAt|Gm~1_combout\)) # (\AAt|Gm~0_combout\) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0011111110111111001111111111111100111111101111110011111110111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \A1|uut|ALT_INV_Gm~1_combout\,
	datab => \AAt|ALT_INV_Gm~0_combout\,
	datac => \AAt|ALT_INV_Gm~1_combout\,
	datad => \AAt|ALT_INV_Ci~1_combout\,
	datae => \A1|uut|ALT_INV_Pm~0_combout\,
	dataf => \A0|uut|ALT_INV_Gm~1_combout\,
	combout => \AAt|Gm~2_combout\);

-- Location: LABCELL_X29_Y1_N9
\AAt|Pm~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \AAt|Pm~0_combout\ = ( \A0|uut|Ci~0_combout\ & ( (\AAt|Ci~1_combout\ & (\A1|uut|Pm~0_combout\ & ((\B[0]~input_o\) # (\A[0]~input_o\)))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000000000000000001110000000000000111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_A[0]~input_o\,
	datab => \ALT_INV_B[0]~input_o\,
	datac => \AAt|ALT_INV_Ci~1_combout\,
	datad => \A1|uut|ALT_INV_Pm~0_combout\,
	dataf => \A0|uut|ALT_INV_Ci~0_combout\,
	combout => \AAt|Pm~0_combout\);

-- Location: LABCELL_X29_Y1_N30
\AAt|Ci[4]\ : cyclonev_lcell_comb
-- Equation(s):
-- \AAt|Ci\(4) = ( \AAt|Pm~0_combout\ & ( (\C_in~input_o\) # (\AAt|Gm~2_combout\) ) ) # ( !\AAt|Pm~0_combout\ & ( \AAt|Gm~2_combout\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000111100001111000011110000111100001111111111110000111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \AAt|ALT_INV_Gm~2_combout\,
	datad => \ALT_INV_C_in~input_o\,
	dataf => \AAt|ALT_INV_Pm~0_combout\,
	combout => \AAt|Ci\(4));

-- Location: LABCELL_X66_Y1_N0
\~QUARTUS_CREATED_GND~I\ : cyclonev_lcell_comb
-- Equation(s):

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000000000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
;
END structure;


