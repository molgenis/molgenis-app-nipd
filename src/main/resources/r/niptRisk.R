# load functions
source('nipt.R')

# compute risk
library(rjson)
cat(toJSON(list(risk = risk(${lower}, ${upper}, ${varcof}, ${z}, ${aPriori}), lower = ${lower}, upper = ${upper}, varcof = ${varcof}, z = ${z}, aPriori = ${aPriori})))