-- schema-journal.sql - a data model for a collection of journal articles

-- Eric Lease Morgan <emorgan@nd.edu>
-- December 12, 2022 - based on previous work


-- author, title, date, etc.
CREATE TABLE bibliographics (

	identifier TEXT,
	author     TEXT,
	title      TEXT,
	date       TEXT,
	abstract   TEXT, 
	url        TEXT
	
);
	
