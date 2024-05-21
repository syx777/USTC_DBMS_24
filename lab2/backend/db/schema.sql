SET FOREIGN_KEY_CHECKS=0;
CREATE DATABASE IF NOT EXISTS SchoolManagementSystem;
USE SchoolManagementSystem;

drop table if exists MajorChanges;
drop table if exists AwardsPunishments;

drop table if exists CourseGrades;
drop table if exists Files;
drop table if exists Courses;
drop table if exists Students;


-- 学生基本信息表
CREATE TABLE Students (
    student_id VARCHAR(20) PRIMARY KEY NOT NULL,
    name VARCHAR(100),
    gender ENUM('M', 'F') NOT NULL,
    birth_date DATE NOT NULL,
    major VARCHAR(100),
    # photo BLOB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 专业变更表
CREATE TABLE MajorChanges (
    change_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    old_major VARCHAR(100),
    new_major VARCHAR(100),
    change_date DATE,
    FOREIGN KEY (student_id) REFERENCES Students(student_id)
);

-- 奖惩情况表
CREATE TABLE AwardsPunishments (
    record_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
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
    student_id INT,
    course_id INT,
    grade DECIMAL(5,2),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

-- 文件管理表
CREATE TABLE Files (
    file_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    file_name VARCHAR(255),
    file_type VARCHAR(50),
    file_content LONGBLOB,
    upload_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES Students(student_id)
);

DELIMITER //

CREATE PROCEDURE AddStudent(
    IN name VARCHAR(100),
    IN gender ENUM('Male', 'Female'),
    IN birth_date DATE,
    IN major VARCHAR(100),
    IN photo BLOB
)
BEGIN
    INSERT INTO Students (name, gender, birth_date, major, photo)
    VALUES (name, gender, birth_date, major, photo);
END //

DELIMITER ;
