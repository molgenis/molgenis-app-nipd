#` Cumulative normal distribution.
cumnor <- function(x){
	pnorm(x, mean = 0, sd = 1, lower.tail = FALSE, log.p = FALSE)
}

#` Computes risk (value 0..1)
#` @param zObserved ?
#` @param lower ?
#` @param upper ?
#` @param aPriori The a priori risk (value 0..1)
#` @varCof ?
risk <- function(zObserved, lower, upper, aPriori, varCof)
{
	# Validate input
	if (upper < lower | aPriori < 0 | 1 < aPriori) return(NA)
	for (test in c(lower, upper, varCof)) if (test < 0 | 100 < test) return(NA)
	
	
	lower = 0.5 * lower / varCof
	upper = 0.5 * upper / varCof

	if (upper - lower < 0.002)
	{
		#this is done to handle the case that the upper and lower limit are
        #identical
		lower = lower - 0.001
		upper = upper + 0.001
	}

	interval = upper - lower

	ptris3 = (cumnor(zObserved - upper) - cumnor(zObserved - lower)) / interval;
	#this is the average likelihood of the Normal distribution
    #over an interval zObserved - upper to zObserved - lower
    #this result is not obtained by direct integration,
    #but by using an accurate function for the cumulative normal distribution
	ptris3 = ptris3 * aPriori / (ptris3 * aPriori + (1 - aPriori) * dnorm(zObserved))
	
	ptris3
}

# Example:
#	risk(zObserved=4, lower = 2, upper = 30, aPriori = .001, varCof = 0.5)
#	[1] 0.2070116