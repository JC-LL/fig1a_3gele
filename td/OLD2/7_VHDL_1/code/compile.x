echo "=> cleaning..."
rm -rf waves.ghw *.o
echo "=> analyzing VHDL files..."
ghdl -a half_adder.vhd
ghdl -a full_adder.vhd
ghdl -a adder8b.vhd
ghdl -a adder8b_generate.vhd
ghdl -a adder8b_tb.vhd
echo "=> elaboration..."
ghdl -e adder8b_tb
echo "=> running simulation"
ghdl -r adder8b_tb --wave=waves.ghw > log
echo "=> starting waveform viewer"
gtkwave waves.ghw chrono.sav
