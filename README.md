Computer Organization Project 3 – MIPS Assembly 3

Due: 23:55, Apr. 7, 2021

Binary search is an efficient search algorithm to locate the position of a specific value (key) within a sorted array. In each step, the algorithm compares the input key value with the value of the middle array element. On a key match, the matching element has been found and its index/position is returned. Otherwise, if the input key is less than the middle element, then the algorithm repeats itself on the sub-array to the left. If the input key is greater, the algorithm repeats itself on the sub-array to the right. If the remaining array size to be searched is reduced to zero, then the key cannot be found in the array and a special "Not found" indication is returned. The algorithm complexity is 𝑂(log 𝑁). In this project, you are required to implement a binary search algorithm for a sorted input array A. The array contains at most 100 integer elements separated by commas. All values are between -100 and 100.

Please submit your source code according to the following rules:

1- Write down enough comments such that you would receive higher scores.

2- The filename is your student ID (e.g., B12345678.asm).

Example:

Please input array A:

0,2,4,6,8,10,12,14

Please input a key value:

14

Step 1: A[3] < 14

Step 2: A[5] < 14

Step 3: A[6] < 14

Step 4: A[7] = 14

Please input array A:

10,8,8,1,-3,-7,-9

Please input a key value:

-2

Step 1: A[3] > -2

Step 2: A[5] < -2

Step 3: A[4] < -2

Step 4: Not found!

Please input array A:

5,2,0,1,3,1,4

Error! The array is not sorted.