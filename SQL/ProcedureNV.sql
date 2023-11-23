USE PKNHAKHOA
GO
--------------------------
--NV01/ XEM LỊCH TRỰC TỪ NGÀY HIỆN TẠI ĐẾN 7 NGÀY KẾ CỦA NHA SĨ
GO
CREATE OR ALTER PROC SP_GETLICHRANHNS_NV
AS
BEGIN TRAN
	BEGIN TRY
		-- LICH CO HEN CUA NHA SI
		SELECT NGAY, CA.MACA, GIOBATDAU, GIOKETTHUC, LH.SOTT SOTTLH, LH.MANS, NS.HOTEN HOTENNS, KH.SODT SODTKH, KH.HOTEN HOTENKH, LH.LYDOKHAM LYDOKHAM
		FROM LICHHEN LH
		JOIN NHASI NS ON NS.MANS = LH.MANS
		JOIN LICHRANH LR2 ON LR2.MANS = LH.MANS AND LH.SOTT = LR2.SOTT
		JOIN CA ON CA.MACA = LR2.MACA
		JOIN KHACHHANG KH ON KH.SODT = LH.SODT
		WHERE DATEDIFF(DAY,GETDATE(), NGAY) <= 7
		ORDER BY NGAY 

		-- LICH CHUA CO HEN CUA NHA SI
		SELECT NGAY, CA.MACA, GIOBATDAU, GIOKETTHUC, LR.SOTT SOTTLR, LR.MANS, HOTEN HOTENNS
		FROM LICHRANH LR
		JOIN CA ON CA.MACA = LR.MACA
		JOIN NHASI NS ON NS.MANS = LR.MANS
		WHERE NOT EXISTS 
		(
			SELECT 1
			FROM LICHHEN LH
			WHERE LH.MANS = LR.MANS AND LH.SOTT = LR.SOTT
		)
		AND DATEDIFF(DAY,GETDATE(), NGAY) <= 7
		ORDER BY NGAY 
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN;
		DECLARE @errorMessage NVARCHAR(200) = ERROR_MESSAGE();
		THROW 51000, @errorMessage, 1;
		RETURN
	END CATCH
COMMIT TRAN
------------------------
--NV02/ TẠO TÀI KHOẢN KHÁCH HÀNG()
GO
CREATE OR ALTER PROC SP_TAOTKKH_NV
	@SODT VARCHAR(100),
	@HOTEN NVARCHAR(50),
	@PHAI NVARCHAR(5),
	@NGAYSINH DATE,
	@DIACHI NVARCHAR(250)
AS
BEGIN TRAN
	BEGIN TRY
		IF EXISTS(SELECT 1 FROM KHACHHANG WHERE SODT = @SODT)
			OR EXISTS(SELECT 1 FROM QTV WHERE MAQTV = @SODT)
			OR EXISTS(SELECT 1 FROM NHANVIEN WHERE MANV = @SODT)
			OR EXISTS(SELECT 1 FROM NHASI WHERE MANS = @SODT)
		BEGIN
			RAISERROR(N'Tài khoản đã tồn tại trong hệ thống', 16, 1);
			ROLLBACK TRAN
			RETURN
		END
		ELSE
		BEGIN
			DECLARE @MATKHAU VARCHAR(100);
			SET @MATKHAU = FORMAT(@NGAYSINH, 'ddMMyyyy');
			INSERT INTO KHACHHANG(SODT, HOTEN, PHAI, NGAYSINH, DIACHI, MATKHAU) 
			VALUES(@SODT, @HOTEN, @PHAI, @NGAYSINH, @DIACHI, @MATKHAU)
		END
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN;
		DECLARE @errorMessage NVARCHAR(200) = ERROR_MESSAGE();
		THROW 51000, @errorMessage, 1;
		RETURN
	END CATCH
COMMIT TRAN
---------------------------
--NV03/ TẠO HÓA ĐƠN
GO
CREATE OR ALTER PROC SP_TAOHOADON_NV
	@SODT VARCHAR(100),
	@SOTT INT,
	@MANV VARCHAR(100)
AS
BEGIN TRAN
	BEGIN TRY
		IF EXISTS(SELECT 1 FROM HOSOBENH WHERE SODT = @SODT AND SOTT = @SODT)
		BEGIN
			RAISERROR(N'Hồ sơ bệnh không tồn tại', 16, 1);
			ROLLBACK TRAN
			RETURN
		END

		IF EXISTS(SELECT 1 FROM HOSOBENH WHERE SODT = @SODT AND SOTT = @SODT AND _DAXUATHOADON = 1)
		BEGIN
			RAISERROR(N'Hồ sơ bệnh đã được xuất hóa đơn', 16, 1);
			ROLLBACK TRAN
			RETURN
		END

		IF NOT EXISTS(SELECT 1 FROM CHITIETDV WHERE SODT = @SODT AND SOTT = @SOTT)
		BEGIN
			RAISERROR(N'Hồ sơ bệnh chưa được thêm dịch vụ vào', 16, 1);
			ROLLBACK TRAN
			RETURN
		END
		ELSE

		BEGIN
			DECLARE @TONGCHIPHI FLOAT;
			DECLARE @TIENDV FLOAT
			DECLARE @TIENTHUOC FLOAT;

			SELECT @TIENTHUOC = ISNULL(SUM(DONGIALUCTHEM * SOLUONG), 0)
			FROM CHITIETTHUOC CTT
			WHERE CTT.SODT = @SODT AND CTT.SOTT = @SOTT;

			SELECT @TIENDV = ISNULL(SUM(DONGIALUCTHEM * SOLUONG), 0)
			FROM CHITIETDV CTDV
			WHERE CTDV.SODT = @SODT AND CTDV.SOTT = @SOTT;
			
			SET @TONGCHIPHI = @TIENTHUOC + @TIENDV

			INSERT INTO HOADON(SODT, SOTT, NGAYXUAT, TONGCHIPHI, _DATHANHTOAN, MANV)
			VALUES(@SODT, @SOTT, GETDATE(), @TONGCHIPHI, 0, @MANV)

			UPDATE HOSOBENH 
			SET _DAXUATHOADON = 1
			WHERE SOTT = @SOTT AND SODT = @SODT

			SELECT KH.HOTEN HOTENKH, HD.SODT SODT, HD.SOTT SOTTHD, NGAYXUAT, TONGCHIPHI, NV.MANV MANV, NV.HOTEN HOTENNV, _DATHANHTOAN, CTDV.MADV, TENDV, CTDV.SOLUONG, LDV.DONGIA, CTT.MATHUOC, TENTHUOC, CTT.SOLUONG, LT.DONGIA
			FROM HOADON HD
			JOIN KHACHHANG KH ON HD.SODT = KH.SODT
			JOIN NHANVIEN NV ON NV.MANV = HD.MANV
			JOIN CHITIETDV CTDV ON CTDV.SODT = HD.SODT AND CTDV.SOTT = HD.SOTT
			LEFT JOIN CHITIETTHUOC CTT ON CTT.SODT = HD.SODT AND CTT.SOTT = HD.SOTT
			WHERE HD.SOTT = @SOTT AND HD.SODT = @SODT
		END
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN;
		DECLARE @errorMessage NVARCHAR(200) = ERROR_MESSAGE();
		THROW 51000, @errorMessage, 1;
		RETURN
	END CATCH
COMMIT TRAN
---------------
--NV04/ XÁC NHẬN THANH TOÁN HÓA ĐƠN
GO
CREATE OR ALTER PROC SP_THANHTOANHOADON_NV
	@SODT VARCHAR(100),
	@SOTT INT
AS
BEGIN TRAN
	BEGIN TRY
		IF (NOT EXISTS(SELECT * FROM HOADON WHERE SODT = @SODT AND SOTT = @SOTT))
		BEGIN
			RAISERROR(N'Hoá đơn này không tồn tại', 16, 1);
			ROLLBACK TRAN
			RETURN
		END

		IF (EXISTS(SELECT * FROM HOADON WHERE SODT = @SODT AND SOTT = @SOTT AND _DATHANHTOAN = 1))
		BEGIN
			RAISERROR(N'Hoá đơn này đã được thanh toán', 16, 1);
			ROLLBACK TRAN
			RETURN
		END
		
		ELSE
		BEGIN
			UPDATE HOADON
			SET	_DATHANHTOAN = 1
			WHERE SODT = @SODT AND SOTT = @SOTT
		END
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN;
		DECLARE @errorMessage NVARCHAR(200) = ERROR_MESSAGE();
		THROW 51000, @errorMessage, 1;
		RETURN
	END CATCH
COMMIT TRAN
-------------------------------------------
--NV05/ TRUY VẤN HÓA ĐƠN
GO
CREATE OR ALTER PROC SP_GETHOADON1KH_NV
	@SODT VARCHAR(100)
AS
BEGIN TRAN
	BEGIN TRY
		IF (NOT EXISTS(SELECT * FROM KHACHHANG WHERE SODT = @SODT))
		BEGIN
			RAISERROR(N'Tài khoản này không tồn tại', 16, 1);
			ROLLBACK TRAN
			RETURN
		END
		
		IF (NOT EXISTS(SELECT * FROM HOADON WHERE SODT = @SODT))
		BEGIN
			RAISERROR(N'Tài khoản không có hóa đơn nào', 16, 1);
			ROLLBACK TRAN
			RETURN
		END

		ELSE
		BEGIN
			SELECT KH.HOTEN, HD.SODT SODT, HD.SOTT ,NGAYXUAT, TONGCHIPHI, NV.HOTEN NVXUATHD, LDV.MADV, CTDV.SOLUONG, LDV.DONGIA, CTT.MATHUOC,TENTHUOC, CTT.SOLUONG, LT.DONGIA
			FROM HOADON HD
			JOIN KHACHHANG KH ON HD.SODT = KH.SODT
			JOIN NHANVIEN NV ON NV.MANV = HD.MANV
			JOIN CHITIETDV CTDV ON CTDV.SODT = HD.SODT AND CTDV.SOTT = HD.SOTT
			JOIN LOAIDICHVU LDV ON LDV.MADV = CTDV.MADV
			LEFT JOIN CHITIETTHUOC CTT ON CTT.SODT = HD.SODT AND CTT.SOTT = HD.SOTT
			LEFT JOIN LOAITHUOC	LT ON LT.MATHUOC = CTT.MATHUOC
			WHERE HD.SODT = @SODT
			ORDER BY HD.SOTT
		END
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN;
		DECLARE @errorMessage NVARCHAR(200) = ERROR_MESSAGE();
		THROW 51000, @errorMessage, 1;
		RETURN
	END CATCH
COMMIT TRAN