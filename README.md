# memex_ad_features
The purpose of this repository is to calculate a number of economic metrics on MEMEX `escorts` data. It's a small data pipeline intended to take a number of extractions from scraped advertisements and spit out usable JSON data.

## Design
The different data targets are managed by the [`Makefile`.](https://github.com/giantoak/memex_ad_features/blob/master/Makefile) Input data for a given target is passed through a number of Python and R scripts, and a generated CSV is spat out.

### Input
**Currently**, the Makefile takes as input TSV-file dumps of Lattice data stored in S3 buckets, and the tsv files dumped by the different files. **Eventually** the makefile will replace these S3 dumps Lattice files stored in HDFS. Potentially, it will also take other extractions from the different teams as well.

### Output
**Currently**, the Makefile spits out a number of different CSV files. **Eventually** it will dump these files into HDFS for general consumption.

### Target Dependencies
The below dependency graph is intended to provide an overview of the makefile and chain of targets that it can create. If it doesn't render correctly, know that all is well! Just click on the "missing" icon to get to the file itself.

![Markdown Target Dependencies](https://github.com/giantoak/memex_ad_features/blob/master/makefile_graph.svg "Makefile sources and targets")

## Target Plans
We will be pairing down this version of the makefile to focus on a limited number of targets. Specifically:

### Ad-level metrics
Note that most ad-level metrics are relatively unimportant. User facing systems already have basic ad information and extracted information. So the theme of what we're going to contribute here is either we're going to impute price for ads or we're going to contribute measures which depend in part on aggregated statistics such as...
  
#### Non-imputed features (we can look these up when they exist)
* [X] Ad price at ad level (`price_per_hour` in `make_ad_prices.py`) (@gstub)
  * [ ] For ads with multiple prices, hold out 10% of the one-hour prices, impute the value of the held out set,
    test the size of the match (Jeff, validates parent)
* [ ] Price relative to geographic area (supertask)
  * [ ] Price relative to the **city** average (lowest level of geographic agg. provided by Lattice) (@gstub)
  * [X] Price relative to the **MSA** average (`price_per_hour` - `ad_p50_msa`)/`ad_std_msa` (@gstub)
  * [ ] Price relative to the **state** average (@gstub)
  * [ ] Find out what list ofcities Lattice is using (@pmlandwehr)
    * [ ] Find the mapping from that list of cities to the MSAs. (@pmlandwehr) (**DO NOT** get hung up on this.)
* [X] Price quantile relative to geographic area (i.e. is this ad at the 25th percentile?  30th perentile?) (@gstub)
* [ ] Price for phone number *X* relative to the median price for phone number *X*. (@gstub)
* [ ] Flag difference from MSA average. (i.e. if 30% of ads in an MSA are flagged "Juvenile" the MSA average is .3, so a non-"Juvenile" flagged ad will have a value of -0.3 and a "Juvenile" flagged at 0.7)
* [ ] Total number of extracted prices (possibly not included in data at this point, but good to have)

  
#### Imputations (features that can't be looked up.)
* [ ] Price (if missing)
  * [ ] Jeff's first task! To see what to do about text features from CMU
  * [ ] Jeff's second task! To see about improving the match rates between features and ads.
* [ ] Age (if missing)
    
### Geographic-area-level metrics
Eventually, there will be three files here:
* State
* City
* MSA / small geographic region

Values should be calculated quarterly (perhaps monthly? Or a *rolling average*?)
* [ ] plots of price changes per *time period* per region w/ more than 300 ads with prices per *time period*, where 
*time period* = 
  * [ ] month
  * [ ] quarter
  * [ ] year
  

* Those laid out in `msa_characteristics.csv` (generated by [`make_msa_characteristics.py`](https://github.com/giantoak/memex_ad_features/blob/2593f8a89ff70b57bba8dd4c4260c7b3df648e63/make_msa_characteristics.py))
  * [X] `ad_count_msa` - number of ads
  * Lattice-extracted Price data per geographic area
    * [X] `ad_mean_msa` - Mean
    * [X] `ad_std_msa` - Standard deviation of price within MSA
    * [X] `ad_p<X>_msa`, where `<X> = range(0, 100, 5)` - value at the Xth price percentile
  * Lattice flag data per geographic area
  <!---
    * [ ] `ad_incall_msa` - percent of ads with incall by MSA
    * [ ] `ad_outcall_msa` - percent of ads with outcall by MSA
    * [ ] `ad_<ethnicity>_msa` - percent of ads with given `<ethnicity>` (each ethnicity will have its own column)
      * [ ] (various ethnicities)
    * [ ] `ad_<flag>_msa` - percent of ads with given `<flag>` (each flag will be its own column)
      * [ ] (various flags)
   -->
  * Lattice-extracted Age data per geographic area
    * [X] `ad_mean_age` - Mean
    * [X] `ad_p<X>_age_msa` where `<X> = range(0, 100, 5)` - value at the the Xth age percentile
  
### ~~Phone~~ Entity-level metrics

* [ ] Phones
* [ ] MIT Author identifiers
* [ ] Rebecca's stylometry clusters (when finished)
* [ ] IST Cluster IDs)
(Others TBA, as they come up.

*No* metrics at this level are in the original makefile, but we have been moving in that direction. (See, for instance, [`make_phone_characteristics.py`](https://github.com/giantoak/memex_ad_features/blob/master/make_phone_characteristics.py) and [`make_phone_level.py`](https://github.com/giantoak/memex_ad_features/blob/master/make_phone_level.py).) These metrics come from [Steve Bach's computations.](https://github.com/HazyResearch/memex-analysis)
  * [ ] Talk to Senthil about the future pipeline for these features. (@jeffborowitz)
  * [ ] All values in `data/bach/phones.csv`. (Not in repo)
    * [X] `n_ads` - Number of ads posted by this phone number in sample
    * [X] `n_distinct_locations` - Number of unique cities
    * [ ] `location_tree_length` - a measure of how far apart the phone number appears around the US
    * [X] `n_incall` - Number of ads posted by this phone number that are incalls.
    * [X] `n_outcall` - Number of ads posted by this phone number that are outcalls.
    * [ ] Other metrics… (needs to be broken down)
  * [ ] Price metrics
    * [X] Share of ads under this phone that have prices
    * [X] Media price per phone number
    * [X] Average price per phone number
    * [X] Standard deviation per phone number
    * [ ] HHI phone numbers? (how many different phone numbers do you have per ad? How many unique prices?)

## Future Possibilities
* MSA-level values, cross-tabbed by gender using ACS data
