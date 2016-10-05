-- original: tkt3298.test
-- credit:   http://www.sqlite.org/src/tree?ci=trunk&name=test

CREATE TABLE t1(a INTEGER PRIMARY KEY, b INT);
    INSERT INTO t1 VALUES(0, 1);
    INSERT INTO t1 VALUES(1, 1);
    INSERT INTO t1 VALUES(2, 1);
    CREATE VIEW v1 AS SELECT a AS x, b+1 AS y FROM t1;
    CREATE TRIGGER r1 INSTEAD OF UPDATE ON v1
      BEGIN
        UPDATE t1 SET b=new.y-1 WHERE a=new.x;
      END;
    CREATE TRIGGER r2 INSTEAD OF DELETE ON v1
      BEGIN
        DELETE FROM t1 WHERE a=old.x;
      END;
    SELECT * FROM v1 ORDER BY x
;UPDATE v1 SET y=3 WHERE x=0;
    SELECT * FROM v1 ORDER by x
;UPDATE v1 SET y=4 WHERE v1.x=2;
    SELECT * FROM v1 ORDER by x
;DELETE FROM v1 WHERE x=1;
    SELECT * FROM v1 ORDER BY x
;DELETE FROM v1 WHERE v1.x=2;
    SELECT * FROM v1 ORDER BY x
;CREATE TABLE t2(p,q);
    INSERT INTO t2 VALUES(1,11);
    INSERT INTO t2 VALUES(2,22);
    CREATE TABLE t3(x,y);
    INSERT INTO t3 VALUES(1,'one');

    SELECT *, (SELECT z FROM (SELECT y AS z FROM t3 WHERE x=t1.a+1) ) FROM t1;