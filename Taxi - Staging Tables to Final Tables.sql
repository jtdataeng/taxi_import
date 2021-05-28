
------------------------------------------------------------------------------------------------------------------------------

-- Inserting Yellow data from staging to final table with correct datatypes --

DELETE FROM YellowGreen_Trip_Data; -- Doesn't need to be repeated for inserting Green data -- only once for both Yellow and Green

INSERT INTO YellowGreen_Trip_Data (VendorID, Yellow_or_Green
								 , pickup_datetime, dropoff_datetime
								 , Passenger_count, Trip_distance
								 , PULocationID, DOLocation
								 , RateCodeID, Store_and_fwd_flag
								 , Payment_type, Fare_amount
								 , Extra, MTA_tax
								 , Improvement_surcharge, Tip_amount
								 , Tolls_amount, total_amount
								 , Trip_type)

							SELECT CAST(VendorID AS int), 'Y'
								 , CAST(tpep_pickup_datetime AS datetime2), CAST(tpep_dropoff_datetime AS datetime2)
								 , CAST(passenger_count as int), CAST(trip_distance as DECIMAL(10,2))
								 , CAST(PULocationID as int), CAST(DOLocationID as int)
								 , CAST(RatecodeID as int), CAST(store_and_fwd_flag as char(1))
								 , CAST(payment_type as char(1)), CAST(fare_amount as DECIMAL(10,2))
								 , CAST(extra as DECIMAL(10,2)), CAST(mta_tax as DECIMAL(10,2))
								 , CAST(improvement_surcharge as DECIMAL(10,2)), CAST(tip_amount as DECIMAL(10,2))
								 , CAST(tolls_amount as DECIMAL(10,2)), CAST(total_amount as DECIMAL(10,2)) 
								 , NULL from Yellow_stage
							WHERE -- This code is to exclude title rows included throughout the staging tables
								VendorID <> 'VendorID' AND tpep_pickup_datetime <> 'tpep_pickup_datetime'
							AND tpep_dropoff_datetime <> 'tpep_dropoff_datetime' AND passenger_count <> 'passenger_count'
							AND trip_distance <> 'trip_distance' AND RatecodeID <> 'RatecodeID'
							AND PULocationID <> 'PULocationID' AND DOLocationID <> 'DOLocationID'
							AND store_and_fwd_flag <> 'store_and_fwd_flag' AND payment_type <> 'payment_type'
							AND fare_amount <> 'fare_amount' AND extra <> 'extra'
							AND mta_tax <> 'mta_tax' AND improvement_surcharge <> 'improvement_surcharge'
							AND tip_amount <> 'tip_amount' AND tolls_amount <> 'tolls_amount'
							AND total_amount <> 'total_amount'

------------------------------------------------------------------------------------------------------------------------------

-- Inserting Green data from staging to final table with correct datatypes --

INSERT INTO YellowGreen_Trip_Data (VendorID, Yellow_or_Green
								  , pickup_datetime, dropoff_datetime
								  , passenger_count, trip_distance 
								  , PULocationID, DOLocation
								  , RateCodeID, Store_and_fwd_flag
								  , payment_type, fare_amount
								  , extra, MTA_tax
								  , Improvement_surcharge, Tip_amount
								  , Tolls_amount, total_amount
								  , Trip_type)

							 SELECT CONVERT(int,VendorID) as VendorID, 'G',
									CONVERT(datetime2,lpep_pickup_datetime) AS pickup_datetime,
									CONVERT(datetime2,lpep_dropoff_datetime) AS dropoff_datetime,
									CONVERT(int,passenger_count) as passenger_count,
									CONVERT(decimal(10,2),trip_distance) AS trip_distance,
									CONVERT(int,PULocationID) AS PULocationID,
									CONVERT(int,DOLocationID) AS DOLocationID,
									CONVERT(INT, RatecodeID) AS RatecodeID,
									CONVERT(CHAR(1),store_and_fwd_flag) AS Store_and_fwd_flag,
									CONVERT(CHAR(1),payment_type) AS payment_type,
									CONVERT(DECIMAL(10,2),fare_amount) AS fare_amount,
									CONVERT(DECIMAL(10,2),extra) AS extra,
									CONVERT(DECIMAL(10,2),MTA_tax) AS MTA_tax,
									CONVERT(DECIMAL(10,2),Improvement_surcharge) AS Improvement_surcharge,
									CONVERT(DECIMAL(10,2),Tip_amount) Tip_amount,
									CONVERT(DECIMAL(10,2),Tolls_amount) AS Tolls_amount,
									CONVERT(DECIMAL(10,2),total_amount) as total_amount,
									CONVERT(char(1),trip_type) as Trip_type FROM green_stage

							WHERE VendorID <> 'VendorID' AND lpep_pickup_datetime <> 'lpep_pickup_datetime' 
							AND lpep_dropoff_datetime <> 'lpep_dropoff_datetime'
							AND passenger_count <> 'passenger_count' AND trip_distance <> 'trip_distance' 
							AND PULocationID <> 'PULocationID' 
							AND DOLocationID <> 'DOLocationID' AND RatecodeID <> 'RateCodeID' 
							AND store_and_fwd_flag <> 'store_and_fwd_flag' 
							AND payment_type <> 'payment_type' AND fare_amount <> 'fare_amount' 
							AND extra <> 'extra' AND mta_tax <> 'mta_tax' 
							AND Improvement_surcharge <> 'Improvement_surcharge' AND Tip_amount <> 'Tip_amount' 
							AND Tolls_amount <> 'Tolls_amount' 
							AND total_amount <> 'total_amount' AND trip_type <> 'trip_type'

------------------------------------------------------------------------------------------------------------------------------

-- Inserting Normal FHV from staging to final table with correct datatypes --

DELETE FROM FHV_Trips_Data; -- Doesn't need to be repeated for inserting High Volume dataset -- only once for both Normal and High Volume

INSERT INTO FHV_Trips_Data(Taxi_type, License_num
								 , Dispatching_base_num, Pickup_datetime
								 , Dropoff_datetime, PULocationID
								 , DOLocationID, SR_Flag)

						SELECT 'N', NULL
							 , CAST(dispatching_base_num AS CHAR(6)), CAST(pickup_datetime AS datetime2)
							 , CAST(dropoff_datetime AS datetime2), CAST(PULocationID as int)
							 , CAST(DOLocationID as int), CAST(SR_Flag AS CHAR(1)) FROM normalfhv_stage
						WHERE
							dispatching_base_num <> 'dispatching_base_num' AND pickup_datetime <> 'pickup_datetime'
						AND dropoff_datetime <> 'dropoff_datetime' AND PULocationID <> 'PULocationID'
						AND DOLocationID <> 'DOLocationID' AND SR_Flag <> 'SR_Flag'

------------------------------------------------------------------------------------------------------------------------------

-- Inserting High Volume FHV from staging to final table with correct datatypes --

INSERT INTO FHV_Trips_Data (Taxi_type, License_num
						  , Dispatching_base_num, Pickup_datetime
						  , Dropoff_datetime, PULocationID
						  , DOLocationID, SR_Flag)

						SELECT 'H', CONVERT(CHAR(1), hvfhs_license_num) AS hvfhs_License_num
							 , CONVERT(CHAR(6), dispatching_base_num) AS dispatching_base_num, CONVERT(DATETIME2, pickup_datetime) AS pickup_datetime
							 , CONVERT(DATETIME2, dropoff_datetime) AS dropoff_datetime, CONVERT(INT, PULocationID) AS PULocationID
							 , CONVERT(INT, DOLocationID) AS DOLocationID, CONVERT(CHAR(1), SR_Flag) AS SR_Flag
						FROM highvolumefhv_stage

						WHERE hvfhs_license_num <> 'hvfhs_license_num' AND dispatching_base_num <> 'dispatching_base_num' 
						AND pickup_datetime <> 'pickup_datetime' AND dropoff_datetime <> 'dropoff_datetime'
						AND PULocationID <> 'PULocationID' AND DOLocationID <> 'DOLocationID' AND SR_Flag <> 'SR_Flag'