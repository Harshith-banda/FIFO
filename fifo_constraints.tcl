create_clock -name MYCLK -period 10 [get_ports clk];

# Set clock latency (adjust as needed based on synthesis and timing analysis)
set_clock_latency -source 1 [get_clocks MYCLK];
set_clock_latency 1 [get_clocks MYCLK];

# Set clock uncertainty (adjust based on clock jitter and uncertainty)
set_clock_uncertainty -setup 0.5 [get_clocks MYCLK];
set_clock_uncertainty -hold 0.1 [get_clocks MYCLK];

# Set input delays for control signals (wr_en, rd_en)
set_input_delay -max 3 -clock [get_clocks MYCLK] {wr_en rd_en}
set_input_delay -min 1 -clock [get_clocks MYCLK] {wr_en rd_en}

# Set input delay for data input (data_in)
set_input_delay -max 3 -clock [get_clocks MYCLK] {data_in}
set_input_delay -min 1 -clock [get_clocks MYCLK] {data_in}

# Set input transition times for control signals (wr_en, rd_en)
set_input_transition -max 0.4 {wr_en rd_en}
set_input_transition -min 0.1 {wr_en rd_en}

# Set input transition time for data input (data_in)
set_input_transition -max 0.4 {data_in}
set_input_transition -min 0.1 {data_in}

# Set output delays for data output (data_out)
set_output_delay -max 2 -clock [get_clocks MYCLK] {data_out}
set_output_delay -min 1 -clock [get_clocks MYCLK] {data_out}

# Set output delays for control signals (full, empty)
set_output_delay -max 2 -clock [get_clocks MYCLK] {full empty}
set_output_delay -min 1 -clock [get_clocks MYCLK] {full empty}
