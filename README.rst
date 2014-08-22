CosmoPhotoz - GLM PhotoZ estimation
====================================

Homepage: `http://github.com/COINtoolbox/COSMOPhotoz/CosmoPy <http://github.com/COINtoolbox/COSMOPhotoz/CosmoPy>`_

`CosmoPhotoz` is a package that determines photometric redshifts from galaxies utilising their magnitudes. The method utilises Generalized Linear Models which reproduce the physical aspects of the output distribution. The rest of the methodology and testing of the technique is described in the associated Astronomy and Computing publication that can be accessed at [link].

.. code-block:: python

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

Features
--------

- Principle Component Anylsis and decomposition of input photometric catalogue
- Generalized Linear Model family and link choice
- Seaborn publication quality plots


Get it now
----------

The package can be installed using the PyPI and pip.

::

    $ pip install -U cosmophotoz

Or if the tarball or repository is downloaded, distutils can be

::

    $ python setup.py install

Examples
--------

Run from the command line.

:: 

    $ run_glm.py --dataset sample.csv --num_components 3 --train_size 10000 --family Gamma --link log


Or import the library into python.

.. code-block:: python  

    import numpy as np

    train_size_arr = np.arange(0,10000,500) catastrophic_error = []

    UserCatalogue.do_PCA()

    for train_size in range(len(train_size_arr)):
        UserCatalogue.num_components = train_size[i]
        UserCatalogue.split_sample(random=True) UserCatalogue.do_GLM()

    catastrophic_error.append(UserCatalogue.catastrophic_error)

    min_indx = numpy.array(catastrophic_error) < 0.01
    optimimum_train_size = train_size[min_indx]


See more examples at the `Quickstart guide`_.

.. _`Quickstart guide`: https://textblob.readthedocs.org/en/latest/quickstart.html#quickstart


Documentation
-------------

-  The library documentation can be accessed at `http://jonnybazookatone.github.io/CosmoPy/ <http://jonnybazookatone.github.io/CosmoPy/>`_

-  The github repository can be accessed at `http://github.com/COINtoolbox/COSMOPhotoz/CosmoPy <http://github.com/COINtoolbox/COSMOPhotoz/CosmoPy>`_

-  The PyPI package page can be accessed at `https://pypi.python.org/pypi?name=CosmoPhotoz&version=1.0 <https://pypi.python.org/pypi?name=CosmoPhotoz&version=1.0>`_

Requirements
------------

- Python >= 2.7 or >= 3.3


License
-------

- GNU General Public License

.. _pattern: http://www.clips.ua.ac.be/pattern
.. _NLTK: http://nltk.org/
