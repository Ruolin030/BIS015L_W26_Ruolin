# Acute stress and restricted diet reduce bill-mediated heat dissipation in the song sparrow (Melospiza melodia): implications for optimal thermoregulation
---

The file titled "all.csv" contains the data for "Acute stress and restricted diet reduce bill-mediated heat dissipation in the song sparrow (Melospiza
melodia): implications for optimal thermoregulation". These data were collected from thermal images collected during experiments on Song Sparrows
(Melospiza melodia) during the summer of 2013. In summary, the experiments were conducted at 37°C (above the thermoneutral zone) and involved the use
of a thermal imaging camera to measure the surface temperatures of birds during a stress response (elicited by handling the bird in photographer's grip).
The data are measurements of the surface temperature of the bill, eyeball, and eye region, which are regions of interest for thermoregulation and/or stress
monitoring via thermography. The file titled 'frame.data.csv' contains metadata for the data in 'all.csv', specifically about the size of the Region
of Interest (ROI) shapes used to extract data on surface temperatures.

## Description of the Data and file structure

The file titled "analysis.R" is an R script that contains the code for all statistical analyses discussed in the manuscript. The file titled
"figures.R" is an R script that contains the code for obtaining the figures in the manuscript. Please note that the entire "analysis.R" script must be run
first for the "figures.R" script to work correctly. The file titled "all.csv" contains the data for "Acute stress and restricted diet reduce bill-mediated
heat dissipation in the song sparrow (Melospiza melodia): implications for optimal thermoregulation". The  file titled 'frame.data.csv' contains metadata
for the data in 'all.csv', specifically about the size of the Region of Interest (ROI) shapes used to extract data on surface temperatures. Below is a
description for each of the columns in the datasheets. The units are listed at the end of the description where applicable.


Variables in 'all.csv':
bird: the individual bird's assigned ID number
subspecies: the subspecies of the individual
trial: an ID number for the experiment itself, which was necessary to differentiate between experiments on the same bird but in two seasons
temp: the ambient temperature during the experiment (degrees Celsius)
time: the time relative to the beginning of handling (minutes)
bill.mean: the average bill surface temperature (degrees Celsius)
frame: the frame in the thermal image sequence
eye.reg.max: the maximum temperature of the eye region (degrees Celsius)
eye.reg.fc: the number of pixels in the Region of Interest (ROI) shape for the eye region
eye.mean: the average eye surface temperature (note, this is not the eye region.) (degrees Celsius)
pant: binary variable for the presence of panting behavior
diet: the type of diet (restricted or unrestricted) that the bird received
season: the season during which the trial was conducted
bill.d: the depth of the individual's bill at the anterior edge of the nares (millimeters)
bill.l: the length of the individual's bill from the anterior edge of the nares to the tip (millimeters)
bill.w: the width of the individual's bill at the anterior edge of the nares (millimeters)
mass: the weight of the individual (grams)

Variables in 'frame.data.csv':
bird: the individual bird's assigned ID number
trial: an ID number for the experiment itself, which was necessary to differentiate between experiments on the same bird but in two seasons
temp: the ambient temperature during the experiment (degrees Celsius)
time: the time relative to the beginning of handling (minutes)
bill.mean: the average bill surface temperature (degrees Celsius)
eye.mean: the average eye surface temperature (note, this is not the eye region.) (degrees Celsius)
season: the season during which the trial was conducted
frame: the frame from which the pixel metadata were collected
b.pix: the number of pixels in the Region of Interest (ROI) shape for the bill
e.pix: the number of pixels in the Region of Interest (ROI) shape for the eye (note, this is not the eye region)


## Sharing/access Information

Links to other publicly accessible locations of the data: NA

Was data derived from another source? No
If yes, list source(s):
