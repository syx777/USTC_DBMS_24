#5、 设计一个存储过程 returnBook，当读者还书时调用该存储过程完成还书处理。 要求：
#A. 还书后补上借阅表 borrow 中对应记录的 return_date;
#B. 还书后将图书表 book 中对应记录的 bstatus 修改为 0(没有其他预约)或 2(有其他预约) 。
#使用该存储过程处理：
#(1) ID为‘R001’ 的读者归还ID为‘B008’ 的书的请求(未借阅)， 并展示还书失败信息。
#(2) ID为‘R001’ 的读者归还ID为‘B001’ 的书的请求，并展示书籍在book表中的bstatus以及在borrow表中的return_date的变化。
#(以上还书日期默认为‘2024-05-10’ )



DROP PROCEDURE IF EXISTS returnBook;
DELIMITER //
CREATE PROCEDURE returnBook(IN readerID CHAR(8), IN bookID CHAR(8), IN returnDate DATE)
label: BEGIN
    DECLARE status INT;
    DECLARE borrowed INT;
    DECLARE reserveTimes INT;
    
    SELECT COUNT(*) INTO borrowed
    FROM borrow
    WHERE reader_id = readerID AND book_id = bookID AND return_date IS NULL;
    IF borrowed = 0 THEN
        SELECT 'Returning failed: Book not borrowed' AS Message;
        LEAVE label;
    END IF;
    
    UPDATE borrow
    SET return_date = returnDate
    WHERE reader_id = readerID AND book_id = bookID AND return_date IS NULL;

    SELECT COUNT(*) INTO reserveTimes
    FROM reserve
    WHERE book_id = bookID;
    SELECT bstatus INTO status
    FROM book
    WHERE bid = bookID;
    IF reserveTimes=0 THEN
        UPDATE book
        SET bstatus = 0
        WHERE bid = bookID;
    ELSE
        UPDATE book
        SET bstatus = 2
        WHERE bid = bookID;
    END IF;
    
    SELECT 'Returning success' AS Message;
END //
DELIMITER ;
CALL returnBook('R001', 'B008', '2024-05-10');
CALL returnBook('R001', 'B001', '2024-05-10');
SELECT * FROM borrow;
SELECT * FROM book;
