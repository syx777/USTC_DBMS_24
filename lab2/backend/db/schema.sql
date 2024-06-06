/* SET FOREIGN_KEY_CHECKS=0;
CREATE DATABASE IF NOT EXISTS SchoolManagementSystem;*/
USE SchoolManagementSystem;

/*drop table if exists MajorChanges;
drop table if exists AwardsPunishments;
drop table if exists CourseGrades;
drop table if exists Class;
drop table if exists Courses;
drop table if exists Students;
drop procedure if exists AddStudent;


-- 学生基本信息表
CREATE TABLE Students (
    student_id VARCHAR(10) PRIMARY KEY NOT NULL,
    name VARCHAR(100),
    gender ENUM('M', 'F') NOT NULL,
    class VARCHAR(20),
    phone VARCHAR(20),
    photo BLOB
);

SHOW VARIABLES LIKE 'secure_file_priv';
SELECT LOAD_FILE('/var/lib/mysql-files/exp1.jpg');


-- 专业变更表
CREATE TABLE MajorChanges (
    change_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id VARCHAR(20),
    old_major VARCHAR(100),
    new_major VARCHAR(100),
    change_date DATE,
    FOREIGN KEY (student_id) REFERENCES Students(student_id)
);

-- 奖惩情况表
CREATE TABLE AwardsPunishments (
    record_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id VARCHAR(20),
    type ENUM('Award', 'Punishment'),
    description TEXT,
    date DATE,
    FOREIGN KEY (student_id) REFERENCES Students(student_id)
);

-- 课程管理表
CREATE TABLE Courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(100),
    credits INT,
    instructor VARCHAR(100)
);

-- 课程成绩表
CREATE TABLE CourseGrades (
    grade_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id VARCHAR(20),
    course_id INT,
    grade DECIMAL(5,2),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

-- 文件管理表
CREATE TABLE Files (
    file_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id VARCHAR(20),
    file_name VARCHAR(255),
    file_type VARCHAR(50),
    file_content LONGBLOB,
    upload_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES Students(student_id)
);


CREATE PROCEDURE AddStudent(
    IN student_id VARCHAR(10),
    IN name VARCHAR(100),
    IN gender ENUM('M', 'F'),
    IN class VARCHAR(20),
    IN phone VARCHAR(20),
    IN photo LONGBLOB
)
BEGIN
    INSERT INTO Students (student_id,name, gender, class,phone,photo)
    VALUES (student_id,name, gender, class,phone,photo);
END
;
Call AddStudent('PB21111001','Tom', 'M', 'CS001','19337353643',LOAD_FILE('/var/lib/mysql-files/exp1.jpg'));
Call AddStudent('PB21111002','Jerry', 'F', 'Ma002','18934372238',LOAD_FILE('/var/lib/mysql-files/exp2.jpg'));
Call AddStudent('PB21111003','Alice', 'F',  'CS003','18137649812',null);
Call AddStudent('PB21111004','Bob', 'M', 'CS001','13782648987',null);


SHOW VARIABLES LIKE 'max_allowed_packet';
DROP PROCEDURE IF EXISTS AddStudent;
DESCRIBE Students;
ALTER TABLE Students MODIFY photo LONGBLOB;
ALTER PROCEDURE `AddStudent` MODIFY photo LONGBLOB;
SHOW VARIABLES LIKE 'max_allowed_packet';

*/

/* 班级信息表 */
/* CREATE TABLE Class (
    class_id VARCHAR(20) PRIMARY KEY NOT NULL,
    major VARCHAR(50) NOT NULL,
    grade INT NOT NULL
);
INSERT INTO Class (class_id, major, grade) VALUES ('CS001', 'Computer Science', 2021); */

/* 班级人数用函数计算*/
/* CREATE FUNCTION GetClassSize(class_id VARCHAR(20)) RETURNS INT
BEGIN
    DECLARE class_size INT;
    SELECT COUNT(*) INTO class_size FROM Students WHERE class = class_id;
    RETURN class_size;
END; */
/*创建班级信息视图，要求包含班级编号、专业、年级、班级人数*/
/* CREATE VIEW ClassInfo AS
SELECT class_id, major, grade, GetClassSize(class_id) AS class_size FROM Class; */


-- 课程管理表
/*CREATE TABLE Courses (
    course_id VARCHAR(20) PRIMARY KEY,
    teacher_name VARCHAR(20),
    course_place VARCHAR(20),
    credits INT
);*/

-- 选课表
/*CREATE TABLE CourseSelection (
    student_id VARCHAR(20),
    course_id VARCHAR(20),
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id),
    grade FLOAT
);*/

/* CREATE VIEW CourseInfo AS
SELECT 
    cs.student_id,
    cs.course_id,
    (SELECT teacher_name FROM Courses WHERE course_id = cs.course_id) AS teacher_name,
    (SELECT course_place FROM Courses WHERE course_id = cs.course_id) AS course_place,
    (SELECT credits FROM Courses WHERE course_id = cs.course_id) AS credits,
    cs.grade
FROM 
    CourseSelection cs; */



