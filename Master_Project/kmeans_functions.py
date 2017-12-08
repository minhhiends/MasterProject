import random
import numpy as np 
import matplotlib.pyplot as plt
from scipy.spatial.distance import cdist


np.set_printoptions(threshold="nan")
np.random.seed(11)
Max_nodes = 100

X = ["X0", "X1", "X2", "X3", "X4", "X5", "X6", "X7", "X8", "X9", "X9"]
P = ["P0", "P1", "P2", "P3", "P4", "P5", "P6", "P7", "P8", "P9", "X9"]
color = ["blue", "green", "lime", "navy", "black", "grey",
 "brown", "indigo", "orange", "violet", "gold"]
with open("Nodes.txt", "r") as f1:
    Y = f1.read()
    Y = np.fromstring(Y, dtype=np.float, sep = '\n').reshape(613,2)
    #Display nodes function
    def kmeans_display(Y, label, centers):
        K = np.amax(label) + 1
        for t in range(0, len(X)):
            X[t] = Y[label == t, ]
            plt.plot(X[t][:, 0], X[t][:, 1], color[t],linestyle='',
                 marker ='o', markersize = 4, alpha = .8)
            P[t] = len(X[t])
            plt.plot(centers[:, 0], centers[:, 1],linestyle='none', marker='*',
                markersize = 18, color = "red", zorder=10)
        for l in range(0, len(X)):
            for k in range(0, len(X[l])):
                plt.plot([centers[l][0], X[l][k][0]],[centers[l][1], X[l][k][1]], color[l])
        plt.axis('equal')
        plt.plot()
        plt.show()
        return P

    #Random first centers
    def kmeans_init_centers(X, k):
        # randomly pick k rows of X as initial centers
        return Y[np.random.choice(Y.shape[0], k, replace=False)]

    #Calculate distances between nodes and centers
    def kmeans_assign_labels(X, centers):
        # calculate pairwise distances btw data and centers
        D = cdist(Y, centers)
        #return index of the closest center
        H = np.argmin(D, axis = 1)
        # G1 = np.bincount(H)
        # print G1
        return (H)

    #Update new centers
    def kmeans_update_centers(X, labels, K):
        centers = np.zeros((K, Y.shape[1]))
        f4 = open("/home/minhhien/Documents/MasterProject/Master_Project/Debug/distances.txt", "w+")
        f5 = open("/home/minhhien/Documents/MasterProject/Master_Project/Debug/check_condiction.txt","w+")
        for k in range(K):
            # collect all points assigned to the k-th cluster
            Yk= Y[labels == k, ]
            np.savetxt('/home/minhhien/Documents/MasterProject/Master_Project/Debug/nodes_assign.txt', Y,fmt='%4.4f', delimiter=' ')
            # take average
            centers[k,:] = np.mean(Yk, axis = 0)
        nodes_assign = np.loadtxt("/home/minhhien/Documents/MasterProject/Master_Project/Debug/nodes_assign.txt",delimiter=' ')
        Dist = cdist(nodes_assign, centers[:,:])
        #Check condiction distance < 90
        for i in Dist:
            f5.write("%s\n" %any(i < 113))
        f4.write("%s\n" %Dist)
        f4.close()
        f5.close()
        return centers

    #Compare position between old centers and new centers
    def has_converged1(centers, new_centers):
        # return True if two sets of centers are the same
        return ((set([tuple(a) for a in centers]) == 
            set([tuple(a) for a in new_centers])))

    #Compare numbers of nodes with max nodes
    def has_converged2(g, Max_nodes):
        #return True if nodes < max_nodes
        return (all( g< Max_nodes))

    #K-mean function
    def kmeans(X, K):
        centers = [kmeans_init_centers(Y, K)]
        labels = []
        it = 0 
        while True:
            labels.append(kmeans_assign_labels(Y, centers[-1]))
            g = np.bincount(labels[-1])
            new_centers = kmeans_update_centers(Y, labels[-1], K)
            if ((has_converged1(centers[-1], new_centers)) and (has_converged2(g,Max_nodes))):
                break
            centers.append(new_centers)
            it += 1
        labels.append(kmeans_assign_labels(Y, centers[-1]))
        print "Clustering's time:",it,"(times)"
        print "Centers found:"
        print centers[-1]
        return centers, labels, it