
CosmoPhotoz - GLM PhotoZ estimation
===================================

CosmoPhotoz is a package that determines photometric redshifts from galaxies utilising their magnitudes.
The method utilises Generalized Linear Models which reproduce the physical aspects of the output distribution.
The rest of the methodology and testing of the technique is described in the associated Astronomy and Computing
publication that can be accessed at [link].

## Installation

The package can be installed using the PyPI and pip.

`pip install cosmophotoz`

Or if the tarball or repository is downloaded, distutils can be used.

`python setup.py install`


## Usage

### Command line

```run_glm.py --dataset sample.csv
--num_components 3
--train_size 10000
--family Gamma
--link log```

### Imported class

    from CosmoPhotoz.photoz import PhotoSample
    import numpy as np

    train_size_arr = np.arange(0,10000,500)

    catastrophic_error = []
    UserCataloge = PhotoSample(filename="CATALOGUE.csv")
    UserCatalogue.do_PCA()

    for train_size in range(len(train_size_arr)):
      UserCatalogue.num_components = train_size[i]
      UserCatalogue.split_sample(random=True)
      UserCatalogue.do_GLM()
      catastrophic_error.append(UserCatalogue.catastrophic_error)        
  
    min_indx = numpy.array(catastrophic_error) < 0.01
    optimimum_train_size = train_size[min_indx]


# Documentation

 * The library documentation can be accessed at [www.github.io](www.github.io).

 * The github repository can be accessed at [www.github.com](www.github.com).

 * The PyPI package page can be accessed at [www.pypi.org](www.pypi.org).
