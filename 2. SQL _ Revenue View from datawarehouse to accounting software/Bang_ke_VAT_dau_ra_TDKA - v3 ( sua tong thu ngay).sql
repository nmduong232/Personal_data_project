/*
Danh sach bang thu
[dbo].[BangTHu_FE_Misa] >> done 
[dbo].[BangTHu_KA_Misa] >> done
[dbo].[Bangthu_MA_Misa] >> done 
[dbo].[BangTHu_PA_Misa] >> done
[dbo].[BangTHu_TC_Misa] >> done
[dbo].[BangTHu_VC_Misa] >> done 
*/

SELECT makh, tenkh INTO #tamtenkh FROM [DBTieuThuong].[dbo].[vTenKh]

-- BangTHu_VC_Misa
SELECT round((Tong_phi_KA/1.1),0) AS 'Phí dịch vụ', round((Tong_phi_KA/11),0) AS 'Thuế VAT (10%)'
, round(Tong_phi_KA,0) AS 'Tổng thanh toán'
, concat(N'Thu phí dịch vụ ngày ', abs(right(Ngaydong,2)), '/', abs((SUBSTRING(Ngaydong,5,2))), '/', LEFT(Ngaydong,4), N' của mã hợp đồng số ', a.MaHD_CRM) 
AS 'Ghi chú'
, Tongtienthu + Thudu AS 'Tổng thu ngày'
, MaHD_CRM AS 'Mã HĐ'
, 'VC' AS 'Đối tác'
, Ngaydong
FROM [DBTieuThuong].dbo.[BangTHu_VC_Misa] a left join #tamtenkh b ON a.Makh_CRM = b.Makh
WHERE Tong_phi_KA IS NOT NULL

UNION ALL

-- [dbo].[Bangthu_MA_Misa] - phai join them bang khachhang
SELECT round((Phi_KA/1.1),0) AS 'Phí dịch vụ', round((Phi_KA/11),0) AS 'Thuế VAT (10%)'
, round(Phi_KA,0) AS 'Tổng thanh toán'
, concat(N'Thu phí dịch vụ ngày ',day(ngay_dongthuc), '/', month(ngay_dongthuc), '/', year(ngay_dongthuc), N' của mã hợp đồng số ', a.mahd) 
AS 'Ghi chú'
, goc + Lai_MAFC + Phi_KA + Thudu AS 'Tổng thu ngày'
, mahd AS 'Mã HĐ'
, 'MA' AS 'Đối tác'
, dbo.getymd(ngay_dongthuc) AS Ngaydong
FROM [DBTieuThuong].dbo.Bangthu_MA_Misa a left join #tamtenkh b ON a.makh = b.Makh
WHERE Phi_KA IS NOT NULL

UNION ALL

-- [dbo].[BangTHu_PA_Misa]
SELECT round((Tong_Phi_KA/1.1),0) AS 'Phí dịch vụ', round((Tong_Phi_KA/11),0) AS 'Thuế VAT (10%)'
, round(Tong_Phi_KA,0) AS 'Tổng thanh toán'
, concat(N'Thu phí dịch vụ ngày ', abs(right(Ngaydong,2)), '/', abs((SUBSTRING(Ngaydong,5,2))), '/', LEFT(Ngaydong,4), N' của mã hợp đồng số ', a.Mahd_CRM)
AS 'Ghi chú'
, Tongtienthu + Thudu AS 'Tổng thu ngày'
, Mahd_CRM AS 'Mã HĐ'
, 'PA' AS 'Đối tác'
, Ngaydong
FROM [DBTieuThuong].dbo.BangTHu_PA_Misa a left join #tamtenkh b ON a.makh = b.Makh
WHERE Tonglai IS NOT NULL

UNION ALL

-- [dbo].[BangTHu_TC_Misa]
SELECT round((Tong_Phi_KA/1.1),0) AS 'Phí dịch vụ', round((Tong_Phi_KA/11),0) AS 'Thuế VAT (10%)'
, round(Tong_Phi_KA,0) AS 'Tổng thanh toán'
, concat(N'Thu phí dịch vụ ngày ', abs(right(Ngaydong,2)), '/', abs((SUBSTRING(Ngaydong,5,2))), '/', LEFT(Ngaydong,4), N' của mã hợp đồng số ', a.Mahd_CRM)
AS 'Ghi chú'
, Tongtienthu + Thudu AS 'Tổng thu ngày'
, Mahd_CRM AS 'Mã HĐ'
, 'TC' AS 'Đối tác'
, Ngaydong
FROM [DBTieuThuong].[dbo].[BangTHu_TC_Misa] a left join #tamtenkh b ON a.MaKH = b.Makh
WHERE Tonglai IS NOT NULL

UNION ALL

-- [dbo].[BangTHu_KA_Misa]
SELECT round((Thu_lai/1.1),0) AS 'Phí dịch vụ', round((Thu_lai/11),0) AS 'Thuế VAT (10%)'
, round(Thu_lai,0) AS 'Tổng thanh toán'
, concat(N'Thu phí dịch vụ ngày ',day(Ngaydong), '/', month(Ngaydong), '/', year(Ngaydong), N' của mã hợp đồng số ', a.Mahd_crm)
AS 'Ghi chú'
, Tongtienthu + THudu AS 'Tổng thu ngày'
, Mahd_crm AS 'Mã HĐ'
, 'KA' AS 'Đối tác'
, dbo.getymd(Ngaydong) AS Ngaydong
FROM [DBTieuThuong].[dbo].[BangTHu_KA_Misa] a left join #tamtenkh b ON a.MaKH = b.Makh
WHERE Thu_lai IS NOT NULL

UNION ALL

-- [dbo].[BangTHu_FE_Misa]
SELECT round((Lai_KA_LT/1.1),0) AS 'Phí dịch vụ', round((Lai_KA_LT/11),0) AS 'Thuế VAT (10%)'
, round(Lai_KA_LT,0) AS 'Tổng thanh toán'
, concat(N'Thu phí dịch vụ ngày ',day(Ngaythucgop), '/', month(Ngaythucgop), '/', year(Ngaythucgop), N' của mã hợp đồng số ', a.Mahd)
AS 'Ghi chú'
, GocNgay + Lai_ngay_FE_LT + Lai_KA_LT + Thudu AS 'Tổng thu ngày'
, Mahd AS 'Mã HĐ'
, 'FE' AS 'Đối tác'
, dbo.getymd(Ngaythucgop) AS Ngaythucgop
FROM [DBTieuThuong].[dbo].[BangTHu_FE_Misa] a left join #tamtenkh b ON a.MaKH = b.Makh
WHERE Lai_KA_LT IS NOT NULL


