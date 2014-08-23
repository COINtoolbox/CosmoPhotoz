from __future__ import print_function
from setuptools import setup, find_packages
from setuptools.command.test import test as TestCommand
import io
import codecs
import os
import sys

import CosmoPhotoz.photoz as photoz

here = os.path.abspath(os.path.dirname(__file__))
def readin(*filenames, **kwargs):
    encoding = kwargs.get('encoding', 'utf-8')
    sep = kwargs.get('sep', '\n')
    buf = []
    for filename in filenames:
        with io.open(filename, encoding=encoding) as f:
            buf.append(f.read())
    return sep.join(buf)

# Convert the github markup to pypi reStructuredText
# try:
#     import pypandoc
#     long_description = pypandoc.convert(source=readin('README.md'), to='rst', format='md')
# except ImportError:
#     print("warning: pypandoc module not found, could not convert Markdown to RST")

long_description = readin('README.rst')

#class PyTest(TestCommand):
#    def finalize_options(self):
#        TestCommand.finalize_options(self)
#        self.test_args = []
#        self.test_suite = True
#
#    def run_tests(self):
#        import pytest
#        errcode = pytest.main(self.test_args)
#        sys.exit(errcode)


#tests_require=['pytest'],
#cmdclass={'test': PyTest},
#test_suite='sandman.test.test_sandman',
#extras_require={
#    'testing': ['pytest'],
#}


setup(
    name='CosmoPhotoz',
    version=photoz.__version__,
    url='http://github.com/COINtoolbox/COSMOPhotoz/CosmoPy',
    license='GNU Public License',
    author=photoz.__author__,
    install_requires=['matplotlib>=1.3.1',
                      'numpy>=1.8.2',
                      'pandas>=0.14.1',
                      'patsy>=0.3.0',
                      'scikit-learn>=0.15.1',
                      'scipy>=0.14.0',
                      'seaborn>=0.3.1',
                      'statsmodels>=0.5.0'],
    author_email=photoz.__email__,
    description=photoz.__doc__,
    long_description=long_description,
    packages=['CosmoPhotoz'],
    package_dir = {'CosmoPhotoz': 'CosmoPhotoz', 'data': 'CosmoPhotoz/data'},
    package_data = {'CosmoPhotoz/data': 'PHAT0.csv.bz2'},
    include_package_data = True,
    scripts=['CosmoPhotoz/run_glm.py'],
    platforms='any',
    classifiers = [
        'Programming Language :: Python',
        'Development Status :: 3 - Alpha',
        'Natural Language :: English',
        'Environment :: X11 Applications',
        'Intended Audience :: Science/Research',
        'License :: OSI Approved :: GNU General Public License (GPL)',
        'Operating System :: OS Independent',
        'Topic :: Software Development :: Libraries :: Python Modules',
        'Topic :: Scientific/Engineering :: Astronomy',
        ],
)
