import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D


#导入库
plt.rcParams['font.sans-serif']=['SimHei'] #用来正常显示中文标签
plt.rcParams['axes.unicode_minus']=False #用来正常显示负号

# Define parameters and constants
alpha_f = 0.1
alpha_m = 0.1
X = 0.5
beta = 0.3
k = 0.2

# Genetic algorithm parameters
population_size = 50
generations = 50
mutation_rate = 0.1

# Define the range of genetic factors (G)
gene_range = (-1, 1)

# Define the initial population
population = np.random.uniform(gene_range[0], gene_range[1], size=(population_size, 2))


# Define the fitness function
def fitness_function(G):
    G_f, G_m = G

    # Placeholder for the ecological model and calculations
    # Replace this with the actual ecological model implementation
    RE = np.random.rand()  # Resource utilization efficiency
    SRB = np.random.rand()  # Sex ratio balance
    PGR = np.random.rand()  # Population growth rate

    return X * RE + beta * SRB + k * PGR


# Run the genetic algorithm
best_fitness_history = []
best_solution = None
best_fitness = float('-inf')

for generation in range(generations):
    # Calculate fitness for each individual in the population
    fitness_values = np.apply_along_axis(fitness_function, 1, population)

    # Select the top individuals based on fitness
    sorted_indices = np.argsort(fitness_values)[::-1]
    top_population = population[sorted_indices[:population_size]]

    # Store the best solution
    current_best_fitness = fitness_values[sorted_indices[0]]
    if current_best_fitness > best_fitness:
        best_fitness = current_best_fitness
        best_solution = top_population[0]

    best_fitness_history.append(best_fitness)

    # Crossover (using a simple averaging method)
    crossover_indices = np.random.choice(population_size, size=(population_size // 2, 2))
    population[:population_size // 2] = (top_population[crossover_indices[:, 0]] + top_population[
        crossover_indices[:, 1]]) / 2

    # Mutation
    mutation_mask = np.random.rand(population_size, 2) < mutation_rate
    mutation_values = np.random.uniform(gene_range[0], gene_range[1], size=(population_size, 2))
    population[mutation_mask] += mutation_values[mutation_mask]

# Display the best solution
print("Best solution:", best_solution)

# Visualize the results in a 3D surface plot
fig = plt.figure(figsize=(10, 8))
ax = fig.add_subplot(111, projection='3d')

# Generate a grid of G_f and G_m values
G_f_values = np.linspace(gene_range[0]+80, gene_range[1]+80, 100)
G_m_values = np.linspace(gene_range[0]+80, gene_range[1]+80, 100)
G_f_mesh, G_m_mesh = np.meshgrid(G_f_values, G_m_values)
fitness_values_mesh = np.zeros_like(G_f_mesh)

# Calculate fitness for each point in the grid
for i in range(G_f_values.shape[0]):
    for j in range(G_m_values.shape[0]):
        fitness_values_mesh[i, j] = fitness_function([G_f_values[i], G_m_values[j]])

# Plot the 3D surface
ax.plot_surface(G_f_mesh, G_m_mesh, fitness_values_mesh, cmap='viridis', alpha=0.8)
ax.set_xlabel('INS')
ax.set_ylabel('评分')
ax.set_zlabel('适应度')
ax.set_title('遗传算法优化')

# Plot the best solution
ax.scatter(best_solution[0]+80, best_solution[1]+80, best_fitness, color='red', s=50, label='Best Solution')

plt.legend()
plt.show()
