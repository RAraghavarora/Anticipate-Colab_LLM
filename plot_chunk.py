import numpy as np
import matplotlib.pyplot as plt

# Updated data
data = [
    # [1772, 1712, 1457, 1961],
    [1821, 1527, 1399, 1438],
    # [1848, 1782, 1692, 1894],
    [1821, 1613, 1596, 1468],
    [1860, 1715, 1603, 1421],
    [1851, 1690, 1683, 1708],
]

# Calculate the averages of each chunk
averages = np.mean(data, axis=0)

# Calculate the standard deviation of each chunk
std_devs = np.std(data, axis=0)

# Calculate the ratio of averages
ratio_of_averages = averages / averages[0]

# Plot the ratio of averages with error bars
plt.errorbar(
    range(1, len(ratio_of_averages) + 1),
    ratio_of_averages,
    yerr=std_devs / averages[0],
    fmt="o-",
    color="b",
    ecolor="r",
    capsize=5,
)
# plt.title("Advantafge")
plt.xlabel("Number of tasks anticipated")
plt.ylabel("Ratio of costs (execution time) to the cost of first task")
plt.grid(True)
plt.tight_layout()
plt.show()
