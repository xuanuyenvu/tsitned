﻿USE master;
GO

-- 21126090 - 21126054 - 21126072 - 21126088

-- MỤC LỤC

-- 1. TẠO CƠ SỞ DỮ LIỆU
-- 2. PHÂN QUYỀN
-- 3. TRIGGER
-- 4. NHẬP LIỆU


-- 1. TẠO CƠ SỞ DỮ LIỆU----------------------------------------------------------------------------------------------------
IF NOT EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = 'PKNHAKHOA')
BEGIN
    CREATE DATABASE PKNHAKHOA;
END
GO
USE PKNHAKHOA;
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'KHACHHANG')
BEGIN
    CREATE TABLE KHACHHANG 
    (
        SODT VARCHAR(10) PRIMARY KEY,
        HOTEN NVARCHAR(50),
        PHAI NVARCHAR(5) CHECK(PHAI IN (N'Nam', N'Nữ')),
        NGAYSINH DATE,
        DIACHI NVARCHAR(250),
        MATKHAU VARCHAR(20),
        _DAKHOA BIT DEFAULT 0
    );
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'NHASI')
BEGIN
	CREATE TABLE NHASI 
	(
		MANS VARCHAR(10) PRIMARY KEY,
		HOTEN NVARCHAR(50),
		PHAI NVARCHAR(5) CHECK(PHAI IN (N'Nam', N'Nữ')),
		GIOITHIEU NVARCHAR(500),
		MATKHAU VARCHAR(20),
		_DAKHOA BIT DEFAULT 0
	);
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'NHANVIEN')
BEGIN
	CREATE TABLE NHANVIEN 
	(
		MANV VARCHAR(10) PRIMARY KEY,
		HOTEN NVARCHAR(50),
		PHAI NVARCHAR(5) CHECK(PHAI IN (N'Nam', N'Nữ')),
		VITRICV NVARCHAR(50),
		MATKHAU VARCHAR(20),
		_DAKHOA BIT DEFAULT 0
	);
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'QTV')
BEGIN
	CREATE TABLE QTV 
	(
		MAQTV VARCHAR(10) PRIMARY KEY,
		HOTEN NVARCHAR(50),
		PHAI NVARCHAR(5) CHECK(PHAI IN (N'Nam', N'Nữ')),
		MATKHAU VARCHAR(20),
	);
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'LOAITHUOC')
BEGIN
	CREATE TABLE LOAITHUOC
	(
		MATHUOC VARCHAR(10) PRIMARY KEY,
		TENTHUOC NVARCHAR(50),
		DONVITINH NVARCHAR(20),
		CHIDINH NVARCHAR(200),
		SLTON INT CHECK (SLTON >= 0),
		SLNHAP INT CHECK (SLNHAP > 0),
		SLDAHUY INT CHECK (SLDAHUY >= 0),
		NGAYHETHAN DATE,
		DONGIA FLOAT CHECK (DONGIA > 0)
	);
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'LOAIDICHVU')
BEGIN
	CREATE TABLE LOAIDICHVU
	(
		MADV VARCHAR(10) PRIMARY KEY,
		TENDV NVARCHAR(50),
		MOTA NVARCHAR(500),
		DONGIA FLOAT CHECK (DONGIA > 0)
	);
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'CA')
BEGIN
	CREATE TABLE CA
	(
		MACA VARCHAR(10) PRIMARY KEY,
		GIOBATDAU TIME,
		GIOKETTHUC TIME
	);
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'CHITIETDV')
BEGIN
	CREATE TABLE CHITIETDV
	(
		MADV VARCHAR(10),
		SOTT INT,
		SODT VARCHAR(10),
		SOLUONG INT CHECK(SOLUONG > 0)
		PRIMARY KEY(SODT, SOTT, MADV)
	);
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'CHITIETTHUOC')
BEGIN
	CREATE TABLE CHITIETTHUOC
	(
		MATHUOC VARCHAR(10),
		SOTT INT,
		SODT VARCHAR(10),
		SOLUONG INT CHECK (SOLUONG > 0),
		THOIDIEMDUNG NVARCHAR(200)
		PRIMARY KEY(SODT, SOTT, MATHUOC)
	);
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'LICHRANH')
BEGIN
	CREATE TABLE LICHRANH
	(
		MANS VARCHAR(10),
		SOTT INT,
		MACA VARCHAR(10),
		NGAY DATE,
		PRIMARY KEY(MANS, SOTT)
	);
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'LICHHEN')
BEGIN
	CREATE TABLE LICHHEN
	(
		MANS VARCHAR(10),
		SOTT INT,
		LYDOKHAM NVARCHAR(200),
		SODT VARCHAR(10)
		PRIMARY KEY(MANS, SOTT, SODT)
	);
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'HOSOBENH')
BEGIN
	CREATE TABLE HOSOBENH
	(
		SODT VARCHAR(10),
		SOTT INT,
		NGAYKHAM DATE,
		DANDO NVARCHAR(500),
		MANS VARCHAR(10),
		_DAXUATHOADON BIT DEFAULT 0
		PRIMARY KEY(SODT, SOTT)
	);
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'HOADON')
BEGIN
	CREATE TABLE HOADON
	(
		SODT VARCHAR(10),
		SOTT INT,
		NGAYXUAT DATE,
		TONGCHIPHI FLOAT CHECK (TONGCHIPHI > 0),
		_DATHANHTOAN BIT DEFAULT 0,
		MANV VARCHAR(10)
		PRIMARY KEY(SODT, SOTT)
	);
END

--PK1 LICHRANH(MANS) --> NHASI(MANS)
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = 'FK_LR_NS')
BEGIN
    ALTER TABLE LICHRANH
    ADD CONSTRAINT FK_LR_NS
    FOREIGN KEY(MANS)
    REFERENCES NHASI(MANS);
END

--PK2 LICHRANH(MACA) --> CA(MACA)
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = 'FK_LR_CA')
BEGIN
    ALTER TABLE LICHRANH
    ADD CONSTRAINT FK_LR_CA
    FOREIGN KEY(MACA)
    REFERENCES CA(MACA);
END

--PK3 LICHHEN(MANS, SOTT) --> LICHRANH(MANS, SOTT)
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = 'FK_LH_LR')
BEGIN
    ALTER TABLE LICHHEN
    ADD CONSTRAINT FK_LH_LR
    FOREIGN KEY(MANS, SOTT)
    REFERENCES LICHRANH(MANS, SOTT);
END

--PK4 LICHHEN(SODT) --> KHACHHANG(SODT)
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = 'FK_LH_KH')
BEGIN
	ALTER TABLE LICHHEN
	ADD CONSTRAINT FK_LH_KH
	FOREIGN KEY(SODT)
	REFERENCES KHACHHANG(SODT);
END

-- PK5 HOSOBENH(MANS) --> NHASI(MANS)
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = 'FK_HSB_NS')
BEGIN
    ALTER TABLE HOSOBENH
    ADD CONSTRAINT FK_HSB_NS
    FOREIGN KEY(MANS)
    REFERENCES NHASI(MANS);
END

-- PK6 HOSOBENH(SODT) --> KHACHHANG(SODT)
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = 'FK_HSB_KH')
BEGIN
    ALTER TABLE HOSOBENH
    ADD CONSTRAINT FK_HSB_KH
    FOREIGN KEY(SODT)
    REFERENCES KHACHHANG(SODT);
END

-- PK7 HOADON(SODT, SOTT) --> HOSOBENH(SODT, SOTT)
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = 'FK_HD_HSB')
BEGIN
    ALTER TABLE HOADON
    ADD CONSTRAINT FK_HD_HSB
    FOREIGN KEY(SODT, SOTT)
    REFERENCES HOSOBENH(SODT, SOTT);
END

-- PK8 HOADON(MANV) --> NHANVIEN(MANV)
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = 'FK_HD_NV')
BEGIN
    ALTER TABLE HOADON
    ADD CONSTRAINT FK_HD_NV
    FOREIGN KEY(MANV)
    REFERENCES NHANVIEN(MANV);
END

-- PK9 CHITIETDV(MADV) --> LOAIDICHVU(MADV)
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = 'FK_CTDV_LDV')
BEGIN
    ALTER TABLE CHITIETDV
    ADD CONSTRAINT FK_CTDV_LDV
    FOREIGN KEY(MADV)
    REFERENCES LOAIDICHVU(MADV);
END

-- PK10 CHITIETDV(SODT, SOTT) --> HOSOBENH(SODT, SOTT)
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = 'FK_CTDV_HSB')
BEGIN
    ALTER TABLE CHITIETDV
    ADD CONSTRAINT FK_CTDV_HSB
    FOREIGN KEY(SODT, SOTT)
    REFERENCES HOSOBENH(SODT, SOTT);
END

-- PK11 CHITIETTHUOC(MATHUOC) --> LOAITHUOC(MATHUOC)
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = 'FK_CTT_LT')
BEGIN
    ALTER TABLE CHITIETTHUOC
    ADD CONSTRAINT FK_CTT_LT
    FOREIGN KEY(MATHUOC)
    REFERENCES LOAITHUOC(MATHUOC);
END

-- PK12 CHITIETTHUOC(SODT, SOTT) --> HOSOBENH(SODT, SOTT)
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = 'FK_CTT_HSB')
BEGIN
    ALTER TABLE CHITIETTHUOC
    ADD CONSTRAINT FK_CTT_HSB
    FOREIGN KEY(SODT, SOTT)
    REFERENCES HOSOBENH(SODT, SOTT);
END
-----------------------------------------------------------------------------------------------------------------

-- 2. PHÂN QUYỀN-------------------------------------------------------------------------------------------------
USE master;
GO

IF NOT EXISTS (SELECT name FROM sys.server_principals WHERE name = 'loginKH')
BEGIN
    CREATE LOGIN loginKH WITH PASSWORD = 'password123@';
END

IF NOT EXISTS (SELECT name FROM sys.server_principals WHERE name = 'loginNS')
BEGIN
    CREATE LOGIN loginNS WITH PASSWORD = 'password123@';
END

IF NOT EXISTS (SELECT name FROM sys.server_principals WHERE name = 'loginNV')
BEGIN
    CREATE LOGIN loginNV WITH PASSWORD = 'password123@';
END

IF NOT EXISTS (SELECT name FROM sys.server_principals WHERE name = 'loginQTV')
BEGIN
    CREATE LOGIN loginQTV WITH PASSWORD = 'password123@';
END

IF NOT EXISTS (SELECT name FROM sys.server_principals WHERE name = 'loginServer')
BEGIN
    CREATE LOGIN loginServer WITH PASSWORD = 'password123@';
END


USE PKNHAKHOA;
GO


IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'userKH')
BEGIN
    CREATE USER userKH FOR LOGIN loginKH;
END

IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'userNS')
BEGIN
    CREATE USER userNS FOR LOGIN loginNS;
END

IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'userNV')
BEGIN
    CREATE USER userNV FOR LOGIN loginNV;
END

IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'userQTV')
BEGIN
    CREATE USER userQTV FOR LOGIN loginQTV;
END

IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'userServer')
BEGIN
    CREATE USER userServer FOR LOGIN loginServer;
END

IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'QTV')
BEGIN
    EXEC SP_ADDROLE 'QTV';
END

IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'KHACHHANG')
BEGIN
    EXEC SP_ADDROLE 'KHACHHANG';
END

IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'NHANVIEN')
BEGIN
    EXEC SP_ADDROLE 'NHANVIEN';
END

IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'NHASI')
BEGIN
    EXEC SP_ADDROLE 'NHASI';
END

EXEC sp_addrolemember 'QTV', 'userQTV'
EXEC sp_addrolemember 'KHACHHANG', 'userKH'
EXEC sp_addrolemember 'NHANVIEN', 'userNV'
EXEC sp_addrolemember 'NHASI', 'userNS'
EXEC sp_addrolemember db_datareader, 'userServer'

USE PKNHAKHOA
GO
--I/ Phân quyền cho role QTV
--1. Quyền quản lý tài khoản KH
GRANT SELECT (SODT, HOTEN, PHAI, NGAYSINH, DIACHI, _DAKHOA), UPDATE (_DAKHOA)
ON KHACHHANG
TO QTV

--2. Quyền quản lý tài khoản NV
GRANT SELECT (MANV, HOTEN, PHAI, VITRICV, _DAKHOA), INSERT, UPDATE (_DAKHOA)
ON NHANVIEN
TO QTV

--3. Quyền quản lý tài khoản NS
GRANT SELECT (MANS, HOTEN, PHAI, GIOITHIEU, _DAKHOA), INSERT, UPDATE (_DAKHOA)
ON NHASI
TO QTV

--4. Quyền quản lý tài khoản QTV
GRANT SELECT, INSERT, UPDATE(HOTEN, PHAI, MATKHAU)
ON QTV
TO QTV

--5. Quyền quản lý dịch vụ 
GRANT SELECT, INSERT, DELETE, UPDATE(TENDV, MOTA, DONGIA)
ON LOAIDICHVU
TO QTV

--6. Quyền quản lý các loại thuốc
GRANT SELECT, INSERT, DELETE, UPDATE (TENTHUOC, DONVITINH, CHIDINH, SLTON, SLNHAP, SLDAHUY, NGAYHETHAN, DONGIA)
ON LOAITHUOC
TO QTV

--7. Quyền quản lý các ca
GRANT SELECT, INSERT, DELETE, UPDATE(GIOBATDAU, GIOKETTHUC)
ON CA
TO QTV

--II/ Phân quyền cho KHACHHANG 
--1. Mọi quyền trên tài khoản KH trừ xóa tài khoản
GRANT SELECT, INSERT, UPDATE(HOTEN, PHAI, NGAYSINH, DIACHI, MATKHAU)
ON KHACHHANG
TO KHACHHANG

--2. Quyền xem,thêm, xóa lịch hẹn
GRANT SELECT, DELETE, INSERT
ON LICHHEN
TO KHACHHANG

--3. Quyền xem trên lịch rảnh của nha sĩ
GRANT SELECT
ON LICHRANH
TO KHACHHANG

--4. Quyền xem trên CA
GRANT SELECT
ON CA
TO KHACHHANG

--5. Quyền xem thông tin nha sĩ
GRANT SELECT (MANS, HOTEN, PHAI, GIOITHIEU)
ON NHASI
TO KHACHHANG

--6. Quyền xem hồ sơ bệnh 
GRANT SELECT (SODT, SOTT, NGAYKHAM, DANDO, MANS)
ON HOSOBENH
TO KHACHHANG

--7. Quyền xem hóa đơn 
GRANT SELECT
ON HOADON
TO KHACHHANG

--8. Quyền xem tên nhân viên trong hóa đơn 
GRANT SELECT(MANV, HOTEN)
ON NHANVIEN
TO KHACHHANG

--9. Quyền xem chi tiết dịch vụ
GRANT SELECT
ON CHITIETDV
TO KHACHHANG

--10. Quyền xem loại dịch vụ
GRANT SELECT
ON LOAIDICHVU
TO KHACHHANG

--11. Quyền xem chi tiết nhân thuốc trong mỗi đơn thuốc
GRANT SELECT
ON CHITIETTHUOC
TO KHACHHANG

--12. Quyền xem tên các loại thuốc
GRANT SELECT (MATHUOC, TENTHUOC, DONVITINH, CHIDINH, DONGIA, NGAYHETHAN)
ON LOAITHUOC
TO KHACHHANG

--III/ Phân quyền cho role NHASI
--1. Quyền xem, sửa trên bảng nha sĩ.
GRANT SELECT, UPDATE (HOTEN, PHAI, GIOITHIEU, MATKHAU)
ON NHASI
TO NHASI

--2. Quyền quản lý lịch rảnh.
GRANT SELECT, INSERT, DELETE, UPDATE(MACA, NGAY)
ON LICHRANH
TO NHASI

--3. Quyền xem ca
GRANT SELECT
ON CA
TO NHASI

--4. Quyền xem lịch hẹn
GRANT SELECT
ON LICHHEN
TO NHASI

--5. Quyền xem, tạo hồ sơ bệnh án của bệnh nhân
GRANT SELECT, INSERT
ON HOSOBENH
TO NHASI

--6. Quyền xem và tạo chi tiết dịch vụ
GRANT SELECT, INSERT
ON CHITIETDV
TO NHASI

--7. Quyền xem loại dịch vụ
GRANT SELECT
ON LOAIDICHVU
TO NHASI

--8. Quyền xem và tạo chi tiết thuốc
GRANT SELECT, INSERT
ON CHITIETTHUOC
TO NHASI

--9. Quyền xem loại thuốc
GRANT SELECT
ON LOAITHUOC
TO NHASI

--10. Quyền xem thông tin khách hàng
GRANT SELECT(SODT, HOTEN, PHAI, NGAYSINH, DIACHI)
ON KHACHHANG
TO NHASI

--IV/ Phân quyền cho role NHANVIEN
--1. Quyền xem, sửa thông tin nhân viên
GRANT SELECT, UPDATE(HOTEN, PHAI)
ON NHANVIEN
TO NHANVIEN

--2. Quyền xem, tạo hóa đơn
GRANT SELECT, INSERT
ON HOADON
TO NHANVIEN

--3. Quyền xem hồ sơ bệnh án
GRANT SELECT
ON HOSOBENH
TO NHANVIEN

--4. Quyền xem trên chi tiết dịch vụ
GRANT SELECT
ON CHITIETDV
TO NHANVIEN

--5. Quyền xem trên loại dịch vụ
GRANT SELECT
ON LOAIDICHVU
TO NHANVIEN

--6. Quyền xem trên chi tiết thuốc
GRANT SELECT
ON CHITIETTHUOC
TO NHANVIEN

--7. Quyền xem các loại thuốc
GRANT SELECT
ON LOAITHUOC
TO NHANVIEN

--8. Quyền xem và tạo tài khoản khách hàng
GRANT SELECT(SODT, HOTEN, PHAI, NGAYSINH, _DAKHOA), INSERT 
ON KHACHHANG
TO NHANVIEN

--9. Quyền xem thông tin nha sĩ
GRANT SELECT(MANS, HOTEN, PHAI, GIOITHIEU, _DAKHOA) 
ON NHASI
TO NHANVIEN

--10. Quyền xem,thêm, xóa lịch hẹn
GRANT SELECT, DELETE, INSERT
ON LICHHEN
TO NHANVIEN

--11. Quyền xem trên lịch rảnh của nha sĩ
GRANT SELECT
ON LICHRANH
TO NHANVIEN

--12. Quyền xem trên CA
GRANT SELECT
ON CA
TO NHANVIEN
GO

-------------------------------------------------------------------------------------------------------
-- 3. Trigger------------------------------------------------------------------------------------------
-- Với mọi ca, giờ bắt đầu phải nhỏ hơn giờ kết thúc.
CREATE TRIGGER TRIGGER_CA_INSERT_UPDATE_1
ON CA
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (SELECT *
    FROM inserted
    WHERE GIOBATDAU >= GIOKETTHUC)
    BEGIN
        RAISERROR (N'Giờ bắt đầu phải nhỏ hơn giờ kết thúc.', 16, 1)
        ROLLBACK TRAN
        RETURN
    END
END;
GO

-- Với mọi ca, giờ kết thúc - giờ bắt đầu = 2 tiếng
CREATE TRIGGER TRIGGER_CA_INSERT_UPDATE_2
ON CA
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1
    FROM inserted
    WHERE DATEDIFF(HOUR, inserted.GIOBATDAU, inserted.GIOKETTHUC) <> 2)
    BEGIN
        RAISERROR ('Độ dài ca phải là 2 tiếng.', 16, 1)
        ROLLBACK TRAN
        RETURN
    END
END;
GO


-- Các lịch rảnh của một nha sĩ không được trùng nhau (trùng ca và trùng ngày).
CREATE TRIGGER TRIGGER_LICHRANH_INSERT_UPDATE_2
ON LICHRANH
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT MANS, NGAY, MACA
        FROM (SELECT MANS, NGAY, MACA FROM inserted) AS I
        GROUP BY MANS, NGAY, MACA
        HAVING COUNT(*) > 1
    )
    BEGIN
        RAISERROR(N'Không thể cập nhật dòng thành một giá trị đã tồn tại.', 16, 1)
        ROLLBACK TRAN
        RETURN
    END
END;
GO

-- Mỗi ca trong ngày chỉ được tối đa 2 nha sĩ được đăng ký. 
CREATE TRIGGER TRIGGER_LICHRANH_INSERT_UPDATE_3
ON LICHRANH
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT MACA, NGAY, COUNT(*) AS SLNS
        FROM LICHRANH
        GROUP BY MACA, NGAY
        HAVING COUNT(*) > 2
    )
    BEGIN
        RAISERROR(N'Không thể đăng ký nhiều hơn 2 Nha sĩ cho mỗi ca trong một ngày.', 16, 1)
        ROLLBACK TRAN
        RETURN
    END
END;
GO

-- Mỗi lịch rảnh, ca và ngày cần not null.
CREATE TRIGGER TRIGGER_LICHRANH_INSERT_UPDATE_4
ON LICHRANH
AFTER INSERT, UPDATE
AS
BEGIN
    
    IF EXISTS (
        SELECT 1
        FROM inserted AS i
        LEFT JOIN CA AS c ON i.MACA = c.MACA
        WHERE c.MACA IS NULL OR i.NGAY IS NULL
    )
    BEGIN
        RAISERROR(N'Mỗi lịch rảnh cần được liên kết với một thông tin ca và ngày không được NULL.', 16, 1)
        ROLLBACK TRAN
        RETURN
    END
END;
GO



-------------------------------------------------------------------------------------------
-- USE PKNHAKHOA
-- GO
-- I/ Tạo trigger cho bảng CHITIETTHUOC
-- 1. Trigger bán thuốc, cập nhật số lượng thuốc tồn kho
-- Tạo trigger nếu chưa tồn tại hoặc cập nhật nếu trigger đã tồn tại
IF EXISTS (SELECT *
FROM sys.triggers
WHERE name = 'Trigger_Insert_CTT')
    DROP TRIGGER Trigger_Insert_CTT
GO

CREATE TRIGGER Trigger_Insert_CTT
ON CHITIETTHUOC
FOR INSERT
AS
BEGIN
    IF(NOT EXISTS(SELECT *
    FROM LOAITHUOC LT JOIN inserted I
        ON LT.MATHUOC = I.MATHUOC))
    BEGIN
        RAISERROR(N'Thuốc này không tồn tại trong kho',16,1)
        ROLLBACK TRAN
        RETURN
    END

    IF(EXISTS(SELECT *
    FROM HOSOBENH HSB JOIN inserted I
        ON HSB.SODT = I.SODT AND HSB.SOTT = I.SOTT
    WHERE _DAXUATHOADON = 1))
    BEGIN
        RAISERROR(N'Lỗi đã xuất hóa đơn, không thể thêm đơn thuốc được',16,1)
        ROLLBACK TRAN
        RETURN
    END

    IF(EXISTS(SELECT *
    FROM LOAITHUOC LT, inserted I
    WHERE I.MATHUOC = LT.MATHUOC AND I.SOLUONG > LT.SLTON AND LT.NGAYHETHAN >= GETDATE()))
    BEGIN
        RAISERROR(N'Lỗi không đủ số lượng thuốc tồn kho để bán',16,1)
        ROLLBACK TRAN
        RETURN
    END

    ELSE
    BEGIN
        UPDATE LOAITHUOC
        SET SLTON = SLTON - (
            SELECT SOLUONG
        FROM inserted
        WHERE MATHUOC = LOAITHUOC.MATHUOC
        )
        FROM LOAITHUOC
            JOIN inserted ON LOAITHUOC.MATHUOC = inserted.MATHUOC
    END
END
GO

-- 2. Trigger bán thuốc, khi sửa số lượng thuốc trong chi tiết thuốc
-- Tạo trigger nếu chưa tồn tại hoặc cập nhật nếu trigger đã tồn tại
IF EXISTS (SELECT *
FROM sys.triggers
WHERE name = 'Trigger_Update_CTT_SL')
    DROP TRIGGER Trigger_Update_CTT_SL
GO

CREATE TRIGGER Trigger_Update_CTT_SL
ON CHITIETTHUOC
FOR UPDATE
AS
if UPDATE(SOLUONG)
BEGIN
    IF(EXISTS(SELECT *
    FROM HOSOBENH HSB JOIN inserted I
        ON HSB.SODT = I.SODT AND HSB.SOTT = I.SOTT
    WHERE _DAXUATHOADON = 1))
    BEGIN
        RAISERROR(N'Lỗi đã xuất hóa đơn, không thể sửa được',16,1)
        ROLLBACK TRAN
        RETURN
    END

    IF(EXISTS(SELECT *
    FROM LOAITHUOC LT, inserted I, deleted D
    WHERE I.MATHUOC = LT.MATHUOC AND D.MATHUOC = LT.MATHUOC AND I.SOLUONG > LT.SLTON + D.SOLUONG))
    BEGIN
        RAISERROR(N'Lỗi không đủ số lượng thuốc tồn kho để bán',16,1)
        ROLLBACK TRAN
        RETURN
    END
    
    ELSE 
    BEGIN
        UPDATE LOAITHUOC
        SET SLTON = SLTON + (
            SELECT SOLUONG
        FROM deleted
        WHERE MATHUOC = LOAITHUOC.MATHUOC
        )
        FROM LOAITHUOC
            JOIN deleted ON LOAITHUOC.MATHUOC = deleted.MATHUOC

        UPDATE LOAITHUOC
        SET SLTON = SLTON - (
            SELECT SOLUONG
        FROM inserted
        WHERE MATHUOC = LOAITHUOC.MATHUOC
        )
        FROM LOAITHUOC
            JOIN inserted ON LOAITHUOC.MATHUOC = inserted.MATHUOC
    END
END
GO

-- 3. Trigger không được thêm, hay sửa chi tiết dịch vụ khi đã xuất hóa đơn
-- Tạo trigger nếu chưa tồn tại hoặc cập nhật nếu trigger đã tồn tại
IF EXISTS (SELECT *
FROM sys.triggers
WHERE name = 'Trigger_Insert_Update_CTDV')
    DROP TRIGGER Trigger_Insert_Update_CTDV
GO

CREATE TRIGGER Trigger_Insert_Update_CTDV
ON  CHITIETDV
FOR UPDATE, INSERT
AS
BEGIN
    IF(EXISTS(SELECT *
    FROM HOSOBENH HSB JOIN inserted I
        ON HSB.SODT = I.SODT AND HSB.SOTT = I.SOTT
    WHERE _DAXUATHOADON = 1))
    BEGIN
        RAISERROR(N'Lỗi đã xuất hóa đơn, không thể sửa được',16,1)
        ROLLBACK TRAN
        RETURN
    END
END
GO

-----------------------------------------

--LICHHEN
--1 Mỗi lịch hẹn luôn đi kèm với duy nhất một lịch rảnh của nha sĩ.
--2 Các lịch hẹn của một khách hàng không được trùng ca nhau.
IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'Trigger_Insert_LichHen')
    DROP TRIGGER Trigger_Insert_LichHen
GO

CREATE TRIGGER Trigger_Insert_LichHen
ON LICHHEN
INSTEAD OF INSERT
AS
BEGIN

	IF (not exists (SELECT * FROM LICHRANH LR JOIN inserted i 
				ON (LR.MANS = i.MANS AND LR.SOTT = i.SOTT)))
	BEGIN
		RAISERROR(N'Lỗi: Lịch hẹn không khớp với lịch rảnh của nha sĩ.',16,1)
		ROLLBACK TRAN
		RETURN
	END

	IF (exists (SELECT * FROM LICHHEN LH JOIN inserted i
				ON (LH.MANS = i.MANS AND LH.SOTT = i.SOTT)))
	BEGIN
		SELECT * FROM LICHHEN LH 
		RAISERROR(N'Lỗi: Lịch hẹn đã có người đặt.',16,1)
		ROLLBACK TRAN
		RETURN
	END
	
	IF (exists (SELECT * FROM 
			(
				SELECT SODT AS SODT1, NGAY AS NGAY1, MACA AS MACA1
				FROM LICHRANH LR1 JOIN inserted i ON (LR1.MANS = i.MANS AND LR1.SOTT = i.SOTT)
			)   AS T1 INNER JOIN
			(
				SELECT SODT AS SODT2, NGAY AS NGAY2, MACA AS MACA2
				FROM LICHRANH LR2 JOIN LICHHEN LH ON (LR2.MANS = LH.MANS AND LR2.SOTT = LH.SOTT)
			)   AS T2
			ON (SODT1 = SODT2 AND NGAY1 = NGAY2 AND MACA1 = MACA2)))
	BEGIN
		RAISERROR(N'Lỗi: Các lịch hẹn của cùng một khách hàng không được trùng ca nhau.',16,1)
		ROLLBACK TRAN
		RETURN
	END

	ELSE
    BEGIN
        INSERT INTO LICHHEN (MANS, SOTT, LYDOKHAM, SODT)
        SELECT MANS, SOTT, LYDOKHAM, SODT
        FROM inserted;
    END
END
GO

--HOADON
--1 Mỗi hóa đơn cần đi theo một hồ sơ bệnh.
--2 Tổng chi phí của hóa đơn = (SoLuong*DonGia(của Dịch vụ) + SoLuong*DonGia(của Thuốc))
--3 Mỗi hóa đơn phải được phụ trách bởi một nhân viên hợp lệ

IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'Trigger_Insert_HoaDon')
    DROP TRIGGER Trigger_Insert_HoaDon
GO

CREATE TRIGGER Trigger_Insert_HoaDon
ON HOADON
INSTEAD OF insert
AS
BEGIN
	IF (not exists (SELECT * FROM HOSOBENH HSB JOIN inserted i 
				ON (HSB.SODT = i.SODT AND HSB.SOTT = i.SOTT)))
	BEGIN
		RAISERROR(N'Lỗi: Không tồn tại hồ sơ bệnh tương ứng.',16,1)
		ROLLBACK TRAN
		RETURN
	END

	IF (not exists (SELECT * FROM NHANVIEN NV JOIN inserted i 
				ON (NV.MANV = i.MANV)))
	BEGIN
		RAISERROR(N'Lỗi: Mã nhân viên phụ trách không hợp lệ.',16,1)
		ROLLBACK TRAN
		RETURN
	END

    DECLARE @NgayXuatHD DATE, @NgayKham DATE;
    SELECT @NgayXuatHD = i.NGAYXUAT
    FROM inserted i;
    SELECT @NgayKham = H.NGAYKHAM
    FROM HOSOBENH H JOIN inserted i ON H.SODT = i.SODT AND H.SOTT = i.SOTT;

    IF @NgayXuatHD < @NgayKham
	BEGIN
		RAISERROR(N'Lỗi: Ngày xuất hóa đơn không hợp lệ.',16,1)
		ROLLBACK TRAN
		RETURN
	END

	ELSE
    BEGIN
        INSERT INTO HOADON (SODT, SOTT, NGAYXUAT, MANV)
        SELECT SODT, SOTT, NGAYXUAT, MANV
        FROM inserted;
    END
END
GO

-----------------------------------------

                    -- TRIGGER LOAI THUOC
-- 1. Trigger cập nhật số lượng tồn khi thêm sửa/xóa loại thuốc:
CREATE TRIGGER Trigger_Insert_Update_Delete_LT on LOAITHUOC for INSERT, UPDATE, DELETE
AS
BEGIN
    -- R3: Số lượng thuốc tồn kho mỗi loại thuốc phải từ 0 trở lên. 
    IF EXISTS (SELECT * FROM LOAITHUOC LT JOIN inserted I ON LT.MATHUOC = I.MATHUOC WHERE LT.SLTON < 0)
    BEGIN
        RAISERROR(N'Số lượng tồn không được nhỏ hơn 0', 16, 1)
        ROLLBACK TRAN
        RETURN
    END
    -- R5: Số lượng thuốc nhập của mỗi loại thuốc phải lớn hơn 0. 
    IF EXISTS (SELECT * FROM LOAITHUOC LT JOIN inserted I ON LT.MATHUOC = I.MATHUOC WHERE LT.SLNHAP < 0)
    BEGIN
        RAISERROR(N'Số lượng nhập không được nhỏ hơn 0', 16, 1)
        ROLLBACK TRAN
        RETURN
    END
    -- R6: Số lượng đã hủy của mỗi loại thuốc phải từ 0 trở lên. 
    IF EXISTS (SELECT * FROM LOAITHUOC LT JOIN inserted I ON LT.MATHUOC = I.MATHUOC WHERE LT.SLDAHUY < 0)
    BEGIN
        RAISERROR(N'Số lượng đã hủy không được nhỏ hơn 0', 16, 1)
        ROLLBACK TRAN
        RETURN
    END

    -- R4: Đơn giá mỗi loại thuốc phải từ 0 trở lên.
    IF EXISTS (SELECT * FROM LOAITHUOC LT JOIN inserted I ON LT.MATHUOC = I.MATHUOC WHERE LT.DONGIA < 0)
    BEGIN
        RAISERROR(N'Đơn giá không được nhỏ hơn 0', 16, 1)
        ROLLBACK TRAN
        RETURN
    END
    -- Ma thuoc khong duoc trung
    IF EXISTS (SELECT * FROM LOAITHUOC LT JOIN inserted I ON LT.MATHUOC = I.MATHUOC WHERE LT.MATHUOC = I.MATHUOC)
    BEGIN
        RAISERROR(N'Mã thuốc không được trùng', 16, 1)
        ROLLBACK TRAN
        RETURN
    END
END
GO



	

CREATE TRIGGER Trigger_Insert_Update_LT_Hethan 
ON LOAITHUOC
INSTEAD OF INSERT
AS
BEGIN

  -- R8: Ngày hết hạn của mỗi loại thuốc phải xa hơn ngày hiện tại.
  IF EXISTS (
    SELECT * 
    FROM LOAITHUOC LT JOIN inserted  I ON LT.MATHUOC = I.MATHUOC 
    WHERE LT.NGAYHETHAN < GETDATE()
  )
  BEGIN
     RAISERROR(N'Ngày hết hạn không được nhỏ hơn ngày hiện tại', 16, 1)
     ROLLBACK TRAN
     RETURN
  END

  -- Cho phép insert 
  INSERT INTO LOAITHUOC (MATHUOC, TENTHUOC, DONVITINH, CHIDINH, 
                          SLTON, SLNHAP, SLDAHUY, NGAYHETHAN, DONGIA)
  SELECT MATHUOC, TENTHUOC, DONVITINH, CHIDINH,
         SLTON, SLNHAP, SLDAHUY, NGAYHETHAN, DONGIA
  FROM inserted

END

GO

--                                 TRIGGER LOAI DICH VU
--1.Trigger gia dich vu lon hon 0:
CREATE TRIGGER Trigger_Insert_Update_LDV on LOAIDICHVU for INSERT, UPDATE
AS
BEGIN
    -- don gia thuoc phau thuat phai lon hon 0
    IF EXISTS (SELECT * FROM LOAIDICHVU LDV JOIN inserted I ON LDV.MADV = I.MADV WHERE LDV.DONGIA < 0)
    BEGIN
        RAISERROR(N'Giá dịch vụ không được nhỏ hơn 0', 16, 1)
        ROLLBACK TRAN
        RETURN
    END
    -- R14: Mã dịch vụ trong loại dịch vụ phải là độc quyền. 
    IF EXISTS (SELECT * FROM LOAIDICHVU LDV JOIN inserted I ON LDV.MADV = I.MADV WHERE LDV.MADV IN (SELECT MADV FROM LOAIDICHVU GROUP BY MADV HAVING COUNT(*) > 1))
    BEGIN
        RAISERROR(N'Mã dịch vụ phải là độc quyền', 16, 1)
        ROLLBACK TRAN
        RETURN
    END
    -- R15: Với mọi chi tiết dịch vụ, tồn tại mã dịch vụ ứng vọi loại dịch vụ đó.
    IF EXISTS (SELECT * FROM LOAIDICHVU LDV JOIN inserted I ON LDV.MADV = I.MADV WHERE LDV.DONGIA < 0)
    BEGIN
        RAISERROR(N'Giá dịch vụ không được nhỏ hơn 0', 16, 1)
        ROLLBACK TRAN
        RETURN
    END
END


-------------------------------------------------------------------------------------------------------
-- 4. NHẬP LIỆU----------------------------------------------------------------------------------------


-- Thêm NHASI
INSERT INTO NHASI (MANS, HOTEN, PHAI, GIOITHIEU, MATKHAU)
VALUES ('NS0001', N'Lê Văn Hòa', N'Nam', N'Chuyên gia: Điều trị nha chu, chữa răng nội nha, tiểu phẫu răng miệng: nhổ răng khôn, nhổ răng mọc ngầm,… phục hình răng giả tháo lắp, phục hình răng sứ thẩm mỹ, cầu răng sứ.\nNgôn ngữ: Tiếng Việt, Tiếng Anh.\nHọc vấn: Tốt nghiệp Bác sỹ Trường Đại học Y Khoa Quảng Tây năm 2012. Tốt nghiệp thạc sỹ Trường Đại học Y khoa Quảng Tây năm 2016.\nKinh nghiệm: Bác sĩ Răng Hàm Mặt – Đại học Y Dược (2019).', 'S4f3&H@ppy*Day');

INSERT INTO NHASI (MANS, HOTEN, PHAI, GIOITHIEU, MATKHAU)
VALUES ('NS0002', N'Phạm Xuân Thanh', N'Nam', N'Chuyên gia: Tiểu phẫu răng miệng; phục hình răng giả; cầu răng sứ; nha khoa tổng quát.\nNgôn ngữ: Tiếng Việt, Tiếng Anh.\nHọc vấn: Tốt nghiệp Bác sĩ Trường Đại học Y Dược Hà Nội năm 2014.\nKinh nghiệm: Bác sĩ tại Bệnh Viện Răng Hàm Mặt Hà Nội từ năm 2014.', 'J@zzY@rd&Rhythm');

INSERT INTO NHASI (MANS, HOTEN, PHAI, GIOITHIEU, MATKHAU)
VALUES ('NS0003', N'Trần Thị Mai Loan', N'Nữ', N'Chuyên gia: chuyên phục hình răng sứ thẩm mỹ; nha khoa tổng quát.\nNgôn ngữ: Tiếng Việt, Tiếng Anh.\nHọc vấn: Tốt nghiệp Trường Đại học Y Dược TP. Hồ Chí Minh năm 1995.\nKinh nghiệm: Bác sĩ tại Bệnh Viện Răng Hàm Mặt TP. Hồ Chí Minh từ năm 1995. Bác sĩ Phó trưởng Khoa Phẫu thuật trong miệng từ năm 2015.', 'M00nL!ght&St@rs');

INSERT INTO NHASI (MANS, HOTEN, PHAI, GIOITHIEU, MATKHAU)
VALUES ('NS0004', N'Trần Minh Tuấn', N'Nam', N'Chuyên gia: Khám, tư vấn và lên phác đồ điều trị nha khoa tổng quát; Cấy ghép Implant nha khoa; Phẫu thuật trong miệng & hàm mặt; Phục hình răng sứ; Cầu răng sứ; Nha khoa thẩm mỹ.\nNgôn ngữ: Tiếng Việt, Tiếng Anh\nHọc vấn: Tốt nghiệp Trường Đại học Y Dược TP. Hồ Chí Minh năm 2011\nKinh nghiệm: Bác sĩ tại Bệnh Viện Răng Hàm Mặt TP. Hồ Chí Minh từ năm 2011.', '7H1s1sP@ssw0rd');

INSERT INTO NHASI (MANS, HOTEN, PHAI, GIOITHIEU, MATKHAU)
VALUES ('NS0005', N'Nguyễn Văn Đông', N'Nam', N'Chuyên gia: Cấy ghép Implant nha khoa; phẫu thuật trong miệng & hàm mặt; phục hình; chỉnh nha; nha khoa thẩm mỹ.\nNgôn ngữ: Tiếng Việt, Tiếng Anh\nHọc vấn: Tốt nghiệp Bác sỹ Trường Đại học Y Dược TP. Hồ Chí Minh năm 2008 Tốt nghiệp chuyên khoa I Trường Đại Học Huế năm 2015.\nKinh nghiệm: Bác sỹ tại Bệnh Viện Răng Hàm Mặt TP. Hồ Chí Minh từ năm 2008.', 'B1cycl3&4FUn#');

INSERT INTO NHASI (MANS, HOTEN, PHAI, GIOITHIEU, MATKHAU)
VALUES ('NS0006', N'Hoàng Thị Ngọc Anh', N'Nữ', N'Chuyên gia: Phục hình răng sứ thẩm mỹ; điều trị nha chu; chỉnh nha; cấy ghép Implant nha khoa.\nNgôn ngữ: Tiếng Việt, Tiếng Anh.\nHọc vấn: Tốt nghiệp Bác sĩ Trường Đại học Y Dược TP. Hồ Chí Minh năm 2010 Thạc sĩ chuyên ngành Nha khoa thẩm mỹ năm 2015.\nKinh nghiệm: Bác sĩ tại Phòng Khám Nha Khoa Ánh Sáng từ năm 2010.', 'H3@rt&S0ul*H@ppy');

INSERT INTO NHASI (MANS, HOTEN, PHAI, GIOITHIEU, MATKHAU)
VALUES ('NS0007', N'Phạm Thị Minh Trang', N'Nữ', N'Chuyên gia: Nha khoa thẩm mỹ; điều trị nha chu; cấy ghép Implant nha khoa; phục hình răng sứ.\nNgôn ngữ: Tiếng Việt, Tiếng Anh.\nHọc vấn: Tốt nghiệp Bác sĩ Trường Đại học Y Khoa Sài Gòn năm 2009 Thạc sĩ chuyên ngành Nha khoa thẩm mỹ năm 2013.\nKinh nghiệm: Bác sĩ tại Phòng Khám Nha Khoa Tươi Đẹp từ năm 2009.', '8L1ghts&Cam3r@#');

INSERT INTO NHASI (MANS, HOTEN, PHAI, GIOITHIEU, MATKHAU)
VALUES ('NS0008', N'Nguyễn Thị Kim Liên', N'Nữ', N'Chuyên gia: Chữa răng nội nha; tiểu phẫu răng miệng; phục hình răng giả tháo lắp; cầu răng sứ.\nNgôn ngữ: Tiếng Việt, Tiếng Anh.\nHọc vấn: Tốt nghiệp Bác sĩ Trường Đại học Y Dược Đà Nẵng năm 2007.\nKinh nghiệm: Bác sĩ tại Bệnh Viện Răng Hàm Mặt Đà Nẵng từ năm 2007.', 'W0nd3rful*W0rld');

INSERT INTO NHASI (MANS, HOTEN, PHAI, GIOITHIEU, MATKHAU)
VALUES ('NS0009', N'Đinh Quang Huy', N'Nam', N'Chuyên gia: Cấy ghép Implant nha khoa; phẫu thuật trong miệng & hàm mặt; phục hình; điều trị nha chu.\nNgôn ngữ: Tiếng Việt, Tiếng Anh.\nHọc vấn: Tốt nghiệp Bác sĩ Trường Đại học Y Dược Hà Nội năm 2012 Chuyên ngành Phẫu thuật nha khoa năm 2017.\nKinh nghiệm: Bác sĩ tại Phòng Khám Nha Khoa Thành Đa từ năm 2012.', 'M@gn1f!c3nt@V!3w');

INSERT INTO NHASI (MANS, HOTEN, PHAI, GIOITHIEU, MATKHAU)
VALUES ('NS0010', N'Vũ Hoàng Anh', N'Nam', N'Chuyên gia: Điều trị nha chu; nha khoa tổng quát; nha khoa thẩm mỹ; chỉnh nha.\nNgôn ngữ: Tiếng Việt, Tiếng Anh.\nHọc vấn: Tốt nghiệp Bác sĩ Trường Đại học Y Dược TP. Hồ Chí Minh năm 2015.\nKinh nghiệm: Bác sĩ tại Bệnh Viện Răng Hàm Mặt TP. Hồ Chí Minh từ năm 2015.', 'H1lls&Gr33n$');
GO

-- Tạo ca, mỗi ca 2 tiếng từ 9g đến 21g
DECLARE @StartTime TIME = '09:00';
DECLARE @EndTime TIME = '21:00';
DECLARE @ShiftCount INT = 1;
WHILE @StartTime < @EndTime
BEGIN
    DECLARE @MACA VARCHAR(10) = 'CA' + RIGHT('00' + CAST(@ShiftCount AS VARCHAR), 3);
    
    INSERT INTO CA (MACA, GIOBATDAU, GIOKETTHUC)
    VALUES (@MACA, @StartTime, DATEADD(HOUR, 2, @StartTime));
    SET @StartTime = DATEADD(HOUR, 2, @StartTime);
    SET @ShiftCount = @ShiftCount + 1;
END;
GO

-- Thêm LICHRANH
-- Ngày 2024-01-01
INSERT INTO LICHRANH (MANS, SOTT, MACA, NGAY)
VALUES
    ('NS0003', 1, 'CA001', '2024-01-01'),
    ('NS0004', 1, 'CA001', '2024-01-01'),
    ('NS0001', 1, 'CA002', '2024-01-01'),
    ('NS0010', 1, 'CA002', '2024-01-01'),
    ('NS0007', 1, 'CA003', '2024-01-01'),
    ('NS0001', 2, 'CA003', '2024-01-01'),
    ('NS0003', 2, 'CA004', '2024-01-01'),
    ('NS0004', 2, 'CA004', '2024-01-01'),
    ('NS0002', 1, 'CA005', '2024-01-01'),
    ('NS0006', 1, 'CA005', '2024-01-01'),
    ('NS0006', 2, 'CA006', '2024-01-01'),
    ('NS0003', 3, 'CA006', '2024-01-01');

-- Ngày 2024-01-02
INSERT INTO LICHRANH (MANS, SOTT, MACA, NGAY)
VALUES
    ('NS0006', 3, 'CA002', '2024-01-02'),
    ('NS0009', 1, 'CA002', '2024-01-02'),
    ('NS0001', 3, 'CA004', '2024-01-02'),
    ('NS0002', 2, 'CA004', '2024-01-02');

-- Ngày 2024-01-03
INSERT INTO LICHRANH (MANS, SOTT, MACA, NGAY)
VALUES
    ('NS0001', 4, 'CA001', '2024-01-03'),
    ('NS0010', 2, 'CA001', '2024-01-03'),
    ('NS0007', 2, 'CA005', '2024-01-03'),
    ('NS0004', 3, 'CA005', '2024-01-03');

-- Ngày 2024-01-04
INSERT INTO LICHRANH (MANS, SOTT, MACA, NGAY)
VALUES
    ('NS0005', 1, 'CA004', '2024-01-04'),
    ('NS0009', 2, 'CA004', '2024-01-04'),
    ('NS0009', 3, 'CA006', '2024-01-04'),
    ('NS0008', 1, 'CA006', '2024-01-04');

-- Ngày 2024-01-05
INSERT INTO LICHRANH (MANS, SOTT, MACA, NGAY)
VALUES
    ('NS0005', 2, 'CA002', '2024-01-05'),
    ('NS0004', 4, 'CA002', '2024-01-05');

-- Ngày 2024-01-06
INSERT INTO LICHRANH (MANS, SOTT, MACA, NGAY)
VALUES
    ('NS0005', 5, 'CA005', '2024-01-06'),
    ('NS0003', 5, 'CA005', '2024-01-06'),
    ('NS0007', 6, 'CA006', '2024-01-06'),
    ('NS0010', 6, 'CA006', '2024-01-06');


--Nhap lieu bang KHACHHANG
INSERT INTO KHACHHANG (SODT, HOTEN, PHAI, NGAYSINH, DIACHI, MATKHAU)
VALUES ('0371234567', N'Nguyễn Huyền Trang', N'Nữ', '1978-05-15', N'15/3 Hoàng Hoa Thám, Phường 6, Quận 3, TP.HCM', 'P@ssw0rd!');

INSERT INTO KHACHHANG (SODT, HOTEN, PHAI, NGAYSINH, DIACHI, MATKHAU)
VALUES ('0712345333', N'Võ Minh Tuấn', N'Nam', '1992-09-23', N'28/6 Phan Chu Trinh, Phường Bến Thành, Quận 1, TP.HCM', 'Qwerty123#');

INSERT INTO KHACHHANG (SODT, HOTEN, PHAI, NGAYSINH, DIACHI, MATKHAU)
VALUES ('0945678765', N'Hoàng Thị Mai Phương', N'Nữ', '1982-08-18', N'291 Đường Đại Lộ Bình Dương, TP.Thủ Dầu Một, Bình Dương', '9M!xA$4e');

INSERT INTO KHACHHANG (SODT, HOTEN, PHAI, NGAYSINH, DIACHI, MATKHAU)
VALUES ('0934567890', N'Vũ Thị Hằng', N'Nữ', '1985-11-10', N'42/9 Ngô Quyền, Phường 5, Quận 10, TP.HCM', 'Ch0c0l@t3&');

INSERT INTO KHACHHANG (SODT, HOTEN, PHAI, NGAYSINH, DIACHI, MATKHAU)
VALUES ('0309876543', N'Quách Văn Phúc', N'Nam', '1996-03-08', N'50 Võ Thị Sáu, Phường Thái Bình, TP.Biên Hòa, Đồng Nai', 'TrungThu@2022');

INSERT INTO KHACHHANG (SODT, HOTEN, PHAI, NGAYSINH, DIACHI, MATKHAU)
VALUES ('0798712432', N'Bùi Thị Mai Anh', N'Nữ', '1980-07-20', N'567 Nguyễn Đình Chính, Quận Phú Nhuận, TP.HCM', 'M0tP@$$w0rd');

INSERT INTO KHACHHANG (SODT, HOTEN, PHAI, NGAYSINH, DIACHI, MATKHAU, _DAKHOA)
VALUES ('0945678901', N'Đoàn Văn Đức', N'Nam', '2003-12-05', N'18/7 Bà Huyện Thanh Quan, Phường Tân Định, Quận 1, TP.HCM', 'B3st@nsw3r!', 1);

INSERT INTO KHACHHANG (SODT, HOTEN, PHAI, NGAYSINH, DIACHI, MATKHAU)
VALUES ('0323456789', N'Lê Thị Thu Hà', N'Nữ', '1971-04-14', N'63/5 Phạm Ngũ Lão, Phường Phạm Ngũ Lão, Quận 1, TP.HCM', 'Secur1ty*');

INSERT INTO KHACHHANG (SODT, HOTEN, PHAI, NGAYSINH, DIACHI, MATKHAU)
VALUES ('0712345678', N'Ngô Đình Quân', N'Nam', '1998-08-02', N'201 Lê Thị Riêng, Phường Bến Thành, Quận 1, TP.HCM', 'H@ppyD@ys7');

INSERT INTO KHACHHANG (SODT, HOTEN, PHAI, NGAYSINH, DIACHI, MATKHAU)
VALUES ('0987654321', N'Dương Thị Thảo', N'Nữ', '1989-06-19', N'72/3 Nguyễn Thị Minh Khai, Phường Đa Kao, Quận 1, TP.HCM', 'L0ngP@ssw0rd#');

INSERT INTO KHACHHANG (SODT, HOTEN, PHAI, NGAYSINH, DIACHI, MATKHAU)
VALUES ('0301234567', N'Hoàng Văn Tùng', N'Nam', '2002-01-30', N'52/14 Lý Thường Kiệt, Phường 10, Quận 11, TP.HCM', 'P!n3@pple$2');

INSERT INTO KHACHHANG (SODT, HOTEN, PHAI, NGAYSINH, DIACHI, MATKHAU)
VALUES ('0743216549', N'Nguyễn Thị Bích Ngọc', N'Nữ', '1975-10-03', N'90/2 Đinh Công Tráng, Phường Tân Đông Hiệp, TP.Dĩ An, Bình Dương', '5tr0ngP@ss!');

INSERT INTO KHACHHANG (SODT, HOTEN, PHAI, NGAYSINH, DIACHI, MATKHAU)
VALUES ('0912345678', N'Võ Văn Thắng', N'Nam', '1990-09-17', N'33 Lê Hồng Phong, Phường Phước Tân, TP.Biên Hòa, Đồng Nai', 'H3ll0W0r1d$');

INSERT INTO KHACHHANG (SODT, HOTEN, PHAI, NGAYSINH, DIACHI, MATKHAU)
VALUES ('0378236541', N'Vũ Thị Hồng Loan', N'Nữ', '1983-07-27', N'22/10 Võ Văn Tần, Phường Long Bình, TP.Biên Hòa, Đồng Nai', 'G00dM0rn!ng9');

INSERT INTO KHACHHANG (SODT, HOTEN, PHAI, NGAYSINH, DIACHI, MATKHAU, _DAKHOA)
VALUES ('0798765432', N'Quách Minh Tâm', N'Nam', '2000-02-12', N'31/5 Đinh Bộ Lĩnh, Phường Lái Thiêu, TP.Thuận An, Bình Dương', 'W@t3rM3l0n#', 1);

INSERT INTO KHACHHANG (SODT, HOTEN, PHAI, NGAYSINH, DIACHI, MATKHAU)
VALUES ('0723456789', N'Bùi Văn Thành', N'Nam', '1972-11-09', N'295 Lê Lai, Phường Bến Thành, Quận 1, TP.HCM', 'Sunsh!ne@21');

INSERT INTO KHACHHANG (SODT, HOTEN, PHAI, NGAYSINH, DIACHI, MATKHAU)
VALUES ('0923456780', N'Đoàn Thị Kim Ngân', N'Nữ', '1994-06-25', N'17/3 Phan Kế Bính, Phường Đa Kao, Quận 1, TP.HCM', '2F@st2Fur!ous');

INSERT INTO KHACHHANG (SODT, HOTEN, PHAI, NGAYSINH, DIACHI, MATKHAU)
VALUES ('0345678901', N'Lê Minh Hoàng', N'Nam', '1987-12-21', N'237 Phạm Ngọc Thạch, Phường 6, Quận 3, TP.HCM', 'F0r3v3rY0ung*');

INSERT INTO KHACHHANG (SODT, HOTEN, PHAI, NGAYSINH, DIACHI, MATKHAU)
VALUES ('0765432109', N'Ngô Thị Lan Anh', N'Nữ', '1999-04-07', N'55/8 Ngô Thời Nhiệm, Phường Tân Quý, Quận Tân Phú, TP.HCM', 'C@t&DogL0v3r');

INSERT INTO KHACHHANG (SODT, HOTEN, PHAI, NGAYSINH, DIACHI, MATKHAU)
VALUES ('0387654321', N'Dương Văn Quyền', N'Nam', '1977-03-28', N'172 Đường Lê Đại Hành, Phường 9, Quận 11, TP.HCM', 'B3@chP@rad1$3');

INSERT INTO KHACHHANG (SODT, HOTEN, PHAI, NGAYSINH, DIACHI, MATKHAU)
VALUES ('0356123456', N'Nguyễn Huyền Thu', N'Nữ', '1979-08-15', N'34/7B Lê Hồng Phong, Phường 4, Quận 5, TP.HCM', 'B3st@nsw3r!');

INSERT INTO KHACHHANG (SODT, HOTEN, PHAI, NGAYSINH, DIACHI, MATKHAU)
VALUES ('0789654321', N'Lê Đức Anh', N'Nam', '1993-05-02', N'14A Đinh Công Tráng, Phường Tân Đông Hiệp, TP.Dĩ An, Bình Dương', 'Secur1ty*');

INSERT INTO KHACHHANG (SODT, HOTEN, PHAI, NGAYSINH, DIACHI, MATKHAU)
VALUES ('0967123456', N'Trần Thị Mai Phương', N'Nữ', '1995-06-14', N'72 Phan Kế Bính, Phường Đa Kao, Quận 1, TP.HCM', 'H@ppyD@ys7');

INSERT INTO KHACHHANG (SODT, HOTEN, PHAI, NGAYSINH, DIACHI, MATKHAU)
VALUES ('0334123456', N'Nguyễn Minh Tuấn', N'Nam', '1970-01-25', N'27/2 Hoàng Hoa Thám, Phường 7, Quận Bình Thạnh, TP.HCM', 'L0ngP@ssw0rd#');

INSERT INTO KHACHHANG (SODT, HOTEN, PHAI, NGAYSINH, DIACHI, MATKHAU)
VALUES ('0823654321', N'Vũ Thị Thu Hằng', N'Nữ', '1984-12-03', N'8 Đường Đại Lộ Bình Dương, TP.Thủ Dầu Một, Bình Dương', 'P!n3@pple$2');

INSERT INTO KHACHHANG (SODT, HOTEN, PHAI, NGAYSINH, DIACHI, MATKHAU)
VALUES ('0978564321', N'Trần Văn Minh', N'Nam', '1996-11-09', N'56/10 Ngô Thời Nhiệm, Phường Tân Quý, Quận Tân Phú, TP.HCM', '5tr0ngP@ss!');

INSERT INTO KHACHHANG (SODT, HOTEN, PHAI, NGAYSINH, DIACHI, MATKHAU)
VALUES ('0967123664', N'Lý Thị Thảo', N'Nữ', '1973-07-28', N'42 Lê Lai, Phường Bến Thành, Quận 1, TP.HCM', 'H3ll0W0r1d$');

INSERT INTO KHACHHANG (SODT, HOTEN, PHAI, NGAYSINH, DIACHI, MATKHAU)
VALUES ('0967123877', N'Phạm Thị Thu Hà', N'Nữ', '1987-09-21', N'49B Phạm Ngọc Thạch, Phường 6, Quận 3, TP.HCM', 'G00dM0rn!ng9');

INSERT INTO KHACHHANG (SODT, HOTEN, PHAI, NGAYSINH, DIACHI, MATKHAU)
VALUES ('0321654321', N'Hoàng Văn Thành', N'Nam', '1998-02-10', N'2B Phan Chu Trinh, Phường Bến Thành, Quận 1, TP.HCM', 'P@ssw0rd!');

INSERT INTO KHACHHANG (SODT, HOTEN, PHAI, NGAYSINH, DIACHI, MATKHAU)
VALUES ('0789652221', N'Nguyễn Thị Thuý Nga', N'Nữ', '1981-03-07', N'121 Lê Thị Riêng, Phường Bến Thành, Quận 1, TP.HCM', 'Qwerty123#');

--Nhap lieu bang NHANVIEN
INSERT INTO NHANVIEN (MANV, HOTEN, PHAI, VITRICV, MATKHAU)
VALUES ('NV0001', N'Trần Thị Bảo Trâm', N'Nữ', N'Hành chính phòng khám', 'B@n4n@&Sm1l3*');

INSERT INTO NHANVIEN (MANV, HOTEN, PHAI, VITRICV, MATKHAU)
VALUES ('NV0002', N'Lê Thị Ngọc Hà', N'Nữ', N'Y tá', 'P@rk#J0g$L0v3');

INSERT INTO NHANVIEN (MANV, HOTEN, PHAI, VITRICV, MATKHAU)
VALUES ('NV0003', N'Lý Thị Minh Tuyết', N'Nữ', N'Y tá', 'W1nt3rT!m3@Out');

INSERT INTO NHANVIEN (MANV, HOTEN, PHAI, VITRICV, MATKHAU)
VALUES ('NV0004', N'Nguyễn Thị Thanh Tâm', N'Nữ', N'Y tá', 'S4f3&H@ppy*Day');

INSERT INTO NHANVIEN (MANV, HOTEN, PHAI, VITRICV, MATKHAU)
VALUES ('NV0005', N'Phạm Thị Thu Hiền', N'Nữ', N'Hành chính phòng khám', 'M00nL!ght&St@rs');

INSERT INTO NHANVIEN (MANV, HOTEN, PHAI, VITRICV, MATKHAU)
VALUES ('NV0006', N'Nguyễn Thị Thảo Vy', N'Nữ', N'Y tá', '7H1s1sP@ssw0rd');

INSERT INTO NHANVIEN (MANV, HOTEN, PHAI, VITRICV, MATKHAU)
VALUES ('NV0007', N'Nguyễn Thị Mai An', N'Nữ', N'Y tá', 'B1cycl3&4FUn#');

INSERT INTO NHANVIEN (MANV, HOTEN, PHAI, VITRICV, MATKHAU)
VALUES ('NV0008', N'Trương Thị Kim Oanh', N'Nữ', N'Quản lý trưởng', 'H3@rt&S0ul*H@ppy');

INSERT INTO NHANVIEN (MANV, HOTEN, PHAI, VITRICV, MATKHAU)
VALUES ('NV0009', N'Bùi Đình Tùng', N'Nam', N'Hành chính phòng khám', 'J@zzY@rd&Rhythm');

INSERT INTO NHANVIEN (MANV, HOTEN, PHAI, VITRICV, MATKHAU)
VALUES ('NV0010', N'Hoàng Thị Diệu Linh', N'Nữ', N'Y tá', '8L1ghts&Cam3r@#');

INSERT INTO NHANVIEN (MANV, HOTEN, PHAI, VITRICV, MATKHAU)
VALUES ('NV0011', N'Đặng Thị Phương Loan', N'Nữ', N'Hành chính phòng khám', 'W0nd3rful*W0rld');

INSERT INTO NHANVIEN (MANV, HOTEN, PHAI, VITRICV, MATKHAU)
VALUES ('NV0012', N'Trần Thị Kim Anh', N'Nữ', N'Y tá', 'M@gn1f!c3nt@V!3w');

INSERT INTO NHANVIEN (MANV, HOTEN, PHAI, VITRICV, MATKHAU)
VALUES ('NV0013', N'Bùi Văn Đạt', N'Nam', N'Y tá', 'P@r4d!s3*3sc@p3');

INSERT INTO NHANVIEN (MANV, HOTEN, PHAI, VITRICV, MATKHAU)
VALUES ('NV0014', N'Võ Thị Quỳnh Nga', N'Nữ', N'Hành chính phòng khám', 'Ch3ck3r3d&Fl@g');

INSERT INTO NHANVIEN (MANV, HOTEN, PHAI, VITRICV, MATKHAU)
VALUES ('NV0015', N'Võ Thanh Long', N'Nam', N'Quản lý phó', 'H1lls&Gr33n$');

--Nhap lieu bang Lich hen
INSERT INTO LICHHEN (MANS, SOTT, LYDOKHAM, SODT)
VALUES ('NS0001', 1, N'Đau rát răng và nướu: Tôi đã cảm thấy đau rát và sưng nướu ở chiếc răng ở phía dưới bên trái trong vài ngày qua. Đau đớn khi chải răng và ăn.', '0323456789');

INSERT INTO LICHHEN (MANS, SOTT, LYDOKHAM, SODT)
VALUES ('NS0002', 1, N'Tôi nhận thấy có một vết đen trên chiếc răng cửa sau bên trái và nghi ngờ răng bị hỏng. Tôi muốn làm sạch và lấy mảng cặn.', '0712345678');

INSERT INTO LICHHEN (MANS, SOTT, LYDOKHAM, SODT)
VALUES ('NS0003', 1, N'Lợi của tôi thường bị sưng và chảy máu khi chải răng. Tôi lo lắng về tình trạng viêm nướu này và muốn tư vấn và điều trị.', '0987654321');

INSERT INTO LICHHEN (MANS, SOTT, LYDOKHAM, SODT)
VALUES ('NS0004', 1, N'Chiếc răng trước cửa đã bị nứt và tôi cảm thấy đau.', '0301234567');

INSERT INTO LICHHEN (MANS, SOTT, LYDOKHAM, SODT)
VALUES ('NS0008', 1, N'Mặt nướu ở phía dưới răng cửa sau bên phải đã sưng lên và tôi cảm thấy đau hàm mặt khi nhai.', '0743216549');

INSERT INTO LICHHEN (MANS, SOTT, LYDOKHAM, SODT)
VALUES ('NS0009', 1, N'Nghi ngờ có vết thương trong miệng. Tôi thấy có một vết thương nhỏ trên bên trong má lúp và lo lắng về tính trạng này.', '0912345678');

INSERT INTO LICHHEN (MANS, SOTT, LYDOKHAM, SODT)
VALUES ('NS0010', 1, N'Răng của tôi lệch và tôi muốn tư vấn về cách chỉnh nha.', '0378236541');

INSERT INTO LICHHEN (MANS, SOTT, LYDOKHAM, SODT)
VALUES ('NS0003', 2, N'Răng xấu, cần được khám và tư vấn niềng răng.', '0723456789');

INSERT INTO LICHHEN (MANS, SOTT, LYDOKHAM, SODT)
VALUES ('NS0009', 2, N'Mất một chiếc răng mọc ở phía trên và lo lắng về việc điều này có thể ảnh hưởng đến cách nhai và nụ cười của tôi.', '0923456780');

INSERT INTO LICHHEN (MANS, SOTT, LYDOKHAM, SODT)
VALUES ('NS0001', 2, N'Nhổ răng khôn', '0345678901');

INSERT INTO LICHHEN (MANS, SOTT, LYDOKHAM, SODT)
VALUES ('NS0005', 1, N'Thay răng giả. Tôi muốn thay chiếc răng giả cũ bằng một chiếc mới để đảm bảo chúng vẫn hoạt động tốt.', '0765432109');

INSERT INTO LICHHEN (MANS, SOTT, LYDOKHAM, SODT)
VALUES ('NS0006', 1, N'Người thân tôi nói rằng tôi kêu răng khi ngủ, và tôi muốn kiểm tra xem có vấn đề gì về nha khoa gây ra điều này.', '0387654321');

--Thêm hồ sơ bệnh án
INSERT INTO HOSOBENH(SODT, SOTT, NGAYKHAM, DANDO, MANS, _DAXUATHOADON)
VALUES
('0323456789', 1, '2024-01-05', N'Chải răng cẩn thận, ít nhất hai lần mỗi ngày. Sử dụng bàn chải mềm và kem đánh răng chứa fluor. Hạn chế thức ăn và đồ uống nóng hoặc lạnh.', 'NS0001', 1),
('0712345678', 1, '2024-01-02', N'Làm sạch răng bằng cách sử dụng chỉ nha khoa và bàn chải mềm mỗi ngày để tránh tái diễn tình trạng này trong tương lai. Không cần tái khám.', 'NS0002', 1),
('0987654321', 1, '2024-01-07', N'Hạn chế thức ăn nóng hoặc cay và hãy duy trì vệ sinh miệng đúng cách. Uống thuốc theo toa đã chỉ định và tái khám sau 2 tuần. Nếu vết viêm không giảm, cần đến khám ngay.', 'NS0003', 1),
('0301234567', 1, '2024-01-02', N'Đề nghị tránh những thức ăn cứng hoặc nhai mạnh, và tránh lâu dài trong nhiệt độ lạnh hoặc nóng. Uống thuốc theo toa đã chỉ định và tái khám sau 2 tuần.', 'NS0004', 1),
('0743216549', 1, '2024-01-02', N'Làm sạch kỹ miệng và nướu hàng ngày. Hạn chế thức ăn và đồ uống có nhiều đường.', 'NS0008', 1),
('0912345678', 1, '2024-01-05', N'Cần tiếp tục chăm sóc và tự theo dõi vết thương tại nhà. Nếu vết thương không lành hoặc tình trạng trở nên nghiêm trọng hơn, hãy quay lại để kiểm tra. Uống thuốc đều đặn theo toa đã kê.', 'NS0009', 1),
('0378236541', 1, '2024-01-03', N'Tuân thủ lịch hẹn kiểm tra định kỳ và duy trì vệ sinh miệng tốt. Tránh thức ăn cứng và cẩn thận với việc sử dụng răng để cắn các vật cứng. Nếu có triệu chứng bất thường, vui lòng đến kiểm tra ngay.', 'NS0010', 1),
('0723456789', 1, '2024-01-03', N'Tuân thủ lịch hẹn kiểm tra định kỳ và duy trì vệ sinh miệng tốt. Tránh thức ăn cứng và cẩn thận với việc sử dụng răng để cắn các vật cứng. Nếu có triệu chứng bất thường, vui lòng đến kiểm tra ngay.', 'NS0003', 1),
('0923456780', 1, '2024-01-05', N'Sau cấy ghép implant, hạn chế ăn thực phẩm cứng, tránh hút thuốc, và thực hiện vệ sinh kỹ lưỡng vùng cấy ghép để đảm bảo quá trình phục hồi suôn sẻ.', 'NS0009', 1),
('0345678901', 1, '2024-01-05', N'Trong vài ngày đầu sau nhổ răng nên ăn đồ mềm và dễ tiêu hóa để xương hàm không phải làm việc nhiều. Không ăn thức ăn quá cứng, quá mặn, đồ ngọt, chua, cay, đồ uống có ga, cồn, quá nóng và các chất kích thích khác trong 2 ngày đầu tiên. Không hút thuốc trong ít nhất 3 ngày.', 'NS0001', 1),
('0765432109', 1, '2024-01-07', N'Hạn chế thức ăn cứng và cẩn thận không dùng răng giả để cắn vật cứng. Đảm bảo vệ sinh miệng đúng cách bằng cách đánh răng và súc miệng thường xuyên. Nếu có vấn đề hoặc triệu chứng lạ, nên liên hệ với nha sĩ ngay lập tức.', 'NS0005', 0),
('0387654321', 1, '2024-01-01', N'Trước khi ngủ, thư giãn bằng việc thực hiện các kỹ thuật thư giãn như thở sâu, tập yoga, hoặc lắng nghe âm nhạc. Sử dụng đồng hồ bảo vệ răng trong lúc ngủ.', 'NS0006', 0);

--Nhap lieu bang HOADON
INSERT INTO HOADON (SODT, SOTT, NGAYXUAT, _DATHANHTOAN, MANV)
VALUES ('0323456789', 1, '2024-01-05', 1, 'NV0001');

INSERT INTO HOADON (SODT, SOTT, NGAYXUAT, _DATHANHTOAN, MANV)
VALUES ('0712345678', 1, '2024-01-02', 1, 'NV0007');

INSERT INTO HOADON (SODT, SOTT, NGAYXUAT, _DATHANHTOAN, MANV)
VALUES ('0987654321', 1, '2024-01-07', 1, 'NV0001');

INSERT INTO HOADON (SODT, SOTT, NGAYXUAT, _DATHANHTOAN, MANV)
VALUES ('0301234567', 1, '2024-01-02', 1, 'NV0003');

INSERT INTO HOADON (SODT, SOTT, NGAYXUAT, _DATHANHTOAN, MANV)
VALUES ('0743216549', 1, '2024-01-02', 1, 'NV0003');

INSERT INTO HOADON (SODT, SOTT, NGAYXUAT, _DATHANHTOAN, MANV)
VALUES ('0912345678', 1, '2024-01-05', 1, 'NV0014');

INSERT INTO HOADON (SODT, SOTT, NGAYXUAT, MANV)
VALUES ('0378236541', 1, '2024-01-03', 'NV0012');

INSERT INTO HOADON (SODT, SOTT, NGAYXUAT, _DATHANHTOAN, MANV)
VALUES ('0723456789', 1, '2024-01-03', 1, 'NV0010');

INSERT INTO HOADON (SODT, SOTT, NGAYXUAT, _DATHANHTOAN, MANV)
VALUES ('0923456780', 1, '2024-01-05', 1, 'NV0008');

INSERT INTO HOADON (SODT, SOTT, NGAYXUAT, MANV)
VALUES ('0345678901', 1, '2024-01-05', 'NV0010');

SELECT * FROM LOAITHUOC
-- NHAP LOAI THUOC
INSERT INTO LOAITHUOC (MATHUOC, TENTHUOC, DONVITINH, CHIDINH, SLTON, SLNHAP, SLDAHUY, NGAYHETHAN, DONGIA) 
VALUES ('MT01', N'Paracetamol', N'Viên', 'Giảm đau nhẹ', 100, 200, 5, '2024-12-31', 5000);
INSERT INTO LOAITHUOC (MATHUOC, TENTHUOC, DONVITINH, CHIDINH, SLTON, SLNHAP, SLDAHUY, NGAYHETHAN, DONGIA) 
VALUES ('MT02', N'Amoxicillin', N'Hộp ', N'Kháng sinh phổ rộng', 50, 100, 1, '2024-08-31', 20000);
INSERT INTO LOAITHUOC (MATHUOC, TENTHUOC, DONVITINH, CHIDINH, SLTON, SLNHAP, SLDAHUY, NGAYHETHAN, DONGIA) 
VALUES ('MT03', N'Vitamin C', N'Chai ', N'Bổ sung vitamin C', 80, 100, 3, '2024-08-31', 12000);
INSERT INTO LOAITHUOC (MATHUOC, TENTHUOC, DONVITINH, CHIDINH, SLTON, SLNHAP, SLDAHUY, NGAYHETHAN, DONGIA) 
VALUES ('MT04', N'Vitamin B', N'Chai ', N'Bổ sung vitamin B', 80, 100, 3, '2024-08-31', 13000);
INSERT INTO LOAITHUOC (MATHUOC, TENTHUOC, DONVITINH, CHIDINH, SLTON, SLNHAP, SLDAHUY, NGAYHETHAN, DONGIA) 
VALUES ('MT05', N'Vitamin D', N'Chai ', N'Bổ sung vitamin D', 80, 100, 3, '2024-08-31', 14000);
INSERT INTO LOAITHUOC (MATHUOC, TENTHUOC, DONVITINH, CHIDINH, SLTON, SLNHAP, SLDAHUY, NGAYHETHAN, DONGIA) 
VALUES ('MT06', N'Vitamin E', N'Chai ', N'Bổ sung vitamin E', 80, 100, 3, '2024-08-31', 15000);
INSERT INTO LOAITHUOC (MATHUOC, TENTHUOC, DONVITINH, CHIDINH, SLTON, SLNHAP, SLDAHUY, NGAYHETHAN, DONGIA) 
VALUES ('MT07', N'Vitamin K', N'Chai ', N'Bổ sung vitamin K', 80, 100, 3, '2024-08-31', 16000);
INSERT INTO LOAITHUOC (MATHUOC, TENTHUOC, DONVITINH, CHIDINH, SLTON, SLNHAP, SLDAHUY, NGAYHETHAN, DONGIA) 
VALUES ('MT08', N'Vitamin A', N'Chai ', N'Bổ sung vitamin A', 80, 100, 3, '2024-08-31', 17000);
INSERT INTO LOAITHUOC (MATHUOC, TENTHUOC, DONVITINH, CHIDINH, SLTON, SLNHAP, SLDAHUY, NGAYHETHAN, DONGIA) 
VALUES ('MT09', N'Vitamin B1', N'Chai ', N'Bổ sung vitamin B1', 80, 100, 3, '2024-08-31', 17000);
INSERT INTO LOAITHUOC (MATHUOC, TENTHUOC, DONVITINH, CHIDINH, SLTON, SLNHAP, SLDAHUY, NGAYHETHAN, DONGIA) 
VALUES ('MT10', N'Vitamin B2', N'Chai ', N'Bổ sung vitamin B2', 80, 100, 3, '2024-08-31', 15000);
INSERT INTO LOAITHUOC (MATHUOC, TENTHUOC, DONVITINH, CHIDINH, SLTON, SLNHAP, SLDAHUY, NGAYHETHAN, DONGIA) 
VALUES ('MT11', N'Vitamin B3', N'Chai ', N'Bổ sung vitamin B3', 80, 100, 3, '2024-08-31', 20000);
INSERT INTO LOAITHUOC (MATHUOC, TENTHUOC, DONVITINH, CHIDINH, SLTON, SLNHAP, SLDAHUY, NGAYHETHAN, DONGIA) 
VALUES ('MT12', N'Vitamin B5', N'Chai ', N'Bổ sung vitamin B5', 80, 100, 3, '2024-08-31', 40000);
INSERT INTO LOAITHUOC (MATHUOC, TENTHUOC, DONVITINH, CHIDINH, SLTON, SLNHAP, SLDAHUY, NGAYHETHAN, DONGIA) 
VALUES ('MT13', N'Vitamin B6', N'Chai ', N'Bổ sung vitamin B6', 80, 100, 3, '2024-08-31', 60000);
INSERT INTO LOAITHUOC (MATHUOC, TENTHUOC, DONVITINH, CHIDINH, SLTON, SLNHAP, SLDAHUY, NGAYHETHAN, DONGIA) 
VALUES ('MT14', N'Vitamin B7', N'Chai ', N'Bổ sung vitamin B7', 80, 100, 3, '2024-08-31', 70000);

-- -THEM LOAI DICH VU
INSERT INTO LOAIDICHVU (MADV, TENDV, MOTA, DONGIA)
VALUES('DV01', N'Khám răng', N'Dịch vụ này bao gồm việc khám và tư vấn về tình trạng răng miệng của bệnh nhân', 200000);
INSERT INTO LOAIDICHVU (MADV, TENDV, MOTA, DONGIA)
VALUES('DV02', N'Chụp X-quang', N'Dịch vụ này cung cấp việc chụp X-quang để đánh giá và chuẩn đoán tình trạng răng miệng', 150000);
INSERT INTO LOAIDICHVU (MADV, TENDV, MOTA, DONGIA)
VALUES('DV03', N'Đắp răng khiểng', N'Dịch vụ này đảm nhiệm việc đắp răng khiểng để điều chỉnh vị trí của răng', 500000);
INSERT INTO LOAIDICHVU (MADV, TENDV, MOTA, DONGIA)
VALUES('DV04', N'Tẩy trắng răng', N'Dịch vụ này cung cấp việc tẩy trắng răng để làm sáng và làm trắng răng', 500000);
INSERT INTO LOAIDICHVU (MADV, TENDV, MOTA, DONGIA)
VALUES('DV05', N'Bọc răng sứ' , N'Dịch vụ này bao gồm việc bọc răng bằng vật liệu sứ để cải thiện ngoại hình và chức năng của răng', 1000000);
INSERT INTO LOAIDICHVU (MADV, TENDV, MOTA, DONGIA)
VALUES('DV06', N'Cấy ghép Implant', N'Dịch vụ này liên quan đến việc cấy ghép Implant nha khoa để thay thế răng hoặc hỗ trợ các công việc nha khoa khác', 2000000);
INSERT INTO LOAIDICHVU (MADV, TENDV, MOTA, DONGIA)
VALUES('DV07', N'Chỉnh nha', N'Dịch vụ này đảm nhiệm việc chỉnh nha để điều chỉnh vị trí của răng và cải thiện hàm răng', 5000000);
INSERT INTO LOAIDICHVU (MADV, TENDV, MOTA, DONGIA)
VALUES('DV08', N'Phục hình răng sứ', N'Dịch vụ này liên quan đến việc phục hình răng bằng vật liệu sứ để khôi phục ngoại hình và chức năng của răng', 1000000);
INSERT INTO LOAIDICHVU (MADV, TENDV, MOTA, DONGIA)
VALUES('DV09', N'Cạo vôi răng', N'Dịch vụ này bao gồm việc cạo vôi trên bề mặt răng nhằm loại bỏ mảng bám và tái tạo vệ sinh răng miệng', 500000);
INSERT INTO LOAIDICHVU (MADV, TENDV, MOTA, DONGIA)
VALUES('DV10', N'Nhổ răng', N'Dịch vụ này đảm nhiệm việc nhổ răng khi cần thiết, bao gồm cả nhổ răng khôn', 250000);
INSERT INTO LOAIDICHVU (MADV, TENDV, MOTA, DONGIA)
VALUES('DV11', N'Chữa nha chu', N'Dịch vụ này cung cấp việc chữa trị các bệnh nha chu như viêm nướu, chảy máu nướu, và hôi miệng', 300000);
INSERT INTO LOAIDICHVU (MADV, TENDV, MOTA, DONGIA)
VALUES('DV12', N'Phẫu thuật trong miệng', N'Dịch vụ này liên quan đến việc phẫu thuật trong miệng như tạo hình lợi, tạo hình mô mềm, hoặc phẫu thuật tuyến nước bọt', 5000000);
INSERT INTO LOAIDICHVU (MADV, TENDV, MOTA, DONGIA)
VALUES('DV13', N'Chữa tủy răng trẻ em', N'Dịch vụ này cung cấp việc chữa trị tủy răng trẻ em, bao gồm cả việc cấp cứu trong trường hợp cần thiết', 1000000);
INSERT INTO LOAIDICHVU (MADV, TENDV, MOTA, DONGIA)
VALUES('DV14', N'Trám răng sữa trẻ em', N'Dịch vụ này liên quan đến việc chữa trị các vấn đề răng nội nha như viêm tủy, nhiễm trùng, hoặc đau răng ADD', 500000);
INSERT INTO LOAIDICHVU (MADV, TENDV, MOTA, DONGIA)
VALUES('DV15', N'Chữa răng nội nha', N'Dịch vụ này bao gồm việc phục hình răng giả để thay thế răng mất, cung cấp chức năng hàm răng', 500000);
INSERT INTO LOAIDICHVU (MADV, TENDV, MOTA, DONGIA)
VALUES('DV16', N'Phục hình răng giả', N'Dịch vụ này đảm nhiệm việc làm cầu răng bằng vật liệu sứ để thay thế nhiều răng mất liên tiếp', 500000);
INSERT INTO LOAIDICHVU (MADV, TENDV, MOTA, DONGIA)
VALUES('DV17', N'Cầu răng sứ', N'Dịch vụ này cung cấp các dịch vụ nha khoa tổng quát như khám răng', 1100000);
INSERT INTO LOAIDICHVU (MADV, TENDV, MOTA, DONGIA)
VALUES('DV18', N'Nha khoa tổng quát', N'Dịch vụ này cung cấp các dịch vụ nha khoa tổng quát như khám răng, tẩy trắng, trám răng, và chữa trị các vấn đề thông thường', 350000);
INSERT INTO LOAIDICHVU (MADV, TENDV, MOTA, DONGIA)
VALUES('DV19', N'Nha khoa thẩm mỹ', N'Dịch vụ này liên quan đến việc cải thiện ngoại hình và thẩm mỹ răng miệng bằng các phương pháp như tẩy trắng, bọc răng sứ, chỉnh nha thẩm mỹ', 500000);
INSERT INTO LOAIDICHVU (MADV, TENDV, MOTA, DONGIA)
VALUES('DV20', N'Đính đá răng' , N'Dịch vụ này bao gồm việc đính đá ngọc trên răng để tạo điểm nhấn và thẩm mỹ cho những người muốn trang trí cho nụ cười của mình', 100000);
INSERT INTO LOAIDICHVU (MADV, TENDV, MOTA, DONGIA)
VALUES('DV21', N'Chỉnh nha thẩm mỹ', N'Dịch vụ này đảm nhiệm việc chỉnh nha nhằm cải thiện vị trí và hình dáng của răng một cách thẩm mỹ', 1000000);

--Thêm chi tiết thuốc
INSERT INTO CHITIETTHUOC (MATHUOC, SODT, SOTT, THOIDIEMDUNG)
VALUES
('MT01', '0323456789', 1, '"Buổi sáng: 1 viên thuốc sau bữa sáng.\nBuổi trưa: 1 viên thuốc sau bữa trưa.\nBuổi tối: 1 viên thuốc sau bữa tối.\n"'),
('MT02', '0323456789', 1, '"Buổi sáng: 1 viên thuốc sau bữa sáng.\nBuổi trưa: 1 viên thuốc sau bữa trưa.\nBuổi tối: 1 viên thuốc sau bữa tối.\n"'),
('MT08', '0323456789', 1, '"Buổi sáng: 1 viên thuốc sau bữa sáng.\nBuổi trưa: 1 viên thuốc sau bữa trưa.\nBuổi tối: 1 viên thuốc sau bữa tối.\n"'),
('MT03', '0712345678', 1, '"Buổi sáng: 1 viên thuốc sau bữa sáng.\nBuổi trưa: 1 viên thuốc sau bữa trưa.\nBuổi tối: 1 viên thuốc sau bữa tối.\n"'),
('MT02', '0987654321', 1, '"Buổi sáng: 1 viên thuốc sau bữa sáng.\nBuổi trưa: 1 viên thuốc sau bữa trưa.\nBuổi tối: 1 viên thuốc sau bữa tối.\n"'),
('MT05', '0301234567', 1, '"Buổi sáng: 1 viên thuốc sau bữa sáng.\nBuổi trưa: 1 viên thuốc sau bữa trưa.\nBuổi tối: 1 viên thuốc sau bữa tối.\n"'),
('MT03', '0923456780', 1, '"Buổi sáng: 1 viên thuốc sau bữa sáng.\nBuổi trưa: 1 viên thuốc sau bữa trưa.\nBuổi tối: 1 viên thuốc sau bữa tối.\n"'),
('MT09', '0923456780', 1, '"Buổi sáng: 1 viên thuốc sau bữa sáng.\nBuổi trưa: 1 viên thuốc sau bữa trưa.\nBuổi tối: 1 viên thuốc sau bữa tối.\n"'),
('MT10', '0387654321', 1, '"Buổi sáng: 1 viên thuốc sau bữa sáng.\nBuổi trưa: 1 viên thuốc sau bữa trưa.\nBuổi tối: 1 viên thuốc sau bữa tối.\n"');
--Thêm chi tiết dịch vụ
INSERT INTO CHITIETDV (MADV, SOTT, SODT, SOLUONG)
VALUES
('DV01', 1, '0323456789', 1),
('DV05', 1, '0712345678', 2),
('DV06', 1, '0987654321', 1),
('DV07', 1, '0301234567', 1),
('DV09', 1, '0743216549', 1),
('DV02', 1, '0912345678', 1),
('DV04', 1, '0378236541', 1),
('DV02', 1, '0723456789', 1),
('DV17', 1, '0923456780', 1),
('DV21', 1, '0345678901', 1),
('DV13', 1, '0765432109', 1),
('DV10', 1, '0387654321', 1),
('DV20', 1, '0387654321', 1),
('DV06', 1, '0765432109', 1);





