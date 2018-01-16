import random
import numpy as np 
import matplotlib.pyplot as plt
from scipy.spatial.distance import cdist
from kmeans_functions import*

np.random.seed(11)
#Main function
K = 8
(centers, labels, it) = kmeans(Y, K)
P = kmeans_display(Y, labels[-1],centers[-1])

#Save nodes and center
f2 = open("Centers" + str(K) + ".txt", "w")
f2.write("%s" %centers[-1])
f2.close()