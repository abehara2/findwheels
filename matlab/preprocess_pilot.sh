# replace 21 with number of rows in the pilot csv file ( the bottom n rows )
tail -n 21 '/Users/ashankbehara/Desktop/FIND-Wheels/Session1/Codebook_Pilot.csv' | cut -f1,4,5,6,7 -d','
