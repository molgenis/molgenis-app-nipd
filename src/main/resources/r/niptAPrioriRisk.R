#` Get paramters from command line
args	= commandArgs(trailingOnly = TRUE)

if (0 == length(args)) stop("Please supply parameters 'chromosome', 'gestational age', 'maternal age'.")

chrom	= args[1]			 	# Chromosome 13, 18, 21
g.age	= as.numeric(args[2])	# Gestational age (weeks)
m.age	= as.numeric(args[3])	# Age of mother (years)

#` Read table from text file
get.table = function(file.name)	read.table(file.name, header = TRUE, skip=2, check.names = FALSE)

#` Estimates a priori risk on trisomy by bilinearly interpolation of corresponding table
#` @param t table containing the a priori risks
#` @param y gestational age in weeks
#` @param x mother's age in years
aPrioriRisk = function(t, y, x)
{	
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
	
		cat(p)
	}
}

#` load table
tab = get.table(paste("T", chrom, "risk.txt", sep=''))

#` print risk
aPrioriRisk(tab, g.age, m.age)