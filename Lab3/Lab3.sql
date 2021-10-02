---------------- LAB3 --------------
--1.a
SELECT ALL title FROM course WHERE credits > 3;
--1.b
SELECT ALL room_number FROM classroom WHERE building = 'Watson' or building = 'Packard';
--1.c
SELECT ALL course_id, title FROM course WHERE dept_name = 'Comp. Sci.';
--1.d
SELECT ALL course_id FROM section WHERE semester = 'Fall';
--1.e
SELECT ALL name FROM student WHERE tot_cred > 45 and tot_cred < 90;
--1.f
SELECT ALL name FROM student WHERE name like '%a' or name like '%e' or name like '%o' or name like '%i' or name like '%y' or name like '%u';
--1.g
SELECT ALL course_id FROM prereq WHERE prereq_id = 'CS-101';


--2.a
SELECT dept_name, avg (salary) as avg_salary FROM instructor group by dept_name order by avg_salary;
--2.b
--2.c
--2.d
--2.e
SELECT ALL name FROM instructor WHERE dept_name = 'Biology' or dept_name = 'Philosophy' or dept_name = 'Music';
--2.f
SELECT id, name FROM instructor WHERE id in ( SELECT id FROM teaches WHERE year = '2018')
                                    and id not in ( SELECT id FROM teaches WHERE year = '2017');

--3.a
SELECT ALL id FROM takes WHERE ( course_id = 'CS-101'
                            or course_id = 'CS-347'
                            or course_id = 'CS-190'
                            or course_id = 'CS-315'
                            or course_id = 'CS-319') and ( grade = 'A' or grade = 'A-');
--3.b
SELECT id, name FROM instructor WHERE id in
                                      ( SELECT i_id FROM advisor WHERE s_id in
                                      ( SELECT id FROM takes WHERE grade = 'B-'
                                                                or grade = 'C+'
                                                                or grade = 'C'
                                                                or grade = 'C-'
                                                                or grade = 'F') );
--3.c d
SELECT DISTINCT dept_name FROM course WHERE course_id not in
                                    ( SELECT course_id FROM takes WHERE grade = 'F' or grade = 'C');
--3.e
SELECT course_id, dept_name FROM course WHERE course_id in
                                                ( SELECT course_id FROM section WHERE time_slot_id in
                                                ( SELECT  time_slot_id FROM time_slot WHERE time_slot.time_slot_id = 'A'
                                                                                         or time_slot.time_slot_id = 'B'
                                                                                         or time_slot.time_slot_id = 'C'
                                                                                         or time_slot.time_slot_id = 'E'
                                                                                         or time_slot.time_slot_id = 'H'));