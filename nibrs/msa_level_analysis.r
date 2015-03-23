library(reshape)
library(RColorBrewer)
library(ggplot2)
library(plyr)
# This file does some basic diagnostics on MSA level ad price information
source('R-Estout2/eststo2.R')
source('R-Estout2/esttab2.R')
source('R-Estout2/estclear.R')
#sink('results/zero_price_diagnostics.txt')
#data<-read.csv('results/zero_price_msa_aggregates.csv')
data<-read.csv('ad_prices_msa.csv')
data$violence_per_capita<-data$violence_counts/data$population
data$female_violence_share<-data$female_violence_fraction/data$violence_fraction
data$female_num_jobs<-data$female_sum.wght/1000
data$male_num_jobs<-data$male_sum.wght/1000
cat('reading ad_prices_msa.csv...\n')
print(summary(data))
estclear()
eststo2(lm(zp_mean ~ female_violence_share, data=data))
eststo2(lm(zp_mean ~ log(population) + unemployment + lt_highschool + highschool + college_plus + avg_commute, data=data))
eststo2(lm(zp_mean ~ log(population) + unemployment + lt_highschool + highschool + college_plus + avg_commute + log(female_p50) + log(male_p50), data = data))
eststo2(lm(zp_mean ~ log(population) + unemployment + lt_highschool + highschool + college_plus + avg_commute + log(female_p50) + log(male_p50) + female_violence_share + violence_per_capita, data = data))
eststo2(lm(zp_mean ~ log(population) + unemployment + lt_highschool + highschool + college_plus + avg_commute + log(female_p50) + log(male_p50) + female_violence_share, data = data))
eststo2(lm(zp_mean ~ log(population) + unemployment + lt_highschool + highschool + college_plus + avg_commute, data=data[!is.na(data$female_violence_share),]))
eststo2(lm(zp_mean ~ log(population) + unemployment + lt_highschool + highschool + college_plus + avg_commute + log(female_p50) + log(male_p50), data = data[!is.na(data$female_violence_share),]))
esttab2(filename='results/zero_price_msa_diagnostics_mean.csv')
esttab2(filename='results/zero_price_msa_diagnostics_mean.txt')
cat('______________\n')
cat('results/zero_price_msa_diagnostics_mean.txt:\n')
writeLines(readLines('results/zero_price_msa_diagnostics_mean.txt'))

estclear()
eststo2(lm(zp_p90 ~ female_violence_share, data=data))
eststo2(lm(zp_p90 ~ log(population) + unemployment + lt_highschool + highschool + college_plus + avg_commute, data=data))
eststo2(lm(zp_p90 ~ log(population) + unemployment + lt_highschool + highschool + college_plus + avg_commute + log(female_p50) + log(male_p50), data = data))
eststo2(lm(zp_p90 ~ log(population) + unemployment + lt_highschool + highschool + college_plus + avg_commute + log(female_p50) + log(male_p50) + female_violence_share + violence_per_capita, data = data))
eststo2(lm(zp_p90 ~ log(population) + unemployment + lt_highschool + highschool + college_plus + avg_commute + log(female_p50) + log(male_p50) + female_violence_share, data = data))
eststo2(lm(zp_p90 ~ log(population) + unemployment + lt_highschool + highschool + college_plus + avg_commute, data=data[!is.na(data$female_violence_share),]))
eststo2(lm(zp_p90 ~ log(population) + unemployment + lt_highschool + highschool + college_plus + avg_commute + log(female_p50) + log(male_p50), data = data[!is.na(data$female_violence_share),]))
esttab2(filename='results/zero_price_msa_diagnostics_p90.csv')
esttab2(filename='results/zero_price_msa_diagnostics_p90.txt')
cat('______________\n')
cat('results/zero_price_msa_diagnostics_p90.txt:\n')
writeLines(readLines('results/zero_price_msa_diagnostics_p90.txt'))

estclear()
eststo2(lm(zp_p10 ~ female_violence_share, data=data))
eststo2(lm(zp_p10 ~ log(population) + unemployment + lt_highschool + highschool + college_plus + avg_commute, data=data))
eststo2(lm(zp_p10 ~ log(population) + unemployment + lt_highschool + highschool + college_plus + avg_commute + log(female_p50) + log(male_p50), data = data))
eststo2(lm(zp_p10 ~ log(population) + unemployment + lt_highschool + highschool + college_plus + avg_commute + log(female_p50) + log(male_p50) + female_violence_share + violence_per_capita, data = data))
eststo2(lm(zp_p10 ~ log(population) + unemployment + lt_highschool + highschool + college_plus + avg_commute + log(female_p50) + log(male_p50) + female_violence_share, data = data))
eststo2(lm(zp_p10 ~ log(population) + unemployment + lt_highschool + highschool + college_plus + avg_commute, data=data[!is.na(data$female_violence_share),]))
eststo2(lm(zp_p10 ~ log(population) + unemployment + lt_highschool + highschool + college_plus + avg_commute + log(female_p50) + log(male_p50), data = data[!is.na(data$female_violence_share),]))
esttab2(filename='results/zero_price_msa_diagnostics_p10.csv')
esttab2(filename='results/zero_price_msa_diagnostics_p10.txt')
writeLines(readLines('results/zero_price_msa_diagnostics_p10.txt'))
### Begin doing 5 different output quantiles
estclear()
eststo2(lm(zp_p10 ~ log(population) + unemployment + lt_highschool + highschool + college_plus + avg_commute + male_p25 + male_p50 + male_p75 + female_violence_share + violence_per_capita, data = data))
eststo2(lm(zp_p25 ~ log(population) + unemployment + lt_highschool + highschool + college_plus + avg_commute + male_p25 + male_p50 + male_p75 + female_violence_share + violence_per_capita, data = data))
eststo2(lm(zp_p50 ~ log(population) + unemployment + lt_highschool + highschool + college_plus + avg_commute + male_p25 + male_p50 + male_p75 + female_violence_share + violence_per_capita, data = data))
eststo2(lm(zp_p75 ~ log(population) + unemployment + lt_highschool + highschool + college_plus + avg_commute + male_p25 + male_p50 + male_p75 + female_violence_share + violence_per_capita, data = data))
eststo2(lm(zp_p90 ~ log(population) + unemployment + lt_highschool + highschool + college_plus + avg_commute + male_p25 + male_p50 + male_p75 + female_violence_share + violence_per_capita, data = data))
esttab2(filename='results/zero_price_by_quantile_male_quantiles.csv', col.headers=c("p10","p25","p50","p75","p90"))
esttab2(filename='results/zero_price_by_quantile_male_quantiles.txt', col.headers=c("p10","p25","p50","p75","p90"))
cat('______________\n')
cat('results/zero_price_by_quantile_male_quantiles.txt:\n')
writeLines(readLines('results/zero_price_by_quantile_male_quantiles.txt'))

estclear()
eststo2(lm(zp_p10 ~ log(population) + unemployment + avg_commute + female_p25 + female_p50 + female_p75 + female_num_jobs + male_num_jobs + female_violence_share + violence_per_capita, data = data))
eststo2(lm(zp_p25 ~ log(population) + unemployment + avg_commute + female_p25 + female_p50 + female_p75 + female_num_jobs + male_num_jobs + female_violence_share + violence_per_capita, data = data))
eststo2(lm(zp_p50 ~ log(population) + unemployment + avg_commute + female_p25 + female_p50 + female_p75 + female_num_jobs + male_num_jobs + female_violence_share + violence_per_capita, data = data))
eststo2(lm(zp_p75 ~ log(population) + unemployment + avg_commute + female_p25 + female_p50 + female_p75 + female_num_jobs + male_num_jobs + female_violence_share + violence_per_capita, data = data))
eststo2(lm(zp_p90 ~ log(population) + unemployment + avg_commute + female_p25 + female_p50 + female_p75 + female_num_jobs + male_num_jobs + female_violence_share + violence_per_capita, data = data))
esttab2(filename='results/zero_price_by_quantile_female_quantiles.csv', col.headers=c("p10","p25","p50","p75","p90"))
esttab2(filename='results/zero_price_by_quantile_female_quantiles.txt', col.headers=c("p10","p25","p50","p75","p90"))
cat('______________\n')
cat('results/zero_price_by_quantile_female_quantiles.txt:\n')
writeLines(readLines('results/zero_price_by_quantile_female_quantiles.txt'))

estclear()
eststo2(lm(zp_p10 ~ log(population) + unemployment + avg_commute + female_p50 + male_p50 + female_num_jobs + male_num_jobs + female_violence_share + violence_per_capita, data = data))
eststo2(lm(zp_p25 ~ log(population) + unemployment + avg_commute + female_p50 + male_p50 + female_num_jobs + male_num_jobs + female_violence_share + violence_per_capita, data = data))
eststo2(lm(zp_p50 ~ log(population) + unemployment + avg_commute + female_p50 + male_p50 + female_num_jobs + male_num_jobs + female_violence_share + violence_per_capita, data = data))
eststo2(lm(zp_p75 ~ log(population) + unemployment + avg_commute + female_p50 + male_p50 + female_num_jobs + male_num_jobs + female_violence_share + violence_per_capita, data = data))
eststo2(lm(zp_p90 ~ log(population) + unemployment + avg_commute + female_p50 + male_p50 + female_num_jobs + male_num_jobs + female_violence_share + violence_per_capita, data = data))
esttab2(filename='results/zero_price_by_quantile_50.csv', col.headers=c("p10","p25","p50","p75","p90"))
esttab2(filename='results/zero_price_by_quantile_50.txt', col.headers=c("p10","p25","p50","p75","p90"))
cat('______________\n')
cat('results/zero_price_by_quantile_50.txt:\n')
writeLines(readLines('results/zero_price_by_quantile_50.txt'))

estclear()
eststo2(lm(zp_p10 ~ log(population) + unemployment + avg_commute + female_p25 + male_p25 + female_num_jobs + male_num_jobs + female_violence_share + violence_per_capita, data = data))
eststo2(lm(zp_p25 ~ log(population) + unemployment + avg_commute + female_p25 + male_p25 + female_num_jobs + male_num_jobs + female_violence_share + violence_per_capita, data = data))
eststo2(lm(zp_p50 ~ log(population) + unemployment + avg_commute + female_p25 + male_p25 + female_num_jobs + male_num_jobs + female_violence_share + violence_per_capita, data = data))
eststo2(lm(zp_p75 ~ log(population) + unemployment + avg_commute + female_p25 + male_p25 + female_num_jobs + male_num_jobs + female_violence_share + violence_per_capita, data = data))
eststo2(lm(zp_p90 ~ log(population) + unemployment + avg_commute + female_p25 + male_p25 + female_num_jobs + male_num_jobs + female_violence_share + violence_per_capita, data = data))
esttab2(filename='results/zero_price_by_quantile_25.csv', col.headers=c("p10","p25","p50","p75","p90"))
esttab2(filename='results/zero_price_by_quantile_25.txt', col.headers=c("p10","p25","p50","p75","p90"))
cat('______________\n')
cat('results/zero_price_by_quantile_25.txt:\n')
writeLines(readLines('results/zero_price_by_quantile_25.txt'))

estclear()
eststo2(lm(zp_p10 ~ log(population) + unemployment + avg_commute + female_p75 + male_p75 + female_num_jobs + male_num_jobs + female_violence_share + violence_per_capita, data = data))
eststo2(lm(zp_p25 ~ log(population) + unemployment + avg_commute + female_p75 + male_p75 + female_num_jobs + male_num_jobs + female_violence_share + violence_per_capita, data = data))
eststo2(lm(zp_p50 ~ log(population) + unemployment + avg_commute + female_p75 + male_p75 + female_num_jobs + male_num_jobs + female_violence_share + violence_per_capita, data = data))
eststo2(lm(zp_p75 ~ log(population) + unemployment + avg_commute + female_p75 + male_p75 + female_num_jobs + male_num_jobs + female_violence_share + violence_per_capita, data = data))
eststo2(lm(zp_p90 ~ log(population) + unemployment + avg_commute + female_p75 + male_p75 + female_num_jobs + male_num_jobs + female_violence_share + violence_per_capita, data = data))
esttab2(filename='results/zero_price_by_quantile_75.csv', col.headers=c("p10","p25","p50","p75","p90"))
esttab2(filename='results/zero_price_by_quantile_75.txt', col.headers=c("p10","p25","p50","p75","p90"))
cat('______________\n')
cat('results/zero_price_by_quantile_75.txt:\n')
writeLines(readLines('results/zero_price_by_quantile_75.txt'))

estclear()
eststo2(lm(zp_p10 ~ log(population) + unemployment + avg_commute + female_p75 + male_p75 + female_num_jobs + male_num_jobs, data = data))
eststo2(lm(zp_p25 ~ log(population) + unemployment + avg_commute + female_p75 + male_p75 + female_num_jobs + male_num_jobs, data = data))
eststo2(lm(zp_p50 ~ log(population) + unemployment + avg_commute + female_p75 + male_p75 + female_num_jobs + male_num_jobs, data = data))
eststo2(lm(zp_p75 ~ log(population) + unemployment + avg_commute + female_p75 + male_p75 + female_num_jobs + male_num_jobs, data = data))
eststo2(lm(zp_p90 ~ log(population) + unemployment + avg_commute + female_p75 + male_p75 + female_num_jobs + male_num_jobs, data = data))
esttab2(filename='results/zero_price_by_quantile_75_nv.csv', col.headers=c("p10","p25","p50","p75","p90"))
esttab2(filename='results/zero_price_by_quantile_75_nv.txt', col.headers=c("p10","p25","p50","p75","p90"))
cat('______________\n')
cat('results/zero_price_by_quantile_75_nv.txt:\n')
writeLines(readLines('results/zero_price_by_quantile_75_nv.txt'))

estclear()
eststo2(lm(zp_p10 ~ log(population) + unemployment + avg_commute + female_p25 + male_p25 + female_num_jobs + male_num_jobs, data = data))
eststo2(lm(zp_p25 ~ log(population) + unemployment + avg_commute + female_p25 + male_p25 + female_num_jobs + male_num_jobs, data = data))
eststo2(lm(zp_p50 ~ log(population) + unemployment + avg_commute + female_p25 + male_p25 + female_num_jobs + male_num_jobs, data = data))
eststo2(lm(zp_p75 ~ log(population) + unemployment + avg_commute + female_p25 + male_p25 + female_num_jobs + male_num_jobs, data = data))
eststo2(lm(zp_p90 ~ log(population) + unemployment + avg_commute + female_p25 + male_p25 + female_num_jobs + male_num_jobs, data = data))
esttab2(filename='results/zero_price_by_quantile_25_nv.csv', col.headers=c("p10","p25","p50","p75","p90"))
esttab2(filename='results/zero_price_by_quantile_25_nv.txt', col.headers=c("p10","p25","p50","p75","p90"))
cat('______________\n')
cat('results/zero_price_by_quantile_25_nv.txt:\n')
writeLines(readLines('results/zero_price_by_quantile_25_nv.txt'))

estclear()
eststo2(lm(zp_p10 ~ log(population) + unemployment + avg_commute + female_p50 + male_p50 + female_num_jobs + male_num_jobs, data = data))
eststo2(lm(zp_p25 ~ log(population) + unemployment + avg_commute + female_p50 + male_p50 + female_num_jobs + male_num_jobs, data = data))
eststo2(lm(zp_p50 ~ log(population) + unemployment + avg_commute + female_p50 + male_p50 + female_num_jobs + male_num_jobs, data = data))
eststo2(lm(zp_p75 ~ log(population) + unemployment + avg_commute + female_p50 + male_p50 + female_num_jobs + male_num_jobs, data = data))
eststo2(lm(zp_p90 ~ log(population) + unemployment + avg_commute + female_p50 + male_p50 + female_num_jobs + male_num_jobs, data = data))
esttab2(filename='results/zero_price_by_quantile_50_nv.csv', col.headers=c("p10","p25","p50","p75","p90"))
esttab2(filename='results/zero_price_by_quantile_50_nv.txt', col.headers=c("p10","p25","p50","p75","p90"))
cat('______________\n')
cat('results/zero_price_by_quantile_50_nv.txt:\n')
writeLines(readLines('results/zero_price_by_quantile_50_nv.txt'))

### End zero price by quantiles

### Begin ad price by quantiles
estclear()
eststo2(lm(ad_p10 ~ log(population) + unemployment + lt_highschool + highschool + college_plus + avg_commute + male_p25 + male_p50 + male_p75 + female_violence_share + violence_per_capita, data = data))
eststo2(lm(ad_p25 ~ log(population) + unemployment + lt_highschool + highschool + college_plus + avg_commute + male_p25 + male_p50 + male_p75 + female_violence_share + violence_per_capita, data = data))
eststo2(lm(ad_p50 ~ log(population) + unemployment + lt_highschool + highschool + college_plus + avg_commute + male_p25 + male_p50 + male_p75 + female_violence_share + violence_per_capita, data = data))
eststo2(lm(ad_p75 ~ log(population) + unemployment + lt_highschool + highschool + college_plus + avg_commute + male_p25 + male_p50 + male_p75 + female_violence_share + violence_per_capita, data = data))
eststo2(lm(ad_p90 ~ log(population) + unemployment + lt_highschool + highschool + college_plus + avg_commute + male_p25 + male_p50 + male_p75 + female_violence_share + violence_per_capita, data = data))
esttab2(filename='results/hourly_price_by_quantile_male_quantiles.csv', col.headers=c("p10","p25","p50","p75","p90"))
esttab2(filename='results/hourly_price_by_quantile_male_quantiles.txt', col.headers=c("p10","p25","p50","p75","p90"))
cat('______________\n')
cat('results/hourly_price_by_quantile_male_quantiles.txt:\n')
writeLines(readLines('results/hourly_price_by_quantile_male_quantiles.txt'))

estclear()
eststo2(lm(ad_p10 ~ log(population) + unemployment + avg_commute + female_p25 + female_p50 + female_p75 + female_num_jobs + male_num_jobs + female_violence_share + violence_per_capita, data = data))
eststo2(lm(ad_p25 ~ log(population) + unemployment + avg_commute + female_p25 + female_p50 + female_p75 + female_num_jobs + male_num_jobs + female_violence_share + violence_per_capita, data = data))
eststo2(lm(ad_p50 ~ log(population) + unemployment + avg_commute + female_p25 + female_p50 + female_p75 + female_num_jobs + male_num_jobs + female_violence_share + violence_per_capita, data = data))
eststo2(lm(ad_p75 ~ log(population) + unemployment + avg_commute + female_p25 + female_p50 + female_p75 + female_num_jobs + male_num_jobs + female_violence_share + violence_per_capita, data = data))
eststo2(lm(ad_p90 ~ log(population) + unemployment + avg_commute + female_p25 + female_p50 + female_p75 + female_num_jobs + male_num_jobs + female_violence_share + violence_per_capita, data = data))
esttab2(filename='results/hourly_price_by_quantile_female_quantiles.csv', col.headers=c("p10","p25","p50","p75","p90"))
esttab2(filename='results/hourly_price_by_quantile_female_quantiles.txt', col.headers=c("p10","p25","p50","p75","p90"))
cat('______________\n')
cat('results/hourly_price_by_quantile_female_quantiles.txt:\n')
writeLines(readLines('results/hourly_price_by_quantile_female_quantiles.txt'))

estclear()
eststo2(lm(ad_p10 ~ log(population) + unemployment + avg_commute + female_p50 + male_p50 + female_num_jobs + male_num_jobs + female_violence_share + violence_per_capita, data = data))
eststo2(lm(ad_p25 ~ log(population) + unemployment + avg_commute + female_p50 + male_p50 + female_num_jobs + male_num_jobs + female_violence_share + violence_per_capita, data = data))
eststo2(lm(ad_p50 ~ log(population) + unemployment + avg_commute + female_p50 + male_p50 + female_num_jobs + male_num_jobs + female_violence_share + violence_per_capita, data = data))
eststo2(lm(ad_p75 ~ log(population) + unemployment + avg_commute + female_p50 + male_p50 + female_num_jobs + male_num_jobs + female_violence_share + violence_per_capita, data = data))
eststo2(lm(ad_p90 ~ log(population) + unemployment + avg_commute + female_p50 + male_p50 + female_num_jobs + male_num_jobs + female_violence_share + violence_per_capita, data = data))
esttab2(filename='results/hourly_price_by_quantile_50.csv', col.headers=c("p10","p25","p50","p75","p90"))
esttab2(filename='results/hourly_price_by_quantile_50.txt', col.headers=c("p10","p25","p50","p75","p90"))
cat('______________\n')
cat('results/hourly_price_by_quantile_50.txt:\n')
writeLines(readLines('results/hourly_price_by_quantile_50.txt'))

estclear()
eststo2(lm(ad_p10 ~ log(population) + unemployment + avg_commute + female_p25 + male_p25 + female_num_jobs + male_num_jobs + female_violence_share + violence_per_capita, data = data))
eststo2(lm(ad_p25 ~ log(population) + unemployment + avg_commute + female_p25 + male_p25 + female_num_jobs + male_num_jobs + female_violence_share + violence_per_capita, data = data))
eststo2(lm(ad_p50 ~ log(population) + unemployment + avg_commute + female_p25 + male_p25 + female_num_jobs + male_num_jobs + female_violence_share + violence_per_capita, data = data))
eststo2(lm(ad_p75 ~ log(population) + unemployment + avg_commute + female_p25 + male_p25 + female_num_jobs + male_num_jobs + female_violence_share + violence_per_capita, data = data))
eststo2(lm(ad_p90 ~ log(population) + unemployment + avg_commute + female_p25 + male_p25 + female_num_jobs + male_num_jobs + female_violence_share + violence_per_capita, data = data))
esttab2(filename='results/hourly_price_by_quantile_25.csv', col.headers=c("p10","p25","p50","p75","p90"))
esttab2(filename='results/hourly_price_by_quantile_25.txt', col.headers=c("p10","p25","p50","p75","p90"))
cat('______________\n')
cat('results/hourly_price_by_quantile_25.txt:\n')
writeLines(readLines('results/hourly_price_by_quantile_25.txt'))

estclear()
eststo2(lm(ad_p10 ~ log(population) + unemployment + avg_commute + female_p75 + male_p75 + female_num_jobs + male_num_jobs + female_violence_share + violence_per_capita, data = data))
eststo2(lm(ad_p25 ~ log(population) + unemployment + avg_commute + female_p75 + male_p75 + female_num_jobs + male_num_jobs + female_violence_share + violence_per_capita, data = data))
eststo2(lm(ad_p50 ~ log(population) + unemployment + avg_commute + female_p75 + male_p75 + female_num_jobs + male_num_jobs + female_violence_share + violence_per_capita, data = data))
eststo2(lm(ad_p75 ~ log(population) + unemployment + avg_commute + female_p75 + male_p75 + female_num_jobs + male_num_jobs + female_violence_share + violence_per_capita, data = data))
eststo2(lm(ad_p90 ~ log(population) + unemployment + avg_commute + female_p75 + male_p75 + female_num_jobs + male_num_jobs + female_violence_share + violence_per_capita, data = data))
esttab2(filename='results/hourly_price_by_quantile_75.csv', col.headers=c("p10","p25","p50","p75","p90"))
esttab2(filename='results/hourly_price_by_quantile_75.txt', col.headers=c("p10","p25","p50","p75","p90"))
cat('______________\n')
cat('results/hourly_price_by_quantile_75.txt:\n')
writeLines(readLines('results/hourly_price_by_quantile_75.txt'))

estclear()
eststo2(lm(ad_p10 ~ log(population) + unemployment + avg_commute + female_p75 + male_p75 + female_num_jobs + male_num_jobs, data = data))
eststo2(lm(ad_p25 ~ log(population) + unemployment + avg_commute + female_p75 + male_p75 + female_num_jobs + male_num_jobs, data = data))
eststo2(lm(ad_p50 ~ log(population) + unemployment + avg_commute + female_p75 + male_p75 + female_num_jobs + male_num_jobs, data = data))
eststo2(lm(ad_p75 ~ log(population) + unemployment + avg_commute + female_p75 + male_p75 + female_num_jobs + male_num_jobs, data = data))
eststo2(lm(ad_p90 ~ log(population) + unemployment + avg_commute + female_p75 + male_p75 + female_num_jobs + male_num_jobs, data = data))
esttab2(filename='results/hourly_price_by_quantile_75_nv.csv', col.headers=c("p10","p25","p50","p75","p90"))
esttab2(filename='results/hourly_price_by_quantile_75_nv.txt', col.headers=c("p10","p25","p50","p75","p90"))
cat('______________\n')
cat('results/hourly_price_by_quantile_75_nv.txt:\n')
writeLines(readLines('results/hourly_price_by_quantile_75_nv.txt'))

estclear()
eststo2(lm(ad_p10 ~ log(population) + unemployment + avg_commute + female_p25 + male_p25 + female_num_jobs + male_num_jobs, data = data))
eststo2(lm(ad_p25 ~ log(population) + unemployment + avg_commute + female_p25 + male_p25 + female_num_jobs + male_num_jobs, data = data))
eststo2(lm(ad_p50 ~ log(population) + unemployment + avg_commute + female_p25 + male_p25 + female_num_jobs + male_num_jobs, data = data))
eststo2(lm(ad_p75 ~ log(population) + unemployment + avg_commute + female_p25 + male_p25 + female_num_jobs + male_num_jobs, data = data))
eststo2(lm(ad_p90 ~ log(population) + unemployment + avg_commute + female_p25 + male_p25 + female_num_jobs + male_num_jobs, data = data))
esttab2(filename='results/hourly_price_by_quantile_25_nv.csv', col.headers=c("p10","p25","p50","p75","p90"))
esttab2(filename='results/hourly_price_by_quantile_25_nv.txt', col.headers=c("p10","p25","p50","p75","p90"))
cat('______________\n')
cat('results/hourly_price_by_quantile_25_nv.txt:\n')
writeLines(readLines('results/hourly_price_by_quantile_25_nv.txt'))

estclear()
eststo2(lm(ad_p10 ~ log(population) + unemployment + avg_commute + female_p50 + male_p50 + female_num_jobs + male_num_jobs, data = data))
eststo2(lm(ad_p25 ~ log(population) + unemployment + avg_commute + female_p50 + male_p50 + female_num_jobs + male_num_jobs, data = data))
eststo2(lm(ad_p50 ~ log(population) + unemployment + avg_commute + female_p50 + male_p50 + female_num_jobs + male_num_jobs, data = data))
eststo2(lm(ad_p75 ~ log(population) + unemployment + avg_commute + female_p50 + male_p50 + female_num_jobs + male_num_jobs, data = data))
eststo2(lm(ad_p90 ~ log(population) + unemployment + avg_commute + female_p50 + male_p50 + female_num_jobs + male_num_jobs, data = data))
esttab2(filename='results/hourly_price_by_quantile_50_nv.csv', col.headers=c("p10","p25","p50","p75","p90"))
esttab2(filename='results/hourly_price_by_quantile_50_nv.txt', col.headers=c("p10","p25","p50","p75","p90"))
cat('______________\n')
cat('results/hourly_price_by_quantile_50_nv.txt:\n')
writeLines(readLines('results/hourly_price_by_quantile_50_nv.txt'))
# End hourly price quantiles

# Begin marginal price quantiles
estclear()
eststo2(lm(mp_p10 ~ log(population) + unemployment + lt_highschool + highschool + college_plus + avg_commute + male_p25 + male_p50 + male_p75 + female_violence_share + violence_per_capita, data = data))
eststo2(lm(mp_p25 ~ log(population) + unemployment + lt_highschool + highschool + college_plus + avg_commute + male_p25 + male_p50 + male_p75 + female_violence_share + violence_per_capita, data = data))
eststo2(lm(mp_p50 ~ log(population) + unemployment + lt_highschool + highschool + college_plus + avg_commute + male_p25 + male_p50 + male_p75 + female_violence_share + violence_per_capita, data = data))
eststo2(lm(mp_p75 ~ log(population) + unemployment + lt_highschool + highschool + college_plus + avg_commute + male_p25 + male_p50 + male_p75 + female_violence_share + violence_per_capita, data = data))
eststo2(lm(mp_p90 ~ log(population) + unemployment + lt_highschool + highschool + college_plus + avg_commute + male_p25 + male_p50 + male_p75 + female_violence_share + violence_per_capita, data = data))
esttab2(filename='results/marginal_price_by_quantile_male_quantiles.csv', col.headers=c("p10","p25","p50","p75","p90"))
esttab2(filename='results/marginal_price_by_quantile_male_quantiles.txt', col.headers=c("p10","p25","p50","p75","p90"))
cat('______________\n')
cat('results/marginal_price_by_quantile_male_quantiles.txt:\n')
writeLines(readLines('results/marginal_price_by_quantile_male_quantiles.txt'))

estclear()
eststo2(lm(mp_p10 ~ log(population) + unemployment + avg_commute + female_p25 + female_p50 + female_p75 + female_num_jobs + male_num_jobs + female_violence_share + violence_per_capita, data = data))
eststo2(lm(mp_p25 ~ log(population) + unemployment + avg_commute + female_p25 + female_p50 + female_p75 + female_num_jobs + male_num_jobs + female_violence_share + violence_per_capita, data = data))
eststo2(lm(mp_p50 ~ log(population) + unemployment + avg_commute + female_p25 + female_p50 + female_p75 + female_num_jobs + male_num_jobs + female_violence_share + violence_per_capita, data = data))
eststo2(lm(mp_p75 ~ log(population) + unemployment + avg_commute + female_p25 + female_p50 + female_p75 + female_num_jobs + male_num_jobs + female_violence_share + violence_per_capita, data = data))
eststo2(lm(mp_p90 ~ log(population) + unemployment + avg_commute + female_p25 + female_p50 + female_p75 + female_num_jobs + male_num_jobs + female_violence_share + violence_per_capita, data = data))
esttab2(filename='results/marginal_price_by_quantile_female_quantiles.csv', col.headers=c("p10","p25","p50","p75","p90"))
esttab2(filename='results/marginal_price_by_quantile_female_quantiles.txt', col.headers=c("p10","p25","p50","p75","p90"))
cat('______________\n')
cat('results/marginal_price_by_quantile_female_quantiles.txt:\n')
writeLines(readLines('results/marginal_price_by_quantile_female_quantiles.txt'))

estclear()
eststo2(lm(mp_p10 ~ log(population) + unemployment + avg_commute + female_p50 + male_p50 + female_num_jobs + male_num_jobs + female_violence_share + violence_per_capita, data = data))
eststo2(lm(mp_p25 ~ log(population) + unemployment + avg_commute + female_p50 + male_p50 + female_num_jobs + male_num_jobs + female_violence_share + violence_per_capita, data = data))
eststo2(lm(mp_p50 ~ log(population) + unemployment + avg_commute + female_p50 + male_p50 + female_num_jobs + male_num_jobs + female_violence_share + violence_per_capita, data = data))
eststo2(lm(mp_p75 ~ log(population) + unemployment + avg_commute + female_p50 + male_p50 + female_num_jobs + male_num_jobs + female_violence_share + violence_per_capita, data = data))
eststo2(lm(mp_p90 ~ log(population) + unemployment + avg_commute + female_p50 + male_p50 + female_num_jobs + male_num_jobs + female_violence_share + violence_per_capita, data = data))
esttab2(filename='results/marginal_price_by_quantile_50.csv', col.headers=c("p10","p25","p50","p75","p90"))
esttab2(filename='results/marginal_price_by_quantile_50.txt', col.headers=c("p10","p25","p50","p75","p90"))
cat('______________\n')
cat('results/marginal_price_by_quantile_50.txt:\n')
writeLines(readLines('results/marginal_price_by_quantile_50.txt'))

estclear()
eststo2(lm(mp_p10 ~ log(population) + unemployment + avg_commute + female_p25 + male_p25 + female_num_jobs + male_num_jobs + female_violence_share + violence_per_capita, data = data))
eststo2(lm(mp_p25 ~ log(population) + unemployment + avg_commute + female_p25 + male_p25 + female_num_jobs + male_num_jobs + female_violence_share + violence_per_capita, data = data))
eststo2(lm(mp_p50 ~ log(population) + unemployment + avg_commute + female_p25 + male_p25 + female_num_jobs + male_num_jobs + female_violence_share + violence_per_capita, data = data))
eststo2(lm(mp_p75 ~ log(population) + unemployment + avg_commute + female_p25 + male_p25 + female_num_jobs + male_num_jobs + female_violence_share + violence_per_capita, data = data))
eststo2(lm(mp_p90 ~ log(population) + unemployment + avg_commute + female_p25 + male_p25 + female_num_jobs + male_num_jobs + female_violence_share + violence_per_capita, data = data))
esttab2(filename='results/marginal_price_by_quantile_25.csv', col.headers=c("p10","p25","p50","p75","p90"))
esttab2(filename='results/marginal_price_by_quantile_25.txt', col.headers=c("p10","p25","p50","p75","p90"))
cat('______________\n')
cat('results/marginal_price_by_quantile_25.txt:\n')
writeLines(readLines('results/marginal_price_by_quantile_25.txt'))

estclear()
eststo2(lm(mp_p10 ~ log(population) + unemployment + avg_commute + female_p75 + male_p75 + female_num_jobs + male_num_jobs + female_violence_share + violence_per_capita, data = data))
eststo2(lm(mp_p25 ~ log(population) + unemployment + avg_commute + female_p75 + male_p75 + female_num_jobs + male_num_jobs + female_violence_share + violence_per_capita, data = data))
eststo2(lm(mp_p50 ~ log(population) + unemployment + avg_commute + female_p75 + male_p75 + female_num_jobs + male_num_jobs + female_violence_share + violence_per_capita, data = data))
eststo2(lm(mp_p75 ~ log(population) + unemployment + avg_commute + female_p75 + male_p75 + female_num_jobs + male_num_jobs + female_violence_share + violence_per_capita, data = data))
eststo2(lm(mp_p90 ~ log(population) + unemployment + avg_commute + female_p75 + male_p75 + female_num_jobs + male_num_jobs + female_violence_share + violence_per_capita, data = data))
esttab2(filename='results/marginal_price_by_quantile_75.csv', col.headers=c("p10","p25","p50","p75","p90"))
esttab2(filename='results/marginal_price_by_quantile_75.txt', col.headers=c("p10","p25","p50","p75","p90"))
cat('______________\n')
cat('results/marginal_price_by_quantile_75.txt:\n')
writeLines(readLines('results/marginal_price_by_quantile_75.txt'))

estclear()
eststo2(lm(mp_p10 ~ log(population) + unemployment + avg_commute + female_p75 + male_p75 + female_num_jobs + male_num_jobs, data = data))
eststo2(lm(mp_p25 ~ log(population) + unemployment + avg_commute + female_p75 + male_p75 + female_num_jobs + male_num_jobs, data = data))
eststo2(lm(mp_p50 ~ log(population) + unemployment + avg_commute + female_p75 + male_p75 + female_num_jobs + male_num_jobs, data = data))
eststo2(lm(mp_p75 ~ log(population) + unemployment + avg_commute + female_p75 + male_p75 + female_num_jobs + male_num_jobs, data = data))
eststo2(lm(mp_p90 ~ log(population) + unemployment + avg_commute + female_p75 + male_p75 + female_num_jobs + male_num_jobs, data = data))
esttab2(filename='results/marginal_price_by_quantile_75_nv.csv', col.headers=c("p10","p25","p50","p75","p90"))
esttab2(filename='results/marginal_price_by_quantile_75_nv.txt', col.headers=c("p10","p25","p50","p75","p90"))
cat('______________\n')
cat('results/marginal_price_by_quantile_75_nv.txt:\n')
writeLines(readLines('results/marginal_price_by_quantile_75_nv.txt'))

estclear()
eststo2(lm(mp_p10 ~ log(population) + unemployment + avg_commute + female_p25 + male_p25 + female_num_jobs + male_num_jobs, data = data))
eststo2(lm(mp_p25 ~ log(population) + unemployment + avg_commute + female_p25 + male_p25 + female_num_jobs + male_num_jobs, data = data))
eststo2(lm(mp_p50 ~ log(population) + unemployment + avg_commute + female_p25 + male_p25 + female_num_jobs + male_num_jobs, data = data))
eststo2(lm(mp_p75 ~ log(population) + unemployment + avg_commute + female_p25 + male_p25 + female_num_jobs + male_num_jobs, data = data))
eststo2(lm(mp_p90 ~ log(population) + unemployment + avg_commute + female_p25 + male_p25 + female_num_jobs + male_num_jobs, data = data))
esttab2(filename='results/marginal_price_by_quantile_25_nv.csv', col.headers=c("p10","p25","p50","p75","p90"))
esttab2(filename='results/marginal_price_by_quantile_25_nv.txt', col.headers=c("p10","p25","p50","p75","p90"))
cat('______________\n')
cat('results/marginal_price_by_quantile_25_nv.txt:\n')
writeLines(readLines('results/marginal_price_by_quantile_25_nv.txt'))

estclear()
eststo2(lm(mp_p10 ~ log(population) + unemployment + avg_commute + female_p50 + male_p50 + female_num_jobs + male_num_jobs, data = data))
eststo2(lm(mp_p25 ~ log(population) + unemployment + avg_commute + female_p50 + male_p50 + female_num_jobs + male_num_jobs, data = data))
eststo2(lm(mp_p50 ~ log(population) + unemployment + avg_commute + female_p50 + male_p50 + female_num_jobs + male_num_jobs, data = data))
eststo2(lm(mp_p75 ~ log(population) + unemployment + avg_commute + female_p50 + male_p50 + female_num_jobs + male_num_jobs, data = data))
eststo2(lm(mp_p90 ~ log(population) + unemployment + avg_commute + female_p50 + male_p50 + female_num_jobs + male_num_jobs, data = data))
esttab2(filename='results/marginal_price_by_quantile_50_nv.csv', col.headers=c("p10","p25","p50","p75","p90"))
esttab2(filename='results/marginal_price_by_quantile_50_nv.txt', col.headers=c("p10","p25","p50","p75","p90"))
cat('______________\n')
cat('results/marginal_price_by_quantile_50_nv.txt:\n')
writeLines(readLines('results/marginal_price_by_quantile_50_nv.txt'))

