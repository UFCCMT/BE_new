from xml.dom import minidom
from xml.dom.minidom import parse
import codecs
import re
import meshRT
#Calls python scripts to create routing tables.  X and Y are dimensions of routing table.  Distance is the physical distance between nodes.  Note that
#another python script that defines functionality must be created for other topologies
x=9
y=8
distance=.001
speed="bandwidth"
meshRT.make(x,y,distance,speed)
