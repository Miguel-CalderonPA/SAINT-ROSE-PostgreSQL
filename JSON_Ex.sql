drop table if exists books, publishers;
create table books (
	title text primary key,
	pubdate text,
	publisher text,
	publishercity text,
	scope text
);

create table publishers (
	publisherName text,
	founded date,
	founderName text[],
	headquarters text
);

insert into books values
	('the gremlins', 1943, 'random house', 'new york', 'children'),
	('sometime never: a fable for supermen', 1948, 'charles scribner''s sons', 'new york', 'adult'),
	('james and the giant peach', 1961, 'alfred a. knopf', 'new york', 'children'),
	('charlie and the chocolate factory', 1964, 'alfred a. knopf', 'new york', 'children'),
	('the magic finger', 1966, 'harper & row', 'new york', 'children'),
	('fantastic mr fox', 1970, 'alfred a. knopf', 'new york', 'children'),
	('charlie and the great glass elevator', 1972, 'alfred a. knopf', 'new york', 'children'),
	('danny the champion of the world', 1975, 'alfred a. knopf', 'new york', 'children'),
	('the enormous crocodile', 1978, 'alfred a. knopf', 'new york', 'children'),
	('my uncle oswald', 1979, 'michael joseph', 'london', 'adult'),
	('the twits', 1980, 'jonathan cape', 'london', 'children'),
	('george''s marvellous medicine', 1981, 'jonathan cape', 'london', 'children'),
	('the bfg', 1982, 'farrar straus and giroux', 'new york', 'children'),
	('the witches', 1983, 'farrar straus and giroux', 'new york', 'children'),
	('the giraffe and the pelly and me', 1985, 'farrar straus and giroux', 'new york', 'children'),
	('matilda', 1988, 'viking kestrel', 'new york', 'children'),
	('esio trot', 1990, 'jonathan cape', 'london', 'children'),
	('the vicar of nibbleswicke', 1991, 'century', 'london', 'children'),
	('the minpins', 1991, 'jonathan cape', 'london', 'children');
insert into publishers(publisherName, founded, founderName, headquarters) values
	('random house', 'Jan 1, 1927', '{bennett cerf, donald klopfer}'::Text[], 'new york City'),
	('charles scribner''s sons', 'Jan 1, 1846', '{charles scribner i, isaac d. baker}'::Text[], 'new york'),
	('alfred a. knopf', 'Jan 1, 1915', '{alfred a. knopf sr.}'::Text[], 'new york'),
	('jonathan cape', 'Jan 1, 1921', '{herbert jonathan cape, wren howard}'::text[], 'london'),
	('farrar straus and giroux', 'Jan 1, 1946', '{john c. farrar, roger w. straus jr.}'::text[], 'new york'),
	('viking kestrel', 'Jan 1, 1925', '{harold k. guinzburg, george s. oppenheim}'::text[], 'new york'),
	('harper & row', 'March 6, 1817', '{james harper, john harper}'::text[], 'new york');
drop table if exists jsonbooks;
select ('[' || 
(select string_agg(
'{' ||
	'"title" : "' || title || '", ' ||
	'"pubyear" : ' || pubdate || ', ' ||
	'"publisher" : "' || publisher || '", ' ||
	'"publishercity" : "' || publishercity || '", ' ||
	'"scope" : "' || scope || '", ' ||
	'"publisherName" : "' || publisherName || '", ' ||
	'"founded" : "' || founded || '", ' ||
	'"headquarters" : "' || headquarters || '", ' ||
	'"founders" : ' || substring('' ||json_build_array(founderName), 2, char_length('' ||json_build_array(founderName)) - 2) 
|| '}'
, ',') from books left outer join publishers on publisher = publishername) || ']')::jsonb 
into jsonbooks;
drop table if exists books, publishers;
--here is a really big, denormalized json object to play with.
select jsonb from jsonbooks;

SELECT jsonb_array_elements(jsonb) FROM jsonbooks;

SELECT jsonb_array_length(jsonb) FROM jsonbooks;

--Query that gets each book----------------------------------------------------------------------------
SELECT jsonb_array_elements(jsonb) as data FROM jsonbooks;
SELECT data->'title' as title FROM (SELECT jsonb_array_elements(jsonb) as data FROM jsonbooks) as Split;

--Explain how data is denormalized (not in 3NF)--------------------------------------------------------
/*
The data is not denormalized and can be shown because publishers are not related directly 
to the books in a set of data. A book is dependent on a publisher, but a publisher can
be related to many different books.
An example is that a specific book isn't related at all to who founded or when the publisher was founded,
but the publisher is related to when the book was published and who wrote the book
*/

--Query that returns titles of all books written before 1980------------------------------------------
SELECT data->>'title' as title FROM (SELECT jsonb_array_elements(jsonb) as data FROM jsonbooks) as Split
WHERE (data->'pubyear')::integer < 1980;


--Query that returns the titles of all books published by Alfred A. Knopf.----------------------------
SELECT data->>'title' FROM (SELECT jsonb_array_elements(jsonb) as data FROM jsonbooks) as Split
WHERE (data->>'publisher') LIKE 'alfred a. knopf';

--Query that returns titles of books and how long ago they were published-----------------------------
-- for books published by publishers founded before 1900
SELECT data->>'title' as Title, (EXTRACT (YEAR FROM now()) - (data->'pubyear')::integer) as Years_Ago
FROM (SELECT jsonb_array_elements(jsonb) as data FROM jsonbooks) as Split WHERE
EXTRACT (YEAR FROM((data->>'founded')::date)) < 1900;

--Query that returns the number of publishers with only one founder--------------------------------------
SELECT count(distinct data->>'publisherName')
FROM (SELECT jsonb_array_elements(jsonb) as data FROM jsonbooks) as Split
WHERE jsonb_array_length(data->'founders') = 1;



