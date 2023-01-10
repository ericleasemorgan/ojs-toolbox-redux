.mode csv
.import ./etc/ojs-titles.csv staging
INSERT INTO titles (title, home, codes, keywords, classification, subjects) SELECT * FROM staging;
DROP TABLE staging;
