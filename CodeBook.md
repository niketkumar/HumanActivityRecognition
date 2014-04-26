Code Book
=========

Please refer to http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones for the details related
to data sets.

Please modify top two lines of run_analysis.R to provide root folder containing data sets and output file name to write
tidy set into: rootFolder and tidySetFile.

There are two tasks executed by run_analysis.R:
* Loads, merges and builds a data frame from files mentioned in R script, line 4-10.

* Transforms the above data frame to generate another data frame which contains mean of selected features per subject per activity(nested)

All the 561 features provided in UCI dataset are not loaded. Only features containing the text: mean or std are selected.
The selection uses case insensitive matching.

Apart from the selected features, the data frame contains two additional features: subject and activity.
subject is pulled from subject_<train/test>.txt and activities from y_<train/test>.txt file.

All the feature names are converted to lower case.


