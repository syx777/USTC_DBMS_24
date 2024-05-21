#设计一个存储过程 updateReaderID,实现对读者表的 ID 的修改,使用该存储过程： 将读者ID中‘R006’改为‘R999’。
drop procedure if exists updateReaderID;
DELIMITER //
CREATE PROCEDURE updateReaderID()
BEGIN
    SET FOREIGN_KEY_CHECKS=0;
    UPDATE  borrow
    SET reader_id='R999'
    WHERE reader_id='R006';
    UPDATE reserve
    SET reader_id='R999'
    WHERE reader_id='R006';
    UPDATE reader
    SET rid='R999'
    WHERE rid='R006';
    SET FOREIGN_KEY_CHECKS=1;
END //
DELIMITER ;
CALL updateReaderID;
SELECT * FROM reader;
SELECT * FROM borrow;
SELECT * FROM reserve;