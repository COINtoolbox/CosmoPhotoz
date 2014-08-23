Introduction
============

This package provides user-friendly interfaces to perform fast and reliable photometric redshift estimation. The code makes use of generalized linear models, more specifically the Gamma family.

The methodology and test cases of the software will be accessible in the future via an article on Astronomy and Computing. The documentation will be updated when it has been submitted to arXiv. 

The problem to be solved is to estimate the redshift of a galaxy based on its multi-wavelength photometry. Such a problem will become increasingly apparent with the new set of instruments to begin observing in the near future, e.g. LSST. They will detect more sources than they can carry out follow up spectroscopy on, and so machine learning techniques must be used.

The gamma family that originates from the wider set of generalized linear models, is a distribution that reproduces positive and continuous observables. We show that this technique requires much smaller training sizes and computational execution time to estimate values of redshift from the multi-wavelength photometry, than conventional methods such as neural networks. Despite the less strict requirements of the model, the fits are similar and sometimes better than the other techniques used.

This package allows you to train a GLM on a sample of known redshifts and then estimate the photometric redshifts of a sample for which you have no redshifts.
