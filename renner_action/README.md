# Renner Action Data

## Data Source

The data is located in a file called samples.txt.  The data contains 5 hammer strikes.
Samples of Renner action hammer motion.  Keys are in the 4th octave but I don't recall
which keys were struck to create the data.

Samples are the motion of the hammer shank at a point close to the flange.

## Measurement System

ADC is 24-bit but data was heavily post-quantized
due to a temporary implementation constraint.
Data was sampled at 8000 samples per second.

See DIY-Grand-Digital-Piano repository for further details.

https://github.com/gzweigle/DIY-Grand-Digital-Piano
https://github.com/gzweigle/DIY-Grand-Digital-Piano/blob/main/video_documentation.md

## Data Usage

To open with Excel, check the box for comma delimited
when importing the data. The data does not have a header row.

For Matlab or Octave, run the file plot_data_and_velocity.m

Data is normalized to 1.0 as max ADC range.
Variation in amplitude is due to non-uniform sensor placement.

## Plots

![alt text](hammer_position_and_velocity.jpg)
![alt text](hammer_position_samples.jpg)