TARGET=bcd2bin
TOP=bcd2bin_top

OBJS = bcd2bin_top.v bcd_sub_block.v control_fsm_b2b.v down_counter.v main_register_right.v perip_bcd2bin.v
PER_OBJS = perip_sqrt.v $(OBJS)

BUILD_DIR = build

all: sim

sim:
	rm -f a.out *.vcd
	iverilog -DBENCH $(TARGET)_TB.v $(OBJS)
	vvp a.out
	gtkwave $(TARGET)_TB.vcd

sim_per:
	rm -f a.out *.vcd
	iverilog -DBENCH   perip_$(TARGET)_TB.v $(PER_OBJS)
	vvp a.out
	gtkwave perip_$(TARGET)_TB.vcd &
$(TOP).json:
	yosys -v3  -p ' read_verilog $(OBJS);  synth_ice40  -top $(TARGET); write_verilog $(TOP)_synth.v' -l ${TARGET}.rpt

#	yosys -v3 -l synth.log -p 'synth_ice40 -top $(TOP) -json $(TOP).json; write_verilog -attr2comment $(TOP)_synth.v' $(OBJS)
#	yosys -p "read_verilog $(TOP)_synth.v; read_verilog cells_sim.v; prep -top $(TOP); show -format svg -prefix yosys"  # Visualize
## ---------------------
## post-synth simulation
## ---------------------

sim_post_syn: $(TOP).json $(OBJS)
	iverilog -g2012 -DSYNTH -o $@_PS.vpp -s $(TOP)_TB $(TARGET)_TB.v $(TOP)_synth.v $(ICE40_SIM_CELLS) 
	vvp $@_PS.vpp
	gtkwave $(TOP)_TB.vcd &
sim_post_syn_sky:
	yosys -l synth.log -c synth.tcl
	cp out.v $(TOP)_synth_sky.v 
	iverilog -DFUNCTIONAL -DUNIT_DELAY=#1 -o $@_PS.vpp -s $(TOP)_TB $(TARGET)_TB.v $(TOP)_synth_sky.v ${SIM_OBJS}
	vvp $@_PS.vpp
	./$@_PS.vpp
	gtkwave $(TOP)_TB.vcd &
	#netlistsvg ${TARGET}.json -o ${TARGET}.svg  #--skin default.svg
	

## ---------------------
## post-route simulation
## ---------------------
$(TOP).asc: $(TOP).json
	nextpnr-ice40 --hx8k --package ct256 --json $(TOP).json --pcf $(TOP).pcf --asc $@  --routed-svg $(TOP)_routed.svg --placed-svg $(TOP)_placed.svg #--pcf-allow-unconstrained
sim_post_route: $(TOP).asc $(TOP).pcf
	icebox_vlog -L -n $(TOP) -sp $(TOP).pcf $< > $(TOP)_route.v
	iverilog -o $@.vpp -s $(TOP)_TB $(TARGET)_post_route_TB.v  $(TOP)_route.v  $(ICE40_SIM_CELLS)
	chmod -x $@
	vvp $@.vpp
	gtkwave $(TOP)_TB.vcd &

svg: $(OBJS)
	yosys -p "prep -top ${TARGET}; write_json ${TARGET}.json" ${OBJS}
	netlistsvg ${TARGET}.json -o ${TARGET}.svg  #--skin default.svg
	yosys -p "prep -top ${TARGET} -flatten; write_json ${TARGET}_flat.json" ${OBJS}
	netlistsvg ${TARGET}_flat.json -o ${TARGET}_flat.svg  #--skin default.svg

clean:
	rm -rf *.out *.vcd *.svg *.json
