-- original: trigger2.test
-- credit:   http://www.sqlite.org/src/tree?ci=trunk&name=test

INSERT INTO tbl VALUES(1, 2);
      INSERT INTO tbl VALUES(3, 4);
  
      CREATE TABLE rlog (idx, old_a, old_b, db_sum_a, db_sum_b, new_a, new_b);
      CREATE TABLE clog (idx, old_a, old_b, db_sum_a, db_sum_b, new_a, new_b);
  
      CREATE TRIGGER before_update_row BEFORE UPDATE ON tbl FOR EACH ROW 
        BEGIN
        INSERT INTO rlog VALUES ( (SELECT coalesce(max(idx),0) + 1 FROM rlog), 
  	  old.a, old.b, 
  	  (SELECT coalesce(sum(a),0) FROM tbl),
          (SELECT coalesce(sum(b),0) FROM tbl), 
  	  new.a, new.b);
      END;
  
      CREATE TRIGGER after_update_row AFTER UPDATE ON tbl FOR EACH ROW 
        BEGIN
        INSERT INTO rlog VALUES ( (SELECT coalesce(max(idx),0) + 1 FROM rlog), 
  	  old.a, old.b, 
  	  (SELECT coalesce(sum(a),0) FROM tbl),
          (SELECT coalesce(sum(b),0) FROM tbl), 
  	  new.a, new.b);
      END;
  
      CREATE TRIGGER conditional_update_row AFTER UPDATE ON tbl FOR EACH ROW
        WHEN old.a = 1
        BEGIN
        INSERT INTO clog VALUES ( (SELECT coalesce(max(idx),0) + 1 FROM clog), 
  	  old.a, old.b, 
  	  (SELECT coalesce(sum(a),0) FROM tbl),
          (SELECT coalesce(sum(b),0) FROM tbl), 
  	  new.a, new.b);
      END
;UPDATE tbl SET a = a * 10, b = b * 10;
        SELECT * FROM rlog ORDER BY idx;
        SELECT * FROM clog ORDER BY idx
;DELETE FROM rlog;
      DELETE FROM tbl;
      INSERT INTO tbl VALUES (100, 100);
      INSERT INTO tbl VALUES (300, 200);
      CREATE TRIGGER delete_before_row BEFORE DELETE ON tbl FOR EACH ROW
        BEGIN
        INSERT INTO rlog VALUES ( (SELECT coalesce(max(idx),0) + 1 FROM rlog), 
  	  old.a, old.b, 
  	  (SELECT coalesce(sum(a),0) FROM tbl),
          (SELECT coalesce(sum(b),0) FROM tbl), 
  	  0, 0);
      END;
  
      CREATE TRIGGER delete_after_row AFTER DELETE ON tbl FOR EACH ROW
        BEGIN
        INSERT INTO rlog VALUES ( (SELECT coalesce(max(idx),0) + 1 FROM rlog), 
  	  old.a, old.b, 
  	  (SELECT coalesce(sum(a),0) FROM tbl),
          (SELECT coalesce(sum(b),0) FROM tbl), 
  	  0, 0);
      END
;DELETE FROM tbl;
        SELECT * FROM rlog
;DELETE FROM rlog;
      CREATE TRIGGER insert_before_row BEFORE INSERT ON tbl FOR EACH ROW
        BEGIN
        INSERT INTO rlog VALUES ( (SELECT coalesce(max(idx),0) + 1 FROM rlog), 
  	  0, 0,
  	  (SELECT coalesce(sum(a),0) FROM tbl),
          (SELECT coalesce(sum(b),0) FROM tbl), 
  	  new.a, new.b);
      END;
  
      CREATE TRIGGER insert_after_row AFTER INSERT ON tbl FOR EACH ROW
        BEGIN
        INSERT INTO rlog VALUES ( (SELECT coalesce(max(idx),0) + 1 FROM rlog), 
  	  0, 0,
  	  (SELECT coalesce(sum(a),0) FROM tbl),
          (SELECT coalesce(sum(b),0) FROM tbl), 
  	  new.a, new.b);
      END
;CREATE TABLE other_tbl(a, b);
        INSERT INTO other_tbl VALUES(1, 2);
        INSERT INTO other_tbl VALUES(3, 4);
        -- INSERT INTO tbl SELECT * FROM other_tbl;
        INSERT INTO tbl VALUES(5, 6);
        DROP TABLE other_tbl;
  
        SELECT * FROM rlog
;CREATE TABLE tbl(a PRIMARY KEY, b, c);
      CREATE TABLE log(a, b, c)
;DELETE FROM tbl; DELETE FROM log
;DROP TRIGGER the_trigger
;DELETE FROM tbl; DELETE FROM log
;DELETE FROM tbl; DELETE FROM log
;DROP TRIGGER the_trigger
;CREATE TABLE tbl (a, b, c, d);
  CREATE TABLE log (a);
  INSERT INTO log VALUES (0);
  INSERT INTO tbl VALUES (0, 0, 0, 0);
  INSERT INTO tbl VALUES (1, 0, 0, 0);
  CREATE TRIGGER tbl_after_update_cd BEFORE UPDATE OF c, d ON tbl
    BEGIN
      UPDATE log SET a = a + 1;
    END
;UPDATE tbl SET b = 1, c = 10; -- 2
    UPDATE tbl SET b = 10; -- 0
    UPDATE tbl SET d = 4 WHERE a = 0; --1
    UPDATE tbl SET a = 4, b = 10; --0
    SELECT * FROM log
;DROP TABLE tbl;
  DROP TABLE log
;CREATE TABLE tbl (a, b, c, d);
  CREATE TABLE log (a);
  INSERT INTO log VALUES (0)
;INSERT INTO tbl VALUES(0, 0, 0, 0);     -- 1 (ifcapable subquery)
    SELECT * FROM log;
    UPDATE log SET a = 0;

    INSERT INTO tbl VALUES(0, 0, 0, 0);     -- 0
    SELECT * FROM log;
    UPDATE log SET a = 0;

    INSERT INTO tbl VALUES(200, 0, 0, 0);     -- 1
    SELECT * FROM log;
    UPDATE log SET a = 0
;DROP TABLE tbl;
  DROP TABLE log
;CREATE TABLE tblA(a, b);
  CREATE TABLE tblB(a, b);
  CREATE TABLE tblC(a, b);

  CREATE TRIGGER tr1 BEFORE INSERT ON tblA BEGIN
    INSERT INTO tblB values(new.a, new.b);
  END;

  CREATE TRIGGER tr2 BEFORE INSERT ON tblB BEGIN
    INSERT INTO tblC values(new.a, new.b);
  END
;INSERT INTO tblA values(1, 2);
    SELECT * FROM tblA;
    SELECT * FROM tblB;
    SELECT * FROM tblC
;DROP TABLE tblA;
  DROP TABLE tblB;
  DROP TABLE tblC
;CREATE TABLE tbl(a, b, c);
  CREATE TRIGGER tbl_trig BEFORE INSERT ON tbl 
    BEGIN
      INSERT INTO tbl VALUES (new.a, new.b, new.c);
    END
;INSERT INTO tbl VALUES (1, 2, 3);
    select * from tbl
;DROP TABLE tbl
;CREATE TABLE tbl(a, b, c);
  CREATE TRIGGER tbl_trig BEFORE INSERT ON tbl 
    BEGIN
      INSERT INTO tbl VALUES (1, 2, 3);
      INSERT INTO tbl VALUES (2, 2, 3);
      UPDATE tbl set b = 10 WHERE a = 1;
      DELETE FROM tbl WHERE a = 1;
      DELETE FROM tbl;
    END
;INSERT INTO tbl VALUES(100, 200, 300)
;DROP TABLE tbl
;CREATE TABLE tbl (a primary key, b, c);
    CREATE TRIGGER ai_tbl AFTER INSERT ON tbl BEGIN
      INSERT OR IGNORE INTO tbl values (new.a, 0, 0);
    END
;BEGIN;
      INSERT INTO tbl values (1, 2, 3);
      SELECT * from tbl
;SELECT * from tbl
;SELECT * from tbl
;INSERT OR REPLACE INTO tbl values (2, 2, 3);
      SELECT * from tbl
;SELECT * from tbl
;DELETE FROM tbl
;INSERT INTO tbl values (4, 2, 3);
    INSERT INTO tbl values (6, 3, 4);
    CREATE TRIGGER au_tbl AFTER UPDATE ON tbl BEGIN
      UPDATE OR IGNORE tbl SET a = new.a, c = 10;
    END
;BEGIN;
      UPDATE tbl SET a = 1 WHERE a = 4;
      SELECT * from tbl
;SELECT * from tbl
;SELECT * from tbl
;UPDATE OR REPLACE tbl SET a = 1 WHERE a = 4;
      SELECT * from tbl
;INSERT INTO tbl VALUES (2, 3, 4);
      SELECT * FROM tbl
;SELECT * from tbl
;DROP TABLE tbl
;CREATE TABLE ab(a, b);
  CREATE TABLE cd(c, d);
  INSERT INTO ab VALUES (1, 2);
  INSERT INTO ab VALUES (0, 0);
  INSERT INTO cd VALUES (3, 4);

  CREATE TABLE tlog(ii INTEGER PRIMARY KEY, 
      olda, oldb, oldc, oldd, newa, newb, newc, newd);

  CREATE VIEW abcd AS SELECT a, b, c, d FROM ab, cd;

  CREATE TRIGGER before_update INSTEAD OF UPDATE ON abcd BEGIN
    INSERT INTO tlog VALUES(NULL, 
	old.a, old.b, old.c, old.d, new.a, new.b, new.c, new.d);
  END;
  CREATE TRIGGER after_update INSTEAD OF UPDATE ON abcd BEGIN
    INSERT INTO tlog VALUES(NULL, 
	old.a, old.b, old.c, old.d, new.a, new.b, new.c, new.d);
  END;

  CREATE TRIGGER before_delete INSTEAD OF DELETE ON abcd BEGIN
    INSERT INTO tlog VALUES(NULL, 
	old.a, old.b, old.c, old.d, 0, 0, 0, 0);
  END;
  CREATE TRIGGER after_delete INSTEAD OF DELETE ON abcd BEGIN
    INSERT INTO tlog VALUES(NULL, 
	old.a, old.b, old.c, old.d, 0, 0, 0, 0);
  END;

  CREATE TRIGGER before_insert INSTEAD OF INSERT ON abcd BEGIN
    INSERT INTO tlog VALUES(NULL, 
	0, 0, 0, 0, new.a, new.b, new.c, new.d);
  END;
   CREATE TRIGGER after_insert INSTEAD OF INSERT ON abcd BEGIN
    INSERT INTO tlog VALUES(NULL, 
	0, 0, 0, 0, new.a, new.b, new.c, new.d);
   END
;UPDATE abcd SET a = 100, b = 5*5 WHERE a = 1;
    DELETE FROM abcd WHERE a = 1;
    INSERT INTO abcd VALUES(10, 20, 30, 40);
    SELECT * FROM tlog
;DELETE FROM tlog;
    INSERT INTO abcd VALUES(10, 20, 30, 40);
    UPDATE abcd SET a = 100, b = 5*5 WHERE a = 1;
    DELETE FROM abcd WHERE a = 1;
    SELECT * FROM tlog
;DELETE FROM tlog;
    DELETE FROM abcd WHERE a = 1;
    INSERT INTO abcd VALUES(10, 20, 30, 40);
    UPDATE abcd SET a = 100, b = 5*5 WHERE a = 1;
    SELECT * FROM tlog
;CREATE TABLE t1(a,b,c);
    INSERT INTO t1 VALUES(1,2,3);
    CREATE VIEW v1 AS
      SELECT a+b AS x, b+c AS y, a+c AS z FROM t1;
    SELECT * FROM v1
;CREATE TABLE v1log(a,b,c,d,e,f);
    CREATE TRIGGER r1 INSTEAD OF DELETE ON v1 BEGIN
      INSERT INTO v1log VALUES(OLD.x,NULL,OLD.y,NULL,OLD.z,NULL);
    END;
    DELETE FROM v1 WHERE x=1;
    SELECT * FROM v1log
;DELETE FROM v1 WHERE x=3;
    SELECT * FROM v1log
;INSERT INTO t1 VALUES(4,5,6);
    DELETE FROM v1log;
    DELETE FROM v1 WHERE y=11;
    SELECT * FROM v1log
;CREATE TRIGGER r2 INSTEAD OF INSERT ON v1 BEGIN
      INSERT INTO v1log VALUES(NULL,new.x,NULL,new.y,NULL,new.z);
    END;
    DELETE FROM v1log;
    INSERT INTO v1 VALUES(1,2,3);
    SELECT * FROM v1log
;CREATE TRIGGER r3 INSTEAD OF UPDATE ON v1 BEGIN
      INSERT INTO v1log VALUES(OLD.x,new.x,OLD.y,new.y,OLD.z,new.z);
    END;
    DELETE FROM v1log;
    UPDATE v1 SET x=x+100, y=y+200, z=z+300;
    SELECT * FROM v1log
;CREATE TABLE t3(a TEXT, b TEXT);
    CREATE VIEW v3 AS SELECT t3.a FROM t3;
    CREATE TRIGGER trig1 INSTEAD OF DELETE ON v3 BEGIN
      SELECT 1;
    END;
    DELETE FROM v3 WHERE a = 1;