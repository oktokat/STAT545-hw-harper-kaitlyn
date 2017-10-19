################################################################################################################################ 
################################ This script cleans the zvitambo data to prepare it for analysis################################ 
################################################################################################################################ 

### Remove unnecessary/unknown variables
rm(zv)

### Change names of age and sex variables for convenience 
z = plyr::rename(z, c("a14"="sex", "i.age.months"="age"))

### Make a small set of variables

z = z %>% 
  select(idno, age, sex, zlen, a05, m.age, noBF, lbw, term, parity, stunt, c.visits.i)


### Keep only subjects that are under 25 months 
z = z %>% 
  filter(age < 25 | is.na(age))


### Keep only individuals that were stunted at some point during the study
stunted = as.data.frame(z %>% 
                          group_by(idno) %>% 
                          filter(1 %in% stunt)) 

### Keep only individuals without NA in zlen

stunted = stunted %>% 
  filter(!is.na(zlen))

### Remove z

rm(z)
