#` Get paramters from command line
args	= commandArgs(trailingOnly = TRUE)

if (0 == length(args)) stop("Please supply parameters: lower, upper, varcof, z, aPriori")

lower	= as.numeric(args[1])	# Lower limit fetal DNA
upper	= as.numeric(args[2])	# Upper ...
varcof	= as.numeric(args[3])	# Variation coefficient
z		= as.numeric(args[4])	# Observed Z score
aPriori = as.numeric(args[5])	# A priori risk of trisomy

#` Cumulative normal distribution.
cumnor <- function(x){
	pnorm(x, mean = 0, sd = 1, lower.tail = FALSE, log.p = FALSE)
}

#` Computes chance (value 0..1) on a trisomy, P(H | E)
# Where:
# H is is the hypothesis trisomy
# E is the observation of the mother's DNA
# P(H) is the a priori chance on a trisomy
# P(H | E) is the chance on a trisomy, given the extra information from observation E

# Bayes rule:  P(H | E) = P(E | H) * P(H) / P(E)
# Where:
# P(E | H) is the likelihood; the chance of E, given H.
# P(E) is the chance of E, which is equal to
# the chance of E, given H correct plus the chance of E, given H incorrect:
# P(E) = P( E | H ) * P (H) + P( E | ~H ) * (1 - P(H))

# See also: http://www.answers.com/topic/bayesian-inference
risk <- function(lower, upper, varcof, zObserved, aPriori)
{
	p = NULL # the risk
	
	# Validate input
	if (upper < lower | aPriori < 0 | 1 < aPriori) p = NA
	for (test in c(lower, upper, varcof)) if (test < 0 | 100 < test) p = NA
	
	if (is.null(p))
	{
		lower = 0.5 * lower / varcof
		upper = 0.5 * upper / varcof

		if (upper - lower < 0.002)
		{	# This is done to handle the case that the upper and lower limit are (almost) identical
			lower = lower - 0.001
			upper = upper + 0.001
		}

		interval = upper - lower

		p = (cumnor(zObserved - upper) - cumnor(zObserved - lower)) / interval;
		p = p * aPriori / (p * aPriori + (1 - aPriori) * dnorm(zObserved))
	}
	
	cat(p)
}

risk(lower, upper, varcof, z, aPriori)

# Example:
#	risk(2, 30, .5, 4, .001)
#	[1] 0.2070116