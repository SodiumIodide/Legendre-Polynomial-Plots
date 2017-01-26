#!usr/bin/env python3
"""
Generate Legendre polynomials and plot them.

@author: Corey Skinner
"""


import numpy as np
from scipy.misc import factorial
import matplotlib.pyplot as plt
import seaborn as sns


def main():
    """Main Function."""
    # Plot P_0 through P_5
    indices = 6
    xarr = np.linspace(-1, 1, 100)
    legendre = []
    for index in range(indices):
        yarr = np.array([])
        for point in xarr:
            lsum = 0
            if index % 2 != 0:
                sumto = (index - 1) / 2
            else:
                sumto = index / 2
            i = 0
            while i <= sumto:
                lsum += (-1)**i * factorial(2 * index - 2 * i) / \
                        (factorial(i) * factorial(index - i) *
                            factorial(index - 2 * i)) * point**(index - 2 * i)
                i += 1
            # Now generate the polynomial point
            val = 1 / 2**index * lsum
            yarr = np.append(yarr, val)
        legendre.append(yarr)
    legendre = np.asarray(legendre)
    # Now plot using MatPlotLib with minimal UI change from SeaBorn
    fig = plt.figure(1)
    sns.set_style(style="darkgrid")
    pl0, = plt.plot(xarr, legendre[0, :], 'r-', label='P_0')
    pl1, = plt.plot(xarr, legendre[1, :], 'k-', label='P_1')
    pl2, = plt.plot(xarr, legendre[2, :], 'g-', label='P_2')
    pl3, = plt.plot(xarr, legendre[3, :], 'b-', label='P_3')
    pl4, = plt.plot(xarr, legendre[4, :], 'c-', label='P_4')
    pl5, = plt.plot(xarr, legendre[5, :], 'm-', label='P_5')
    plt.legend(handles=[pl0, pl1, pl2, pl3, pl4, pl5], loc=4)
    plt.savefig("legendre.png")
    plt.close(fig)


if __name__ == '__main__':
    try:
        main()
    finally:
        print("\nProgram terminated\n")
