drop table if exists letters, sentences, T, R;
create table letters (
	letter text
);

create table sentences (
	sentence text
);

insert into letters values ('a'), ('b'), ('c'), ('d'), ('e'), 
	('f'), ('g'), ('h'), ('i'), ('j'), ('k'), ('l'), ('m'), 
	('n'), ('o'), ('p'), ('q'), ('r'), ('s'), ('t'), ('u'), 
	('v'), ('w'), ('x'), ('y'), ('z');
insert into sentences values 
	('it is cold when it snows'),
	('lava is hot'),
	('I play my music in the sun'),
	('on your left and on your right crosses are green crosses are blue'),
	('the molten rock spills out over the land'),
	('I am pappy'),  
	('all the worlds a stage and we are merely players'),
	('zymology is the study of fermentation'),
	('he''s sullen');

SELECT * FROM letters;
SELECT * FROM sentences;

SELECT sentence, letter FROM sentences, letters WHERE sentence NOT LIKE '%' || letter || '%';

--------------------------------------------------------------------------------

INSERT INTO sentences VALUES 
	('the quick brown fox jumps over the lazy dog');

SELECT a.sentence
FROM sentences as A LEFT OUTER JOIN (sentences as B CROSS JOIN letters) 
ON B.sentence NOT LIKE '%' || letter || '%'
AND A.sentence = B.sentence WHERE B is null;

DELETE FROM sentences WHERE sentence LIKE 'the quick brown%';

---------------------------------------------------------------------------------

--1. Code with a Syntax Error
/*
ERROR:  syntax error at or near "TEXT"
LINE 50:  country TEXT);
                  ^
********** Error **********

ERROR: syntax error at or near "TEXT"
SQL state: 42601
Character: 1477

COMMENT: forgot to place a comma in my create table
*/

--2. Two Tables with 2 attributes, one that is shared, one different, all joins
	CREATE table T (
	ID INTEGER,
	country TEXT);

	CREATE TABLE R (
	ID INTEGER,
	captials TEXT);

	INSERT INTO T VALUES
	(100, 'USA'),
	(101, 'Spain'),
	(102, 'Peru'),
	(103, 'Japan'),
	(104, 'DRC');

	INSERT INTO R VALUES
	(100, 'Washington D.C'),
	(105, 'Madrid'),
	(106, 'Lima'),
	(107, 'Tokyo'),
	(108, 'Kinshasa');

SELECT * FROM T LEFT OUTER JOIN R ON T.ID=R.ID;
SELECT * FROM T RIGHT OUTER JOIN R ON T.ID=R.ID;
SELECT * FROM T FULL OUTER JOIN R ON T.ID=R.ID;

--3. Query that shows the sentences that contain each letter using A,B
SELECT sentences.sentence, letters.letter 
FROM sentences, letters 
WHERE sentence LIKE '%' || letter || '%'; 

--4. Left outer join that finds the alphabetically first sentence
SELECT a.sentence FROM sentences as A LEFT OUTER JOIN sentences as B 
ON A.sentence > B.sentence WHERE B is null;  

--5. Query that shows letters that are not in a sentence
SELECT * FROM letters as A LEFT OUTER JOIN (letters as B CROSS JOIN sentences) 
ON sentence LIKE '%' || b.letter || '%' AND a.letter = b.letter WHERE b is null;

--6. Query that displays true if every letter is in atleast 1 sentence false otherwise
SELECT count(A)=0 FROM letters as A LEFT OUTER JOIN (sentences CROSS JOIN letters as B) 
ON  A.letter = B.letter AND sentence LIKE '%'|| b.letter ||'%' WHERE sentence is NULL;

--7. Query that gives all sentences that don't have anything in common
SELECT * FROM   (sentences as A CROSS JOIN sentences as B) LEFT OUTER JOIN letters
ON  A.sentence LIKE '%' || letter || '%' AND B.sentence LIKE '%' || letter || '%' 
WHERE letter is null AND A.sentence < B.sentence;