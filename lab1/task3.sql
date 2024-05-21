#设计一个存储过程 borrowBook, 当读者借书时调用该存储过程完成借书处理。 要求：
#A. 一个读者最多只能借阅 3 本图书，意味着如果读者已经借阅了 3本图书并且未归还则不允许再借书；
#B. 同一天不允许同一个读者重复借阅同一本读书；
#C. 如果该图书存在预约记录，而当前借阅者没有预约，则不许借阅；
#D. 如果借阅者已经预约了该图书，则允许借阅，但要求借阅完成后删除借阅者对该图书的预约记录；
#E. 借阅成功后图书表中的 times 加 1， 修改 bstatus， 并在borrow表中插入相应借阅信息。
#使用该存储过程处理：
#(1) ID为'R001'的读者借阅ID为'B008'的书的请求(未预约)，显示借阅失败信息。
#(2) ID为'R001'的读者借阅ID为'B001'的书的请求(已预约)，显示借阅成功信息，并展示预约表相关预约记录被删除，以及图书表对应书籍的borrow_times和bstatus属性的变化。
#(3) ID为'R001'的读者再次借阅ID为'B001'的书的请求(同一天已经借阅过) ，显示借阅失败信息。
#(4) ID为'R005' 的读者借阅ID为'B008' 的书的请求(已借三本书未还) ， 显示借阅失败信息。
#(以上借阅日期默认为'2024-05-9' )
DROP PROCEDURE IF EXISTS borrowBook;
DELIMITER //

CREATE PROCEDURE borrowBook(IN readerID CHAR(8), IN bookID CHAR(8), IN borrowDate DATE)
label: BEGIN
    DECLARE status INT;
    DECLARE borrowCount INT;
    DECLARE alreadyBorrowed INT;
    DECLARE hasReservation INT;
    DECLARE notReservedButReservedExists INT;
    
    SELECT bstatus INTO status
    FROM book
    WHERE bid=bookID;
    IF status=1 THEN
        SELECT 'Borrowing failed: Book isn\'t here now' AS Message;
        LEAVE label;
    END IF;
    #检查是否在同一天重复借阅同一本书
    SELECT COUNT(*) INTO alreadyBorrowed
    FROM borrow
    WHERE reader_id = readerID AND book_id = bookID AND borrow_date = borrowDate;
    IF alreadyBorrowed > 0 THEN
        SELECT 'Borrowing failed: Book already borrowed today' AS Message;
        LEAVE label;
    END IF;

    #检查读者是否已借阅3本书
    SELECT COUNT(*) INTO borrowCount
    FROM borrow
    WHERE reader_id = readerID AND return_date IS NULL;
    IF borrowCount >= 3 THEN
        SELECT 'Borrowing failed: Already borrowed 3 books' AS Message;
        LEAVE label;
    END IF;

    #检查预约情况
    SELECT COUNT(*) INTO hasReservation
    FROM reserve
    WHERE book_id = bookID AND reader_id = readerID;
    IF hasReservation = 0 THEN
        SELECT 'Borrowing failed: Book reserved by another reader' AS Message;
        LEAVE label;
    END IF;

    #借阅成功处理
    IF hasReservation = 1 THEN
        #删除预约记录
        DELETE FROM reserve WHERE book_id = bookID AND reader_id = readerID;
    END IF;
    
    #更新图书表
    UPDATE book SET borrow_times = borrow_times + 1, bstatus = 1 WHERE bid = bookID;
    
    #插入借阅记录
    INSERT INTO borrow (book_id, reader_id, borrow_date) VALUES (bookID, readerID, borrowDate);
    
    SELECT 'Borrowing successful' AS Message;
END //

DELIMITER ;
CALL borrowBook('R001', 'B008', '2024-05-09');#没有预约
CALL borrowBook('R001', 'B001', '2024-05-09');#借阅成功
SELECT * FROM reserve;
SELECT * FROM book;
CALL borrowBook('R001', 'B001', '2024-05-09');
CALL borrowBook('R005', 'B008', '2024-05-09');
