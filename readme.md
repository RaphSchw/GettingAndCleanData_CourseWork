## Folder structure after script execution

    ```
    project
    │   readme.md
    │   Rhistory
    |   .RData
    |   run_analysis.R
    │
    └───data
    │   │   sources.zip
    │   │
    │   └───UCI HAR Dataset
    │       │   actvity_labels.txt
    │       │   features_info.txt
    │       │   README.txt
    │       │   
    │       └───test
    │       │     │   subject_test.txt
    │       │     │   X_test.txt
    │       │     │   y_test.txt
    │       │     │
    │       │     └───Intertial Signals
    │       │            body_acc_x_test.txt
    │       │            body_acc_y_test.txt
    │       │            body_acc_z_test.txt
    │       │            body_gyro_x_test.txt
    │       │            body_gyro_y_test.txt
    │       │            body_gyro_z_test.txt
    │       │            total_acc_x_test.txt
    │       │            total_acc_y_test.txt
    │       │            total_acc_z_test.txt
    │       └───train
    │            │   subject_train.txt
    │            │   X_train.txt
    │            │   y_train.txt
    │            │
    │            └───Intertial Signals
    │                   body_acc_x_train.txt
    │                   body_acc_y_train.txt
    │                   body_acc_z_train.txt
    │                   body_gyro_x_train.txt
    │                   body_gyro_y_train.txt
    │                   body_gyro_z_train.txt
    │                   total_acc_x_train.txt
    │                   total_acc_y_train.txt
    │                   total_acc_z_train.txt
    ```

## Steps in extracting and transforming the data

The "run_analysis.R" script will perform the following actions :

-   Download the data and put it in a data folder

-   Unzip the raw data

-   Reading the raw data into a dataframe for the test data set and one for the train data set

    -   This gives us 2 dataframes with raw data and without descriptive column names

        -   df_test

        -   df_train

-   Add a new column "set" to both dataframes (df_test, df_train) which takes the value :

    -   "test" in the df_test for each row

    -   "train" in the df_train for each row

    -   This column will facilitate work later on when the two data sets are merged

-   Name the columns of the raw data using the provided feature names

    -   This gives us descriptive column names for df_test and df_train

-   Adding a participant variable based on the provided data for the test and train data sets

    -   This adds another column "participant" to both df_test and df_train
    -   To do so the data contained in the "subject_test.txt" files (in the test and train sub folders respectively) is used

-   Associate the activity data in numeric form to the

    -   This adds another column "activity" to both df_test and df_train, which contains the data of the following files :

        -   "./data/UCI HAR Dataset/train/y_train.txt" – for df_train

        -   "./data/UCI HAR Dataset/test/y_test.txt" – for df_test

-   Merge the data contained in df_train with the data in df_test and save the result in a new dataframe called df_merged

-   Within df_merged the previous observations are filtered to only keep the mean and standard deviation measurements, the activity, participant, and set. Once the data is selected the dataframe is molten down (using the melt() function of the reshape2 library) to obtain a long rather than wide dataframe

-   In the long dataframe the activity IDs are now replaced by descriptive activity names as per the mapping in the "activity_labels.txt" file

-   The dataframe is then summarised to obtain the mean values for the variable column (observations in the original data) by set, participant, activity, and variable (name of the column in the df_test or df_train dataframe) and assigned to the df_clean dataframe

-   Lastly the values in the "variable" column are split to split the multiple characteristics obtained in these values over the variables described in [Data structure df_clean](#data-structure-df_clean)

## Data structure df_clean

| Variable            | Description                                                                                                         |
|---------------------|---------------------------------------------------------------------------------------------------------------------|
| set                 | The original dataset it came from: "test", "train"                                                                  |
| participant         | The participant number obtained from the raw data                                                                   |
| activity            | The descriptive activity name: "LAYING", "SITTING", "STANDING", "WALKING", "WALKING_DOWNSTAIRS", "WALKING_UPSTAIRS" |
| mean_value          | The mean value obtained for the measurement                                                                         |
| measurement         | The type of measurement: "mean", "std"                                                                              |
| dimension           | The dimension/axis of the original signal: "X", "Y", "Z"                                                            |
| acceleration_signal | An indication whether the acceleration signal was a body or gravity acceleration signals: "Body", "Gravity"         |
| sensor_signal       | An indication whether the signals come from the accelerometer or gyroscope: "Acc", "Gyro"                           |
| jerk_signal         | An indication whether the mean_value has been transformed into a jerk signal: "yes", NA                             |
| magnitude           | An indication whether the magnitude has been derived for this mean_value: "yes", NA                                 |
| time_signal         | Indication whether the mean_value concerns a time domain signal: "yes", NA                                          |
| frequency_signal    | Indication whether the mean_value concerns a time frequency signal: "yes", NA                                       |

## **Data dictionary**

See [./data_dictionary.md](./data_dictionary.md)
