library(fBasics)
library(gdata)
require(akima)

#` Interpolate risk table.
#` Uses linear bivariate interpolation.
#` @todo this is not exactly the same as bilinear interpolation!
#` @param t table, read in using read.table
#` @param ga gestational age in weeks
#` @param ma mother's age in years
interpolateRisk <- function (t, ga, ma) {
	m = sapply(dimnames(t)[[1]], strtoi)
	g = sapply(names(t), function(x) strtoi(substring(x, 2)))
	gvec = rep(g, each = length(m))
	mvec = rep(m, times = length(g))
	rvec = unmatrix(as.matrix(t))
	linearInterpp(gvec, mvec, rvec, ga, ma)$z
}

#` Interpolates a priori risk from three risk tables
#` @param ga gestational age in weeks
#` @param ma mother's age in years
aprioriRisk <- function(ga, ma) {
	T13 = read.table("T13risk.txt", header=TRUE, skip=2);
	T18 = read.table("T18risk.txt", header=TRUE, skip=2);
	T21 = read.table("T21risk.txt", header=TRUE, skip=2);

	data.frame(t13 = interpolateRisk(t = T13, ga = ga, ma = ma),
	t18 = interpolateRisk(t = T18, ga = ga, ma = ma),
	t21 = interpolateRisk(t = T21, ga = ga, ma = ma) )
}

aprioriRisk(ga = 13, ma = 44)

#` Cumulative normal distribution.
cumnor <- function(x){
	pnorm(x, mean = 0, sd = 1, lower.tail = FALSE, log.p = FALSE)
}

#` Computes risk.
#` @param z_observed ?
#` @param lower ?
#` @param upper ?
#` @param a_priori the a priori risk
#` @varcof ?
risk <- function(z_observed, lower, upper, a_priori, varcof) {
	lower = 0.5 * lower / varcof
	upper = 0.5 * upper / varcof
	if( upper - lower < 0.002 ){
		#this is done to handle the case that the upper and lower limit are
        #identical
		lower = lower - 0.001
		upper = upper + 0.001
	}
	interval = upper - lower
	a_priori = 1 / a_priori
	ptris3 = (cumnor(z_observed - upper) - cumnor2(z_observed - lower)) / interval;
	#this is the average likelihood of the Normal distribution
    #over an interval Z_observed - upper to Z_observed - lower
    #this result is not obtained by direct integration,
    #but by using an accurate function for the cumulative normal distribution
	ptris3 = ptris3 * a_priori / (ptris3 * a_priori + (1 - a_priori) * dnorm(z_observed))
	data.frame(z_observed = z_observed, 
		lower = lower, upper = upper, interval = interval, 
		a_priori = a_priori,
		ptris = ptris3 * 100, varcof = varcof)
}

risk(z_observed=0.11, lower = 2, upper = 30, a_priori = 22, varcof = 0.5)

#` Old implementation of cumulative normal distribution.
#` For comparison use only.
cumnor2 <- function(x){
	if (x > 0.0) {
    	x_abs = x
    }
  	else {
    	x_abs = -x
    }
  	if (x_abs > 37) {
  		temp = 0.0
  	} else {
    	exponential = exp(-0.5 * x_abs * x_abs);
    	if (x_abs < 7.07106781186547) {
			build = 3.52624965998911E-02 * x_abs + 0.700383064443688;
		      build = build * x_abs + 6.37396220353165;
		      build = build * x_abs + 33.912866078383;
		      build = build * x_abs + 112.079291497871;
		      build = build * x_abs + 221.213596169931;
		      build = build * x_abs + 220.206867912376;
		      temp = exponential * build;
		      build = 8.83883476483184E-02 * x_abs + 1.75566716318264;
		      build = build * x_abs + 16.064177579207;
		      build = build * x_abs + 86.7807322029461;
		      build = build * x_abs + 296.564248779674;
		      build = build * x_abs + 637.333633378831;
		      build = build * x_abs + 793.826512519948;
		      build = build * x_abs + 440.413735824752;
		      temp = temp / build;
    	}	
    	else {
	      build = x_abs + 0.65;
	      build = x_abs + 4 / build;
	      build = x_abs + 3 / build;
	      build = x_abs + 2 / build;
	      build = x_abs + 1 / build;
	      temp = exponential / build / 2.506628274631
	    }
  	}
  if (x < 0) {
  	1.0 - temp
  }  
  else {
  	temp
  }
}