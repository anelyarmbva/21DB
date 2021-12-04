---- LABARATORY WORK 8 Rymbayeva Anelya
-- 1 Task: Create a function that :
--1a: Increments given values by 1 and returns it
CREATE FUNCTION Serzhan(val integer) RETURNS integer AS $$
BEGIN
RETURN val + 1;
END; $$
LANGUAGE PLPGSQL;
-- 1b: Returns sum of 2 numbers
CREATE OR REPLACE FUNCTION Deyna(a numeric, b numeric)
RETURNS numeric AS $$
BEGIN
RETURN a + b;
END; $$
LANGUAGE PLPGSQL;
--1c: Returns true or false if numbers are divisible by 2
CREATE OR REPLACE FUNCTION Alibek(num integer)
RETURNS  integer AS $$
BEGIN
    IF num % 2 == 2 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END; $$
LANGUAGE PLPGSQL;
--1d: Checks some password for validity
CREAte OR REPLACE FUNCTION Anelya(pas text)
RETURNS BOOLEAN AS $$
BEGIN
    IF length(pas) >= 5 AND length(pas) <= 16 THEN
        RETURN TRUE;
    else
        return FALSE;
    END IF;
END; $$
LANGUAGE PLPGSQL;
--1e: Returns two outputs, but one input
CREATE OR REPLACE FUNCTION Ramazan(a integer, out a_square integer, out a_plus integer)
AS $$
BEGIN
    a_square = a * a;
    a_plus = a + a;
END; $$
LANGUAGE PLPGSQL;
SELECT * FROM Ramazan(2);





--2 Task: Create a trigger that:
--2a: Return timestamp of the occured action within the database:
CREATE TABLE person(
    id INT PRIMARY KEY,
    name VARCHAR,
    last_name VARCHAR,
    date_of_birth DATE,
    age INT,
    insertion_time timestamp
);
CREATE TABLE item(
    item_id INT PRIMARY KEY,
    item_name VARCHAR,
    price_initial NUMERIC,
    price_final NUMERIC
);
--2a: Return timestamp of the occurred action within the database:
CREATE FUNCTION trig_func()
RETURNS TRIGGER AS $$
    BEGIN
        new.insertion_time = now();
        RETURN new;
    END;$$
LANGUAGE PLPGSQL;

CREATE TRIGGER time_of_action BEFORE INSERT OR UPDATE
    ON person
    FOR EACH ROW
    EXECUTE PROCEDURE trig_func();

--2b: Computes the age of a person when persons’ date of birth is inserted:
CREATE FUNCTION calc_age_function()
RETURNS TRIGGER AS $$
    DECLARE year_c INT;
    BEGIN
        SELECT date_part('year', age(new.date_of_birth)) INTO year_c;
        new.age = year_c;
        RETURN new;
    END;$$
LANGUAGE PLPGSQL;

CREATE TRIGGER calc_age_trigger
    BEFORE INSERT
    ON person
    FOR EACH ROW
    EXECUTE PROCEDURE calc_age_function();

DROP TRIGGER calc_age_trigger ON person;
DROP FUNCTION calc_age_function;
DROP FUNCTION trig_func;
DROP TRIGGER time_of_action ON person;

INSERT INTO person VALUES(1,'Anelya','Rymbayeva','2002-07-01');

DELETE FROM person WHERE id = 1;

--2c: Adds 12% tax on the price of the inserted item:

CREATE FUNCTION adding_tax()
RETURNS TRIGGER AS $$
    BEGIN
        new.price_final = new.price_initial*1.12;
        return new;
    END;$$
LANGUAGE PLPGSQL;

CREATE TRIGGER adding_tax_trigger
    BEFORE UPDATE OR INSERT
    ON item
    FOR EACH ROW
    EXECUTE PROCEDURE adding_tax();

INSERT INTO item VALUES(3,'something3',1000);
INSERT INTO item VALUES(4,'smth',1000);

--2d: Prevents deletion of any row from only one table:

CREATE FUNCTION prev_del()
RETURNS TRIGGER AS $$
    BEGIN
        INSERT INTO item VALUES(old.item_id,old.item_name,old.price_initial);
        RETURN old;
    END;$$
LANGUAGE PLPGSQL;

CREATE TRIGGER prevent_deletion AFTER DELETE
    ON item
    FOR EACH ROW
    EXECUTE PROCEDURE prev_del();

DROP TRIGGER prevent_deletion ON item;
DROP FUNCTION prev_del;

DELETE FROM item WHERE item_id = 3;

CREATE TABLE accounts(
    acc_id INT PRIMARY KEY,
    acc_name VARCHAR,
    password VARCHAR
);

--2e: Launches functions  1.d and 1.e:

CREATE FUNCTION launch()
RETURNS TRIGGER AS $$
    DECLARE pass_val pair;
    BEGIN
        pass_val = validity(new.password);
        IF pass_val.stat = 'valid' THEN RETURN new;
        ELSE RAISE 'INVALID PASSWORD';
        END IF;
    END;$$
LANGUAGE PLPGSQL;

CREATE TRIGGER launch_trig BEFORE INSERT
    ON accounts
    FOR EACH ROW
    EXECUTE PROCEDURE launch();

INSERT INTO accounts VALUES(2,'Deyna','ggwpez123!!!');

-- 3 Task: What is the difference between procedure and function?
-- Function is used to calculate something from a given input. Hence it got its name from Mathematics.
-- While procedure is the set of commands, which are executed in a order.

-- 4 Task: Create procedures:
-- 3a: Increases salary by 10% for every 2 years of work experience and provides 10% discount and after 5 years adds 1% to the discount

CREATE TABLE employee(
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR,
    date_of_birth DATE,
    age INT,
    salary NUMERIC,
    work_experience INT,
    discount INT
);

CREATE PROCEDURE benefits(id INT) AS $$
    DECLARE
        cf2 INT;
        sal NUMERIC;
        wx INT;
    BEGIN
        SELECT work_experience INTO wx FROM employee WHERE employee_id = id;
        UPDATE employee SET discount = 10, salary = salary + (salary/10) * (work_experience/2) WHERE employee_id = id;
        IF wx>=5 THEN UPDATE employee SET discount = discount + 1 WHERE employee_id = id;
        END IF;
    END;$$
LANGUAGE PLPGSQL;

INSERT INTO employee VALUES(1,'Aibat','2003-12-03',18,100,5);
INSERT INTO employee VALUES(2,'Morti','2002-08-09',19,200,3);
CALL benefits(1);

-- 3b: After reaching 40 years, increase salary by 15%. If work experience is more than 8 years, increase salary 15% of the already increased value for work experience and provide a constant 20% siacount.
CREATE PROCEDURE benefits2(id INT) AS $$
    DECLARE
        cf2 INT;
        e_age INT;
        wx INT;
    BEGIN
        SELECT age,work_experience INTO e_age,wx FROM employee WHERE employee.employee_id = id;
        cf2 = wx / 2;
        IF e_age>=40 THEN UPDATE employee SET salary = salary * 1.15 WHERE employee_id = id;
        END IF;
        IF wx>=8 THEN UPDATE employee SET salary = salary * 1.15,discount = 20 WHERE employee_id = id;
        END IF;
    END;$$
LANGUAGE PLPGSQL;

-- 5 Task: Produce a CTE that can return the upward recommendation chain for any
-- member. You should be able to select recommender from recommenders
-- where member=x. Demonstrate it by getting the chains for members 12 and 22.
-- Results table should have member and recommender, ordered by member
-- ascending, recommender descending.

CREATE TABLE members(
    memid INT,
    surname varchar(200),
    firstname varchar(200),
    address varchar(300),
    zipcode INT,
    telephone varchar(20),
    recommendedby INT,
    joindate timestamp
);
CREATE TABLE bookings(
    facid INT,
    memid INT,
    starttime timestamp,
    slots INT
);
CREATE TABLE facilities(
    facid INT,
    name varchar(200),
    membercost NUMERIC,
    guestcost NUMERIC,
    initialoutlay NUMERIC,
    monthlymaintenance NUMERIC
);

WITH RECURSIVE recommenders(recommender, member) AS (
    SELECT recommendedby, memid
    FROM members
    UNION ALL
    SELECT mems.recommendedby, recs.member
    FROM recommenders recs
             INNER JOIN members mems
                        ON mems.memid = recs.recommender
)
SELECT recs.member member, recs.recommender, mems.firstname, mems.surname
FROM recommenders recs
         INNER JOIN members mems
                    ON recs.recommender = mems.memid
WHERE recs.member = 22
   OR recs.member = 12
ORDER BY recs.member ASC, recs.recommender DESC
