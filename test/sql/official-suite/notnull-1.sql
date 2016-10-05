-- original: notnull.test
-- credit:   http://www.sqlite.org/src/tree?ci=trunk&name=test

CREATE TABLE t1 (
      a NOT NULL,
      b NOT NULL DEFAULT 5,
      c NOT NULL ON CONFLICT REPLACE DEFAULT 6,
      d NOT NULL ON CONFLICT IGNORE DEFAULT 7,
      e NOT NULL ON CONFLICT ABORT DEFAULT 8
    );
    SELECT * FROM t1
;CREATE INDEX t1a ON t1(a);
    CREATE INDEX t1b ON t1(b);
    CREATE INDEX t1c ON t1(c);
    CREATE INDEX t1d ON t1(d);
    CREATE INDEX t1e ON t1(e);
    CREATE INDEX t1abc ON t1(a,b,c)
;DROP TABLE IF EXISTS t1;
    CREATE TABLE t1(a, b NOT NULL);
    CREATE TABLE t2(c, d);
    INSERT INTO t2 VALUES(3, 4);
    INSERT INTO t2 VALUES(5, NULL)
;SELECT * FROM t1
;SELECT * FROM t1;