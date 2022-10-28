#!/usr/bin/env bash

# configure
CORPORA='corpora'
JOURNALS='./etc/journals.tsv'

# initialize
IFS=$'\t'

# process each journal
cat $JOURNALS | while read TITLE KEY URL EXTENSION; do
	
	# initialize
	echo >&2
	echo "Initializing $KEY" >&2
	mkdir -p ./$CORPORA
	DATABASE="./etc/$KEY.db"
	./bin/clean.sh $KEY
	./bin/db-create.sh $KEY
	mkdir -p ./$CORPORA/$KEY/bibliographics
	mkdir -p ./$CORPORA/$KEY/cache

	# get identifiers and insert them in to the database
	echo "Getting identifiers" >&2
	./bin/harvest-identifiers.pl $URL > ./$CORPORA/$KEY/identifiers.txt
	echo 'BEGIN TRANSACTION;'    > ./$CORPORA/$KEY/identifiers.sql
	cat ./$CORPORA/$KEY/identifiers.txt | parallel ./bin/identifier2sql.sh >> ./$CORPORA/$KEY/identifiers.sql
	echo 'END TRANSACTION;' >> ./$CORPORA/$KEY/identifiers.sql
	cat ./$CORPORA/$KEY/identifiers.sql | sqlite3 $DATABASE

	# get the bibliographics
	echo "Getting bibliographics" >&2
	cat ./$CORPORA/$KEY/identifiers.txt | parallel ./bin/harvest-bibliogrpahics.sh $URL {} $KEY

	# clean, normalize, enhance bibliographics here
	echo "Building bibliographics" >&2
	printf "identifier\tauthor\ttitle\tdate\tsource\tpublisher\tlanguage\tdoi\turl\tabstract\n" > ./$CORPORA/$KEY/bibliographics.tsv
	cat ./$CORPORA/$KEY/bibliographics/*.tsv >> ./$CORPORA/$KEY/bibliographics.tsv

	# insert bibliographics into the database
	echo "Saving bibliographics" >&2
	echo 'BEGIN TRANSACTION;' > ./$CORPORA/$KEY/bibliogrpahics.sql
	find ./$CORPORA/$KEY/bibliographics -name *.tsv | parallel ./bin/bibliographic2sql.sh >> ./$CORPORA/$KEY/bibliogrpahics.sql
	echo 'END TRANSACTION;' >> ./$CORPORA/$KEY/bibliogrpahics.sql
	cat ./$CORPORA/$KEY/bibliogrpahics.sql | sqlite3 $DATABASE

	# parse authors and insert them into the database
	echo "Munging authors" >&2
	echo 'DELETE FROM authors;'  > ./$CORPORA/$KEY/authors.sql
	echo 'BEGIN TRANSACTION;'   >> ./$CORPORA/$KEY/authors.sql
	printf ".mode tabs\nSELECT bid, author FROM bibliographics;" | sqlite3 $DATABASE | parallel --colsep '\t' ./bin/author2authors.sh $1 $2 >> ./$CORPORA/$KEY/authors.sql
	echo 'END TRANSACTION;' >> ./$CORPORA/$KEY/authors.sql
	cat ./$CORPORA/$KEY/authors.sql | sqlite3 $DATABASE

	# harvest pdf
	echo "Harvesting content" >&2
	printf ".mode tabs\nSELECT identifier, url FROM bibliographics;" | sqlite3 $DATABASE | parallel --colsep '\t' ./bin/harvest-pdf.sh $KEY $EXTENSION '$1' '$2' 

done
exit
