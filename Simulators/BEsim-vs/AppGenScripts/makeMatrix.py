from xml.dom import minidom
from xml.dom.minidom import parse
import codecs
import re
import VSMatrixBuilder
#Creates layout of BEOs for use in VS.  Note that the VSMatrixBuilder python scripts defines actual functionality. 
x=16
y=16
VSMatrixBuilder.make(x,y)
