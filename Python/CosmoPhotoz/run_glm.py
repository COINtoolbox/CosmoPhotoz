#!/usr/bin/env python

"""
Photo-z fitting package utilising Generalised Linear Models.

Usage:
 - run_glm.py -d/--dataset <DATASET>
     or
   run_glm.py -d/--dataset <DATASET_TRAIN> <DATASET_TEST>

   run_glm.py -h/--help for further options

Details:
 - The response (redshift) is positive and continuous: Gamma family is used (log link)
 - Principle Component Analysis has been used to ensure each feature is independent from one another

Libraries used:

 - pandas:      Allows the use of DataFrames (alla R)
 - sklearn:     Easy implementation of PCA analysis
 - statsmodels: Easy implementation of GLM and fitting via IRLS (alla R)
 - seaborn:     Makes the fancy pandas plots fancier
 - matplotlib:  General plotting
 - time:        For timing
 - logging:     For logging
 - numpy:       For arrays
 - argparse:    Allow users to use it easily from the command line

"""

__author__ = "J. Elliott, R. S. de Souza, A. Krone-Martins"
__maintainer__ = "J. Elliott"
__copyright__ = "Copyright 2014"
__version__ = "0.1"
__email__ = "jonnynelliott@googlemail.com"
__status__ = "Prototype"
__license__ = "GPL"

from CosmoPhotoz.photoz import PhotoSample
import sys
import argparse

def main(args):

  if len(args.dataset) == 1:
    UserCatalogue = PhotoSample(filename=args.dataset[0], family=args.family, link=args.link)
  elif len(args.dataset) == 2:
    UserCatalogue = PhotoSample(filename_train=args.dataset[0], filename_test=args.dataset[1], family=args.family, link=args.link)
  else:
    print("You gave too many filenames")
    print(__doc__)
    sys.exit(0)

  # Training size
  UserCatalogue.test_size = args.training_size # This inconsistent naming must be changed

  # GLM Family and link
  UserCatalogue.family = args.family
  UserCatalogue.link = args.link

  # Number of PCA components
  UserCatalogue.num_components = args.num_components

  # Run everything
  UserCatalogue.run_full()

if __name__=='__main__':

  parser = argparse.ArgumentParser(usage=__doc__)
  parser.add_argument('-d', '--dataset', dest="dataset", nargs="+", default=None, required=True, type=str)
  parser.add_argument('-t', '--training_size', dest='training_size', default=False, required=False, type=int)
  parser.add_argument('-f', '--family', dest="family", default="Gamma", required=False, type=str)
  parser.add_argument('-l', '--link', dest="link", default="log", required=False, type=str)
  parser.add_argument('-n', '--num_components', dest='num_components', default=False, required=False, type=int)

  args = parser.parse_args()

  main(args)
