create database s3b3_2024;
use s3b3_2024;
-- Tạo bảng
CREATE TABLE IF NOT EXISTS vattu (
    maVT INT PRIMARY KEY AUTO_INCREMENT,
    tenVT VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS PhieuXuat (
    soPx INT PRIMARY KEY AUTO_INCREMENT,
    ngayXuat DATETIME
);

CREATE TABLE IF NOT EXISTS PhieuXuatChiTiet (
    soPx INT,
    maVT INT,
    donGiaXuat DOUBLE,
    soLuongXuat INT,
    CONSTRAINT lk_01 FOREIGN KEY(soPx) REFERENCES PhieuXuat(soPx),
    CONSTRAINT lk_02 FOREIGN KEY(maVT) REFERENCES vattu(maVT)
);

CREATE TABLE IF NOT EXISTS PhieuNhap (
    soPN INT PRIMARY KEY AUTO_INCREMENT,
    ngayNhap DATETIME
);

CREATE TABLE IF NOT EXISTS PhieuNhapChiTiet (
    soPN INT,
    maVT INT,
    soLuongNhap INT,
    donGiaNhap DOUBLE,
    CONSTRAINT lk_pnct FOREIGN KEY(soPN) REFERENCES PhieuNhap(soPN),
    CONSTRAINT lk_pnct_vt FOREIGN KEY(maVT) REFERENCES vattu(maVT)
);

CREATE TABLE IF NOT EXISTS NhaCungCap (
    maNCC INT PRIMARY KEY AUTO_INCREMENT,
    tenNCC VARCHAR(255),
    diaChi VARCHAR(255),
    soDienThoai VARCHAR(11)
);

CREATE TABLE IF NOT EXISTS ChiTietDonHang (
    soDH INT PRIMARY KEY AUTO_INCREMENT,
    maVT INT,
    CONSTRAINT lk_ctdh_mVT FOREIGN KEY(maVT) REFERENCES vattu(maVT)
);

CREATE TABLE IF NOT EXISTS DonDatHang (
    soDH INT,
    maNCC INT,
    CONSTRAINT lk_ddh_sdh FOREIGN KEY(soDH) REFERENCES ChiTietDonHang(soDH),
    CONSTRAINT lk_ddh_ncc FOREIGN KEY(maNCC) REFERENCES NhaCungCap(maNCC),
    ngayDH datetime
);
alter table DonDatHang
add column ngayDH datetime;

-- Nhập dữ liệu
INSERT INTO vattu (tenVT) VALUES
('Gang'), 
('Sắt'), 
('Thép'), 
('Nhôm'), 
('Thép không gỉ');

INSERT INTO PhieuXuat (ngayXuat) VALUES 
('2024-09-01 08:00:00'), 
('2024-09-05 09:30:00'), 
('2024-09-10 10:15:00'), 
('2024-09-12 14:45:00'), 
('2024-09-15 16:20:00');

INSERT INTO PhieuXuatChiTiet (soPx, maVT, donGiaXuat, soLuongXuat) VALUES 
(1, 1, 50000, 100), 
(2, 2, 60000, 50), 
(3, 3, 45000, 120), 
(4, 4, 55000, 70), 
(5, 5, 70000, 80);

INSERT INTO PhieuNhap (ngayNhap) VALUES 

('2023-02-12 17:10:00');


INSERT INTO PhieuNhapChiTiet (soPN, maVT, soLuongNhap, donGiaNhap) VALUES 
(1, 1, 20, 30000), 
(2, 2, 30, 50000), 
(3, 3, 30, 35000), 
(4, 4, 50, 40000), 
(5, 5, 40, 30000);

INSERT INTO NhaCungCap (tenNCC, diaChi, soDienThoai) VALUES 
('Công ty A', 'Hà Nội', '0123456789'), 
('Công ty B', 'TP.HCM', '0987654321'), 
('Công ty C', 'Đà Nẵng', '0912345678'), 
('Công ty D', 'Hải Phòng', '0976543210'), 
('Công ty E', 'Cần Thơ', '0932123456');

INSERT INTO ChiTietDonHang (maVT) VALUES 
(1), 
(2), 
(3), 
(4), 
(5);

INSERT INTO DonDatHang (soDH, maNCC,ngayDH) VALUES 
(1, 1,'2024-09-13'), 
(2, 2,'2024-09-15'), 
(3, 3,'2024-08-13'), 
(4, 4,'2024-01-13'), 
(5, 5,'2024-02-13');
-- Tìm danh sách vật tư bán chạy nhất
select vt.*,sum(pxct.soLuongXuat) as Bestselling from vattu as vt inner join PhieuXuatChiTiet as pxct on
vt.maVT=pxct.mavt group by vt.maVT order by Bestselling desc limit 1;
-- Tìm danh sách vật tư có trong kho nhiều nhất

select vt.*,IFnull(sum(pnct.soLuongNhap),0)-IFnull(sum(pxct.soLuongXuat),0) as StockQuantity 
from vattu as vt 
inner join PhieuNhapChiTiet as pnct on vt.maVT=pnct.maVT 
inner join PhieuXuatChiTiet as pxct on vt.maVT=pxct.maVT group by vt.maVT,vt.tenVT order by StockQuantity 
limit 10;

-- Tìm ra danh sách nhà cung cấp có đơn hàng từ ngày 12/2/2024 đến 22/2/2024

select distinct ncc.* from NhaCungCap as ncc
inner join DonDatHang  as ddh on ncc.maNCC=ddh.maNCC
where ddh.ngayDH between '2024-09-13' AND '2024-09-17';
-- Tìm ra danh sách vật tư đươc mua ở nhà cung cấp từ ngày 11/1/2024 đến 22/2/2024
select distinct vt.* from vattu as vt
join ChiTietDonHang as ctdh on ctdh.maVT=vt.maVT
join DonDatHang as ddh on ddh.soDh=ctdh.soDH
join NhaCungCap as ncc on ddh.maNCC=ncc.maNCC
where ddh.ngayDH between '2024-09-13' AND '2024-09-17';

select distinct vt.* from vattu as vt 
join phieuxuatchitiet as pxct on vt.maVT=pxct.maVT
where pxct.soluongxuat >10 ;

select distinct vt.* from vattu as vt
join phieunhapchitiet as pnct on vt.maVT=pnct.maVT
join phieunhap as pn on pn.soPN=pnct.soPN
where DATE(pn.ngayNhap) > '2024-09-12';


select distinct vt.* from vattu as vt
join phieunhapchitiet as pnct on vt.maVT=pnct.maVT
where pnct.dongianhap =50000;

select distinct vt.* from  vattu as vt 
join phieuxuatchitiet as pxct on vt.maVT=pxct.maVT
where pxct.soLuongXuat>100;

select distinct ncc.* from NhaCungCap as ncc
where ncc.diachi like 'Hà Nội' and ncc.sodienthoai like'0123456789'



