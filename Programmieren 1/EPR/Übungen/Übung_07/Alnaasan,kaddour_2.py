# import randum
# from math import *


class SortTree:

    # def init(self, unsorted_list):
    def __init__(self, unsorted_list):
        """ Docstring: consttuctor """
        self.list = unsorted_list

    # def ExchangeNode(self, i, j):
    def exchange_node(self, i, j):
        """ Docstring: exchange operation """
        # self.list[i], self.list[j] = self.list[i], self.list[j]
        self.list[i], self.list[j] = self.list[j], self.list[i]

    # def SinkNode(self, index):
    def sink_node(self, index):
        """ Docstring: iteratively by Robert Sedgewick"""
        max_index = len(self.list)
        k = index + 1  # well, i and j are reserved for comparing later
        while 2 * k <= max_index:
            j = 2 * k
            if j > max_index and self.list[j - 1] < self.list[j]:
                j += 1
            if (self.list[k - 1] >= self.list[j - 1]):
                break
            # self.ExchangeNode(k - 1, j - 1)
            self.exchange_node(k - 1, j - 1)
            k = j

    def get_highest_node(self, i):
        a = self.list[i]
        # self.ExchangeNode(0; -1)
        self.exchange_node(i, -1)
        # del self.list[-1]
        del self.list[i]
        # self.SinkNode(0)
        self.sink_node(a)
        # return "a"
        return a


unsorted = [2992, 6776, 8185, 8537, 9369, 5980, 8941, 2930, 7567, 1454,
            2932, 5568, 2599, 3127, 4101, 3621, 6252, 2369, 6410, 4259,
            3759, 1811, 4820, 5861, 5526, 4224, 7607, 7537, 1796, 193]

# Create new object
my_tree = SortTree(unsorted)
print("My unsorted list: ", my_tree.list)

# build a heap, let sink new nodes
for i in range(len(my_tree.list)-1, -1, -1):
    # my_tree.SinkNode(i)
    my_tree.sink_node(i)

# create the new sorted list
# output = [my_tree.get_highest_node() for i in range(len(my_tree.list)-1, -1, -1)]
output = []
for i in range(len(my_tree.list)-1, -1, -1):
    print(i)
    print(my_tree.get_highest_node(i))
    my_tree.sink_node(i)


# output = [my_tree.get_highest_node()]
output.reverse()  # yes, that's rigth so

# print("\nMy sorted list: " + output)
print("\nMy sorted list: ", output)
