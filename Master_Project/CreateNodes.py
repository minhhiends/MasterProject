import random
import numpy as np 
import matplotlib.pyplot as plt
from scipy.spatial.distance import cdist


np.random.seed(11)

#Create Array nodes function
np.set_printoptions(threshold="nan")
N = 100
X = ["X0", "X1", "X2", "X3", "X4", "X5", "X6", "X7", "X8", "X9"]
P = ["P0", "P1", "P2", "P3", "P4", "P5", "P6", "P7", "P8", "P9"]
color = ["blue", "green", "lime", "navy", "black", "grey",
 "brown", "indigo", "orange", "violet"]

for i in range(0,len(X)):
    X[i]= 370*np.random.rand(random.randrange(N), 2)
Y = np.concatenate((X[0], X[1], X[2], X[3], X[4], X[5], X[6], X[7], X[8], X[9]), axis = 0)
original_label = np.asarray([0]*len(X[0]) + [1]*len(X[1]) +
 [2]*len(X[2]) + [3]*len(X[3]) + [4]*len(X[4]) + [5]*len(X[5]) + 
 [6]*len(X[6]) + [7]*len(X[7]) + [8]*len(X[8]) + [9]*len(X[9])).T
print (len(Y))
np.savetxt('Nodes.txt', Y,fmt='%4.4f', delimiter=' ')
# f3 = open("Nodes.txt", "w")
# f3.write("%s" %Y)
# f3.close()