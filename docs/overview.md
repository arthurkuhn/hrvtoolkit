# Overview



## Purpose

This toolbox was built to enable R-Peak extraction and heart rate variability analysis in pre-term infants. Widely used beat extraction algorithms such as Pan & Tompkins are unable to deal with the high amount of noise in these sognals. This project uses the algorithm proposed by Kota TODO. Much less sensitive to noise, this algorithn allows fro more reliable R-peak extraction.

This toolbox was put together by Arthur Kuhn & Clara Dionet as part of the McGill Engineering Design Project.



## Acknowledgements & References

We thank Professor Robert E. Kearney and Dr Samantha Latremouille for their continuous guidance and support throughout this project. Their expert guidance steered us in the right direction and made the completion of this project possible.

# Packages
## Overview

This toolbox enables processing of raw ECG signals to extract numerous heart rate variability measures. It is split into multiple packages. The beats package processes the raw ECG signal, extracts R-peak locations and filters the signal to remove noisy and ectopic beats. The HRVAS package is a small modification of the following project: TODO. It takes a series of inter-beat intervals as an input and computes many hrv measures. The physionet package is used for validation, to compare the results of our qrs peak extraction algorithm with annotated ECG files from the physionet database.



## Usage

1. Beats:
2. HRVAS
3. Physionet

# Individual Record Analysis

## Extracting the heart-rate
1. Programmatically
2. Through the UI

## Analysing the results
HRVAS


# Batch Processing

## Extracting the heart-rate
## Analysing the result
