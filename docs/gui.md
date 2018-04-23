---
# Page settings
layout: default
keywords:
comments: false

# Hero section
title: Using the GUI
description: Both the QRS extraction and HRVAS apps have user interfaces allowing for simple control of the pipeline. Find out about all the features here.

# Micro navigation
micro_nav: true

# Page navigation
page_nav:
    prev:
        content: Installation
        url: '/installation'
    next:
        content: Using MATLAB
        url: '/matlabguide'
---

# Loading the signal

The toolkit loads the ECG signal from the raw APEX recording. Use the file selector to find the correct .mat file.

# Post-Processing

The toolkit offers a variety of post-processing options. Ensemble methods work directly on the ECG signal. On the other hand, all other methods function directly on the processed tachogram (inter-beat intervals).

## Ensemble methods

The Ensemble processing unit compares each beat to the average beat to eliminate odd beats, based on correlation. The unit works as follows:

1. For each detected R-peak, get a 200mn window of the raw ECG signal centered around the peak.
2. Average all of these windows to get the shape of the average peak.
3. Discard all peaks that have a correlation with the average beat lower than the specified threshold.


## MAD Filtering

The Median Absolute Deviation Filter can be used to detect and remove outlier inter-beat intervals.


## Missed Beat Detector

The missed beat detector passes over the signal to detect any potential missed beats. Missed beats are detected by looking for a sudden doubling of the RR-interval before a return to normal.

# Tachogram

## Interpolation

To generate the continuous heart rate signal over time, use one of the following methods:
1. Direct (linear) interpolation
2. Splines (cubic) interpolation, with a supplied smoothing coefficient.

## Median Fitering

Once the final tachogram has been obtained, it can be smoothed using a median filter.


# Results

## Evaluation

The toolkit displays various quality metrics in the left pane after processing.

## Graphs

Graphs are shown in the right-hand pane. They can be explored using the slider and zoom options.




