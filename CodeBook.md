# Code Book

This code book summarizes the resulting data fields in `tidy_data.txt`.

## Identifiers

* `subject` - The ID of the test subject

* `activity` - The type of activity performed when the corresponding measurements were taken

## Variables

* `domain` - time/frequency domain (time domain signals were captured at a constant rate of 50 Hz, Fast Fourier Transform (FFT) was applied to some of these signals to produce frequency domain signals 

* `acceleration signal` - body/gravity acceleration signals separated using a low pass Butterworth filter with a corner frequency of 0.3 Hz

* `sensor` - accelerometer/gyroscope

* `jerk signal` - the body linear acceleration and angular velocity were in time to obtain Jerk signals

* `magnitude` - the magnitude of the three-dimensional signals calculated using the Euclidean norm

* `axis` - X/Y/Z

## Values

* `mean` - the mean of all observations

* `std` - the standard deviation of all observations
