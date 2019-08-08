# replace 21 with number of rows in the pilot csv file ( the bottom n rows )
tail -n 21 '/Users/ashankbehara/Desktop/FIND-Wheels/Session1/Codebook_Pilot.csv' | cut -f1,4,5,6,7 -d','


cat /Users/ashankbehara/Desktop/FIND-Wheels/Session1/Trial19/Aditya_20_GA_Wrist.csv  | tr '\r' '\n' | head -n 99  | tail -n 1





