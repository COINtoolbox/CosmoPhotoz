#!/usr/bin/env python

"""
Photometric redshift library that implements Generalised Linear Models.
"""

__author__ = "J. Elliott, R. S. de Souza, A. Krone-Martins"
__maintainer__ = "J. Elliott"
__copyright__ = "Copyright 2014"
__version__ = "0.1"
__email__ = "jonnynelliott@googlemail.com"
__status__ = "Prototype"
__license__ = "GPL"

import numpy as np
import pandas as pd
import time, argparse, logging, sys

class PhotoSample(object):

  def __init__(self, filename_train=False, filename_test=False, \
               filename=False, family="Gamma", link=False, \
               Testing=False):

    """
    Constructor for the photometric sample class.
    This contains content related to the:

    1. logging
    2. PCA preferences
    3. GLM preferences
    4. Plotting aesthetics

    Instance variables:
    -------------------

    logger             - logger

    filename_train     - user filename for fitting 
    filename_test      - user filename for prediction
    filename           - user filename


    family_name        - GLM family
    link               - GLM link
    formula            - GLM formula

    test_size          - size of the training sample
    num_components     - number of PCA components
    cross_validate     - defines if redshift predictions should be made

    lims               - axes limits (should be obselete)
    color_palette      - color palette passed to seaborn
    reduce_size        - this defines how many objects to use in plotting
    fontsize           - fontsize used for axes labels
    
    Testing            - purely for test purposes
    

    Method attributes
    -----------------
    PCA_data_frame     - DataFrame object from PCA fitting
    data_frame_train   - DataFrame object with PCA for training
    data_frame_test    - DataFrame object with PCA for predictions/cross validation
    
    deltas             - absolute different of measured to predicted
    median             - median of deltas
    std                - standard deviation of deltas
    measured           - measured redshifts
    predicted          - predicted redshifts from GLM
    num_mega_outliers  - number of outliers
    average            - average of deltas
    rms                - root mean squares of deltas
    rms_outliers       - root mean squares of deltas without outliers
    bias_outliers      - mean of the deltas without outliers
    catastrophic_error - fraction of outliers

    kde_1d_ax          - seaborn axes object for KDE 1D plot
    kde_2d_ax          - seaborn axes object for KDE 2D plot
    :kde_ax             - seaborn axes object for violin plot:

    """ 


    #: test : 

    # Setup the logger to the command line
    # To a file can also be added fairly easily
    logfmt = '%(levelname)s [%(asctime)s]:\t  %(message)s'
    datefmt= '%m/%d/%Y %I:%M:%S %p'
    formatter = logging.Formatter(fmt=logfmt,datefmt=datefmt)

    logger = logging.getLogger('__photoz__')
    logger.setLevel(logging.DEBUG)
    logger.propagate = 0
    #logging.root.setLevel(logging.DEBUG)
    #logging.root.setLevel(logging.WARNING)
    if not logger.handlers:
      ch = logging.StreamHandler() #console handler
      ch.setFormatter(formatter)
      logger.addHandler(ch)
 
    self.logger = logger

    # Book keeping of what the user entered
    self.filename_train = filename_train
    self.filename_test = filename_test
    self.filename = filename

    # GLM
    self.family_name = family
    self.link = link
    self.formula = False

    # Plots
    self.lims = {"x": [0.3, 0.8], "y": [0.41, 0.71]}
    self.color_palette = "seagreen" # This is specific to seaborn
    self.reduce_size = 5000  # This uses a subsample to make plots
    self.fontsize = 30

    # Testing
    self.Testing = Testing # Testing purposes
    self.test_size = False  # The size of the training sample
    self.num_components = False # Number of PCA components

    # This is for more test purposes
    if self.filename:

      self.data_frame = self.load_data_frame(filename)

      self.logger.info("You gave a complete file, separating training sets")
      self.logger.info("You gave the dataset: {0}".format(filename))
      self.cross_validate = True

    # This is for normal users
    elif self.filename_test and filename_train:
      self.logger.info("You gave two separate files")
      self.logger.info("Training dataset: {0}".format(filename_train))
      self.logger.info("Testing dataset: {0}".format(filename_test))
      self.cross_validate = False

      self.data_frame_test = self.load_data_frame(filename_test)
      self.data_frame_train = self.load_data_frame(filename_train)

#      if not "redshift" in self.data_frame_test.columns:
 #       self.data_frame_test["redshift"] = numpy.zeros(len(self.data_frame_test))

      # Join the training and testing into a single file.
      # This is required for the PCA semi-supervised analysis
      self.data_frame = self.data_frame_train.copy()
      self.data_frame = self.data_frame.append(self.data_frame_test)   

    else:
      self.logger.warning("You must give a training and test set or a complete file.")
      sys.exit(0)


  def load_data_frame(self, filename):
    """Loads the file into a pandas DataFrame. Returns this to the user."""

    try:
      if filename == "PHAT0":
        import os
        phat = os.path.join(os.path.dirname(__file__), 'data', 'PHAT0.csv.bz2')
        data_frame = pd.read_csv(phat, compression="bz2", encoding="utf-8")

      else:
        data_frame = pd.read_csv(filename, encoding="utf-8")

      self.data_frame_header = [i for i in data_frame.columns if i not in ["redshift", "specObjID"]]

      if self.Testing:
        rows = np.random.choice(data_frame.index.values, self.reduce_size)
        sampled_df = data_frame.ix[rows]
        return sampled_df
      
      else:
        return data_frame

    except:
      self.logger.info("Failed to open CSV file: {0}".format(sys.exc_info()[0]))
      sys.exit(0)

  def do_PCA(self):
    """
    Principle Component Analysis
    Simple PCA is used to deconstruct an N-dimensional DataFrame into a lower dimension.
    The number of components is determined from the variance. This can be changed easily via
    the properties of the class.
    """

    from sklearn.decomposition import PCA

    # Number of components
    # if not self.num_components:
    #   self.num_components = len([i for i in self.data_frame.columns if i != "redshift"])

    self.logger.info("Carrying out Principle Component Analysis")
    pca = PCA()

    pca.fit(self.data_frame[self.data_frame_header])

    if not self.num_components:

      # We select the number of components that retain 99.95% of the variance
      x = pca.explained_variance_ratio_
      x_cf = []
      for i in range(len(x)):
        if i>0: x_cf.append(x[i]+x_cf[i-1])
        else: x_cf.append(x[i])
      x_cf = x_cf

      j = False
      for i in range(len(x_cf)):
        if x_cf[i]>0.9995:
          j = i
          break
      if not j: j = len(x_cf)-1

      self.logger.info("explained variance: {0}".format(pca.explained_variance_ratio_))
      self.logger.info("CDF: {0}".format(x_cf))
      self.logger.info("99.5% variance reached with {0} components".format(j+1))

      self.num_components = j+1

    # Collect the PCA components
    M_pca = pca.fit_transform(self.data_frame[self.data_frame_header])

    M_df = {}
    M_df["redshift"] = self.data_frame["redshift"].values

    for i in range(self.num_components):
      M_df["PC{0:d}".format(i+1)] = M_pca[:,i]

    self.PCA_data_frame = pd.DataFrame(M_df)

  def split_sample(self, random):
    """
    If a single dataset is given, it is required to split the sample into a training set
    and a testing set. Also, any new PCA components are created.
    TODO: place PCA parts in PCA, remove from this section.
    """
    # Cross Validation Section
    ##
    if not self.test_size:
      self.test_size = int(self.data_frame.shape[0]*0.2)

      self.logger.info("Splitting into training/testing sets.")

    ## Split into train/test      
    if random:
      from sklearn.cross_validation import train_test_split
      test, train = train_test_split(self.PCA_data_frame, test_size=int(self.test_size), random_state=42)
    else:
      left = self.data_frame_train.shape[0]
      train = self.PCA_data_frame[:left]
      test = self.PCA_data_frame[left:]

    self.logger.info("Training set length: {0}".format(train.shape[0]))
    self.logger.info("Testing set length: {0}".format(test.shape[0]))

    ## Redefine some DataFrames, otherwise they are just numpy arrays
    col_train = {}
    col_test = {}

    try:
      col_train["redshift"] = train[:,-1]
      col_test["redshift"] = test[:,-1]
      for i in range(self.num_components):
        col_train["PC{0:d}".format(i+1)] = train[:,i]
        col_test["PC{0:d}".format(i+1)] = test[:,i]

    except:
      col_train["redshift"] = train["redshift"].values
      col_test["redshift"] = test["redshift"].values
      for i in range(self.num_components):
        col_train["PC{0:d}".format(i+1)] = train["PC{0:d}".format(i+1)]
        col_test["PC{0:d}".format(i+1)] = test["PC{0:d}".format(i+1)]

    self.data_frame_test = pd.DataFrame(col_test)
    self.data_frame_train = pd.DataFrame(col_train)


  def do_GLM(self, disp=1):

    """
    Generaliesd Linear Models
    This fits a GLM to the training data set and then fits it to the testing dataset.
    Different families and links can be included if need be simply using the statsmodels
    simple API.
    """
    import statsmodels.api as sm
    import statsmodels.formula.api as smf
    import statsmodels.genmod as smg

    # Decide the family    
    if self.family_name == "Gamma":
      if self.link == "log":
        self.family = sm.families.Gamma(link=smg.families.links.log)
      else:
        self.family = sm.families.Gamma()
    elif self.family_name == "Quantile":
        self.family = self.family_name
        self.link = "None"
    else:
      logger.info("You can only pick the family: Gamma and Quantile")

    # Decide the formula
    poly = lambda x, power: x**power

    if not self.formula:
      formula = "redshift ~ poly(PC1, 2) +"
      for i in range(self.num_components):
        if i<self.num_components-1:
          formula += "PC{0}*".format(i+1)
        else:
          formula += "PC{0}".format(i+1)
      self.formula = formula

    self.logger.info("Family: {0} with \tformula: {1}\tlink: {2}".format(self.family_name, self.formula, self.link))
    self.logger.info("Fitting...")
    
    t1 = time.time()
    if self.family == "Quantile":
      # Quantile regression
      model = smf.quantreg(formula=self.formula, data=self.data_frame_train)
      results = model.fit(q=.5)
      if verbose:
        self.logger.info(results.summary())
    else:
      model = smf.glm(formula=self.formula, data=self.data_frame_train, family=self.family)
      results = model.fit()
      self.logger.info(results.summary())
    t2 = time.time()

    self.dt = (t2-t1)
    self.logger.info("Time taken: {0} seconds".format(self.dt))

 
    #Plot the model with our test data
    ## Prediction
    if self.cross_validate:
      self.logger.info("Cross validating")
      self.measured = np.array(self.data_frame_test["redshift"].values)
      self.predicted = results.predict(self.data_frame_test)
    else:
      self.measured = np.array(self.data_frame_train["redshift"].values)
      self.predicted = results.predict(self.data_frame_train)
      self.fitted = results.predict(self.data_frame_test)

    ## Outliers
    ## (z_phot - z_spec)/(1+z_spec)

    self.deltas = abs(self.predicted - self.measured)
    self.median = np.median(self.deltas)
    self.std = np.std(self.deltas)

    # First we will remove the outliers
    mega_out_indx = (self.deltas/(1+self.measured)) > 0.15
    self.num_mega_outliers = mega_out_indx.sum() / (1.0*len(self.deltas))
    self.average = np.mean(self.deltas[mega_out_indx.__invert__()])

    self.rms = np.sqrt(np.mean(self.deltas**2))

    self.rms_outliers = np.sqrt(np.mean(self.deltas[mega_out_indx.__invert__()]**2))
    self.std_outliers = np.std(self.deltas[mega_out_indx.__invert__()])
    self.bias_outliers = np.mean(self.deltas[mega_out_indx.__invert__()])


    self.logger.info("Median (dz):.............................................{0}".format(self.median))
    self.logger.info("Standard deviation (dz):.................................{0}".format(self.std))
    self.logger.info("RMS (dz).................................................{0}".format(self.rms))
    self.logger.info("............................................................")
    self.logger.info("Number of outliers removed...............................{0}".format(self.num_mega_outliers))
    self.logger.info("Average (removed outliers for > 0.15) (dz):..............{0}".format(self.average))
    self.logger.info("Standard deviation (removed outliers for > 0.15) (dz):...{0}".format(self.std_outliers))
    self.logger.info("RMS (removed outliers for z > 0.15)......................{0}".format(self.rms_outliers))
    self.logger.info("Bias (removed outliers for z > 0.15).....................{0}".format(self.bias_outliers))

    self.outliers = (self.predicted - self.measured) / (1.0 + self.measured)

    # R code
    # Out<-100*length(PHAT0.Pred$fit[(abs(PHAT0.test.PCA$redshift-PHAT0.Pred$fit))>0.15*(1+PHAT0.test.PCA$redshift)])/length(PHAT0.Pred$fit)
    self.catastrophic_error = 100.0*(abs(self.measured-self.predicted) > (0.15*(1+self.measured))).sum()/(1.0*self.measured.shape[0])
    self.logger.info("Catastrophic Error:......................................{0}%".format(self.catastrophic_error))

  def write_to_file(self):
    """
    If the user gave a second file to make a prediction it writes the fit to a file.
    """
    out_file = "glmPhotoZresults.csv"
    self.logger.info("Writing to file: {0}".format(out_file))
    df = pd.DataFrame({"redshift": self.fitted})
    df.to_csv(out_file, index=False)

  def make_1D_KDE(self):

    """
    Makes a 1 dimensional probability density of the outliers. See the publication
    for a definition of outliers.
    """
    from matplotlib.mlab import griddata
    import matplotlib.pyplot as plt
    import seaborn as sns

    self.logger.info("Generating 1D KDE plot...")
    ind = range(len(self.outliers))
    rows = list(set(np.random.choice(ind,self.reduce_size)))
    self.logger.info("Using a smaller size for space ({0} objects)".format(self.reduce_size))

    outliers = self.outliers[rows]
    measured = self.measured[rows]
    predicted = self.predicted[rows]

    fig = plt.figure()
    ax = fig.add_subplot(111)
    x_straight = np.arange(0,1.6,0.1)
    
    sns.distplot(outliers, hist_kws={"histtype": "stepfilled", "color": "slategray"}, ax=ax, color=self.color_palette)
  
    ax.set_xlabel(r"$(z_{\rm phot}-z_{\rm spec})/(1+z_{\rm spec})$", fontsize=self.fontsize)
    ax.set_ylabel(r"$\rm Density$", fontsize=self.fontsize)
    ax.set_position([.15,.17,.75,.75])

    ax.set_xlim([-0.15,0.15])

    for item in ([ax.xaxis.label, ax.yaxis.label]):
            item.set_fontsize(self.fontsize)

    for item in (ax.get_xticklabels() + ax.get_yticklabels()):
            item.set_fontsize(self.fontsize-10)

    self.kde_1d_ax = ax
    plt.savefig("PHOTZ_KDE_1D_{0}.pdf".format(self.family_name), format="pdf")


  def make_2D_KDE(self):

    """
    Makes a 2 dimensional probability density plot of the outliers. Each dimension has a 
    probability density histogram created and placed at the top of each axis.
    """

    from matplotlib.mlab import griddata
    import matplotlib.pyplot as plt
    import seaborn as sns

    pal = sns.dark_palette(self.color_palette)

    self.logger.info("Generating 2D KDE plot...")
    ind = range(len(self.outliers))
    rows = list(set(np.random.choice(ind,self.reduce_size)))
    self.logger.info("Using a smaller size for space ({0} objects)".format(self.reduce_size))

    outliers = self.outliers[rows]
    measured = self.measured[rows]
    predicted = self.predicted[rows]

    xmin, xmax = 0, self.data_frame["redshift"].max()
    ymin, ymax = 0, xmax

    x_straight = np.arange(xmin, xmax+0.1, 0.1)
    plt.figure()

    pal = sns.dark_palette(self.color_palette, as_cmap=True)

    g = sns.JointGrid(measured, predicted, size=10, space=0)
    g.plot_marginals(sns.distplot, kde=True, color=self.color_palette)
    g.plot_joint(plt.scatter, color="silver", edgecolor="white")
    g.plot_joint(sns.kdeplot, kind="hex", color=self.color_palette, cmap=pal)
    g.ax_joint.set(xlim=[xmin, xmax], ylim=[ymin, ymax])  
    g.set_axis_labels(xlabel=r"$z_{\rm spec}$", ylabel=r"$z_{\rm phot}$")
    g.ax_joint.errorbar(x_straight, x_straight, lw=2)

    # Temp solution
    # http://stackoverflow.com/questions/21913671/subplots-adjust-with-seaborn-regplot
    axj, axx, axy = plt.gcf().axes
    axj.set_position([.15, .12, .7, .7])
    axx.set_position([.15, .85, .7, .13])
    axy.set_position([.88, .12, .13, .7])

    for item in ([axj.xaxis.label, axj.yaxis.label]):
            item.set_fontsize(self.fontsize+10)

    for item in (axj.get_xticklabels() + axj.get_yticklabels()):
            item.set_fontsize(self.fontsize)

    self.kde_2d_ax = [axj, axx, axy]
    plt.savefig("PHOTZ_KDE_2D_{0}.pdf".format(self.family_name), format="pdf")

  def make_violin(self):

    """
    Violin plots are made for the outliers over redshift. Each violin is a box plot, i.e.,
    it depicts the probability density of the outliers for a given bin in redshift.
    """

    from matplotlib.mlab import griddata
    import matplotlib.pyplot as plt
    import seaborn as sns

    self.logger.info("Generating violin plot...")
    ind = range(len(self.outliers))
    rows = list(set(np.random.choice(ind,10000)))
    self.logger.info("Using a smaller size for space ({0} objects)".format(self.reduce_size))

    outliers = self.outliers[rows]
    measured = self.measured[rows]
    predicted = self.predicted[rows]

    plt.figure()
    
    bins = np.arange(0,self.measured.max()+0.1,0.1)
    text_bins = ["{0}".format(i) for i in bins]

    digitized = np.digitize(measured, bins)

    outliers2 = (predicted - measured)/(measured+1)

    violins = [outliers2[digitized == i] for i in range(1, len(bins))]
    dbin = (bins[1]-bins[0])/2.
    bins += dbin

    final_violin, final_names = [], []

    for i in range(len(violins)):

      if len(violins[i]) > 1:
        final_violin.append(violins[i])
        final_names.append(bins[i])

    pal = sns.blend_palette([self.color_palette, "lightblue"], 4)

    sns.offset_spines()
    ax = sns.violinplot(final_violin, names=final_names, color=pal)
    sns.despine(trim=True)

    ax.set_ylabel(r"$(z_{\rm phot}-z_{\rm spec})/(1+z_{\rm spec})$", fontsize=self.fontsize)
    ax.set_xlabel(r"$z_{\rm spec}$", fontsize=self.fontsize)
    ax.set_ylim([-0.5,0.5])

    xtix = [i.get_text() for i in ax.get_xticklabels()]
    new_xtix = [xtix[i] if (i % 2 == 0) else "" for i in range(len(xtix))]
    ax.set_xticklabels(new_xtix)

    for item in ([ax.xaxis.label, ax.yaxis.label]):
            item.set_fontsize(self.fontsize)

    for item in (ax.get_xticklabels() + ax.get_yticklabels()):
            item.set_fontsize(self.fontsize-10)

    ax.set_position([.15,.17,.75,.75])

    self.kde_ax = ax
    plt.savefig("PHOTZ_VIOLIN_{0}.pdf".format(self.family_name), format="pdf")

  def run_full(self, show=False):
    """
    This runs the main features of the photo-z package outlined in the publication.
    Similar routines can be created for personal use, depending on the wanted output.
    """

    self.do_PCA()

    if self.filename:
      random = True
    else:
      random = False

    self.split_sample(random=random)
    self.do_GLM()

    self.make_1D_KDE()
    self.make_2D_KDE()
    self.make_violin()

    if not self.cross_validate:
      self.write_to_file()

def main():
  print(__doc__)

if __name__=='__main__':
  main()
