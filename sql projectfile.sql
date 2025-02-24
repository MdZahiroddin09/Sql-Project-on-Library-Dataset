create database Library;
use Library;


create table publisher(
publisher_PublisherName varchar(255) primary key,
publisher_PublisherAddress varchar(255),
publisher_PublisherPhone varchar(255));

create table books(
book_BookID int primary key auto_increment,
book_Title varchar(255),
book_PublisherName varchar(255),
foreign key (book_PublisherName) references publisher(publisher_PublisherName)
on delete cascade
on update cascade
);

create table authors(
book_authors_AuthorID int primary key auto_increment,
book_authors_BookID int,
book_authors_AuthorName varchar(255),
foreign key (book_authors_BookID) references books(book_BookID)
on delete cascade
on update cascade
);

create table library_branch(
library_branch_BranchID int primary key auto_increment,
library_branch_BranchName varchar(255),
library_branch_BranchAddress varchar(255));


create table book_copies(
book_copies_CopiesID int primary key auto_increment,
book_copies_BookID int,
book_copies_BranchID int,
book_copies_No_Of_Copies int,
foreign key (book_copies_BookID) references books(book_BookID)
on delete cascade
on update cascade,
foreign key (book_copies_BranchID) references library_branch(library_branch_BranchID)
on delete cascade
on update cascade);


create table borrower(
borrower_CardNo int primary key auto_increment,
borrower_BorrowerName varchar(255),
borrower_BorrowerAddress varchar(255),
borrower_BorrowerPhone varchar(255));

create table book_loans(
book_loans_LoansID int primary key auto_increment,
book_loans_BookID int,
book_loans_BranchID int,
book_loans_CardNo int,
book_loans_DateOut date,
book_loans_DueDate date,
foreign key (book_loans_BookID) references books(book_BookID)
on delete cascade
on update cascade,
foreign key (book_loans_BranchID) references library_branch(library_branch_BranchID)
on delete cascade
on update cascade,
foreign key (book_loans_CardNo) references borrower(borrower_CardNo)
on delete cascade
on update cascade);

select * from publisher;

select * from books;

select * from authors;

select * from library_branch;

select * from book_copies;

select * from borrower;

select * from book_loans;
-- in sql date format is yyyy-mm-dd so before inserting data if it contain date then convert it to yyyy-mm-dd format.
-- you can't convert date format of csv file to yyyy-mm-dd ,firstly you have to change your laptop date format to yyyy-mm-dd by going to control panel>region.
truncate book_loans;


-- 1. How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?
select book_title,library_branch_BranchName,book_copies_no_of_Copies from library_branch as lb
join book_copies as bc
on bc.book_copies_BranchID = lb.library_branch_BranchID
join books as b
on bc.book_copies_BookID = b.book_BookID
where book_title = "The Lost Tribe" and library_branch_BranchName = "Sharpstown";





-- 2. How many copies of the book titled "The Lost Tribe" are owned by each library branch?

select book_title,library_branch_BranchName,book_copies_no_of_Copies from library_branch as lb
join book_copies as bc
on bc.book_copies_BranchID = lb.library_branch_BranchID
join books as b
on bc.book_copies_BookID = b.book_BookID
where book_title = "The Lost Tribe";



-- 3. Retrieve the names of all borrowers who do not have any books checked out.
select b.borrower_CardNo ,b.borrower_BorrowerName from borrower as b
where b.borrower_CardNo not in (select distinct bl.book_loans_CardNo from book_loans as bl);


-- 4. For each book that is loaned out from the "Sharpstown" branch and whose DueDate is 2/3/18, retrieve the book title, the borrower's name, and the borrower's address. 
select b.book_Title,br.borrower_BorrowerName,br.borrower_BorrowerAddress from book_loans as bl
join library_branch as lb
on bl.book_loans_BranchID = lb.library_branch_BranchID
join books as b
on bl.book_loans_BookID = b.book_BookID
join borrower as br
on bl.book_loans_CardNo = br.borrower_CardNo
where lb.library_branch_BranchName='Sharpstown' and bl.book_loans_DueDate="2018-02-03";


-- 5. For each library branch, retrieve the branch name and the total number of books loaned out from that branch.

select lb.library_branch_BranchName,count(bl.book_loans_BookID) as `total number of books loaned` from library_branch as lb
join book_loans as bl
on bl.book_loans_BranchID = lb.library_branch_BranchID
group by lb.library_branch_BranchName;


-- 6. Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out.

select b.borrower_BorrowerName,count(*) from borrower as b
join book_loans as bl
on bl.book_loans_CardNo = b.borrower_CardNo
group by b.borrower_BorrowerName
having count(*)>5;

-- 7. For each book authored by "Stephen King", retrieve the title and the number of copies owned by the library branch whose name is "Central".

select b.book_Title,bc.book_copies_No_Of_Copies from book_copies as bc
join books as b
on b.book_BookID = bc.book_copies_BookID
join library_branch as lb
on lb.library_branch_BranchID = bc.book_copies_BranchID
join authors as a
on a.book_authors_BookID = bc.book_copies_BookID
where a.book_authors_AuthorName = "Stephen King" and lb.library_branch_BranchName="Central";



