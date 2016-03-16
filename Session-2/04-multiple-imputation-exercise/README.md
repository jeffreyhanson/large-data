# Handling missing exercise
#### Moreno Di Marco (m.dimarco@uq.edu.au)

### Repository contents
* Data obtained from [Penone et al. (2014)](http://onlinelibrary.wiley.com/doi/10.1111/2041-210X.12232/abstract) stored in "carnivora_data_complete.csv". Note that the original dataset contained missing data which have been imputed to simulate a complete dataset for this exercise.
* R script contained in "imputation_exercise.R"

### Overview
1. A complete life-history trait dataset is provided, with information for 273 mammalian carnivores: Body Mass, Litter Size, Longevity, Habitat Breadth, Head-Body Lenngth, Diet Breadth, Gestation Length, Weaning Age.

2. The purpose is to evaluate the allometric relationship between body mass and longevity:
	* log(longevity)= a*log(body mass) + log(k)

3. The presence of missing data cases is simulated following different patterns:
	* missing completely at random (MCAR)
	* missing at random (MAR)
	* missing non at random (MNAR)

4. The complete dataset is compared with the three incomplete datasets, by plotting the two variables of interest in a scatterplot

5. Following a data deletion procedure, the available information (only complete cases) from the three incomplete datasets is used to define allometric models.

6. Following a data imputation procedure, the missing data in the three incomplete datasets are imputed, and then imputed datasets are used to define allometric models.

7. The coefficients of the actual model, based on the original complete dataset, are compared to those derived under the data deletion or the data imputation strategies, to evaluate the effect that different missing data pattern have on the data deletion vs data imputation approach.
 
### References
[Penone, C., Davidson, A. D., Shoemaker, K. T., Di Marco, M., Rondinini, C., Brooks, T. M., Young, B. E., Graham, C. H., Costa, G. C. (2014), Imputation of missing data in life-history trait datasets: which approach performs the best?. Methods in Ecology and Evolution, 5: 961-970.](http://onlinelibrary.wiley.com/doi/10.1111/2041-210X.12232/abstract)

[Nakagawa S., Freckleton R. P. (2008), Missing inaction: the dangers of ignoring missing data. Trends in Ecology & Evolution, 23: 592-596.](http://www.sciencedirect.com/science/article/pii/S0169534708002772)
