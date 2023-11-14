USE PKNHAKHOA
GO

-- THÊM LOẠI THUỐC MỚI
CREATE PROCEDURE SP_THEMLOAITHUOC_QTV
    @TENTHUOC NVARCHAR(100),
    @DONVITINH NVARCHAR(50),
    @CHIDINH NVARCHAR(500),

    @SLNHAP INT,

    @NGAYHETHAN DATE,
    @DONGIA FLOAT
AS
BEGIN
    DECLARE @NewMATHUOC VARCHAR(10);

    SELECT @NewMATHUOC = COALESCE(MAX(MATHUOC), 'MT01')
    FROM LOAITHUOC;
    SET @NewMATHUOC = 'MT' + RIGHT('00' + CAST(CAST(RIGHT(@NewMATHUOC, 2) AS INT) + 1 AS VARCHAR(2)), 2);
    INSERT INTO LOAITHUOC
        (MATHUOC, TENTHUOC, DONVITINH, CHIDINH, SLTON, SLNHAP, SLDAHUY, NGAYHETHAN, DONGIA)
    VALUES
        (@NewMATHUOC, @TENTHUOC, @DONVITINH, @CHIDINH, @SLNHAP, @SLNHAP, 0, @NGAYHETHAN, @DONGIA);
END;
GO

-- HỦY LOẠI THUỐC
CREATE PROCEDURE SP_HUYTHUOC_QTV
    @MATHUOC VARCHAR(10)
AS
BEGIN
    DECLARE @NGAYHETHAN DATE;

    SELECT @NGAYHETHAN = NGAYHETHAN
    FROM LOAITHUOC
    WHERE MATHUOC = @MATHUOC;

    IF @NGAYHETHAN < GETDATE()
    BEGIN
    
        UPDATE LOAITHUOC
        SET SLDAHUY = SLDAHUY + SLTON, SLTON = 0
        WHERE MATHUOC = @MATHUOC;
    END
    ELSE
    BEGIN
        PRINT 'Không thể hủy thuốc vì chưa hết hạn.';
    END
END;
GO
-- CẬP NHẬT THUỐC
CREATE PROCEDURE SP_CAPNHATLOAITHUOC_QTV
    @MATHUOC VARCHAR(10),
    @TENTHUOC NVARCHAR(50) = NULL,
    @CHIDINH NVARCHAR(500) = NULL,
    @DONGIA FLOAT = NULL
AS
BEGIN
    IF @CHIDINH IS NOT NULL OR @DONGIA IS NOT NULL
    BEGIN
        UPDATE LOAITHUOC
        SET 
            TENTHUOC = ISNULL(@TENTHUOC,TENTHUOC),
            CHIDINH = ISNULL(@CHIDINH, CHIDINH),
            DONGIA = ISNULL(@DONGIA, DONGIA)
        WHERE MATHUOC = @MATHUOC;
    END
    ELSE
    BEGIN
        PRINT 'Không có thông tin mới để cập nhật.';
    END
END;
GO

-- NHẬP THUỐC
CREATE PROCEDURE SP_NHAPTHEMTHUOC_QTV
    @MATHUOC VARCHAR(10),
    @SOLUONGNHAP INT,
    @NGAYHETHAN DATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @SLTON_OLD INT, @SLTON_NEW INT, @SLNHAP_OLD INT, @SLNHAP_NEW INT, @NGAYHETHAN_OLD DATE;

    SELECT @SLTON_OLD = ISNULL(SLTON, 0), @NGAYHETHAN_OLD = NGAYHETHAN, @SLNHAP_OLD = SLNHAP
    FROM LOAITHUOC
    WHERE MATHUOC = @MATHUOC;


    IF @NGAYHETHAN_OLD <= GETDATE() OR @SLTON_OLD = 0
    BEGIN
        
        SET @SLTON_NEW = @SOLUONGNHAP;
        SET @SLNHAP_NEW = @SLNHAP_OLD + @SOLUONGNHAP;

        UPDATE LOAITHUOC
        SET SLTON = @SLTON_NEW, SLNHAP = @SLNHAP_NEW, NGAYHETHAN = @NGAYHETHAN
        WHERE MATHUOC = @MATHUOC;

    END
    ELSE
    BEGIN
        PRINT 'Ngày hết hạn không hợp lệ hoặc thuốc đã hết hạn.';
    END
END;
go

-- THÊM DV
CREATE PROCEDURE SP_THEMDICHVU_QTV
    @TENDV NVARCHAR(100),
    @CHITIET NVARCHAR(500),
    @DONGIA INT
AS
BEGIN
    DECLARE @NewMADV VARCHAR(10);

    SELECT @NewMADV = COALESCE(MAX(MADV), 'DV01')
    FROM LOAIDICHVU;
    SET @NewMADV = 'DV' + RIGHT('00' + CAST(CAST(RIGHT(@NewMADV, 2) AS INT) + 1 AS VARCHAR(2)), 2);

    INSERT INTO LOAIDICHVU
        (MADV, TENDV, MOTA, DONGIA)
    VALUES
        (@NewMADV, @TENDV, @CHITIET, @DONGIA);
END;
GO

-- CẬP NHẬT DV
CREATE PROCEDURE SP_CAPNHATDICHVU_QTV
    @MADV VARCHAR(10),
    @TENDV NVARCHAR(100) = NULL,
    @CHITIET NVARCHAR(500) = NULL,
    @DONGIA INT = NULL
AS
BEGIN
    IF @TENDV IS NOT NULL OR @CHITIET IS NOT NULL OR @DONGIA IS NOT NULL
    BEGIN
        UPDATE LOAIDICHVU
        SET TENDV = ISNULL(@TENDV, TENDV),
            MOTA = ISNULL(@CHITIET, MOTA),
            DONGIA = ISNULL(@DONGIA, DONGIA)
        WHERE MADV = @MADV;
    END
    ELSE
    BEGIN
        PRINT 'Không có thông tin nào được cập nhật.';
    END
END;
GO
-- XEM DS NHA SĨ
CREATE PROCEDURE SP_XEMDANHSACHNHASI
AS
BEGIN
    SET NOCOUNT ON;

    SELECT MANS, HOTEN, PHAI, GIOITHIEU
    FROM NHASI;
END;
GO






--15. Khóa tài khoản nha sĩ
CREATE OR ALTER PROC SP_KHOA_TAI_KHOAN_NHA_SI
    @MA_NS VARCHAR(10)
AS

BEGIN TRAN
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM NHASI WHERE MANS = @MA_NS)
        BEGIN
            UPDATE NHASI
            SET _DAKHOA = 1
            WHERE MANS = @MA_NS
        END
        ELSE
        BEGIN
            RAISERROR('Không tồn tại mã nha sĩ này', 16, 1)
            ROLLBACK TRAN
            RETURN
        END
    END TRY

    BEGIN CATCH
        ROLLBACK TRAN
    END CATCH
COMMIT TRAN





--16. Mở tài khoản nha sĩ
CREATE OR ALTER PROC SP_MO_TAI_KHOAN_NHA_SI
    @MA_NS VARCHAR(10)
AS

BEGIN TRAN
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM NHASI WHERE MANS = @MA_NS)
        BEGIN
            UPDATE NHASI
            SET _DAKHOA = 0
            WHERE MANS = @MA_NS
        END
        ELSE
        BEGIN
            RAISERROR('Không tồn tại mã nha sĩ này', 16, 1)
            ROLLBACK TRAN
            RETURN
        END
    END TRY
    BEGIN CATCH
        ROLLBACK TRAN
    END CATCH
COMMIT TRAN

--17. Xem danh sách QTV
XEM HET TAT CA CAC THUOC TINH CUA QTV TRU MAT KHAU

CREATE OR ALTER PROC SP_XEM_DANH_SACH_QTV
AS
BEGIN TRAN
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM QTV)
        BEGIN
            SELECT QTV.MAQTV,QTV.HOTEN,QTV.PHAI FROM QTV
        END
        ELSE
        BEGIN
            RAISERROR('Không tồn tại quản trị viên nào', 16, 1)
            ROLLBACK TRAN
            RETURN
        END
    END TRY

    BEGIN CATCH
        ROLLBACK TRAN
    END CATCH
COMMIT TRAN


--18. Tạo Quản trị viên mới
CREATE OR ALTER PROC SP_TAO_QTV_MOI

    @HOTEN VARCHAR(50),
    @PHAI NVARCHAR(5)
   
AS
BEGIN TRAN
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM QTV)
        BEGIN
            INSERT INTO QTV(HOTEN,PHAI)
            VALUES(@HOTEN,@PHAI)
        END
        ELSE
        BEGIN
            RAISERROR('Không thể tạo quản trị viên mới', 16, 1)
            ROLLBACK TRAN
            RETURN
        END
    END TRY

    BEGIN CATCH
        ROLLBACK TRAN
    END CATCH
COMMIT TRAN
--19. Xem danh sách khách hàng 
CREATE OR ALTER PROC SP_XEM_DANH_SACH_KHACH_HANG

AS
BEGIN TRAN
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM KHACHHANG)
        BEGIN
            SELECT KH.SODT,KH.HOTEN,KH.PHAI,KH.NGAYSINH,KH.DIACHI,KH._DAKHOA
            FROM KHACHHANG KH
        END
        ELSE
        BEGIN
            RAISERROR('Không tìm thấy danh sách khách hàng nào', 16, 1)
            ROLLBACK TRAN
            RETURN
        END
    END TRY

    BEGIN CATCH
        ROLLBACK TRAN
    END CATCH
COMMIT TRAN

--20. Khóa Tài khoản khách hàng
CREATE OR ALTER PROC SP_XEM_DANH_SACH_KHACH_HANG
    @SODT VARCHAR(20)
AS
BEGIN TRAN
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM KHACHHANG WHERE SODT = @SODT)
        BEGIN
            UPDATE KHACHHANG
            SET _DAKHOA = 1
            WHERE SODT = @SODT
        END
        ELSE
        BEGIN
            RAISERROR('Không tìm thấy khách hàng nào', 16, 1)
            ROLLBACK TRAN
            RETURN
        END
    END TRY

    BEGIN CATCH
        ROLLBACK TRAN
    END CATCH
COMMIT TRAN


--21. Mở tài khoản khách hàng
CREATE OR ALTER PROC SP_MO_TAI_KHOAN_KHACH_HANG
    @SODT VARCHAR(20)
AS
BEGIN TRAN
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM KHACHHANG WHERE SODT = @SODT)
        BEGIN
            UPDATE KHACHHANG
            SET _DAKHOA = 0
            WHERE SODT = @SODT
        END
        ELSE
        BEGIN
            RAISERROR('Không thẻ mở tài khoản khách hàng này', 16, 1)
            ROLLBACK TRAN
            RETURN
        END
    END TRY

    BEGIN CATCH
        ROLLBACK TRAN
    END CATCH
COMMIT TRAN