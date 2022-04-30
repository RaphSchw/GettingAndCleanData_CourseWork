# data_direcotry

## Contents of the df_clean dataframe

The df_clean dataframe is the final form of the transformed data and is a long form of the original data. In this data frame both training and test data observations are contained.

Number of observations :

    ## [1] 11880

| variables           | description                                                                                                   |
|:--------------------|:--------------------------------------------------------------------------------------------------------------|
| set                 | test , train                                                                                                  |
| participant         | 2, 4, 9, 10, 12, 13, 18, 20, 24, 1, 3, 5, 6, 7, 8, 11, 14, 15, 16, 17, 19, 21, 22, 23, 25, 26, 27, 28, 29, 30 |
| activity            | LAYING , SITTING , STANDING , WALKING , WALKING_DOWNSTAIRS, WALKING_UPSTAIRS                                  |
| mean_value          | The mean of the original raw data observations                                                                |
| measurement         | mean, std                                                                                                     |
| dimension           | X , Y , Z , NA                                                                                                |
| acceleration_signal | Body , Gravity                                                                                                |
| sensor_signal       | Acc , Gyro                                                                                                    |
| jerk_signal         | NA , yes                                                                                                      |
| magnitude           | NA , yes                                                                                                      |
| time_signal         | yes, NA                                                                                                       |
| frequency_signal    | NA , yes                                                                                                      |