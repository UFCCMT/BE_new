# @Author:	Nalini Kumar
# @Date:	09-12-16
# @Brief:	Hardware description file for Titan @ LLNL



# Simulation Root is the "type" (not the "name") of the component that defines 
# simulation granularity. default:system, rack, node, processor
Root( "node" )

#This capability will need to be built into the simulator
Leaf( "processor" )		# deafult:core, processor, node



#------------- Define machine hierarchies --------------
# Component( "name", "hierarchy", "type", "quantity" )

# Containers:
Component( "titan", "system" )       
Component( "titan.rack" ) #200 racks
Component( "titan.board" ) #24 boards

# Real things:
Component( "titan.node", "node", "cray-xk7", "4" )
Component( "titan.cpu", "processor", "amd.opteron", "1" )
Component( "titan.gpu", "processor", "nvidia.k20x", "1" )

#Override lookup file defined for "titan.cpu' for "computeA"
Operation( "titan.cpu", "computeA", "amd.opteron.computeA.csv")
Operation( "titan.gpu", "transfer", "pci-x16-transfer.csv")



#------------- Define machine networks -----------------
Component( "titan.network", "cray-gemini" )		#predefined type cray-gemini
Component( "titan.node.network", "pci-x16" )	#predefined type pci-x16
Component( "titan.processor.network", "links")

# Override lookup file for "titan.network" and "titan.node.network" for "transfer"
Operation( "titan.network", "transfer", "gemini-transfer.csv")
Operation( "titan.node.network", "transfer", "pci-x16-transfer.csv")



#------------- Describe the connectivity -----------
Connect( "titan.cpu" "titan.cpu.mem", "ddr-channel")
Connect( "titan.gpu" "titan.gpu.mem", "gddr5-channel")
#Offspring( container.name, connect[offspring1, offspring2, interconnect], ... )
Offspring( "temp", connect["titan.cpu", "titan.gpu", "titan.node.network"], ... )
Offspring( "titan.node", connect["temp", "titan.network.router", "ht3link"] )
Offspring( "titan.system", connect["titan.network.router", "3d-torus[200,30,16]"] )
Offspring( "titan.rack", connect["titan.network.router", "3d-torus[]"] )












