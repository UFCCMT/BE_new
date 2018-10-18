# @Author:	Nalini Kumar
# @Date:	09-27-16
# @Brief:	Hardware description file for Cab @ LLNL



# Simulation Root is the "type" (not the "name") of the component that defines 
# simulation granularity. default:system, rack, node, processor
Root( "system" )

#This capability will need to be built into the simulator
Leaf( "processor" )		# deafult:core, processor, node



#------------- Define machine hierarchies --------------
# Component( "name", "hierarchy", "type", "quantity" )
# Should we have "my.type", "my.child.type" in the component description?

# Containers:
Component( "cab", "system" )       

# Real things:
Component( "cab.node", "node", " ", "1296" )
Component( "cab.cpu", "processor", "intel.xeon-e5-2670", "2" )
Component( "cab.cpu.cores", "cores", "intel.xeon-e5-2670.core", "8")

#Override lookup file defined for "titan.cpu' for "computeA"
Operation( "cab.cpu", "computeA", "intel.xeon.computeA.csv")



#------------- Define machine networks -----------------
Component( "cab.network", "cray-gemini" )	#predefined type cray-gemini
Component( "titan.node.network", "pci-x16" )	#predefined type pci-x16
Component( "titan.processor.network", "links")

# Override lookup file for "titan.network" and "titan.node.network" for "transfer"
Operation( "titan.network", "transfer", "gemini-transfer.csv")
Operation( "titan.node.network", "transfer", "pci-x16-transfer.csv")



#------------- Describe the connectivity -----------
Connect( "titan.cpu" "titan.cpu.mem", "ddr-channel")
#Offspring( container.name, connect[offspring1, offspring2, interconnect], ... )
Offspring( "temp", connect["titan.cpu", "titan.gpu", "titan.node.network"], ... )
Offspring( "titan.node", connect["temp", "titan.network.router", "ht3link"] )
Offspring( "titan.system", connect["titan.network.router", "3d-torus[200,30,16]"] )
Offspring( "titan.rack", connect["titan.network.router", "3d-torus[]"] )












