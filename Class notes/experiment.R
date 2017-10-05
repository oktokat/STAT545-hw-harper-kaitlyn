
library(gapminder)
library(tidyverse)
library(ggplot2)

data(gapminder)
head(gapminder)

americas = gapminder %>% 
  filter(continent == "Americas", country != "United States", country != "Canada")

americas %>% 
  ggplot(aes(x=year, y=gdpPercap, group=country)) +
  geom_point() +
  geom_line()

# I want to (1) find the first time countries fall below 7500
#           (2) get rid of all time points prior
#           (3) plot all time points after (even if they increase about 7500 again)

# (1)

test = americas %>% 
  group_by(country, stunt = ifelse(gdpPercap<5000, 1, 0), lagstunt = ifelse(lag(gdpPercap<5000), 1, 0))

test2 = test %>% 
  group_by(country) %>% 
  match(c(0, 1), test$stunt)




gdp_change_cutoff <- -1000 ## this is your gdp drop cut off value

countries_with_drop <- gapminder %>% 
  filter(continent == "Americas") %>% 
  group_by(country) %>% 
  mutate(change_gdp = gdpPercap - lag(gdpPercap)) %>% 
  filter(!is.na(change_gdp)) %>%
  filter(change_gdp < gdp_change_cutoff) %>% 
  top_n(n = -1, wt = year) %>% 
  rename(year_of_earliest_drop = year) %>% 
  select(country, year_of_earliest_drop)

countries_time_series <- left_join(gapminder, countries_with_drop)

countries_time_series %>% 
  filter(!is.na(year_of_earliest_drop)) %>% 
  group_by(country) %>% 
  filter(year >= year_of_earliest_drop) %>% 
  ggplot(aes(x = year, y = gdpPercap, color = country)) + geom_point() + geom_line() +
  facet_wrap( ~ country)













