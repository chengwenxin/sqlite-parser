-- original: with2.test
-- credit:   http://www.sqlite.org/src/tree?ci=trunk&name=test

CREATE TABLE t1(a);
  INSERT INTO t1 VALUES(1);
  INSERT INTO t1 VALUES(2)
;WITH x1 AS (SELECT * FROM t1)
  SELECT sum(a) FROM x1
;WITH x1 AS (SELECT * FROM t1)
  SELECT (SELECT sum(a) FROM x1)
;WITH x1 AS (SELECT * FROM t1)
  SELECT (SELECT sum(a) FROM x1)
;CREATE TABLE t2(i);
  INSERT INTO t2 VALUES(2);
  INSERT INTO t2 VALUES(3);
  INSERT INTO t2 VALUES(5);

  WITH x1   AS (SELECT i FROM t2),
       i(a) AS (
         SELECT min(i)-1 FROM x1 UNION SELECT a+1 FROM i WHERE a<10
       )
  SELECT a FROM i WHERE a NOT IN x1
;WITH x1 AS (SELECT a FROM t1),
       x2 AS (SELECT i FROM t2),
       x3 AS (SELECT * FROM x1, x2 WHERE x1.a IN x2 AND x2.i IN x1)
  SELECT * FROM x3
;CREATE TABLE t3 AS SELECT 3 AS x;
  CREATE TABLE t4 AS SELECT 4 AS x;

  WITH x1 AS (SELECT * FROM t3),
       x2 AS (
         WITH t3 AS (SELECT * FROM t4)
         SELECT * FROM x1
       )
  SELECT * FROM x2
;WITH x2 AS (
         WITH t3 AS (SELECT * FROM t4)
         SELECT * FROM t3
       )
  SELECT * FROM x2
;WITH x2 AS (
         WITH t3 AS (SELECT * FROM t4)
         SELECT * FROM main.t3
       )
  SELECT * FROM x2
;WITH x1 AS (SELECT * FROM t1)
  SELECT (SELECT sum(a) FROM x1), (SELECT max(a) FROM x1)
;WITH x1 AS (SELECT * FROM t1)
  SELECT (SELECT sum(a) FROM x1), (SELECT max(a) FROM x1), a FROM x1
;WITH 
  i(x) AS ( 
    WITH 
    j(x) AS ( SELECT * FROM i ), 
    i(x) AS ( SELECT * FROM t1 )
    SELECT * FROM j
  )
  SELECT * FROM i
;WITH r(i) AS (
    VALUES('.')
    UNION ALL
    SELECT i || '.' FROM r, (
      SELECT x FROM x INTERSECT SELECT y FROM y
    ) WHERE length(i) < 10
  ),
  x(x) AS ( VALUES(1) UNION ALL VALUES(2) UNION ALL VALUES(3) ),
  y(y) AS ( VALUES(2) UNION ALL VALUES(4) UNION ALL VALUES(6) )

  SELECT * FROM r
;WITH r(i) AS (
    VALUES('.')
    UNION ALL
    SELECT i || '.' FROM r, ( SELECT x FROM x WHERE x=2 ) WHERE length(i) < 10
  ),
  x(x) AS ( VALUES(1) UNION ALL VALUES(2) UNION ALL VALUES(3) )

  SELECT * FROM r ORDER BY length(i) DESC
;WITH 
  t4(x) AS ( 
    VALUES(4)
    UNION ALL 
    SELECT x+1 FROM t4 WHERE x<10
  )
  SELECT * FROM t4
;WITH 
  t4(x) AS ( 
    VALUES(4)
    UNION ALL 
    SELECT x+1 FROM main.t4 WHERE x<10
  )
  SELECT * FROM t4
;WITH i(x) AS (
    VALUES(sub_min) UNION ALL SELECT x+1 FROM i WHERE x < sub_max
  )
  SELECT * FROM i
;WITH i(x) AS (
    VALUES(sub_min) UNION ALL SELECT x+1 FROM i WHERE x < sub_max
  )
  SELECT x FROM i JOIN i AS j USING (x)
;DROP TABLE IF EXISTS t1;
  DROP TABLE IF EXISTS t2;
  CREATE TABLE t1(a, b);
  CREATE TABLE t2(a, b)
;DROP TABLE IF EXISTS t1;
  DROP TABLE IF EXISTS t2;
  CREATE TABLE t1(a, b);
  CREATE TABLE t2(a, b)
;CREATE TABLE t5(x INTEGER);
  CREATE TABLE t6(y INTEGER);

  WITH s(x) AS ( VALUES(7) UNION ALL SELECT x+7 FROM s WHERE x<49 )
  INSERT INTO t5 
  SELECT * FROM s;

  INSERT INTO t6 
  WITH s(x) AS ( VALUES(2) UNION ALL SELECT x+2 FROM s WHERE x<49 )
  SELECT * FROM s
;SELECT * FROM t6 WHERE y IN (SELECT x FROM t5)
;WITH ss AS (SELECT x FROM t5)
  SELECT * FROM t6 WHERE y IN (SELECT x FROM ss)
;WITH ss(x) AS ( VALUES(7) UNION ALL SELECT x+7 FROM ss WHERE x<49 )
  SELECT * FROM t6 WHERE y IN (SELECT x FROM ss)
;SELECT * FROM t6 WHERE y IN (
    WITH ss(x) AS ( VALUES(7) UNION ALL SELECT x+7 FROM ss WHERE x<49 )
    SELECT x FROM ss
  )
;CREATE TABLE t7(y);
  INSERT INTO t7 VALUES(NULL);
  CREATE VIEW v AS SELECT * FROM t7 ORDER BY y
;WITH q(a) AS (
    SELECT 1
    UNION 
    SELECT a+1 FROM q, v WHERE a<5
  )
  SELECT * FROM q
;WITH q(a) AS (
    SELECT 1
    UNION ALL
    SELECT a+1 FROM q, v WHERE a<5
  )
  SELECT * FROM q;