# SWITCH INPUTS
set_property PACKAGE_PIN F22        [get_ports {switch}];  # "Switch In"
set_property IOSTANDARD LVCMOS33    [get_ports {switch}];
 

# TO DO DAC OUTPUTS
set_property PACKAGE_PIN W7         [get_ports MOSI];  
set_property IOSTANDARD LVCMOS33    [get_ports MOSI];

set_property PACKAGE_PIN V7         [get_ports spi_clk];  
set_property IOSTANDARD LVCMOS33    [get_ports spi_clk];

set_property PACKAGE_PIN V5         [get_ports CS];  
set_property IOSTANDARD LVCMOS33    [get_ports CS];


# ZedBoard Y9 - external 100?MHz oscillator
set_property PACKAGE_PIN Y9                     [get_ports clk];
set_property IOSTANDARD LVCMOS33                [get_ports clk];
create_clock -name sys_clk -period 10.0         [get_ports clk];
