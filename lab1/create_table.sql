drop table if exists reserve;
drop table if exists borrow;
drop table if exists book;
drop table if exists reader;



create table book(
    bid char(8) PRIMARY KEY,
    bname varchar(100) NOT NULL,
    author varchar(50),
    price float,
    bstatus int DEFAULT 0,
    borrow_times int DEFAULT 0,
    reserve_times int DEFAULT 0,
    check (bstatus in (0, 1, 2))
);

create table reader(
    rid char(8) PRIMARY KEY,
    rname varchar(20) NOT NULL,
    age int,
    address varchar(100)
);

create table borrow(
    book_id char(8),
    reader_id char(8),
    borrow_date date,
    return_date date,
    PRIMARY KEY (book_id, reader_id,borrow_date),
    FOREIGN KEY (book_id) REFERENCES book(bid),
    FOREIGN KEY (reader_id) REFERENCES reader(rid)
);

create table reserve(
    book_id char(8),
    reader_id char(8),
    take_date date,
    PRIMARY KEY (book_id, reader_id,reserve_date),
    FOREIGN KEY (book_id) REFERENCES book(bid),
    FOREIGN KEY (reader_id) REFERENCES reader(rid),
    reserve_date date DEFAULT (curdate()),
    CHECK (take_date >= reserve_date)
);


