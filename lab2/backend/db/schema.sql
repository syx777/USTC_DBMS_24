/* SET FOREIGN_KEY_CHECKS=0;
CREATE DATABASE IF NOT EXISTS SchoolManagementSystem;*/
-- USE SchoolManagementSystem;

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

//存储过程：添加学生


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

/* 班级信息表 */
/* CREATE TABLE Class (
    class_id VARCHAR(20) PRIMARY KEY NOT NULL,
    major VARCHAR(50) NOT NULL,
    grade INT NOT NULL
);

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


/* DELIMITER $$

CREATE PROCEDURE AddOrUpdateStudent(
    IN p_student_id VARCHAR(10),
    IN p_name VARCHAR(100),
    IN p_gender ENUM('M', 'F'),
    IN p_class VARCHAR(20),
    IN p_phone VARCHAR(20),
    IN p_photo BLOB,
    IN p_is_new BOOLEAN
)
BEGIN
    DECLARE class_size INT;

    -- 开始事务
    START TRANSACTION;

    -- 如果是新学生
    IF p_is_new THEN
        INSERT INTO Students (student_id, name, gender, class, phone, photo)
        VALUES (p_student_id, p_name, p_gender, p_class, p_phone, p_photo);
    ELSE
        UPDATE Students
        SET name = p_name, gender = p_gender, class = p_class, phone = p_phone, photo = p_photo
        WHERE student_id = p_student_id;
    END IF;

    -- 计算班级人数
    SET class_size = GetClassSize(p_class);

    -- 如果班级人数超过2，回滚事务并退出
    IF class_size > 2 THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '班级人数超过2，操作失败';
    ELSE
        -- 提交事务
        COMMIT;
    END IF;
END$$

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
    (SELECT name from Students WHERE student_id = cs.student_id) AS student_name,
    cs.course_id,
    (SELECT teacher_name FROM Courses WHERE course_id = cs.course_id) AS teacher_name,
    (SELECT course_place FROM Courses WHERE course_id = cs.course_id) AS course_place,
    (SELECT credits FROM Courses WHERE course_id = cs.course_id) AS credits,
    cs.grade
FROM 
    CourseSelection cs; */

/*DELIMITER //

CREATE TRIGGER update_student_status_after_insert
AFTER INSERT ON CourseSelection
FOR EACH ROW
BEGIN
    DECLARE all_passed BOOLEAN;

    -- 检查该学生的所有课程成绩
    SELECT COUNT(*) = 0
    INTO all_passed
    FROM CourseSelection
    WHERE student_id = NEW.student_id
    AND grade < 60;

    -- 更新学生的状态
    IF all_passed THEN
        UPDATE Students
        SET status = '合格'
        WHERE student_id = NEW.student_id;
    ELSE
        UPDATE Students
        SET status = '不合格'
        WHERE student_id = NEW.student_id;
    END IF;
END //

CREATE TRIGGER update_student_status_after_update
AFTER UPDATE ON CourseSelection
FOR EACH ROW
BEGIN
    DECLARE all_passed BOOLEAN;

    -- 检查该学生的所有课程成绩
    SELECT COUNT(*) = 0
    INTO all_passed
    FROM CourseSelection
    WHERE student_id = NEW.student_id
    AND (grade < 60);

    -- 更新学生的状态
    IF all_passed THEN
        UPDATE Students
        SET status = '合格'
        WHERE student_id = NEW.student_id;
    ELSE
        UPDATE Students
        SET status = '不合格'
        WHERE student_id = NEW.student_id;
    END IF;
END //


CREATE TRIGGER update_student_status_after_delete
AFTER DELETE ON CourseSelection
FOR EACH ROW
BEGIN
    DECLARE all_passed BOOLEAN;

    -- 检查该学生的所有课程成绩
    SELECT COUNT(*) = 0
    INTO all_passed
    FROM CourseSelection
    WHERE student_id = OLD.student_id
    AND (grade < 60);

    -- 更新学生的状态
    IF all_passed THEN
        UPDATE Students
        SET status = '合格'
        WHERE student_id = OLD.student_id;
    ELSE
        UPDATE Students
        SET status = '不合格'
        WHERE student_id = OLD.student_id;
    END IF;
END //

DELIMITER ; */

-- 奖惩情况表
/* CREATE TABLE AwardsPunishments (
    record_id VARCHAR(20) PRIMARY KEY,
    student_id VARCHAR(20),
    type ENUM('Award', 'Punishment'),
    description TEXT,
    FOREIGN KEY (student_id) REFERENCES Students(student_id)
);

CREATE VIEW AwardsPunishmentsInfo AS
SELECT 
    a.record_id,
    a.student_id,
    (SELECT name from Students WHERE student_id = a.student_id) AS student_name,
    a.type,
    a.description
FROM 
    AwardsPunishments a; */



-- DELIMITER ; 

/* ALTER TABLE Students
ADD FOREIGN KEY (class) REFERENCES Class(class_id);  */

/* CREATE VIEW StudentView AS
SELECT Students.*, Class.major, Class.grade
FROM Students
JOIN Class ON Students.class = Class.class_id; */


/* ALTER TABLE Students
ALTER COLUMN status SET DEFAULT '合格'; */





