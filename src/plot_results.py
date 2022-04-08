import matplotlib.pyplot as plt
import sys

def get_lines(path: str):
	file = [line for line in open(path, 'r')]
	lines = [line.split() for line in file]
	return lines

def plot_everything(path: str):
	lines = get_lines(path)

	throughput = [line[3] for line in lines]
	ylabel = throughput[0]
	throughput = [float(elem) for idx, elem in enumerate(throughput) if idx > 0]

	for i in range(len(lines[0])):
		if i == 3:
			continue
		stat = [line[i] for line in lines]
		xlabel = stat[0]

		if i == 4:
			xlabel = xlabel + " (in MB)"
		elif i == 5:
			xlabel = xlabel + " (in KB)"
		elif i == 6:
			xlabel = xlabel + " (in KB)"

		stat = [float(elem) for idx, elem in enumerate(stat) if idx > 0]

		if sum(stat) == 0:
			continue

		plt.title("Metric: " + sys.argv[2] + ". Personality: " + sys.argv[3])
		plt.xlabel(xlabel)
		plt.ylabel(ylabel)
		plt.plot(stat, throughput)
		plt.show()

	mean = [line[2] for line in lines]
	ylabel = mean[0]
	mean = [float(elem) for idx, elem in enumerate(mean) if idx > 0]

	for i in range(len(lines[0])):
		# mean column case
		if i == 2:
			continue
		stat = [line[i] for line in lines]
		xlabel = stat[0]

		if i == 4:
			xlabel = xlabel + " (in MB)"
		elif i == 5:
			xlabel = xlabel + " (in KB)"
		elif i == 6:
			xlabel = xlabel + " (in KB)"

		stat = [float(elem) for idx, elem in enumerate(stat) if idx > 0]

		if sum(stat) == 0:
			continue

		plt.title("Metric: " + sys.argv[2] + ". Personality: " + sys.argv[3])
		plt.xlabel(xlabel)
		plt.ylabel(ylabel)
		plt.plot(stat, mean)
		plt.show()


if __name__ == "__main__":
	path = sys.argv[1]
	plot_everything(path)
