CosmoPhotoz - GLM PhotoZ estimation
====================================

.. image:: https://readthedocs.org/projects/cosmophotoz/badge/?version=latest

Homepage: `GitHub Repository <https://github.com/COINtoolbox/CosmoPhotoz/tree/master/Python>`_

`CosmoPhotoz` is a package that determines photometric redshifts from galaxies utilising their magnitudes. The method utilises Generalized Linear Models which reproduce the physical aspects of the output distribution. The rest of the methodology and testing of the technique is described in the associated Astronomy and Computing publication (link TBC).


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


See more examples within the `Documentation`_.

.. _`Documentation`: http://cosmophotoz.readthedocs.org/


Documentation
-------------

-  The library documentation can be accessed at `Read the Docs <https://readthedocs.org/projects/cosmophotoz/badge/?version=latest>`_

-  The git repository can be accessed at `GitHub <http://github.com/COINtoolbox/COSMOPhotoz>`_

-  The PyPI package page can be accessed at `PyPI <https://pypi.python.org/pypi?name=CosmoPhotoz&version=0.1>`_

Requirements
------------

- Python >= 2.7 or >= 3.3


License
-------

- GNU General Public License (GPL>=3)

.. _pattern: http://www.clips.ua.ac.be/pattern
.. _NLTK: http://nltk.org/
