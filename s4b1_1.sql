create database s3b4;
use s3b4;
create table if not exists class(
class_id int primary key auto_increment,
class_name varchar(100),
start_date datetime,
status bit

);

create table if not exists student(
student_id int  primary key auto_increment,
student_name varchar(100),
address varchar(255),
phone varchar(11),
class_id int,
constraint linked_01 foreign key(class_id) references class(class_id)


);
alter table student
add column status bit;

create table if not exists subject(
subject_id int primary key auto_increment,
subject_name  varchar(100),
credit  int,
status bit 
);
create table if not exists mark(
   markid INT PRIMARY KEY AUTO_INCREMENT,  -- Thêm AUTO_INCREMENT nếu bạn muốn tự động tăng giá trị cho markid
    subject_id INT,
    CONSTRAINT lienket_02 FOREIGN KEY (subject_id) REFERENCES subject(subject_id),
    student_id INT,
    CONSTRAINT lienket_03 FOREIGN KEY (student_id) REFERENCES student(student_id),
    mark DOUBLE,
    exam_time DATETIME
);
insert into class(class_name,start_date,status) values('HN_JV231103','2023-11-03',1),
('HN_JV231229','2023-12-29',1),('HN_JV230615','2023-06-15',1);
insert into student(student_name,address,phone,class_id,status) values
('Hùng','Quảng Ninh','0828973995',1,1),('Giang','Quảng Nam','0128973215',1,1),
('Mạnh','Hà Nội','0828955995',2,1),('Cao','Vũng Tàu','0658973555',2,1),
('Long','Thanh Hóa','0828963885',3,1),
('Du','Nghệ An','0824455789',1,1),('Xuân','Hà Tĩnh','0828973997',3,1);
insert into subject(subject_name,credit,status) values('Toán','3',1),('Văn','3',1),('Anh','2',1);

insert into mark(subject_id,student_id, mark,exam_time) values(1,1,7,'2024-05-12'),(1,1,7,'2024-03-15'),
(2,2,8,'2024-05-15'),(2,3,9,'2024-03-08'),(3,3,10,'2024-02-11');

select c.* from class as c 
order by c.class_name desc;

select s.* from student as s 
where lower(s.address ) like lower('Hà Nội');

select s.* from student as s 
inner join class as c on s.class_id=c.class_id
where c.class_name like 'HN_JV231229';

select s.* from subject as s
where s.credit>2;
-- Hiển thị số lượng sinh viên theo từng địa chỉ nơi ở.
select s.address, Count(s.address) as Count_sv_area from student as s group by(s.address);
-- Hiển thị số lượng sinh viên theo từng địa chỉ nơi ở.
-- Hiển thị các thông tin môn học có điểm thi lớn nhất.
select sb.subject_id, sb.subject_name, sb.credit, m.mark, m.exam_time
FROM subject AS sb  inner join mark as m on sb.subject_id=m.subject_id
where m.mark=(select max(mark) from mark);
-- hoặc dùng orderBy limit 1
-- Tính điểm trung bình các môn học của từng học sinh.

select s.student_id,s.student_name,avg(m.mark) as AvergeStudent from student as s 
inner join mark as m on m.student_id=s.student_id
group by  s.student_id,s.student_name;

select s.student_id,s.student_name,avg(m.mark) as AvergeStudent from student as s 
inner join mark as m on m.student_id=s.student_id 
group by  s.student_id,s.student_name 
having AvergeStudent <=7;
-- Được sử dụng để lọc các nhóm dữ liệu sau khi nhóm và tính toán các hàm tổng hợp.

-- Hiển thị thông tin học viên có điểm trung bình các môn lớn nhất.
select s.student_id,s.student_name,avg(m.mark) as AvergeStudent from student as s 
inner join mark as m on m.student_id=s.student_id 
group by  s.student_id,s.student_name 
HAVING AVG(m.mark) = (
    SELECT MAX(avg_mark)
    FROM (
        SELECT AVG(mark) AS avg_mark
        FROM mark
        GROUP BY student_id
    ) AS subquery
);
-- Hiển thị các thông tin sinh viên và điểm trung bình của mỗi sinh viên, xếp hạng theo thứ tự điểm giảm dần
select s.student_id,s.student_name,avg(m.mark) as AvergeStudent from student as s 
inner join mark as m on m.student_id=s.student_id 
group by  s.student_id,s.student_name 
order by AvergeStudent desc;
