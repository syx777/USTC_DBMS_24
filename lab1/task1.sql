#查询读者 Rose 借过的书（包括已还和未还） 的图书号、书名和借期
SELECT borrow.book_id,book.bname,borrow.borrow_date
FROM book,reader,borrow
WHERE reader.rname='Rose' AND reader.rid=borrow.reader_id AND book.bid=borrow.book_id;

#查询从没有借过图书也从没有预约过图书的读者号和读者姓名；
SELECT reader.rid,reader.rname
FROM reader
WHERE NOT EXISTS (SELECT * FROM borrow,reserve WHERE reader.rid=borrow.reader_id OR reader.rid=reserve.reader_id);

#查询被借阅次数最多的作者（注意一个作者可能写了多本书）；
#A.使用借阅表 borrow 中的借书记录；
SELECT book.author,COUNT(borrow.book_id) AS total_borrow_times
FROM book,borrow
WHERE book.bid=borrow.book_id
GROUP BY book.author
ORDER BY total_borrow_times DESC
LIMIT 1;
#B.使用图书表 book 中的 borrow_times
SELECT book.author,SUM(book.borrow_times) AS total_borrow_times
FROM book
GROUP BY book.author
ORDER BY total_borrow_times DESC
LIMIT 1;

#查询目前借阅未还的书名中包含“MySQL” 的图书号和书名；
SELECT book.bid,book.bname
FROM book,borrow
WHERE book.bid=borrow.book_id AND book.bname LIKE '%MySQL%' AND borrow.return_date IS NULL;

#查询借阅图书数目超过 3 本的读者姓名,重复借阅同一本书需要多次计入
SELECT reader.rname
FROM reader,borrow
WHERE reader.rid=borrow.reader_id
GROUP BY reader.rid
HAVING COUNT(borrow.book_id)>3;

#查询没有借阅过任何一本 J.K. Rowling 所著的图书的读者号和姓名；
SELECT reader.rid,reader.rname
FROM reader
WHERE NOT EXISTS (SELECT * FROM book,borrow WHERE book.author='J.K. Rowling' AND reader.rid=borrow.reader_id AND book.bid=borrow.book_id)
AND NOT EXISTS(SELECT * FROM book,borrow WHERE book.author='J.D. Rowling' AND reader.rid=borrow.reader_id AND book.bid=borrow.book_id);

#查询 2024 年借阅图书数目排名前 3 名的读者号、姓名以及借阅图书数；
SELECT reader.rid,reader.rname,COUNT(borrow.book_id) AS total_borrow_times
FROM reader,borrow
WHERE reader.rid=borrow.reader_id AND borrow.borrow_date BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY reader.rid
ORDER BY total_borrow_times DESC
LIMIT 3;

#创建一个读者借书信息的视图， 该视图包含读者号、姓名、所借图书号、图书名和借期（对于没有借过图书的读者，是否包含在该视图中均可）并使用该视图查询2024年所有读者的读者号以及所借阅的不同图书数；
DROP VIEW IF EXISTS reader_borrow_info;
CREATE VIEW reader_borrow_info AS
SELECT reader.rid,reader.rname,borrow.book_id,book.bname,borrow.borrow_date
FROM reader,borrow,book
WHERE reader.rid=borrow.reader_id AND book.bid=borrow.book_id;
SELECT rid,COUNT(DISTINCT book_id) AS total_borrow_books
FROM reader_borrow_info
WHERE borrow_date BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY reader.rid;

