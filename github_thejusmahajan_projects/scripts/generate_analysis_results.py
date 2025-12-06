import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import numpy as np

# Setup
file_path = 'berlin-tree-analysis/data/2025_trees_steglitz.csv'
save_folder = 'berlin-tree-analysis/results'

# Load Data
print("Loading data...")
df = pd.read_csv(file_path, sep=';')

# Data Cleaning
print("Cleaning data...")
# Convert pflanzjahr to numeric, coerce errors to NaN
df['pflanzjahr'] = pd.to_numeric(df['pflanzjahr'], errors='coerce')
# Filter valid years (e.g., 1700 to 2025)
df = df[(df['pflanzjahr'] >= 1700) & (df['pflanzjahr'] <= 2025)]
# Calculate Age
df['age'] = 2025 - df['pflanzjahr']

# 1. Species Diversity
print("Analyzing species...")
top_species = df['baumart'].value_counts().head(10)
plt.figure(figsize=(12, 6))
sns.barplot(x=top_species.values, y=top_species.index, palette='viridis')
plt.title('Top 10 Tree Species in Steglitz-Zehlendorf')
plt.xlabel('Count')
plt.tight_layout()
plt.savefig(f'{save_folder}/analysis_top_species.png')
plt.close()

# 2. Age Distribution
print("Analyzing age...")
plt.figure(figsize=(10, 6))
sns.histplot(df['pflanzjahr'], bins=50, kde=True, color='green')
plt.title('Distribution of Planting Years')
plt.xlabel('Year')
plt.ylabel('Count')
plt.tight_layout()
plt.savefig(f'{save_folder}/analysis_age_dist.png')
plt.close()

# 3. Spatial Distribution (District)
print("Analyzing spatial distribution...")
district_counts = df['ortsteil'].value_counts()
plt.figure(figsize=(12, 6))
sns.barplot(x=district_counts.values, y=district_counts.index, palette='magma')
plt.title('Tree Count by District (Ortsteil)')
plt.xlabel('Count')
plt.tight_layout()
plt.savefig(f'{save_folder}/analysis_district_dist.png')
plt.close()

# 4. Trends: Old vs New
print("Analyzing trends...")
old_trees = df[df['pflanzjahr'] < 1990]
new_trees = df[df['pflanzjahr'] > 2010]

top_old = old_trees['baumart'].value_counts().head(5)
top_new = new_trees['baumart'].value_counts().head(5)

fig, axes = plt.subplots(1, 2, figsize=(15, 6))

sns.barplot(x=top_old.values, y=top_old.index, ax=axes[0], palette='Blues_r')
axes[0].set_title('Top Species Planted Before 1990')

sns.barplot(x=top_new.values, y=top_new.index, ax=axes[1], palette='Greens_r')
axes[1].set_title('Top Species Planted After 2010')

plt.tight_layout()
plt.savefig(f'{save_folder}/analysis_trends_old_vs_new.png')
plt.close()

# Print Stats for Report
print("\n--- STATISTICS FOR REPORT ---")
print(f"Total Trees: {len(df)}")
print(f"Unique Species: {df['baumart'].nunique()}")
print(f"Average Age: {df['age'].mean():.1f} years")
print(f"Oldest Tree: {df['age'].max():.0f} years ({df.loc[df['age'].idxmax(), 'baumart']})")
print(f"Most Common Species: {top_species.index[0]} ({top_species.values[0]})")
print(f"Greenest District: {district_counts.index[0]} ({district_counts.values[0]})")
print("\nTop 5 Old Species:\n", top_old)
print("\nTop 5 New Species:\n", top_new)
