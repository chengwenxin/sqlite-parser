-- original: tkt3731.test
-- credit:   http://www.sqlite.org/src/tree?ci=trunk&name=test

CREATE TABLE t1(a PRIMARY KEY, b);
    CREATE TRIGGER tr1 AFTER INSERT ON t1 BEGIN
      INSERT INTO t1 VALUES(new.a || '+', new.b || '+');
    END
;INSERT INTO t1 VALUES('a', 'b');
    INSERT INTO t1 VALUES('c', 'd');
    SELECT * FROM t1
;DELETE FROM t1;
    CREATE TABLE t2(a, b);
    INSERT INTO t2 VALUES('e', 'f');
    INSERT INTO t2 VALUES('g', 'h');
    INSERT INTO t1 SELECT * FROM t2;
    SELECT * FROM t1;