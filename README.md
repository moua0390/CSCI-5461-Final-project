# CSCI 5461 Project:  Using Machine Learning Approaches on Single-Nuclei Sequencing Data to Identify Senescent Cells
The data for this project is being generously provided by our collaborators before it has been published. Groups are only able to use it for their CSCI 5461 Spring 2024 project under the following conditions:
* The datasets themselves and any results derived from them cannot be shared beyond students, TAs, or the instructor of CSCI 5461 without the permission of Prof. David Bernlohr.
* Groups’ project reports, the associated supplementary data, and project code should be shared with our collaborators at the end of the project.

Our collaborators may reach out to project groups at the conclusion of the course to learn more about their approach to solving the problem and the results. Students may continue to discuss/explore their results with the collaborators if they choose to but are not required to do so.

Please contact csci5461-help@umn.edu  if you have any questions regarding this project.

---

### Data description:

**1. Integrated_scaled_counts_release.txt**
* The integrated and scaled data from the single nuclei sequencing results, processed by using Seurat (R toolkit).
* Dimension: 2,000 genes with the highest variance across the 57,193 nuclei (adipose tissue cells)
* This data has been normalized across mouse samples and is ready for downstream clustering analysis. Please note that this data is no longer appropriate for analyses that require the original raw sequencing counts (e.g., differential gene expression analysis). If you want to access the raw counts or data for additional genes, see the Adipose_Student_Version.rds file.

**2. Metadata_release.txt**
* Metadata for all 57,193 nuclei (cells), which were derived from 3 old mice and 3 young mice.
* cell_ID: This identifier labels each cell and will correspond to a single column in the integrated_scaled_counts.txt file. This identifier also indicates which animal that particular cell came from. For example, in this case “`AAACCTGAGACTGGGT-1_1`”, “`AAACCTGAGACTGGGT`” identifies the cell, and “1_1” identifies the animal. The animal label will be one of the following possibilities: 1_1, 1_2, 1_3, 1_4, 1_5, 1_6 (one for each of the six mice).
* orig.ident: This identifier labels whether the mouse came from the “Old” or the “Young” group. There are 3 mice from each group.
* nCount_RNA: The total number of molecules (or reads) detected in a cell across all genes.
* nFeature_RNA:The number of unique genes (features) detected in a cell. This is a count of how many different genes have at least one read mapped to them in a particular cell.
* percent.mt: The percentage of the total molecules (or reads) in a cell that map to mitochondrial genes. This is calculated as the number of reads mapped to mitochondrial genes divided by the total number of reads, multiplied by 100.

**3. SENESCENCE_mouse_terms_collection.xlsx**
* This file contains 4 tabs, each with a gene list or collection of gene lists with senescence-related potential marker genes identified in previous published studies. We are providing these lists as a guide for scoring the clusters derived from your unsupervised analysis to identify a candidate cluster that is likely to correspond to the senescent cell population. The sources of each of the gene lists are cited in each tab– we encourage you to read more about those previous studies.
* Most of these literature-derived gene lists include a set of genes expected to be up-regulated in senescent cells (e.g., genes supporting processes that are more active in senescent cells) and a complementary set of genes expected to be down-regulated in senescent cells (e.g., processes likely not active in senescent cells). A high scoring cluster would include many genes with high expression from the “up” list and low expression from the “down” list relative to the expression of those genes in other clusters. One of the lists (the SenMayo list) has no direction indicated, but it is safe to assume that many of those genes would be up-regulated in senescent cells.

* Important note: The motivation for this project is that we do not yet know how to precisely define senescent cells, so there are no true “gold standard” gene sets. We expect that all of these are imperfect, and some of these curated lists are higher quality than others. Also, single-nuclei expression data is noisy and incomplete, so you will need to develop a scoring criteria that is robust to these imperfections. We encourage you to explore many possibilities and consider placing variable weight on these different literature-curated lists. Remember that in addition to these gene lists, we expect the SnC population to be more abundant (~ 5-20X or more abundant) in the samples derived from old mice relative to the young mice, which should also be incorporated into your scoring criteria.

**4. Adipose_Student_Version.rds**
* A SeuratObject produced by our collaborators, which could be read and analyzed in an R environment with the package "Seurat" installed. Seurat is a very commonly used package for processing and analysis of single-cell expression datasets. You are welcome to use Seurat for your project if you wish, but you are by no means required to do so. In fact, we hope to see a diversity of different clustering methods from different computing environments/libraries applied to this problem across the different groups. 
* This SeuratObject contains more information about the original experimental data in addition to data file (1) (scaled data) and data file (2) (metadata) described above.
* This SeuratObject contains information for all the cells, including the ones that we held out for testing the Phase 2 classification results. For both phases, you should focus on the 57,193 samples from the metadata for developing your methods.
* This SeuratObject may also contain some clustering results from our collaborators, generated by the Seurat package. We ask that you ignore those results as we don’t want your cluster evaluation to be biased by those prior results. We will not be using those to evaluate your group’s results.

**5. Phase2_masked_holdout_10k_integrated_scaled_counts.txt**
* The held-out cell population for Phase 2 only. 
* This is a matrix of expression profiles for held-out cells in the same format as Integrated_scaled_counts_release.txt. Your pipeline should take it as the input, and the output file should contain a single, real-valued score per cell in the held-out population. Output should be comma-delimited and in the same order as the input data columns. 

Feel free to email us at csci5461-help@umn.edu if you have any questions about the data files or how to get started on your project.

---

### Project deliverables and expected formats:
Project poster and video (due May 3, 2024)  
Project report (due May 3, 2024)

### Phase 1:
* a SnC cluster scoring module:  this module should take in a matrix of single-nuclei data in the same format as integrated_scaled_counts.txt and a comma-delimited list of cell_IDs. This module should output a single, real-valued score which reflects the likelihood that the input list of cell_IDs reflects a true SnC cluster (high scores→ high confidence). Your putative SnC cluster(s) should be identified using this same scoring criteria.
* a comma-delimited list of cell_IDs that contain the nuclei in your groups’ putative SnC cluster. (due April 30)
* Code that produces your clustering results.

### Phase 2:
* A trained SnC cell classifier module: this module should take in a matrix of single-nuclei data in the same format as *Integrated_scaled_counts_release.txt*. This module should output a single, real-valued score per cell represented in the dataset reflecting the likelihood that the corresponding cell belongs to your putative SnC cell class (high scores→ high confidence). Output should be comma-delimited and in the same order as the input data columns. This classifier should have been trained on your putative SnC cell population. 
* Predictions for our held-out cell population. You are provided with a matrix of expression profiles for held-out cells (*Phase2_masked_holdout_10k_integrated_scaled_counts.txt*). Your output file should contain a single, real-valued score per cell in the held-out population. Output should be comma-delimited and in the same order as the input data columns. (due April 30)
* Evaluation results based on cross-validation experiments that characterize the performance of your classifier in detecting your SnC cell population.
* Code that produces your SnC classifier and evaluations.
