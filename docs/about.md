---
# Page settings
layout: default
keywords:
comments: false

# Hero section
title: About
description: Find out about the HRV Toolkit and the different use cases.

# Micro navigation
micro_nav: true

# Page navigation
page_nav:
    prev:
        content: Homepage
        url: '/'
    next:
        content: Installation
        url: '/installation'
---

# The Tacho Toolbox


## Purpose

This toolbox was built to enable R-Peak extraction and heart rate variability analysis in pre-term infants. Widely used beat extraction algorithms such as Pan & Tompkins are unable to deal with the high amount of noise in these sognals. This project uses the algorithm proposed by Kota. Much less sensitive to noise, this algorithn allows fro more reliable R-peak extraction.

The technical report can be found [here.](http://hrvtoolkit.com/final_report.pdf)

This toolbox was put together by Arthur Kuhn & Clara Dionet as part of the McGill Engineering Design Project.


## Acknowledgements & References

We thank Professor Robert E. Kearney and Dr Samantha Latremouille for their continuous guidance and support throughout this project. Their expert guidance steered us in the right direction and made the completion of this project possible.

# Package
## Overview

This toolbox enables processing of raw ECG signals to extract numerous heart rate variability measures. It is split into multiple packages. The beats package processes the raw ECG signal, extracts R-peak locations and filters the signal to remove noisy and ectopic beats. The HRVAS package is a small modification of the following project: TODO. It takes a series of inter-beat intervals as an input and computes many hrv measures. The physionet package is used for validation, to compare the results of our qrs peak extraction algorithm with annotated ECG files from the physionet database.

## Get the Package

The source code is currently available on GitHub. Release 1 will include a windows executable as well as a Matlab app.


## Usage

1. Gui: [Matlab Documentation](https://arthurkuhn.github.io/hrvtoolkit/gui/)
2. HRVAS: [README](https://github.com/jramshur/HRVAS)
3. Source Code: [Matlab Documentation](https://arthurkuhn.github.io/hrvtoolkit/matlab/)
4. Physionet Tests: [Matlab Documentation](https://arthurkuhn.github.io/hrvtoolkit/physionet/)