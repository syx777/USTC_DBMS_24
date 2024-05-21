#6、 设计触发器， 实现：
#A. 当一本书被预约时, 自动将图书表 book 中相应图书的 bstatus修改为 2，并增加 reserve_Times；
#B. 当某本预约的书被借出时或者读者取消预约时, 自动减少reserve_Times；
#C. 当某本书的最后一位预约者取消预约且该书未被借出(修改前bstatus 为 2) 时， 将 bstatus 改为 0。
#定义并创建该触发器， 然后处理：(1) ID为‘R001’ 的读者预约ID为‘B012’ 的书，再取消预约的请求，展示过程中reserve_Times 和 bstatus 的变化。(要实现预约操作，直接将对应信息insert进reserve表中即可)

DROP TRIGGER IF EXISTS book_reserve;
DROP TRIGGER IF EXISTS return_update;
DELIMITER //
CREATE TRIGGER book_reserve
AFTER INSERT ON reserve
FOR EACH ROW
BEGIN
    UPDATE book
    SET bstatus = 2, reserve_times = reserve_times + 1
    WHERE bid = NEW.book_id;
END //
CREATE TRIGGER return_update
AFTER DELETE ON reserve
FOR EACH ROW
BEGIN
    UPDATE book 
    SET reserve_times = reserve_times - 1 
    WHERE bid = OLD.book_id;
    UPDATE book
    SET bstatus = 0
    WHERE bstatus = 2 AND reserve_times = 0 AND bid = OLD.book_id;
END //
DELIMITER ;
INSERT INTO reserve (book_id, reader_id, reserve_date) VALUES ('B012', 'R001', '2024-05-10');
SELECT * FROM reserve;
SELECT * FROM book;
DELETE FROM reserve WHERE book_id = 'B012' AND reader_id = 'R001';
SELECT * FROM book;
SELECT * FROM reserve;
