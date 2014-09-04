#` Read table from text file
get.table = function(file.name)	read.table(file.name, header=TRUE, skip=2, check.names=FALSE)

#` Estimates a priori risk on trisomy by bilinearly interpolation
#` @param t table containing the a priori risks
#` @param y gestational age in weeks
#` @param x mother's age in years
aPrioriRisk = function(t, x, y)
{	
	# get row/column headers as integers
	m = as.numeric(rownames(t))
	g = as.numeric(colnames(t))
	
	if (x < min(m) | max(m) < x | y < min(g) | max(g) < y) return(NA)
	
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
			Q11
		} else {
			Q11 + (Q12 - Q11) * (y - y1) / (y2 - y1)
		}
	} else if (y2 == y1) {
		Q11 + (Q21 - Q11) * (x - x1) / (x2 - x1)
	} else {
		(Q11*f11 + Q21*f21 + Q12*f12 + Q22*f22) / area
	}
}


t13 = get.table("T13risk.txt")
t18 = get.table("T18risk.txt")
t21 = get.table("T21risk.txt")

#Example: aPrioriRisk(t13, 20, 11)
