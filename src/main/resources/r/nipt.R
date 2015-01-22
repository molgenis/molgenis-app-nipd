# TODO: remove cat(...), and in niptAPrioriRisk.R, niptRisk.R: call source of script via
#		source(fromJSON(paste0(readLines(curl( 'http://localhost:8080/api/vi/scripts/nipt'  ))))$content)

cat("

#` Read table from text file
get.table = function(file.name)	read.table(file.name, header = TRUE, skip=2, check.names = FALSE)

#` Estimates a priori risk on trisomy by bilinearly interpolation of corresponding table
#` @param t table containing the a priori risks
#` @param yw gestational age in weeks
#` @param yd gestational age in days
#` @param xy mother's age years
#` @param xw mother's age months
#` @returns risk as 1 in n cases
aPrioriRisk = function(t, yw, yd, xy, xm)
{	
	# Derive gest and mat age
	y = yw + yd/7
	x = xy + xm/12
	
	# get row/column headers as integers
	m = as.numeric(rownames(t))
	g = as.numeric(colnames(t))
	
	if (x < min(m) | max(m) < x | y < min(g) | max(g) < y) {
		cat(NA)
	} else {
		# find indices of grid points surrounding x, y
		index.x1 = max(which(m <= x))
		index.x2 = min(which(x <= m))
		index.y1 = max(which(g <= y))
		index.y2 = min(which(y <= g))

		# lookup coordinates of the grid points
		x1 = m[index.x1]
		x2 = m[index.x2]
		y1 = g[index.y1]
		y2 = g[index.y2]
	
		# lookup values of the grid points
		Q11 = t[index.x1, index.y1]
		Q12 = t[index.x1, index.y2]
		Q21 = t[index.x2, index.y1]
		Q22 = t[index.x2, index.y2]

		# compute areas for each corner (see http://en.wikipedia.org/wiki/Bilinear_interpolation)
		area = (x2 - x1) * (y2 - y1)
		f11 = (x2 - x) * (y2 - y)
		f21 = (x - x1) * (y2 - y)
		f12 = (x2 - x) * (y - y1)
		f22 = (x - x1) * (y - y1)
	
		# Return result; take care of boundary cases
		if (x2 == x1) {
			if( y2 == y1 ) {
				p = Q11
			} else {
				p = Q11 + (Q12 - Q11) * (y - y1) / (y2 - y1)
			}
		} else if (y2 == y1) {
			p = Q11 + (Q21 - Q11) * (x - x1) / (x2 - x1)
		} else {
			p = (Q11*f11 + Q21*f21 + Q12*f12 + Q22*f22) / area
		}
	
		round(p)
	}
}

#` Cumulative normal distribution.
cumnor <- function(x){
	pnorm(x, mean = 0, sd = 1, lower.tail = FALSE, log.p = FALSE)
}

post.test.probability = function(lower, upper, zObserved, aPriori)
{
	interval = upper - lower
	intermediate = (cumnor(zObserved - upper) - cumnor(zObserved - lower)) / interval;
	p = intermediate * aPriori / (intermediate * aPriori + (1 - aPriori) * dnorm(zObserved))
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
#` @param aPriori == n means 1 in n cases
#` @returns risk in ##.##%
risk <- function(lower, upper, varcof, zObserved, aPriori)
{
	aPriori = 1 / aPriori
	p = NULL # the risk
	
	# Validate input
	if (upper < lower | aPriori < 0 | 1 < aPriori | is.na(aPriori)) p = NA
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
		
	}
	
	lower.broad		= lower
	upper.broad 	= upper
	lower.center 	= lower.broad + 5/22 	* (upper.broad - lower.broad)
	upper.center	= lower.broad + 17/22	* (upper.broad - lower.broad)
	weight.broad	= 0.4
	weight.center	= 0.6
	
	p = weight.broad * post.test.probability(lower.broad, upper.broad, zObserved, aPriori) + weight.center * post.test.probability(lower.center, upper.center, zObserved, aPriori)
	
	# return with one decimal
	sprintf('%.1f', 100 * p)
}

")