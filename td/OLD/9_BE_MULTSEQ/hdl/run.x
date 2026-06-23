ghdl -a mult_seq.vhd
ghdl -a mult_seq_tb.vhd
ghdl -e mult_seq_tb
ghdl -r mult_seq_tb --wave=mult_seq.ghw
gtkwave mult_seq.ghw wave.gtkw
