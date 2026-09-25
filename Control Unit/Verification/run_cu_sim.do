# createing and map the working library
vlib work
vmap work work

# compiling the DUT files 
vlog -work work +cover ../CU.v
vlog -work work +cover ../dispatchROM1.v
vlog -work work +cover ../dispatchROM2.v

# compiling the Testbench files 
vlog -work work interface.sv
vlog -work work cu_package.sv
vlog -work work top.sv

# loading the simulation with visibility (+acc) and coverage tracking enabled
vsim -voptargs="+acc" -coverage work.top_tb

# configuring the Waveform Viewer
# logs all signals inside the interface
add wave -divider "Execution Interface"
add wave -position insertpoint sim:/top_tb/u_intf/*

# logging the internal DUT signals
add wave -divider "CU Internals"
add wave -position insertpoint sim:/top_tb/dut/*

# running the simulation
run -all

# generating the detailed coverage reports
# Functional Coverage Report (Covergroups and Assertions only)
coverage report -output func_cov_report.txt -detail -cvg -assert

# Structural Code Coverage Report (Statements, Branches, Toggles + Annotated Code)
coverage report -output code_cov_report.txt -detail -codeAll -annotate

# saving the database and generating an interactive HTML Code Coverage report
coverage save simulation_data.ucdb
vcover report -html simulation_data.ucdb -htmldir html_code_cov

echo "Simulation complete! Check code_cov_report.txt and func_cov_report.txt for coverage"