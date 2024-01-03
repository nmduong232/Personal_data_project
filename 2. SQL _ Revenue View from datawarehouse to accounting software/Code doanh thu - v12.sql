Declare @month as varchar(6)
set @month = 202210

---B1: Xác định các hợp đồng được giảm lãi theo chính sách áp dụng từ ngày 31.03

Select * 
INTO #tam_giam_lai FROM 
---Chính sách giảm lãi này áp dụng cho các hợp đồng từ giải ngân trước ngày 2/8:
(select cast(mahd_crm as nvarchar) as mahd_crm, a.ngaymo, c.Giam_phi_KA 
FROM v_contract a
LEFT JOIN (select ma_loai_hd, min(Groups) as Groups from pr_loaihd group by ma_loai_hd) b ON a.ma_loai_hd = b.ma_loai_hd
left join (select Hanmuc, Chuanky, Gopky, sum(Giam_1_2) - sum(Phi) as Giam_phi_KA FROM pr_map_giamlai_2022 group by Hanmuc, Chuanky, Gopky) c 
ON a.sotienvay = c.Hanmuc and a.Soky = c.Chuanky and a.gopngay = c.Gopky
WHERE b.Groups = 'Bimonthly' AND Giam_phi_KA IS NOT NULL AND dbo.GETYMD(a.ngaymo) < 20220802
UNION ALL
---Chính sách giảm lãi áp dụng cho các hợp đồng giải ngân mới sau ngày 2/8:
select cast(mahd_crm as nvarchar) as mahd_crm, a.ngaymo, c.Giam_phi_KA 
FROM v_contract a
LEFT JOIN (select ma_loai_hd, min(Groups) as Groups from pr_loaihd group by ma_loai_hd) b ON a.ma_loai_hd = b.ma_loai_hd
left join (select Hanmuc, Chuanky, Gopky, - sum(Phi) as Giam_phi_KA FROM pr_map_giamlai_2022 group by Hanmuc, Chuanky, Gopky) c 
ON a.sotienvay = c.Hanmuc and a.Soky = c.Chuanky and a.gopngay = c.Gopky
WHERE b.Groups = 'Bimonthly' AND Giam_phi_KA IS NOT NULL AND dbo.GETYMD(a.ngaymo) >= 20220802) a


---B1: Xac dinh so tien Kim An se giam lai theo tung hop dong cho sản phẩm book giảm lãi kỳ cuối trước ngày 31.03
SELECT * INTO #tam_giam_lai_truoc_3103 FROM 

(SELECT 
coalesce (

(case 
	when b.Groups = 'Bimonthly' and a.Soky = '7' and a.sotienvay = 10000000 and a.gopngay = 1780000 then 1120000 --- Giam lai theo bang sp ky ban hành tháng 10 cho ky 6+
	when b.Groups = 'Bimonthly' and a.Soky = '7' and a.sotienvay = 15000000 and a.gopngay = 2670000 then 2010000
	when b.Groups = 'Bimonthly' and a.Soky = '7' and a.sotienvay = 20000000 and a.gopngay = 3560000 then 2500000
	when b.Groups = 'Bimonthly' and a.Soky = '7' and a.sotienvay = 25000000 and a.gopngay = 4450000 then 3510000
	when b.Groups = 'Bimonthly' and a.Soky = '7' and a.sotienvay = 30000000 and a.gopngay = 5340000 then 4020000
	when b.Groups = 'Bimonthly' and a.Soky = '7' and a.sotienvay = 35000000 and a.gopngay = 6230000 then 5010000
	when b.Groups = 'Bimonthly' and a.Soky = '7' and a.sotienvay = 40000000 and a.gopngay = 7120000 then 5520000
	when b.Groups = 'Bimonthly' and a.Soky = '7' and a.sotienvay = 45000000 and a.gopngay = 8010000 then 6530000
	when b.Groups = 'Bimonthly' and a.Soky = '7' and a.sotienvay = 50000000 and a.gopngay = 8900000 then 7520000
	end)

, (case when b.Groups = 'Bimonthly' and a.Soky = '7' and a.sotienvay = 15000000 and a.gopngay = 2800000 then 2800000 --- Giam lai theo bang sp ban hanh thang 3 cho ky 6+
	when b.Groups = 'Bimonthly' and a.Soky = '7' and a.sotienvay = 20000000 and a.gopngay = 3740000 then 3940000
	when b.Groups = 'Bimonthly' and a.Soky = '7' and a.sotienvay = 25000000 and a.gopngay = 4670000 then 4570000
	when b.Groups = 'Bimonthly' and a.Soky = '7' and a.sotienvay = 30000000 and a.gopngay = 5600000 then 5700000
	when b.Groups = 'Bimonthly' and a.Soky = '7' and a.sotienvay = 35000000 and a.gopngay = 6540000 then 6440000
	when b.Groups = 'Bimonthly' and a.Soky = '7' and a.sotienvay = 40000000 and a.gopngay = 7470000 then 7570000
end)	
	
,(case
	when b.Groups = 'Bimonthly' and a.Soky = '7' and a.sotienvay = 45000000 and a.gopngay = 8400000 then 8700000
	when b.Groups = 'Bimonthly' and a.Soky = '7' and a.sotienvay = 50000000 and a.gopngay = 9340000 then 9340000
	when b.Groups = 'Bimonthly' and a.Soky = '7' and a.sotienvay = 60000000 and a.gopngay = 11200000 then 11600000
	when b.Groups = 'Bimonthly' and a.Soky = '7' and a.sotienvay = 70000000 and a.gopngay = 13070000 then 13370000
	when b.Groups = 'Bimonthly' and a.Soky = '7' and a.sotienvay = 80000000 and a.gopngay = 15040000 then 15940000
	when b.Groups = 'Bimonthly' and a.Soky = '7' and a.sotienvay = 90000000 and a.gopngay = 16800000 then 17400000
	when b.Groups = 'Bimonthly' and a.Soky = '7' and a.sotienvay = 100000000 and a.gopngay = 18770000 then 19970000
end) 

)
as Giam_lai_KAcv
, a.mahd_crm
from v_contract a
LEFT JOIN pr_loaihd b ON a.ma_loai_hd = b.ma_loai_hd
WHERE  b.Groups = 'Bimonthly' and a.Soky = '7'

UNION ALL 

SELECT 

coalesce (

(case 
	when b.Groups = 'Bimonthly' and a.Soky = '9' and a.sotienvay = 10000000 and a.gopngay = 1360000 then 680000 --- Giam lai theo bang sp ky ban hành tháng 10 cho ky 8+
	when b.Groups = 'Bimonthly' and a.Soky = '9' and a.sotienvay = 15000000 and a.gopngay = 2040000 then 1380000
	when b.Groups = 'Bimonthly' and a.Soky = '9' and a.sotienvay = 20000000 and a.gopngay = 2720000 then 1660000
	when b.Groups = 'Bimonthly' and a.Soky = '9' and a.sotienvay = 25000000 and a.gopngay = 3400000 then 2360000
	when b.Groups = 'Bimonthly' and a.Soky = '9' and a.sotienvay = 30000000 and a.gopngay = 4080000 then 2620000
	when b.Groups = 'Bimonthly' and a.Soky = '9' and a.sotienvay = 35000000 and a.gopngay = 4760000 then 3360000
	when b.Groups = 'Bimonthly' and a.Soky = '9' and a.sotienvay = 40000000 and a.gopngay = 5440000 then 3640000
	when b.Groups = 'Bimonthly' and a.Soky = '9' and a.sotienvay = 45000000 and a.gopngay = 6120000 then 4360000
	when b.Groups = 'Bimonthly' and a.Soky = '9' and a.sotienvay = 50000000 and a.gopngay = 6800000 then 5080000
end)

,(case
	when b.Groups = 'Bimonthly' and a.Soky = '9' and a.sotienvay = 15000000 and a.gopngay = 2080000 then 1480000 --- Giam lai theo bang sp ban hanh thang 3 cho ky 8+
	when b.Groups = 'Bimonthly' and a.Soky = '9' and a.sotienvay = 20000000 and a.gopngay = 2900000 then 2700000
	when b.Groups = 'Bimonthly' and a.Soky = '9' and a.sotienvay = 25000000 and a.gopngay = 3550000 then 2850000
	when b.Groups = 'Bimonthly' and a.Soky = '9' and a.sotienvay = 30000000 and a.gopngay = 4250000 then 3750000
	when b.Groups = 'Bimonthly' and a.Soky = '9' and a.sotienvay = 35000000 and a.gopngay = 4980000 then 4180000
	when b.Groups = 'Bimonthly' and a.Soky = '9' and a.sotienvay = 40000000 and a.gopngay = 5700000 then 5100000
	when b.Groups = 'Bimonthly' and a.Soky = '9' and a.sotienvay = 45000000 and a.gopngay = 6350000 then 5250000
end)
	
,(case	
	when b.Groups = 'Bimonthly' and a.Soky = '9' and a.sotienvay = 50000000 and a.gopngay = 7150000 then 6450000
	when b.Groups = 'Bimonthly' and a.Soky = '9' and a.sotienvay = 60000000 and a.gopngay = 8500000 then 7500000
	when b.Groups = 'Bimonthly' and a.Soky = '9' and a.sotienvay = 70000000 and a.gopngay = 9950000 then 9350000
	when b.Groups = 'Bimonthly' and a.Soky = '9' and a.sotienvay = 80000000 and a.gopngay = 11400000 then 10200000
	when b.Groups = 'Bimonthly' and a.Soky = '9' and a.sotienvay = 90000000 and a.gopngay = 12750000 then 11750000
	when b.Groups = 'Bimonthly' and a.Soky = '9' and a.sotienvay = 100000000 and a.gopngay = 14200000 then 13100000
end) ) as Giam_lai_KA
, a.mahd_crm
from v_contract a
LEFT JOIN pr_loaihd b ON a.ma_loai_hd = b.ma_loai_hd
WHERE b.Groups = 'Bimonthly' and a.Soky = '9'

UNION ALL 

SELECT 
case 
	when b.Groups = 'Monthly' and a.Soky = '6' and a.sotienvay = 15000000 and a.gopngay = 3350000 then 2350000 --- Giam lai theo bang sp thang ban hành tháng 10 cho thang 5+
	when b.Groups = 'Monthly' and a.Soky = '6' and a.sotienvay = 20000000 and a.gopngay = 4500000 then 3000000
	when b.Groups = 'Monthly' and a.Soky = '6' and a.sotienvay = 25000000 and a.gopngay = 5650000 then 4150000
	when b.Groups = 'Monthly' and a.Soky = '6' and a.sotienvay = 30000000 and a.gopngay = 6750000 then 4750000
	when b.Groups = 'Monthly' and a.Soky = '6' and a.sotienvay = 35000000 and a.gopngay = 7900000 then 5900000
 	when b.Groups = 'Monthly' and a.Soky = '6' and a.sotienvay = 40000000 and a.gopngay = 9000000 then 6500000
	when b.Groups = 'Monthly' and a.Soky = '6' and a.sotienvay = 45000000 and a.gopngay = 10150000 then 7650000
	when b.Groups = 'Monthly' and a.Soky = '6' and a.sotienvay = 50000000 and a.gopngay = 11250000 then 8750000
end as Giam_lai_KA
, a.mahd_crm
from v_contract a
LEFT JOIN pr_loaihd b ON a.ma_loai_hd = b.ma_loai_hd
WHERE b.Groups = 'Monthly' and a.Soky = '6'

UNION ALL 

SELECT 
coalesce(

(case 
	when b.Groups = 'Bimonthly' and a.Soky = '11' and a.sotienvay = 15000000 and a.gopngay = 1700000 then 800000 --- Giam lai theo bang sp ban hanh thang 3 cho ky 10+
	when b.Groups = 'Bimonthly' and a.Soky = '11' and a.sotienvay = 20000000 and a.gopngay = 2300000 then 1400000
	when b.Groups = 'Bimonthly' and a.Soky = '11' and a.sotienvay = 25000000 and a.gopngay = 2900000 then 2200000
	when b.Groups = 'Bimonthly' and a.Soky = '11' and a.sotienvay = 30000000 and a.gopngay = 3500000 then 2500000
	when b.Groups = 'Bimonthly' and a.Soky = '11' and a.sotienvay = 35000000 and a.gopngay = 4100000 then 3300000
	when b.Groups = 'Bimonthly' and a.Soky = '11' and a.sotienvay = 40000000 and a.gopngay = 4600000 then 2800000
end)	

, (case	
	when b.Groups = 'Bimonthly' and a.Soky = '11' and a.sotienvay = 45000000 and a.gopngay = 5200000 then 3600000	
	when b.Groups = 'Bimonthly' and a.Soky = '11' and a.sotienvay = 50000000 and a.gopngay = 5800000 then 3900000
	when b.Groups = 'Bimonthly' and a.Soky = '11' and a.sotienvay = 60000000 and a.gopngay = 6900000 then 4700000
	when b.Groups = 'Bimonthly' and a.Soky = '11' and a.sotienvay = 70000000 and a.gopngay = 8100000 then 6300000
	when b.Groups = 'Bimonthly' and a.Soky = '11' and a.sotienvay = 80000000 and a.gopngay = 9200000 then 5600000
	when b.Groups = 'Bimonthly' and a.Soky = '11' and a.sotienvay = 90000000 and a.gopngay = 10400000 then 7200000
	when b.Groups = 'Bimonthly' and a.Soky = '11' and a.sotienvay = 100000000 and a.gopngay = 11500000 then 7500000
end) 
) as Giam_lai_KA
, a.mahd_crm
from v_contract a
LEFT JOIN pr_loaihd b ON a.ma_loai_hd = b.ma_loai_hd
WHERE b.Groups = 'Bimonthly' and a.Soky = '11') a


--- B2: Xac dinh so lai doi tac cua tung hop dong
select * into #tam_Lai_dt from 
(SELECT a.mahd_crm, sum(b.Tong_lai) AS Interest_from_FI, g.Groups
FROM v_contract a
LEFT JOIN v_Contract_FE b
ON a.mahd = b.Mahd
LEFT JOIN v_haukiem f
ON a.mahd = f.MaHD
LEFT JOIN pr_loaihd g
ON f.Sp_Code = g.Loai_hd
WHERE g.Doitac = 'FE'
GROUP BY a.mahd, a.mahd_crm, b.LOAN_TENOR, g.Groups

union all

SELECT a.mahd_crm, sum(b.GopNgay*f.songayvay - b.sotienvay) AS Interest_from_FI, g.Groups
FROM v_contract a
LEFT JOIN v_Contract_VP b
ON a.mahd = b.Mahd
LEFT JOIN v_haukiem f
ON a.mahd = f.MaHD
LEFT JOIN pr_loaihd g
ON f.Sp_Code = g.Loai_hd
WHERE g.Doitac = 'VP'
GROUP BY a.mahd, a.mahd_crm, g.Groups

union all

SELECT a.mahd_crm, sum(b.Tong_Lai_MA) AS Interest_from_FI, 
g.Groups
FROM v_contract a
LEFT JOIN v_Contract_MA b
ON a.mahd = b.Mahd
LEFT JOIN v_haukiem f
ON a.mahd = f.MaHD
LEFT JOIN pr_loaihd g
ON f.Sp_Code = g.Loai_hd
WHERE g.Doitac = 'MA'
GROUP BY a.mahd, a.mahd_crm, g.Groups

union all

SELECT  a.mahd_crm, sum(b.Tonglai_VC) AS Interest_from_FI, g.Groups
FROM v_contract a
LEFT JOIN v_Contract_VC b
ON a.mahd_crm = b.Mahd_crm
LEFT JOIN v_haukiem f
ON a.mahd = f.MaHD
LEFT JOIN pr_loaihd g
ON f.Sp_Code = g.Loai_hd
WHERE g.Doitac = 'VC'
GROUP BY a.mahd, a.mahd_crm, g.Groups) as a


--- Xác định số tổng thu của Kim An sau khi đã trừ giảm lãi
select a.mahd_crm
, a.sotienvay AS Goc
, (a.gopngay*a.soky) - a.Sotienvay as TongThuKA_dukien
, b.Giam_phi_KA
, d.Giam_lai_KA
, c.Interest_from_FI
, case when d.Giam_lai_KA IS NULL then (a.gopngay*a.soky) - a.Sotienvay - ISNULL(b.Giam_phi_KA,0) - ISNULL(c.Interest_from_FI,0) 
else (a.gopngay*a.soky) - a.Sotienvay - ISNULL(d.Giam_lai_KA,0) - ISNULL(c.Interest_from_FI,0) end as Phi_KA
, case
when ((a.gopngay*a.soky) - a.Sotienvay) = 0 then 0
when ((a.gopngay*a.soky) - a.Sotienvay) != 0 and d.Giam_lai_KA IS NULL 
then ((a.gopngay*a.soky) - a.Sotienvay - ISNULL(b.Giam_phi_KA,0) - ISNULL(c.Interest_from_FI,0)) / ((a.gopngay*a.soky) - a.Sotienvay) 
when ((a.gopngay*a.soky) - a.Sotienvay) != 0 and d.Giam_lai_KA IS NOT NULL 
then ((a.gopngay*a.soky) - a.Sotienvay - ISNULL(d.Giam_lai_KA,0) - ISNULL(c.Interest_from_FI,0)) / ((a.gopngay*a.soky) - a.Sotienvay)
end as Ty_le_phi_KA_tren_tong_thu_lai
, a.Soky
into #tam_tongthu_hd
from v_contract a
LEFT JOIN #tam_giam_lai b ON a.mahd_crm = b.mahd_crm
LEFT JOIN #tam_Lai_dt c ON a.mahd_crm = c.mahd_crm
LEFT JOIN #tam_giam_lai_truoc_3103 d ON a.mahd_crm = d.mahd_crm

--- Lấy các thông tin về CN, đối tác, loại hợp đồng
select a.mahd_crm, a.macn, b.Doitac, b.Groups, b.ma_loai_hd, a.ngaymo
, case when b.ma_loai_hd = '41' THEN 'TD' when b.Doitac = 'CD' and b.ma_loai_hd !='41' and dbo.GETYMD(a.ngaymo) >= 20220307 then 'TD' when b.Doitac = 'CD' and b.ma_loai_hd !='41' and dbo.GETYMD(a.ngaymo) < 20220307 then 'TC' else b.Doitac end AS Doitac_phapnhan
into #tam_chitiet_hopdong
from v_contract a left join pr_loaihd b on a.ma_loai_hd = b.ma_loai_hd

--- Lấy các thông tin về phí phạt với sản phẩm ứng vốn
select contract_id as mahd, 'Phat' AS period_id, NULL AS ngay_dukien, transaction_date AS ngay_dongthuc, 0 AS goc, 0 as lai, amount as Phi_KA 
into #tam_phi_ung_von
from v_contract_uv_thu


--- Lấy các thông tin về thu lại của các hợp đồng đã write-off trên hệ thống CRM và data không chạy vào bảng thu của Kim An.

SELECT b.*, ISNULL(a.TLDP, 0) AS TLDP, b.So_thu - ISNULL(a.TLDP, 0) AS Phi_phat 
INTO #tam_thuhd_writeoff
FROM 
(select dbo.GETYM(Ngaydong) as Thang_dong, Mahd_crm, sum(amt) as So_thu from DBTieuthuong.dbo.Bangthu_HD_Writeoff_2022
GROUP BY dbo.GETYM(Ngaydong), Mahd_crm) b
LEFT JOIN
(select Thang, Mahd, sum(DP_KT) as TLDP from v_tldp 
GROUP BY Thang, Mahd) a
ON a.Thang = b.Thang_dong AND a.Mahd = b.Mahd_crm

--- B3.1: Tách phần phí Kim An chia cho số kỳ thu - 2 kỳ đầu vào trong bảng v_contract_full_lich_tra với các hd này
--- Kỳ phí phạt 7+ khi thu được thì kỳ phạt cuối cùng thì trên bảng thu v_contract_full_lich_tra mới ghi nhận ngày đóng thực => tới lúc đó thì kỳ phí mới được ghi nhận cho các CN


SELECT * INTO #tam_bang_thu_sp_ky_chua_thudu_giam_lai_CD FROM 
--- Bảng thu với sản phẩm kỳ book phí phạt kỳ cuối giải ngân trước 02.08.2022 và có giảm lãi 2 kỳ đầu
(SELECT cast(a.mahd as varchar) as mahd , a.period_id, a.ngay_dukien, a.ngay_dongthuc, a.goc, (a.lai + a.phi) as lai --- cần bỏ cả kỳ phí phạt vào đây để ghi nhận phải trả đối tác vào kỳ cuối cùng
, case when period_id IN ('1','2') then 0 else round(cast(b.Phi_KA as int) / (cast(b.Soky as int) - 2) ,0) end as Phi_KA
, a.lai + a.phi - case when period_id IN ('1','2') then 0 else round(cast(b.Phi_KA as int) / (cast(b.Soky as int) - 2) ,0) end as Lai_doitac
, c.Doitac
, c.Groups
, c.macn
, c.Doitac_phapnhan
, c.ma_loai_hd
FROM v_contract_full_lichtra a 
left join #tam_tongthu_hd b ON a.mahd = b.mahd_crm
left join (select mahd_crm, min(macn) as macn, min(Doitac) as Doitac, min(Groups) as Groups, min(Doitac_phapnhan) as Doitac_phapnhan , min(ma_loai_hd) as ma_loai_hd, min(ngaymo) as ngaymo
from #tam_chitiet_hopdong group by mahd_crm) c 
ON a.mahd = c.mahd_crm
WHERE a.mahd IN (SELECT DISTINCT mahd_crm FROM #tam_giam_lai) and dbo.GETYM(ngay_dongthuc) >= 202203 and c.ma_loai_hd != '41' and dbo.GETYMD(c.ngaymo) < 20220802

UNION ALL

--- Bảng thu với sản phẩm kỳ book phí phạt kỳ cuối giải ngân từ 02.08.2022 và không giảm lãi 2 kỳ đầu
SELECT cast(a.mahd as varchar) as mahd , a.period_id, a.ngay_dukien, a.ngay_dongthuc, a.goc, (a.lai + a.phi) as lai --- cần bỏ cả kỳ phí phạt vào đây để ghi nhận phải trả đối tác vào kỳ cuối cùng
, round(cast(b.Phi_KA as int) / cast(b.Soky as int),0) as Phi_KA
, a.lai + a.phi - case when period_id IN ('1','2') then 0 else round(cast(b.Phi_KA as int) / cast(b.Soky as int),0) end as Lai_doitac
, c.Doitac
, c.Groups
, c.macn
, c.Doitac_phapnhan
, c.ma_loai_hd
FROM v_contract_full_lichtra a 
left join #tam_tongthu_hd b ON a.mahd = b.mahd_crm
left join (select mahd_crm, min(macn) as macn, min(Doitac) as Doitac, min(Groups) as Groups, min(Doitac_phapnhan) as Doitac_phapnhan , min(ma_loai_hd) as ma_loai_hd, min(ngaymo) as ngaymo
from #tam_chitiet_hopdong group by mahd_crm) c 
ON a.mahd = c.mahd_crm
WHERE a.mahd IN (SELECT DISTINCT mahd_crm FROM #tam_giam_lai) and dbo.GETYM(ngay_dongthuc) >= 202203 and c.ma_loai_hd != '41' and dbo.GETYMD(c.ngaymo) >= 20220802

UNION ALL

--- Bảng thu với sản phẩm kỳ book giảm lãi kỳ cuối
SELECT cast(a.mahd as varchar) as mahd , a.period_id, a.ngay_dukien, a.ngay_dongthuc, a.goc, a.lai
, round(cast(b.Phi_KA as int)/cast(b.Soky as int), 0) as Phi_KA
, a.lai - round(cast(b.Phi_KA as int)/cast(b.Soky as int), 0) as Lai_doitac
, c.Doitac
, c.Groups
, c.macn
, c.Doitac_phapnhan
, c.ma_loai_hd
FROM v_contract_full_lichtra a
left join #tam_tongthu_hd b ON a.mahd = b.mahd_crm
left join (select mahd_crm, min(macn) as macn, min(Doitac) as Doitac, min(Groups) as Groups, min(Doitac_phapnhan) as Doitac_phapnhan , min(ma_loai_hd) as ma_loai_hd from #tam_chitiet_hopdong group by mahd_crm) c 
ON a.mahd = c.mahd_crm
WHERE a.mahd IN (SELECT DISTINCT mahd_crm FROM #tam_giam_lai_truoc_3103) and c.ma_loai_hd != '41'

UNION ALL

--- Bảng thu với các sản phẩm khác ngoài sản phẩm ứng vốn, ngoài sản phẩm phí phạt và ngoài sản phẩm giảm lãi kỳ cuối
SELECT cast(a.mahd as varchar) as mahd , a.period_id, a.ngay_dukien, a.ngay_dongthuc, a.goc, (a.lai + a.phi) as lai
, round(cast(b.Phi_KA as int)/ cast(b.Soky as int), 0) as Phi_KA
, a.lai + a.phi - round(cast(b.Phi_KA as int) / cast(b.Soky as int),0) as Lai_doitac
, c.Doitac
, c.Groups
, c.macn
, c.Doitac_phapnhan
, c.ma_loai_hd
FROM v_contract_full_lichtra a
left join #tam_tongthu_hd b ON a.mahd = b.mahd_crm
left join (select mahd_crm, min(macn) as macn, min(Doitac) as Doitac, min(Groups) as Groups, min(Doitac_phapnhan) as Doitac_phapnhan, min(ma_loai_hd) as ma_loai_hd from #tam_chitiet_hopdong group by mahd_crm) c 
ON a.mahd = c.mahd_crm
WHERE a.mahd NOT IN (SELECT DISTINCT mahd_crm FROM #tam_giam_lai) and c.ma_loai_hd != '41' and a.mahd NOT IN (SELECT DISTINCT mahd_crm FROM #tam_giam_lai_truoc_3103) 
and dbo.GETYM(ngay_dongthuc) >= 202203

UNION ALL

--- Bảng thu phần gốc với sản phẩm ứng vốn có gốc lãi trên bảng v_contract_full lịch trả gộp chung làm một
SELECT cast(a.mahd as varchar) as mahd , a.period_id, a.ngay_dukien, a.ngay_dongthuc, a.goc + a.lai as goc, 0 as lai
, 0 as Phi_KA
, 0 as Lai_doitac
, c.Doitac
, c.Groups
, c.macn
, c.Doitac_phapnhan
, c.ma_loai_hd
FROM v_contract_full_lichtra a
left join #tam_tongthu_hd b ON a.mahd = b.mahd_crm
left join (select mahd_crm, min(macn) as macn, min(Doitac) as Doitac, min(Groups) as Groups, min(Doitac_phapnhan) as Doitac_phapnhan, min(ma_loai_hd) as ma_loai_hd from #tam_chitiet_hopdong group by mahd_crm) c 
ON a.mahd = c.mahd_crm
WHERE a.mahd NOT IN (SELECT DISTINCT mahd_crm FROM #tam_giam_lai) and c.ma_loai_hd = '41' and dbo.GETYM(ngay_dongthuc) >= 202203

UNION ALL

--- Bảng thu phần phí của sản phẩm ứng vốn có gốc lãi trên bảng v_contract_full lịch trả gộp chung làm một
SELECT cast(a.mahd as varchar) as mahd , 0 AS period_id, a.ngay_dongthuc AS ngay_dukien, a.ngay_dongthuc, 0 as goc, a.Phi_KA as lai
, a.Phi_KA
, 0 as Lai_doitac
, c.Doitac
, c.Groups
, c.macn
, c.Doitac_phapnhan
, c.ma_loai_hd
FROM #tam_phi_ung_von a
left join #tam_tongthu_hd b ON a.mahd = b.mahd_crm
left join (select mahd_crm, min(macn) as macn, min(Doitac) as Doitac, min(Groups) as Groups, min(Doitac_phapnhan) as Doitac_phapnhan, min(ma_loai_hd) as ma_loai_hd from #tam_chitiet_hopdong group by mahd_crm) c 
ON a.mahd = c.mahd_crm
WHERE a.mahd NOT IN (SELECT DISTINCT mahd_crm FROM #tam_giam_lai) and c.ma_loai_hd = '41' and dbo.GETYM(ngay_dongthuc) >= 202203

UNION ALL

--- Bảng thu của các hợp đồng được write-off

SELECT cast(a.Mahd_crm as varchar) as mahd , 0 AS period_id, EOMONTH(datefromparts(left(a.Thang_dong,4), right(a.Thang_dong,2), 1)) AS ngay_dukien
, EOMONTH(datefromparts(left(a.Thang_dong,4), right(a.Thang_dong,2), 1)) as ngay_dongthuc, 0 as goc, a.Phi_phat as lai
, a.Phi_phat
, 0 as Lai_doitac
, c.Doitac
, c.Groups
, c.macn
, c.Doitac_phapnhan
, c.ma_loai_hd
FROM #tam_thuhd_writeoff a
left join #tam_tongthu_hd b ON a.Mahd_crm = b.mahd_crm
left join (select mahd_crm, min(macn) as macn, min(Doitac) as Doitac, min(Groups) as Groups, min(Doitac_phapnhan) as Doitac_phapnhan, min(ma_loai_hd) as ma_loai_hd from #tam_chitiet_hopdong group by mahd_crm) c 
ON a.Mahd_crm = c.mahd_crm
WHERE a.Mahd_crm NOT IN (SELECT DISTINCT mahd_crm FROM #tam_giam_lai) and a.Thang_dong >= 202203 AND a.Phi_phat > 0
) a

--- B4: Lấy danh sách thu dư của các hợp đồng này trên bảng nợ xấu

select * into #tam_bangnoxau_gon from DBTieuThuong.dbo.vBangNoXau_TT
where thang >= 202203

select a.ngay, a.ngay2, a.MaHD, ThucGop, Thudu 
INTO #tam_thu_du
FROM #tam_bangnoxau_gon a --- !!!! Replace vBangnoxau này bằng bảng trong database báo cáo
WHERE Thudu != 0 


--- B5: Tạo bảng thu bao gồm cả số thu dư

select * into #tam_bang_thu_sp_ky_gom_thudu_giam_lai_CD from
(select  a.* , 0 as Thudu from #tam_bang_thu_sp_ky_chua_thudu_giam_lai_CD as a
where a.ngay_dongthuc IS NOT NULL

union all 

select MaHD, null, null, ngay2 , null, null, null, null
, c.Doitac
, c.Groups
, c.macn
, c.Doitac_phapnhan
, c.ma_loai_hd
, a.Thudu
from #tam_thu_du a
left join (select cast(mahd_crm as nvarchar) as mahd_crm, min(macn) as macn, min(Doitac) as Doitac, min(Groups) as Groups, min(Doitac_phapnhan) AS Doitac_phapnhan, min(ma_loai_hd) as ma_loai_hd  from #tam_chitiet_hopdong group by mahd_crm) c on a.MaHD = c.mahd_crm
) n

select * into #tam_bang_thu_sp_ky_gom_thudu FROM 
(select * from #tam_bang_thu_sp_ky_gom_thudu_giam_lai_CD WHERE Doitac != 'CD'
UNION ALL
select mahd,	period_id,	ngay_dukien,	ngay_dongthuc,	goc, lai, Phi_KA, 0 AS Lai_doitac, Doitac, Groups, macn, Doitac_phapnhan,	ma_loai_hd,	Thudu 
FROM #tam_bang_thu_sp_ky_gom_thudu_giam_lai_CD WHERE Doitac = 'CD') a


--- B6: Code format theo form đẩy MISA chưa bao gồm mã chứng từ tự chạy (lưu ý phải có điều kiện khác sản phẩm 41 của sản phẩm ứng vốn) 

select * into #bang_thu_MISA_spky
from (
 ---- Tra goc ---- 
select null as hienthitreso 
, ngay_dongthuc as  ngay_hach_toan
, ngay_dongthuc as ngay_chung_tu
, concat('CRM-TG',
Doitac_phapnhan
,(case when month(ngay_dongthuc) < 10 then '0' +CAST(month(ngay_dongthuc) as varchar(2)) else CAST(month(ngay_dongthuc) as varchar(2)) end ) ,'/' , Right(Cast(year(ngay_dongthuc) as nvarchar(4)),2)
) as so_chung_tu
,
case when Doitac_phapnhan = 'FE' AND Groups ='Weekly' THEN 'SPT-FE'
	when Doitac_phapnhan = 'FE' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPK-FE'
	when Doitac_phapnhan = 'FE' AND Groups = 'Daily' THEN 'SPN-FE'
	when Doitac_phapnhan = 'MA' AND Groups ='Weekly' THEN 'SPT-MR'
	when Doitac_phapnhan = 'MA' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPK-MR'
	when Doitac_phapnhan = 'MA' AND Groups = 'Daily' THEN 'SPN-MR'
	when Doitac_phapnhan = 'TC' AND Groups ='Weekly' THEN 'SPTTCTC'
	when Doitac_phapnhan = 'TC' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPKTC'
	when Doitac_phapnhan = 'TC' AND Groups = 'Daily' THEN 'SPNTC'
	when Doitac_phapnhan = 'TD' AND Groups ='Weekly' THEN 'SPT-TD'
	when Doitac_phapnhan = 'TD' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPK-TD'
	when Doitac_phapnhan = 'TD' AND Groups = 'Daily' THEN 'SPN-TD'
	when Doitac_phapnhan = 'VP' AND Groups ='Weekly' THEN 'SPT-VPB'
	when Doitac_phapnhan = 'VP' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPK-VPB'
	when Doitac_phapnhan = 'VP' AND Groups = 'Daily' THEN 'SPN-VPB'
	when Doitac_phapnhan = 'VC' AND Groups ='Weekly' THEN 'SPT-VC'
	when Doitac_phapnhan = 'VC' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPK-VC'
	when Doitac_phapnhan = 'VC' AND Groups = 'Daily' THEN 'SPN-VC'
end  as ma_doi_tuong
, null as ten_doi_tuong
, null as diachi
, null as ly_do_nop
, case when Doitac_phapnhan = 'FE' THEN N'Thu gốc FE'
	when Doitac_phapnhan = 'MA' THEN N'Thu gốc MR'
	when Doitac_phapnhan = 'TC' THEN N'Thu gốc TC'
	when Doitac_phapnhan = 'TD' THEN N'Thu gốc TD'
	when Doitac_phapnhan = 'VC' THEN N'Thu gốc VC'
	when Doitac_phapnhan = 'VP' THEN N'Thu gốc VP'
end as dien_giai_ly_do_nop
, null as nguoi_nop
, null as  nhan_vien_thu
, null as  kem_theo
, null as  loai_tien
, null as  ty_gia
, case when Doitac_phapnhan = 'FE' THEN N'Thu gốc FE'
	when Doitac_phapnhan = 'MA' THEN N'Thu gốc MR'
	when Doitac_phapnhan = 'TC' THEN N'Thu gốc TC'
	when Doitac_phapnhan = 'TD' THEN N'Thu gốc TD'
	when Doitac_phapnhan = 'VC' THEN N'Thu gốc VC'
	when Doitac_phapnhan = 'VP' THEN N'Thu gốc VP'
end as dien_giai
, '111108' as TK_no
, case 
	when Doitac_phapnhan = 'FE' THEN '3388111'
	when Doitac_phapnhan = 'MA' THEN '3388141'
	when Doitac_phapnhan = 'TC' THEN '33884'
	when Doitac_phapnhan = 'TD' THEN '33884'
	when Doitac_phapnhan = 'VP' THEN '3388131'
	when Doitac_phapnhan = 'VC' THEN '338812'
end as TK_co
, sum(Goc) as so_tien
, null as   quy_doi
, null as   doi_tuong
, null as   Tk_ngan_hang
, null as hop_dong_ban
, concat('TD',(case when len(macn)=1 then '00'+ CAST(macn as varchar(3)) when len(macn)=2 then '0'+ CAST(macn as varchar(3)) else cast(macn as varchar(3)) end)) as don_vi
, mahd
, Doitac_phapnhan
from #tam_bang_thu_sp_ky_gom_thudu
where Goc is not null and Goc != 0 and dbo.GETYM(ngay_dongthuc) >= 202203 and ma_loai_hd != '41' --- Sản phẩm Ứng vốn mã '41' thu tiền trực tiếp về tài khoản ngân hàng chứ không qua TD Kim An nên không có bút hạch toán gốc lãi ở đây
group by ngay_dongthuc
, ngay_dongthuc
, case when Doitac_phapnhan = 'FE' AND Groups ='Weekly' THEN 'SPT-FE'
	when Doitac_phapnhan = 'FE' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPK-FE'
	when Doitac_phapnhan = 'FE' AND Groups = 'Daily' THEN 'SPN-FE'
	when Doitac_phapnhan = 'MA' AND Groups ='Weekly' THEN 'SPT-MR'
	when Doitac_phapnhan = 'MA' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPK-MR'
	when Doitac_phapnhan = 'MA' AND Groups = 'Daily' THEN 'SPN-MR'
	when Doitac_phapnhan = 'TC' AND Groups ='Weekly' THEN 'SPTTCTC'
	when Doitac_phapnhan = 'TC' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPKTC'
	when Doitac_phapnhan = 'TC' AND Groups = 'Daily' THEN 'SPNTC'
	when Doitac_phapnhan = 'TD' AND Groups ='Weekly' THEN 'SPT-TD'
	when Doitac_phapnhan = 'TD' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPK-TD'
	when Doitac_phapnhan = 'TD' AND Groups = 'Daily' THEN 'SPN-TD'
	when Doitac_phapnhan = 'VP' AND Groups ='Weekly' THEN 'SPT-VPB'
	when Doitac_phapnhan = 'VP' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPK-VPB'
	when Doitac_phapnhan = 'VP' AND Groups = 'Daily' THEN 'SPN-VPB'
	when Doitac_phapnhan = 'VC' AND Groups ='Weekly' THEN 'SPT-VC'
	when Doitac_phapnhan = 'VC' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPK-VC'
	when Doitac_phapnhan = 'VC' AND Groups = 'Daily' THEN 'SPN-VC'
end
, case when Doitac_phapnhan = 'FE' THEN N'Thu gốc FE'
	when Doitac_phapnhan = 'MA' THEN N'Thu gốc MR'
	when Doitac_phapnhan = 'TC' THEN N'Thu gốc TC'
	when Doitac_phapnhan = 'TD' THEN N'Thu gốc TD'
	when Doitac_phapnhan = 'VC' THEN N'Thu gốc VC'
	when Doitac_phapnhan = 'VP' THEN N'Thu gốc VP'
end
, concat('TD',(case when len(macn)=1 then '00'+ CAST(macn as varchar(3)) when len(macn)=2 then '0'+ CAST(macn as varchar(3)) else cast(macn as varchar(3)) end))
,case 
	when Doitac_phapnhan = 'FE' THEN '3388111'
	when Doitac_phapnhan = 'MA' THEN '3388141'
	when Doitac_phapnhan = 'TC' THEN '33884'
	when Doitac_phapnhan = 'TD' THEN '33884'
	when Doitac_phapnhan = 'VP' THEN '3388131'
	when Doitac_phapnhan = 'VC' THEN '338812'
end
, concat('CRM-TG',
Doitac_phapnhan
,(case when month(ngay_dongthuc) < 10 then '0' +CAST(month(ngay_dongthuc) as varchar(2)) else CAST(month(ngay_dongthuc) as varchar(2)) end ) ,'/' , Right(Cast(year(ngay_dongthuc) as nvarchar(4)),2)
)
, mahd
, Doitac_phapnhan

UNION ALL

--- Tra lai
select null as hienthitreso 
, ngay_dongthuc as  ngay_hach_toan
, ngay_dongthuc as ngay_chung_tu
, concat('CRM-TL',
Doitac_phapnhan
,(case when month(ngay_dongthuc) < 10 then '0' +CAST(month(ngay_dongthuc) as varchar(2)) else CAST(month(ngay_dongthuc) as varchar(2)) end ) ,'/' , Right(Cast(year(ngay_dongthuc) as nvarchar(4)),2)
) as so_chung_tu
,
case when Doitac_phapnhan = 'FE' AND Groups ='Weekly' THEN 'SPT-FE'
	when Doitac_phapnhan = 'FE' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPK-FE'
	when Doitac_phapnhan = 'FE' AND Groups = 'Daily' THEN 'SPN-FE'
	when Doitac_phapnhan = 'MA' AND Groups ='Weekly' THEN 'SPT-MR'
	when Doitac_phapnhan = 'MA' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPK-MR'
	when Doitac_phapnhan = 'MA' AND Groups = 'Daily' THEN 'SPN-MR'
	when Doitac_phapnhan = 'TC' AND Groups ='Weekly' THEN 'SPTTCTC'
	when Doitac_phapnhan = 'TC' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPKTC'
	when Doitac_phapnhan = 'TC' AND Groups = 'Daily' THEN 'SPNTC'
	when Doitac_phapnhan = 'TD' AND Groups ='Weekly' THEN 'SPT-TD'
	when Doitac_phapnhan = 'TD' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPK-TD'
	when Doitac_phapnhan = 'TD' AND Groups = 'Daily' THEN 'SPN-TD'
	when Doitac_phapnhan = 'VP' AND Groups ='Weekly' THEN 'SPT-VPB'
	when Doitac_phapnhan = 'VP' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPK-VPB'
	when Doitac_phapnhan = 'VP' AND Groups = 'Daily' THEN 'SPN-VPB'
	when Doitac_phapnhan = 'VC' AND Groups ='Weekly' THEN 'SPT-VC'
	when Doitac_phapnhan = 'VC' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPK-VC'
	when Doitac_phapnhan = 'VC' AND Groups = 'Daily' THEN 'SPN-VC'
end  as ma_doi_tuong
, null as ten_doi_tuong
, null as diachi
, null as ly_do_nop
, case when Doitac_phapnhan = 'FE' THEN N'Thu lãi của KH đối tác FE hưởng'
	when Doitac_phapnhan = 'MA' THEN N'Thu lãi của KH đối tác MR hưởng'
	when Doitac_phapnhan = 'TC' THEN N'Thu lãi của KH đối tác TC hưởng'
	when Doitac_phapnhan = 'TD' THEN N'Thu lãi của KH đối tác TD hưởng'
	when Doitac_phapnhan = 'VC' THEN N'Thu lãi của KH đối tác VC hưởng'
	when Doitac_phapnhan = 'VP' THEN N'Thu lãi của KH đối tác VP hưởng'
end as dien_giai_ly_do_nop
, null as nguoi_nop
, null as  nhan_vien_thu
, null as  kem_theo
, null as  loai_tien
, null as  ty_gia
, case when Doitac_phapnhan = 'FE' THEN N'Thu lãi của KH đối tác FE hưởng'
	when Doitac_phapnhan = 'MA' THEN N'Thu lãi của KH đối tác MR hưởng'
	when Doitac_phapnhan = 'TC' THEN N'Thu lãi của KH đối tác TC hưởng'
	when Doitac_phapnhan = 'TD' THEN N'Thu lãi của KH đối tác TD hưởng'
	when Doitac_phapnhan = 'VC' THEN N'Thu lãi của KH đối tác VC hưởng'
	when Doitac_phapnhan = 'VP' THEN N'Thu lãi của KH đối tác VP hưởng'
end as dien_giai
, '111108' as TK_no
, case 
	when Doitac_phapnhan = 'FE' THEN '3388111'
	when Doitac_phapnhan = 'MA' THEN '3388141'
	when Doitac_phapnhan = 'TC' THEN '33884'
	when Doitac_phapnhan = 'TD' THEN '33884'
	when Doitac_phapnhan = 'VP' THEN '3388131'
	when Doitac_phapnhan = 'VC' THEN '338812'
end as TK_co
, sum(Lai_doitac) as so_tien
, null as   quy_doi
, null as   doi_tuong
, null as   Tk_ngan_hang
, null as hop_dong_ban
, concat('TD',(case when len(macn)=1 then '00'+ CAST(macn as varchar(3)) when len(macn)=2 then '0'+ CAST(macn as varchar(3)) else cast(macn as varchar(3)) end)) as don_vi
, mahd
, Doitac_phapnhan
from #tam_bang_thu_sp_ky_gom_thudu
where lai is not null and lai != 0 and dbo.GETYM(ngay_dongthuc) >= 202203  and ma_loai_hd != '41' --- Sản phẩm Ứng vốn mã '41' thu tiền trực tiếp về tài khoản ngân hàng chứ không qua TD Kim An nên không có bút hạch toán gốc lãi ở đây
group by ngay_dongthuc
, ngay_dongthuc
, case when Doitac_phapnhan = 'FE' AND Groups ='Weekly' THEN 'SPT-FE'
	when Doitac_phapnhan = 'FE' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPK-FE'
	when Doitac_phapnhan = 'FE' AND Groups = 'Daily' THEN 'SPN-FE'
	when Doitac_phapnhan = 'MA' AND Groups ='Weekly' THEN 'SPT-MR'
	when Doitac_phapnhan = 'MA' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPK-MR'
	when Doitac_phapnhan = 'MA' AND Groups = 'Daily' THEN 'SPN-MR'
	when Doitac_phapnhan = 'TC' AND Groups ='Weekly' THEN 'SPTTCTC'
	when Doitac_phapnhan = 'TC' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPKTC'
	when Doitac_phapnhan = 'TC' AND Groups = 'Daily' THEN 'SPNTC'
	when Doitac_phapnhan = 'TD' AND Groups ='Weekly' THEN 'SPT-TD'
	when Doitac_phapnhan = 'TD' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPK-TD'
	when Doitac_phapnhan = 'TD' AND Groups = 'Daily' THEN 'SPN-TD'
	when Doitac_phapnhan = 'VP' AND Groups ='Weekly' THEN 'SPT-VPB'
	when Doitac_phapnhan = 'VP' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPK-VPB'
	when Doitac_phapnhan = 'VP' AND Groups = 'Daily' THEN 'SPN-VPB'
	when Doitac_phapnhan = 'VC' AND Groups ='Weekly' THEN 'SPT-VC'
	when Doitac_phapnhan = 'VC' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPK-VC'
	when Doitac_phapnhan = 'VC' AND Groups = 'Daily' THEN 'SPN-VC'
end
, case when Doitac_phapnhan = 'FE' THEN N'Thu lãi của KH đối tác FE hưởng'
	when Doitac_phapnhan = 'MA' THEN N'Thu lãi của KH đối tác MR hưởng'
	when Doitac_phapnhan = 'TC' THEN N'Thu lãi của KH đối tác TC hưởng'
	when Doitac_phapnhan = 'TD' THEN N'Thu lãi của KH đối tác TD hưởng'
	when Doitac_phapnhan = 'VC' THEN N'Thu lãi của KH đối tác VC hưởng'
	when Doitac_phapnhan = 'VP' THEN N'Thu lãi của KH đối tác VP hưởng'
end
, concat('TD',(case when len(macn)=1 then '00'+ CAST(macn as varchar(3)) when len(macn)=2 then '0'+ CAST(macn as varchar(3)) else cast(macn as varchar(3)) end))
,case 
	when Doitac_phapnhan = 'FE' THEN '3388111'
	when Doitac_phapnhan = 'MA' THEN '3388141'
	when Doitac_phapnhan = 'TC' THEN '33884'
	when Doitac_phapnhan = 'TD' THEN '33884'
	when Doitac_phapnhan = 'VP' THEN '3388131'
	when Doitac_phapnhan = 'VC' THEN '338812'
end
, concat('CRM-TL',
Doitac_phapnhan
,(case when month(ngay_dongthuc) < 10 then '0' +CAST(month(ngay_dongthuc) as varchar(2)) else CAST(month(ngay_dongthuc) as varchar(2)) end ) ,'/' , Right(Cast(year(ngay_dongthuc) as nvarchar(4)),2)
)
, mahd
, Doitac_phapnhan

UNION ALL

--- Tra phi cac khoan vay off-balance sheet lending
select null as hienthitreso 
, ngay_dongthuc as  ngay_hach_toan
, ngay_dongthuc as ngay_chung_tu
, concat('CRM-TP',
Doitac_phapnhan
,(case when month(ngay_dongthuc) < 10 then '0' +CAST(month(ngay_dongthuc) as varchar(2)) else CAST(month(ngay_dongthuc) as varchar(2)) end ) ,'/' , Right(Cast(year(ngay_dongthuc) as nvarchar(4)),2)
) as so_chung_tu
,
case when Doitac_phapnhan = 'FE' AND Groups ='Weekly' THEN 'SPT-FE'
	when Doitac_phapnhan = 'FE' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPK-FE'
	when Doitac_phapnhan = 'FE' AND Groups = 'Daily' THEN 'SPN-FE'
	when Doitac_phapnhan = 'MA' AND Groups ='Weekly' THEN 'SPT-MR'
	when Doitac_phapnhan = 'MA' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPK-MR'
	when Doitac_phapnhan = 'MA' AND Groups = 'Daily' THEN 'SPN-MR'
	when Doitac_phapnhan = 'TC' AND Groups ='Weekly' THEN 'SPTTCTC'
	when Doitac_phapnhan = 'TC' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPKTC'
	when Doitac_phapnhan = 'TC' AND Groups = 'Daily' THEN 'SPNTC'
	when Doitac_phapnhan = 'TD' AND Groups ='Weekly' THEN 'SPT-TD'
	when Doitac_phapnhan = 'TD' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPK-TD'
	when Doitac_phapnhan = 'TD' AND Groups = 'Daily' THEN 'SPN-TD'
	when Doitac_phapnhan = 'VP' AND Groups ='Weekly' THEN 'SPT-VPB'
	when Doitac_phapnhan = 'VP' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPK-VPB'
	when Doitac_phapnhan = 'VP' AND Groups = 'Daily' THEN 'SPN-VPB'
	when Doitac_phapnhan = 'VC' AND Groups ='Weekly' THEN 'SPT-VC'
	when Doitac_phapnhan = 'VC' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPK-VC'
	when Doitac_phapnhan = 'VC' AND Groups = 'Daily' THEN 'SPN-VC'
end  as ma_doi_tuong
, null as ten_doi_tuong
, null as diachi
, null as ly_do_nop
, case when Doitac_phapnhan = 'FE' THEN concat(N'Thu phí ủy quyền của KH KA hưởng từ KH của đối tác FE - ',mahd)
	when Doitac_phapnhan = 'MA' THEN concat(N'Thu phí ủy quyền của KH KA hưởng từ KH của đối tác MR - ',mahd)
	when Doitac_phapnhan = 'TC' THEN concat(N'Thu phí ủy quyền của KH KA hưởng từ KH của đối tác TC - ',mahd)
	when Doitac_phapnhan = 'TD' THEN concat(N'Thu phí ủy quyền của KH KA hưởng từ KH của đối tác TD - ',mahd)
	when Doitac_phapnhan = 'VC' THEN concat(N'Thu phí ủy quyền của KH KA hưởng từ KH của đối tác VC - ',mahd)
	when Doitac_phapnhan = 'VP' THEN concat(N'Thu phí ủy quyền của KH KA hưởng từ KH của đối tác VP - ',mahd)
end as dien_giai_ly_do_nop
, null as nguoi_nop
, null as  nhan_vien_thu
, null as  kem_theo
, null as  loai_tien
, null as  ty_gia
, case when Doitac_phapnhan = 'FE' THEN concat(N'Thu phí ủy quyền của KH KA hưởng từ KH của đối tác FE - ',mahd)
	when Doitac_phapnhan = 'MA' THEN concat(N'Thu phí ủy quyền của KH KA hưởng từ KH của đối tác MR - ',mahd)
	when Doitac_phapnhan = 'TC' THEN concat(N'Thu phí ủy quyền của KH KA hưởng từ KH của đối tác TC - ',mahd)
	when Doitac_phapnhan = 'TD' THEN concat(N'Thu phí ủy quyền của KH KA hưởng từ KH của đối tác TD - ',mahd)
	when Doitac_phapnhan = 'VC' THEN concat(N'Thu phí ủy quyền của KH KA hưởng từ KH của đối tác VC - ',mahd)
	when Doitac_phapnhan = 'VP' THEN concat(N'Thu phí ủy quyền của KH KA hưởng từ KH của đối tác VP - ',mahd)
end as dien_giai
, '111108' as TK_no
, '51131' as TK_co
, sum(round(Phi_KA/1.1,0)) as so_tien
, null as   quy_doi
, null as   doi_tuong
, null as   Tk_ngan_hang
, null as hop_dong_ban
, concat('TD',(case when len(macn)=1 then '00'+ CAST(macn as varchar(3)) when len(macn)=2 then '0'+ CAST(macn as varchar(3)) else cast(macn as varchar(3)) end)) as don_vi
, mahd
, Doitac_phapnhan
from #tam_bang_thu_sp_ky_gom_thudu
left join (select mahd_crm, ngaymo from #tam_chitiet_hopdong) b on #tam_bang_thu_sp_ky_gom_thudu.mahd = b.mahd_crm --- lấy thêm thông tin ngày mở để lọc các hợp đồng đối tác là TD nhưng không trả phí lại cho Toàn Diện VN
where Phi_KA is not null and Phi_KA > 0 and dbo.GETYM(ngay_dongthuc) >= 202203 and ma_loai_hd != '41' and (Doitac_phapnhan != 'TD' or (Doitac_phapnhan = 'TD' and dbo.GETYMD(b.ngaymo) < 20220319)) --- các hợp đồng giải ngân từ ngày 20220319 thì phí sẽ kê khai ở Toàn Diện VN
group by ngay_dongthuc
, ngay_dongthuc
, case when Doitac_phapnhan = 'FE' AND Groups ='Weekly' THEN 'SPT-FE'
	when Doitac_phapnhan = 'FE' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPK-FE'
	when Doitac_phapnhan = 'FE' AND Groups = 'Daily' THEN 'SPN-FE'
	when Doitac_phapnhan = 'MA' AND Groups ='Weekly' THEN 'SPT-MR'
	when Doitac_phapnhan = 'MA' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPK-MR'
	when Doitac_phapnhan = 'MA' AND Groups = 'Daily' THEN 'SPN-MR'
	when Doitac_phapnhan = 'TC' AND Groups ='Weekly' THEN 'SPTTCTC'
	when Doitac_phapnhan = 'TC' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPKTC'
	when Doitac_phapnhan = 'TC' AND Groups = 'Daily' THEN 'SPNTC'
	when Doitac_phapnhan = 'TD' AND Groups ='Weekly' THEN 'SPT-TD'
	when Doitac_phapnhan = 'TD' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPK-TD'
	when Doitac_phapnhan = 'TD' AND Groups = 'Daily' THEN 'SPN-TD'
	when Doitac_phapnhan = 'VP' AND Groups ='Weekly' THEN 'SPT-VPB'
	when Doitac_phapnhan = 'VP' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPK-VPB'
	when Doitac_phapnhan = 'VP' AND Groups = 'Daily' THEN 'SPN-VPB'
	when Doitac_phapnhan = 'VC' AND Groups ='Weekly' THEN 'SPT-VC'
	when Doitac_phapnhan = 'VC' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPK-VC'
	when Doitac_phapnhan = 'VC' AND Groups = 'Daily' THEN 'SPN-VC'
end
, case when Doitac_phapnhan = 'FE' THEN concat(N'Thu phí ủy quyền của KH KA hưởng từ KH của đối tác FE - ',mahd)
	when Doitac_phapnhan = 'MA' THEN concat(N'Thu phí ủy quyền của KH KA hưởng từ KH của đối tác MR - ',mahd)
	when Doitac_phapnhan = 'TC' THEN concat(N'Thu phí ủy quyền của KH KA hưởng từ KH của đối tác TC - ',mahd)
	when Doitac_phapnhan = 'TD' THEN concat(N'Thu phí ủy quyền của KH KA hưởng từ KH của đối tác TD - ',mahd)
	when Doitac_phapnhan = 'VC' THEN concat(N'Thu phí ủy quyền của KH KA hưởng từ KH của đối tác VC - ',mahd)
	when Doitac_phapnhan = 'VP' THEN concat(N'Thu phí ủy quyền của KH KA hưởng từ KH của đối tác VP - ',mahd)
end
, concat('TD',(case when len(macn)=1 then '00'+ CAST(macn as varchar(3)) when len(macn)=2 then '0'+ CAST(macn as varchar(3)) else cast(macn as varchar(3)) end))
, concat('CRM-TP',
Doitac_phapnhan
,(case when month(ngay_dongthuc) < 10 then '0' +CAST(month(ngay_dongthuc) as varchar(2)) else CAST(month(ngay_dongthuc) as varchar(2)) end ) ,'/' , Right(Cast(year(ngay_dongthuc) as nvarchar(4)),2))
, mahd
, Doitac_phapnhan

UNION ALL

--- Tra VAT cac khoan vay off-balance sheet lending

select null as hienthitreso 
, ngay_dongthuc as  ngay_hach_toan
, ngay_dongthuc as ngay_chung_tu
, concat('CRM-VAT',
Doitac_phapnhan
,(case when month(ngay_dongthuc) < 10 then '0' +CAST(month(ngay_dongthuc) as varchar(2)) else CAST(month(ngay_dongthuc) as varchar(2)) end ) ,'/' , Right(Cast(year(ngay_dongthuc) as nvarchar(4)),2)
) as so_chung_tu
,
case when Doitac_phapnhan = 'FE' AND Groups ='Weekly' THEN 'SPT-FE'
	when Doitac_phapnhan = 'FE' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPK-FE'
	when Doitac_phapnhan = 'FE' AND Groups = 'Daily' THEN 'SPN-FE'
	when Doitac_phapnhan = 'MA' AND Groups ='Weekly' THEN 'SPT-MR'
	when Doitac_phapnhan = 'MA' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPK-MR'
	when Doitac_phapnhan = 'MA' AND Groups = 'Daily' THEN 'SPN-MR'
	when Doitac_phapnhan = 'TC' AND Groups ='Weekly' THEN 'SPTTCTC'
	when Doitac_phapnhan = 'TC' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPKTC'
	when Doitac_phapnhan = 'TC' AND Groups = 'Daily' THEN 'SPNTC'
	when Doitac_phapnhan = 'TD' AND Groups ='Weekly' THEN 'SPT-TD'
	when Doitac_phapnhan = 'TD' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPK-TD'
	when Doitac_phapnhan = 'TD' AND Groups = 'Daily' THEN 'SPN-TD'
	when Doitac_phapnhan = 'VP' AND Groups ='Weekly' THEN 'SPT-VPB'
	when Doitac_phapnhan = 'VP' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPK-VPB'
	when Doitac_phapnhan = 'VP' AND Groups = 'Daily' THEN 'SPN-VPB'
	when Doitac_phapnhan = 'VC' AND Groups ='Weekly' THEN 'SPT-VC'
	when Doitac_phapnhan = 'VC' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPK-VC'
	when Doitac_phapnhan = 'VC' AND Groups = 'Daily' THEN 'SPN-VC'
end  as ma_doi_tuong
, null as ten_doi_tuong
, null as diachi
, null as ly_do_nop
, case when Doitac_phapnhan = 'FE' THEN concat(N'Thu VAT của phí ủy quyền của KH KA hưởng từ KH của đối tác FE - ',mahd)
	when Doitac_phapnhan = 'MA' THEN concat(N'Thu VAT của phí ủy quyền của KH KA hưởng từ KH của đối tác MR - ',mahd)
	when Doitac_phapnhan = 'TC' THEN concat(N'Thu VAT của phí ủy quyền của KH KA hưởng từ KH của đối tác TC - ',mahd)
	when Doitac_phapnhan = 'TD' THEN concat(N'Thu VAT của phí ủy quyền của KH KA hưởng từ KH của đối tác TD - ',mahd)
	when Doitac_phapnhan = 'VC' THEN concat(N'Thu VAT của phí ủy quyền của KH KA hưởng từ KH của đối tác VC - ',mahd)
	when Doitac_phapnhan = 'VP' THEN concat(N'Thu VAT của phí ủy quyền của KH KA hưởng từ KH của đối tác VP - ',mahd)
end as dien_giai_ly_do_nop
, null as nguoi_nop
, null as  nhan_vien_thu
, null as  kem_theo
, null as  loai_tien
, null as  ty_gia
, case when Doitac_phapnhan = 'FE' THEN concat(N'Thu VAT của phí ủy quyền của KH KA hưởng từ KH của đối tác FE - ',mahd)
	when Doitac_phapnhan = 'MA' THEN concat(N'Thu VAT của phí ủy quyền của KH KA hưởng từ KH của đối tác MR - ',mahd)
	when Doitac_phapnhan = 'TC' THEN concat(N'Thu VAT của phí ủy quyền của KH KA hưởng từ KH của đối tác TC - ',mahd)
	when Doitac_phapnhan = 'TD' THEN concat(N'Thu VAT của phí ủy quyền của KH KA hưởng từ KH của đối tác TD - ',mahd)
	when Doitac_phapnhan = 'VC' THEN concat(N'Thu VAT của phí ủy quyền của KH KA hưởng từ KH của đối tác VC - ',mahd)
	when Doitac_phapnhan = 'VP' THEN concat(N'Thu VAT của phí ủy quyền của KH KA hưởng từ KH của đối tác VP - ',mahd)
end as dien_giai
, '111108' as TK_no
, '33311' as TK_co
, sum(round(Phi_KA/11,0)) as so_tien
, null as   quy_doi
, null as   doi_tuong
, null as   Tk_ngan_hang
, null as hop_dong_ban
, concat('TD',(case when len(macn)=1 then '00'+ CAST(macn as varchar(3)) when len(macn)=2 then '0'+ CAST(macn as varchar(3)) else cast(macn as varchar(3)) end)) as don_vi
, mahd
, Doitac_phapnhan
from #tam_bang_thu_sp_ky_gom_thudu
left join (select mahd_crm, ngaymo from #tam_chitiet_hopdong) b on #tam_bang_thu_sp_ky_gom_thudu.mahd = b.mahd_crm --- lấy thêm thông tin ngày mở để lọc các hợp đồng đối tác là TD nhưng không trả phí lại cho Toàn Diện VN
where Phi_KA is not null and Phi_KA > 0 and dbo.GETYM(ngay_dongthuc) >= 202203 and ma_loai_hd != '41' and (Doitac_phapnhan != 'TD' or (Doitac_phapnhan = 'TD' and dbo.GETYMD(b.ngaymo) < 20220319)) --- các hợp đồng giải ngân từ ngày 20220319 thì phí sẽ kê khai ở Toàn Diện VN
group by ngay_dongthuc
, ngay_dongthuc
, case when Doitac_phapnhan = 'FE' AND Groups ='Weekly' THEN 'SPT-FE'
	when Doitac_phapnhan = 'FE' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPK-FE'
	when Doitac_phapnhan = 'FE' AND Groups = 'Daily' THEN 'SPN-FE'
	when Doitac_phapnhan = 'MA' AND Groups ='Weekly' THEN 'SPT-MR'
	when Doitac_phapnhan = 'MA' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPK-MR'
	when Doitac_phapnhan = 'MA' AND Groups = 'Daily' THEN 'SPN-MR'
	when Doitac_phapnhan = 'TC' AND Groups ='Weekly' THEN 'SPTTCTC'
	when Doitac_phapnhan = 'TC' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPKTC'
	when Doitac_phapnhan = 'TC' AND Groups = 'Daily' THEN 'SPNTC'
	when Doitac_phapnhan = 'TD' AND Groups ='Weekly' THEN 'SPT-TD'
	when Doitac_phapnhan = 'TD' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPK-TD'
	when Doitac_phapnhan = 'TD' AND Groups = 'Daily' THEN 'SPN-TD'
	when Doitac_phapnhan = 'VP' AND Groups ='Weekly' THEN 'SPT-VPB'
	when Doitac_phapnhan = 'VP' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPK-VPB'
	when Doitac_phapnhan = 'VP' AND Groups = 'Daily' THEN 'SPN-VPB'
	when Doitac_phapnhan = 'VC' AND Groups ='Weekly' THEN 'SPT-VC'
	when Doitac_phapnhan = 'VC' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPK-VC'
	when Doitac_phapnhan = 'VC' AND Groups = 'Daily' THEN 'SPN-VC'
end
, case when Doitac_phapnhan = 'FE' THEN concat(N'Thu VAT của phí ủy quyền của KH KA hưởng từ KH của đối tác FE - ',mahd)
	when Doitac_phapnhan = 'MA' THEN concat(N'Thu VAT của phí ủy quyền của KH KA hưởng từ KH của đối tác MR - ',mahd)
	when Doitac_phapnhan = 'TC' THEN concat(N'Thu VAT của phí ủy quyền của KH KA hưởng từ KH của đối tác TC - ',mahd)
	when Doitac_phapnhan = 'TD' THEN concat(N'Thu VAT của phí ủy quyền của KH KA hưởng từ KH của đối tác TD - ',mahd)
	when Doitac_phapnhan = 'VC' THEN concat(N'Thu VAT của phí ủy quyền của KH KA hưởng từ KH của đối tác VC - ',mahd)
	when Doitac_phapnhan = 'VP' THEN concat(N'Thu VAT của phí ủy quyền của KH KA hưởng từ KH của đối tác VP - ',mahd)
end
, concat('TD',(case when len(macn)=1 then '00'+ CAST(macn as varchar(3)) when len(macn)=2 then '0'+ CAST(macn as varchar(3)) else cast(macn as varchar(3)) end))
, concat('CRM-VAT',
Doitac_phapnhan
,(case when month(ngay_dongthuc) < 10 then '0' +CAST(month(ngay_dongthuc) as varchar(2)) else CAST(month(ngay_dongthuc) as varchar(2)) end ) ,'/' , Right(Cast(year(ngay_dongthuc) as nvarchar(4)),2)
)
, mahd
, Doitac_phapnhan

UNION ALL

--- Tra phi cac khoan vay cua Toan Dien VN - TD Kim An thu hộ và trả lại cho Toàn Diện VN

select null as hienthitreso 
, ngay_dongthuc as  ngay_hach_toan
, ngay_dongthuc as ngay_chung_tu
, concat('CRM-TP',
Doitac_phapnhan
,(case when month(ngay_dongthuc) < 10 then '0' +CAST(month(ngay_dongthuc) as varchar(2)) else CAST(month(ngay_dongthuc) as varchar(2)) end ) ,'/' , Right(Cast(year(ngay_dongthuc) as nvarchar(4)),2)
) as so_chung_tu
,
case 
	when Doitac_phapnhan = 'TD' AND Groups ='Weekly' THEN 'SPT-TD'
	when Doitac_phapnhan = 'TD' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPK-TD'
	when Doitac_phapnhan = 'TD' AND Groups = 'Daily' THEN 'SPN-TD'
end  as ma_doi_tuong
, null as ten_doi_tuong
, null as diachi
, null as ly_do_nop
, case
	when Doitac_phapnhan = 'TD' THEN N'Thu phí của KH đối tác TD hưởng'
end as dien_giai_ly_do_nop
, null as nguoi_nop
, null as  nhan_vien_thu
, null as  kem_theo
, null as  loai_tien
, null as  ty_gia
, case 
	when Doitac_phapnhan = 'TD' THEN N'Thu phí của KH đối tác TD hưởng'
end as dien_giai
, '111108' as TK_no
, case 
	when Doitac_phapnhan = 'TD' THEN '33884'
end as TK_co
, sum(Phi_KA) as so_tien
, null as   quy_doi
, null as   doi_tuong
, null as   Tk_ngan_hang
, null as hop_dong_ban
, concat('TD',(case when len(macn)=1 then '00'+ CAST(macn as varchar(3)) when len(macn)=2 then '0'+ CAST(macn as varchar(3)) else cast(macn as varchar(3)) end)) as don_vi
, mahd
, Doitac_phapnhan
from #tam_bang_thu_sp_ky_gom_thudu
left join (select mahd_crm, ngaymo from #tam_chitiet_hopdong) b on #tam_bang_thu_sp_ky_gom_thudu.mahd = b.mahd_crm 
--- lấy thêm thông tin ngày mở để lọc các hợp đồng đối tác là TD, giải ngân từ ngày 19.03 thì TD Kim An cần trả phí lại cho Toàn Diện VN
where Phi_KA is not null and Phi_KA > 0 and dbo.GETYM(ngay_dongthuc) >= 202203 and ma_loai_hd != '41' and Doitac_phapnhan = 'TD' and dbo.GETYMD(b.ngaymo) >= 20220319
group by ngay_dongthuc
, ngay_dongthuc
, case 
	when Doitac_phapnhan = 'TD' AND Groups ='Weekly' THEN 'SPT-TD'
	when Doitac_phapnhan = 'TD' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPK-TD'
	when Doitac_phapnhan = 'TD' AND Groups = 'Daily' THEN 'SPN-TD'
end
, case 
	when Doitac_phapnhan = 'TD' THEN N'Thu phí của KH đối tác TD hưởng'
end
, concat('TD',(case when len(macn)=1 then '00'+ CAST(macn as varchar(3)) when len(macn)=2 then '0'+ CAST(macn as varchar(3)) else cast(macn as varchar(3)) end))
,case 
	when Doitac_phapnhan = 'TD' THEN '33884'
end
, concat('CRM-TP',
Doitac_phapnhan
,(case when month(ngay_dongthuc) < 10 then '0' +CAST(month(ngay_dongthuc) as varchar(2)) else CAST(month(ngay_dongthuc) as varchar(2)) end ) ,'/' , Right(Cast(year(ngay_dongthuc) as nvarchar(4)),2)
)
, mahd
, Doitac_phapnhan


UNION ALL

--- Tra phi bi am cac khoan vay off-balance sheet lending
select null as hienthitreso 
, ngay_dongthuc as  ngay_hach_toan
, ngay_dongthuc as ngay_chung_tu
, concat('CRM-TP',
Doitac_phapnhan
,(case when month(ngay_dongthuc) < 10 then '0' +CAST(month(ngay_dongthuc) as varchar(2)) else CAST(month(ngay_dongthuc) as varchar(2)) end ) ,'/' , Right(Cast(year(ngay_dongthuc) as nvarchar(4)),2)
) as so_chung_tu
,
case when Doitac_phapnhan = 'FE' AND Groups ='Weekly' THEN 'SPT-FE'
	when Doitac_phapnhan = 'FE' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPK-FE'
	when Doitac_phapnhan = 'FE' AND Groups = 'Daily' THEN 'SPN-FE'
	when Doitac_phapnhan = 'MA' AND Groups ='Weekly' THEN 'SPT-MR'
	when Doitac_phapnhan = 'MA' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPK-MR'
	when Doitac_phapnhan = 'MA' AND Groups = 'Daily' THEN 'SPN-MR'
	when Doitac_phapnhan = 'TC' AND Groups ='Weekly' THEN 'SPTTCTC'
	when Doitac_phapnhan = 'TC' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPKTC'
	when Doitac_phapnhan = 'TC' AND Groups = 'Daily' THEN 'SPNTC'
	when Doitac_phapnhan = 'TD' AND Groups ='Weekly' THEN 'SPT-TD'
	when Doitac_phapnhan = 'TD' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPK-TD'
	when Doitac_phapnhan = 'TD' AND Groups = 'Daily' THEN 'SPN-TD'
	when Doitac_phapnhan = 'VP' AND Groups ='Weekly' THEN 'SPT-VPB'
	when Doitac_phapnhan = 'VP' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPK-VPB'
	when Doitac_phapnhan = 'VP' AND Groups = 'Daily' THEN 'SPN-VPB'
	when Doitac_phapnhan = 'VC' AND Groups ='Weekly' THEN 'SPT-VC'
	when Doitac_phapnhan = 'VC' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPK-VC'
	when Doitac_phapnhan = 'VC' AND Groups = 'Daily' THEN 'SPN-VC'
end as ma_doi_tuong
, null as ten_doi_tuong
, null as diachi
, null as ly_do_nop
, case when Doitac_phapnhan = 'FE' THEN N'Lãi KA hưởng bị âm từ đối tác FE'
	when Doitac_phapnhan = 'MA' THEN N'Lãi KA hưởng bị âm từ đối tác MR'
	when Doitac_phapnhan = 'TC' THEN N'Lãi KA hưởng bị âm từ đối tác TC'
	when Doitac_phapnhan = 'TD' THEN N'Lãi KA hưởng bị âm từ đối tác TD'
	when Doitac_phapnhan = 'VC' THEN N'Lãi KA hưởng bị âm từ đối tác VC'
	when Doitac_phapnhan = 'VP' THEN N'Lãi KA hưởng bị âm từ đối tác VP'
end as dien_giai_ly_do_nop
, null as nguoi_nop
, null as  nhan_vien_thu
, null as  kem_theo
, null as  loai_tien
, null as  ty_gia
, case when Doitac_phapnhan = 'FE' THEN N'Lãi KA hưởng bị âm từ đối tác FE'
	when Doitac_phapnhan = 'MA' THEN N'Lãi KA hưởng bị âm từ đối tác MR'
	when Doitac_phapnhan = 'TC' THEN N'Lãi KA hưởng bị âm từ đối tác TC'
	when Doitac_phapnhan = 'TD' THEN N'Lãi KA hưởng bị âm từ đối tác TD'
	when Doitac_phapnhan = 'VC' THEN N'Lãi KA hưởng bị âm từ đối tác VC'
	when Doitac_phapnhan = 'VP' THEN N'Lãi KA hưởng bị âm từ đối tác VP'
end as dien_giai
, '52131' as TK_no
, '111108' as TK_co
, sum(Phi_KA) as so_tien
, null as   quy_doi
, null as   doi_tuong
, null as   Tk_ngan_hang
, null as hop_dong_ban
, concat('TD',(case when len(macn)=1 then '00'+ CAST(macn as varchar(3)) when len(macn)=2 then '0'+ CAST(macn as varchar(3)) else cast(macn as varchar(3)) end)) as don_vi
, mahd
, Doitac_phapnhan
from #tam_bang_thu_sp_ky_gom_thudu
where Phi_KA is not null and Phi_KA < 0 and dbo.GETYM(ngay_dongthuc) >= 202203 and ma_loai_hd != '41'
group by ngay_dongthuc
, ngay_dongthuc
, concat('CRM-TP',
Doitac_phapnhan
,(case when month(ngay_dongthuc) < 10 then '0' +CAST(month(ngay_dongthuc) as varchar(2)) else CAST(month(ngay_dongthuc) as varchar(2)) end ) ,'/' , Right(Cast(year(ngay_dongthuc) as nvarchar(4)),2)
)
, case when Doitac_phapnhan = 'FE' AND Groups ='Weekly' THEN 'SPT-FE'
	when Doitac_phapnhan = 'FE' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPK-FE'
	when Doitac_phapnhan = 'FE' AND Groups = 'Daily' THEN 'SPN-FE'
	when Doitac_phapnhan = 'MA' AND Groups ='Weekly' THEN 'SPT-MR'
	when Doitac_phapnhan = 'MA' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPK-MR'
	when Doitac_phapnhan = 'MA' AND Groups = 'Daily' THEN 'SPN-MR'
	when Doitac_phapnhan = 'TC' AND Groups ='Weekly' THEN 'SPTTCTC'
	when Doitac_phapnhan = 'TC' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPKTC'
	when Doitac_phapnhan = 'TC' AND Groups = 'Daily' THEN 'SPNTC'
	when Doitac_phapnhan = 'TD' AND Groups ='Weekly' THEN 'SPT-TD'
	when Doitac_phapnhan = 'TD' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPK-TD'
	when Doitac_phapnhan = 'TD' AND Groups = 'Daily' THEN 'SPN-TD'
	when Doitac_phapnhan = 'VP' AND Groups ='Weekly' THEN 'SPT-VPB'
	when Doitac_phapnhan = 'VP' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPK-VPB'
	when Doitac_phapnhan = 'VP' AND Groups = 'Daily' THEN 'SPN-VPB'
	when Doitac_phapnhan = 'VC' AND Groups ='Weekly' THEN 'SPT-VC'
	when Doitac_phapnhan = 'VC' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPK-VC'
	when Doitac_phapnhan = 'VC' AND Groups = 'Daily' THEN 'SPN-VC'
end
, case when Doitac_phapnhan = 'FE' THEN N'Lãi KA hưởng bị âm từ đối tác FE'
	when Doitac_phapnhan = 'MA' THEN N'Lãi KA hưởng bị âm từ đối tác MR'
	when Doitac_phapnhan = 'TC' THEN N'Lãi KA hưởng bị âm từ đối tác TC'
	when Doitac_phapnhan = 'TD' THEN N'Lãi KA hưởng bị âm từ đối tác TD'
	when Doitac_phapnhan = 'VC' THEN N'Lãi KA hưởng bị âm từ đối tác VC'
	when Doitac_phapnhan = 'VP' THEN N'Lãi KA hưởng bị âm từ đối tác VP'
end
, concat('TD',(case when len(macn)=1 then '00'+ CAST(macn as varchar(3)) when len(macn)=2 then '0'+ CAST(macn as varchar(3)) else cast(macn as varchar(3)) end))
, mahd
, Doitac_phapnhan

UNION ALL

--- Thu du
select null as hienthitreso 
, ngay_dongthuc as  ngay_hach_toan
, ngay_dongthuc as ngay_chung_tu
, concat('CRM-TP',
Doitac_phapnhan
,(case when month(ngay_dongthuc) < 10 then '0' +CAST(month(ngay_dongthuc) as varchar(2)) else CAST(month(ngay_dongthuc) as varchar(2)) end ) ,'/' , Right(Cast(year(ngay_dongthuc) as nvarchar(4)),2)
) as so_chung_tu
,
case when Doitac_phapnhan = 'FE' AND Groups ='Weekly' THEN 'SPTFE-TD'
	when Doitac_phapnhan = 'FE' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPKFE-TD'
	when Doitac_phapnhan = 'FE' AND Groups = 'Daily' THEN 'SPNFE-TD'
	when Doitac_phapnhan = 'MA' AND Groups ='Weekly' THEN 'SPTMR-TD'
	when Doitac_phapnhan = 'MA' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPKMR-TD'
	when Doitac_phapnhan = 'MA' AND Groups = 'Daily' THEN 'SPNMR-TD'
	when Doitac_phapnhan = 'TC' AND Groups ='Weekly' THEN 'SPTTCTC-TD'
	when Doitac_phapnhan = 'TC' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPKTC-TD'
	when Doitac_phapnhan = 'TC' AND Groups = 'Daily' THEN 'SPNTC-TD'
	when Doitac_phapnhan = 'TD' AND Groups ='Weekly' THEN 'SPTTD-TD'
	when Doitac_phapnhan = 'TD' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPKTD-TD'
	when Doitac_phapnhan = 'TD' AND Groups = 'Daily' THEN 'SPNTD-TD'
	when Doitac_phapnhan = 'VP' AND Groups ='Weekly' THEN 'SPTVPB-TD'
	when Doitac_phapnhan = 'VP' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPKVPB-TD'
	when Doitac_phapnhan = 'VP' AND Groups = 'Daily' THEN 'SPNVPB-TD'
	when Doitac_phapnhan = 'VC' AND Groups ='Weekly' THEN 'SPTVC-TD'
	when Doitac_phapnhan = 'VC' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPKVC-TD'
	when Doitac_phapnhan = 'VC' AND Groups = 'Daily' THEN 'SPNVC-TD'
end  as ma_doi_tuong
, null as ten_doi_tuong
, null as diachi
, null as ly_do_nop
, case when Doitac_phapnhan = 'FE' THEN N'Thu dư từ KH của đối tác FE'
	when Doitac_phapnhan = 'MA' THEN N'Thu dư từ KH của đối tác MR'
	when Doitac_phapnhan = 'TC' THEN N'Thu dư từ KH của đối tác TC'
	when Doitac_phapnhan = 'TD' THEN N'Thu dư từ KH của đối tác TD'
	when Doitac_phapnhan = 'VC' THEN N'Thu dư từ KH của đối tác VC'
	when Doitac_phapnhan = 'VP' THEN N'Thu dư từ KH của đối tác VP'
end as dien_giai_ly_do_nop
, null as nguoi_nop
, null as  nhan_vien_thu
, null as  kem_theo
, null as  loai_tien
, null as  ty_gia
, case when Doitac_phapnhan = 'FE' THEN N'Thu dư từ KH của đối tác FE'
	when Doitac_phapnhan = 'MA' THEN N'Thu dư từ KH của đối tác MR'
	when Doitac_phapnhan = 'TC' THEN N'Thu dư từ KH của đối tác TC'
	when Doitac_phapnhan = 'TD' THEN N'Thu dư từ KH của đối tác TD'
	when Doitac_phapnhan = 'VC' THEN N'Thu dư từ KH của đối tác VC'
	when Doitac_phapnhan = 'VP' THEN N'Thu dư từ KH của đối tác VP'
end as dien_giai
, (case when  Thudu>0 then '111108' else '3388111' end )  as TK_no
,  (case when  Thudu>0 then '3388111' else '111108' end )  as TK_co
, (case when sum(Thudu)<0 then sum(Thudu)*-1 else sum(Thudu) end) as so_tien
, null as   quy_doi
, null as   doi_tuong
, null as   Tk_ngan_hang
, null as hop_dong_ban
, concat('TD',(case when len(macn)=1 then '00'+ CAST(macn as varchar(3)) when len(macn)=2 then '0'+ CAST(macn as varchar(3)) else cast(macn as varchar(3)) end)) as don_vi
, mahd
, Doitac_phapnhan
from #tam_bang_thu_sp_ky_gom_thudu
where Thudu is not null and Thudu != 0 and dbo.GETYM(ngay_dongthuc) >= 202203 and ma_loai_hd != '41'
group by ngay_dongthuc
, ngay_dongthuc
, case when Doitac_phapnhan = 'FE' AND Groups ='Weekly' THEN 'SPTFE-TD'
	when Doitac_phapnhan = 'FE' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPKFE-TD'
	when Doitac_phapnhan = 'FE' AND Groups = 'Daily' THEN 'SPNFE-TD'
	when Doitac_phapnhan = 'MA' AND Groups ='Weekly' THEN 'SPTMR-TD'
	when Doitac_phapnhan = 'MA' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPKMR-TD'
	when Doitac_phapnhan = 'MA' AND Groups = 'Daily' THEN 'SPNMR-TD'
	when Doitac_phapnhan = 'TC' AND Groups ='Weekly' THEN 'SPTTCTC-TD'
	when Doitac_phapnhan = 'TC' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPKTC-TD'
	when Doitac_phapnhan = 'TC' AND Groups = 'Daily' THEN 'SPNTC-TD'
	when Doitac_phapnhan = 'TD' AND Groups ='Weekly' THEN 'SPTTD-TD'
	when Doitac_phapnhan = 'TD' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPKTD-TD'
	when Doitac_phapnhan = 'TD' AND Groups = 'Daily' THEN 'SPNTD-TD'
	when Doitac_phapnhan = 'VP' AND Groups ='Weekly' THEN 'SPTVPB-TD'
	when Doitac_phapnhan = 'VP' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPKVPB-TD'
	when Doitac_phapnhan = 'VP' AND Groups = 'Daily' THEN 'SPNVPB-TD'
	when Doitac_phapnhan = 'VC' AND Groups ='Weekly' THEN 'SPTVC-TD'
	when Doitac_phapnhan = 'VC' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPKVC-TD'
	when Doitac_phapnhan = 'VC' AND Groups = 'Daily' THEN 'SPNVC-TD'
end
, case when Doitac_phapnhan = 'FE' THEN N'Thu dư từ KH của đối tác FE'
	when Doitac_phapnhan = 'MA' THEN N'Thu dư từ KH của đối tác MR'
	when Doitac_phapnhan = 'TC' THEN N'Thu dư từ KH của đối tác TC'
	when Doitac_phapnhan = 'TD' THEN N'Thu dư từ KH của đối tác TD'
	when Doitac_phapnhan = 'VC' THEN N'Thu dư từ KH của đối tác VC'
	when Doitac_phapnhan = 'VP' THEN N'Thu dư từ KH của đối tác VP'
end
, concat('TD',(case when len(macn)=1 then '00'+ CAST(macn as varchar(3)) when len(macn)=2 then '0'+ CAST(macn as varchar(3)) else cast(macn as varchar(3)) end))
, (case when  Thudu>0 then '111108' else '3388111' end )
,  (case when  Thudu>0 then '3388111' else '111108' end )
, concat('CRM-TP',
Doitac_phapnhan
,(case when month(ngay_dongthuc) < 10 then '0' +CAST(month(ngay_dongthuc) as varchar(2)) else CAST(month(ngay_dongthuc) as varchar(2)) end ) ,'/' , Right(Cast(year(ngay_dongthuc) as nvarchar(4)),2)
)
, mahd
, Doitac_phapnhan
) a


--- B9: Code bảng thu của Thịnh Cường khi thu lại gốc và khi thu dư

select * into #bang_thu_Thinh_Cuong
from (
 ---- Tra goc ---- 
select null as hienthitreso 
, ngay_dongthuc as  ngay_hach_toan
, ngay_dongthuc as ngay_chung_tu
, concat('CRM-GTC',
Doitac_phapnhan
,(case when month(ngay_dongthuc) < 10 then '0' +CAST(month(ngay_dongthuc) as varchar(2)) else CAST(month(ngay_dongthuc) as varchar(2)) end ) ,'/' , Right(Cast(year(ngay_dongthuc) as nvarchar(4)),2)
) as so_chung_tu
,
case
	when Doitac_phapnhan = 'TC' AND Groups ='Weekly' THEN 'SPTTCTC'
	when Doitac_phapnhan = 'TC' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPKTC'
	when Doitac_phapnhan = 'TC' AND Groups = 'Daily' THEN 'SPNTC'
end  as ma_doi_tuong
, null as ten_doi_tuong
, null as diachi
, null as ly_do_nop
, case 
	when Doitac_phapnhan = 'TC' THEN N'Thu gốc TC'
end as dien_giai_ly_do_nop
, null as nguoi_nop
, null as  nhan_vien_thu
, null as  kem_theo
, null as  loai_tien
, null as  ty_gia
, case 
	when Doitac_phapnhan = 'TC' THEN N'Thu gốc TC'
end as dien_giai
, '33884' as TK_no
, case 
	when Doitac_phapnhan = 'TC' THEN '1311'
end as TK_co
, sum(Goc) as so_tien
, null as   quy_doi
, null as   doi_tuong
, null as   Tk_ngan_hang
, null as hop_dong_ban
, case when len(macn)=1 then '00'+ CAST(macn as varchar(3)) when len(macn)=2 then '0'+ CAST(macn as varchar(3)) else cast(macn as varchar(3)) end as don_vi
, mahd
, Doitac_phapnhan
from #tam_bang_thu_sp_ky_gom_thudu
where Goc is not null and Goc != 0 and dbo.GETYM(ngay_dongthuc) >= 202203 and Doitac_phapnhan = 'TC' --- Sản phẩm Ứng vốn mã '41' thu tiền trực tiếp về tài khoản ngân hàng chứ không qua TD Kim An nên không có bút hạch toán gốc lãi ở đây
group by ngay_dongthuc
, ngay_dongthuc
, case 
	when Doitac_phapnhan = 'TC' AND Groups ='Weekly' THEN 'SPTTCTC'
	when Doitac_phapnhan = 'TC' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPKTC'
	when Doitac_phapnhan = 'TC' AND Groups = 'Daily' THEN 'SPNTC'
end 
, case 
	when Doitac_phapnhan = 'TC' THEN N'Thu gốc TC'
	
end
, case when len(macn)=1 then '00'+ CAST(macn as varchar(3)) when len(macn)=2 then '0'+ CAST(macn as varchar(3)) else cast(macn as varchar(3)) end
, case 
	when Doitac_phapnhan = 'TC' THEN '1311'
end
, concat('CRM-GTC',
Doitac_phapnhan
,(case when month(ngay_dongthuc) < 10 then '0' +CAST(month(ngay_dongthuc) as varchar(2)) else CAST(month(ngay_dongthuc) as varchar(2)) end ) ,'/' , Right(Cast(year(ngay_dongthuc) as nvarchar(4)),2)
)
, mahd
, Doitac_phapnhan

UNION ALL

--- Tra lai
select null as hienthitreso 
, ngay_dongthuc as  ngay_hach_toan
, ngay_dongthuc as ngay_chung_tu
, concat('CRM-LTC',
Doitac_phapnhan
,(case when month(ngay_dongthuc) < 10 then '0' +CAST(month(ngay_dongthuc) as varchar(2)) else CAST(month(ngay_dongthuc) as varchar(2)) end ) ,'/' , Right(Cast(year(ngay_dongthuc) as nvarchar(4)),2)
) as so_chung_tu
,
case when Doitac_phapnhan = 'TC' AND Groups ='Weekly' THEN 'SPTTCTC'
	when Doitac_phapnhan = 'TC' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPKTC'
	when Doitac_phapnhan = 'TC' AND Groups = 'Daily' THEN 'SPNTC'
end  as ma_doi_tuong
, null as ten_doi_tuong
, null as diachi
, null as ly_do_nop
, case 
	when Doitac_phapnhan = 'TC' THEN N'Thu lãi của KH đối tác TC hưởng'
end as dien_giai_ly_do_nop
, null as nguoi_nop
, null as  nhan_vien_thu
, null as  kem_theo
, null as  loai_tien
, null as  ty_gia
, case when Doitac_phapnhan = 'TC' THEN N'Thu lãi của KH đối tác TC hưởng'
end as dien_giai
, '33884' as TK_no
, case 
	when Doitac_phapnhan = 'TC' THEN '1311'
end as TK_co
, sum(Lai_doitac) as so_tien
, null as   quy_doi
, null as   doi_tuong
, null as   Tk_ngan_hang
, null as hop_dong_ban
, case when len(macn)=1 then '00'+ CAST(macn as varchar(3)) when len(macn)=2 then '0'+ CAST(macn as varchar(3)) else cast(macn as varchar(3)) end as don_vi
, mahd
, Doitac_phapnhan
from #tam_bang_thu_sp_ky_gom_thudu
where lai is not null and lai != 0 and dbo.GETYM(ngay_dongthuc) >= 202203 and Doitac_phapnhan = 'TC' --- Sản phẩm Ứng vốn mã '41' thu tiền trực tiếp về tài khoản ngân hàng chứ không qua TD Kim An nên không có bút hạch toán gốc lãi ở đây
group by ngay_dongthuc
, ngay_dongthuc
, case 
	when Doitac_phapnhan = 'TC' AND Groups ='Weekly' THEN 'SPTTCTC'
	when Doitac_phapnhan = 'TC' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPKTC'
	when Doitac_phapnhan = 'TC' AND Groups = 'Daily' THEN 'SPNTC'
end 
, case 
	when Doitac_phapnhan = 'TC' THEN N'Thu lãi của KH đối tác TC hưởng'
end
, case when len(macn)=1 then '00'+ CAST(macn as varchar(3)) when len(macn)=2 then '0'+ CAST(macn as varchar(3)) else cast(macn as varchar(3)) end
, case 
	when Doitac_phapnhan = 'TC' THEN '1311'
end
, concat('CRM-LTC',
Doitac_phapnhan
,(case when month(ngay_dongthuc) < 10 then '0' +CAST(month(ngay_dongthuc) as varchar(2)) else CAST(month(ngay_dongthuc) as varchar(2)) end ) ,'/' , Right(Cast(year(ngay_dongthuc) as nvarchar(4)),2)
)
, mahd
, Doitac_phapnhan

UNION ALL

--- Thu du
select null as hienthitreso 
, ngay_dongthuc as  ngay_hach_toan
, ngay_dongthuc as ngay_chung_tu
, concat('CRM-TDTC',
Doitac_phapnhan
,(case when month(ngay_dongthuc) < 10 then '0' +CAST(month(ngay_dongthuc) as varchar(2)) else CAST(month(ngay_dongthuc) as varchar(2)) end ) ,'/' , Right(Cast(year(ngay_dongthuc) as nvarchar(4)),2)
) as so_chung_tu
,
case 
	when Doitac_phapnhan = 'TC' AND Groups ='Weekly' THEN 'SPTTCTC-TD'
	when Doitac_phapnhan = 'TC' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPKTC-TD'
	when Doitac_phapnhan = 'TC' AND Groups = 'Daily' THEN 'SPNTC-TD'
end  as ma_doi_tuong
, null as ten_doi_tuong
, null as diachi
, null as ly_do_nop
, case when Doitac_phapnhan = 'TC' THEN N'Thu dư từ KH của đối tác TC'
end as dien_giai_ly_do_nop
, null as nguoi_nop
, null as  nhan_vien_thu
, null as  kem_theo
, null as  loai_tien
, null as  ty_gia
, case
	when Doitac_phapnhan = 'TC' THEN N'Thu dư từ KH của đối tác TC'
end as dien_giai
, (case when  Thudu>0 then '1311' else '33884' end )  as TK_no
,  (case when  Thudu>0 then '33884' else '1311' end )  as TK_co
, (case when sum(Thudu)<0 then sum(Thudu)*-1 else sum(Thudu) end) as so_tien
, null as   quy_doi
, null as   doi_tuong
, null as   Tk_ngan_hang
, null as hop_dong_ban
, case when len(macn)=1 then '00'+ CAST(macn as varchar(3)) when len(macn)=2 then '0'+ CAST(macn as varchar(3)) else cast(macn as varchar(3)) end as don_vi
, mahd
, Doitac_phapnhan
from #tam_bang_thu_sp_ky_gom_thudu
where Thudu is not null and Thudu != 0 and dbo.GETYM(ngay_dongthuc) >= 202203 and Doitac_phapnhan = 'TC'
group by ngay_dongthuc
, ngay_dongthuc
, case when Doitac_phapnhan = 'TC' AND Groups ='Weekly' THEN 'SPTTCTC-TD'
	when Doitac_phapnhan = 'TC' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPKTC-TD'
	when Doitac_phapnhan = 'TC' AND Groups = 'Daily' THEN 'SPNTC-TD'
end
, case
	when Doitac_phapnhan = 'TC' THEN N'Thu dư từ KH của đối tác TC'
end
, case when len(macn)=1 then '00'+ CAST(macn as varchar(3)) when len(macn)=2 then '0'+ CAST(macn as varchar(3)) else cast(macn as varchar(3)) end
, (case when  Thudu>0 then '1311' else '33884' end )
,  (case when  Thudu>0 then '33884' else '1311' end )
, concat('CRM-TDTC',
Doitac_phapnhan
,(case when month(ngay_dongthuc) < 10 then '0' +CAST(month(ngay_dongthuc) as varchar(2)) else CAST(month(ngay_dongthuc) as varchar(2)) end ) ,'/' , Right(Cast(year(ngay_dongthuc) as nvarchar(4)),2)
)
, mahd
, Doitac_phapnhan
) a

--- B10: Code bảng thu của Toàn Diện VN khi thu lại gốc và khi thu dư

select * into #bang_thu_Toan_Dien_VN
from (
 ---- Tra goc ---- 
select null as hienthitreso 
, ngay_dongthuc as  ngay_hach_toan
, ngay_dongthuc as ngay_chung_tu
, concat('CRM-GTD',
Doitac_phapnhan
,(case when month(ngay_dongthuc) < 10 then '0' +CAST(month(ngay_dongthuc) as varchar(2)) else CAST(month(ngay_dongthuc) as varchar(2)) end ) ,'/' , Right(Cast(year(ngay_dongthuc) as nvarchar(4)),2)
) as so_chung_tu
, 'SPPA'
 as ma_doi_tuong
, null as ten_doi_tuong
, null as diachi
, null as ly_do_nop
, case
	when Doitac_phapnhan = 'TD' THEN N'Thu gốc TD'
end as dien_giai_ly_do_nop
, null as nguoi_nop
, null as  nhan_vien_thu
, null as  kem_theo
, null as  loai_tien
, null as  ty_gia
, case
	when Doitac_phapnhan = 'TD' THEN N'Thu gốc TD'
end as dien_giai
, '33884' as TK_no
, case 
	when Doitac_phapnhan = 'TD' THEN '141'
end as TK_co
, sum(Goc) as so_tien
, null as   quy_doi
, null as   doi_tuong
, null as   Tk_ngan_hang
, null as hop_dong_ban
, concat('VNTD', (case when len(macn)=1 then '00'+ CAST(macn as varchar(3)) when len(macn)=2 then '0'+ CAST(macn as varchar(3)) else cast(macn as varchar(3)) end)) as don_vi
, mahd
, Doitac_phapnhan
from #tam_bang_thu_sp_ky_gom_thudu
where Goc is not null and Goc != 0 and dbo.GETYM(ngay_dongthuc) >= 202203 and ma_loai_hd != '41' and Doitac_phapnhan = 'TD' --- Sản phẩm Ứng vốn mã '41' thu tiền trực tiếp về tài khoản ngân hàng chứ không qua TD Kim An nên không có bút hạch toán gốc lãi ở đây
group by ngay_dongthuc
, ngay_dongthuc 
, case when Doitac_phapnhan = 'TD' THEN N'Thu gốc TD'
end
, concat('VNTD',(case when len(macn)=1 then '00'+ CAST(macn as varchar(3)) when len(macn)=2 then '0'+ CAST(macn as varchar(3)) else cast(macn as varchar(3)) end))
,case 
	when Doitac_phapnhan = 'TD' THEN '141'
end
, concat('CRM-GTD',
Doitac_phapnhan
,(case when month(ngay_dongthuc) < 10 then '0' +CAST(month(ngay_dongthuc) as varchar(2)) else CAST(month(ngay_dongthuc) as varchar(2)) end ) ,'/' , Right(Cast(year(ngay_dongthuc) as nvarchar(4)),2)
)
, mahd
, Doitac_phapnhan

UNION ALL

--- Tra lai
select null as hienthitreso 
, ngay_dongthuc as  ngay_hach_toan
, ngay_dongthuc as ngay_chung_tu
, concat('CRM-LTD',
Doitac_phapnhan
,(case when month(ngay_dongthuc) < 10 then '0' +CAST(month(ngay_dongthuc) as varchar(2)) else CAST(month(ngay_dongthuc) as varchar(2)) end ) ,'/' , Right(Cast(year(ngay_dongthuc) as nvarchar(4)),2)
) as so_chung_tu
, 'SPPA' as ma_doi_tuong
, null as ten_doi_tuong
, null as diachi
, null as ly_do_nop
, case 
	when Doitac_phapnhan = 'TD' THEN N'Thu lãi của KH đối tác TD hưởng'
end as dien_giai_ly_do_nop
, null as nguoi_nop
, null as  nhan_vien_thu
, null as  kem_theo
, null as  loai_tien
, null as  ty_gia
, case when Doitac_phapnhan = 'TD' THEN N'Thu lãi của KH đối tác TD hưởng'
end as dien_giai
, '33884' as TK_no
, case 
	when Doitac_phapnhan = 'TD' THEN '141'
end as TK_co
, sum(Lai_doitac) as so_tien
, null as   quy_doi
, null as   doi_tuong
, null as   Tk_ngan_hang
, null as hop_dong_ban
, concat('VNTD',(case when len(macn)=1 then '00'+ CAST(macn as varchar(3)) when len(macn)=2 then '0'+ CAST(macn as varchar(3)) else cast(macn as varchar(3)) end)) as don_vi
, mahd
, Doitac_phapnhan
from #tam_bang_thu_sp_ky_gom_thudu
where lai is not null and lai != 0 and dbo.GETYM(ngay_dongthuc) >= 202203  and ma_loai_hd != '41' and Doitac_phapnhan = 'TD'--- Sản phẩm Ứng vốn mã '41' thu tiền trực tiếp về tài khoản ngân hàng chứ không qua TD Kim An nên không có bút hạch toán gốc lãi ở đây
group by ngay_dongthuc
, ngay_dongthuc
, case when Doitac_phapnhan = 'TD' THEN N'Thu lãi của KH đối tác TD hưởng'
end
, concat('VNTD',(case when len(macn)=1 then '00'+ CAST(macn as varchar(3)) when len(macn)=2 then '0'+ CAST(macn as varchar(3)) else cast(macn as varchar(3)) end))
,case 
	when Doitac_phapnhan = 'TD' THEN '141'
end
, concat('CRM-LTD',
Doitac_phapnhan
,(case when month(ngay_dongthuc) < 10 then '0' +CAST(month(ngay_dongthuc) as varchar(2)) else CAST(month(ngay_dongthuc) as varchar(2)) end ) ,'/' , Right(Cast(year(ngay_dongthuc) as nvarchar(4)),2)
)
, mahd
, Doitac_phapnhan

UNION ALL

--- Thu du
select null as hienthitreso 
, ngay_dongthuc as  ngay_hach_toan
, ngay_dongthuc as ngay_chung_tu
, concat('CRM-TDTD',
Doitac_phapnhan
,(case when month(ngay_dongthuc) < 10 then '0' +CAST(month(ngay_dongthuc) as varchar(2)) else CAST(month(ngay_dongthuc) as varchar(2)) end ) ,'/' , Right(Cast(year(ngay_dongthuc) as nvarchar(4)),2)
) as so_chung_tu
, 'SPPA'  as ma_doi_tuong
, null as ten_doi_tuong
, null as diachi
, null as ly_do_nop
, case 	when Doitac_phapnhan = 'TD' THEN N'Thu dư từ KH của đối tác TD'
	end as dien_giai_ly_do_nop
, null as nguoi_nop
, null as  nhan_vien_thu
, null as  kem_theo
, null as  loai_tien
, null as  ty_gia
, case
	when Doitac_phapnhan = 'TD' THEN N'Thu dư từ KH của đối tác TD'
end as dien_giai
, (case when  Thudu>0 then '141' else '33884' end )  as TK_no
,  (case when  Thudu>0 then '33884' else '141' end )  as TK_co
, (case when sum(Thudu)<0 then sum(Thudu)*-1 else sum(Thudu) end) as so_tien
, null as   quy_doi
, null as   doi_tuong
, null as   Tk_ngan_hang
, null as hop_dong_ban
, concat('VNTD',(case when len(macn)=1 then '00'+ CAST(macn as varchar(3)) when len(macn)=2 then '0'+ CAST(macn as varchar(3)) else cast(macn as varchar(3)) end)) as don_vi
, mahd
, Doitac_phapnhan
from #tam_bang_thu_sp_ky_gom_thudu
where Thudu is not null and Thudu != 0 and dbo.GETYM(ngay_dongthuc) >= 202203 and Doitac_phapnhan = 'TD' and ma_loai_hd != '41'
group by ngay_dongthuc
, ngay_dongthuc
, case 
	when Doitac_phapnhan = 'TD' THEN N'Thu dư từ KH của đối tác TD'
end
, concat('VNTD',(case when len(macn)=1 then '00'+ CAST(macn as varchar(3)) when len(macn)=2 then '0'+ CAST(macn as varchar(3)) else cast(macn as varchar(3)) end))
, (case when  Thudu>0 then '141' else '33884' end )
,  (case when  Thudu>0 then '33884' else '141' end )
, concat('CRM-TDTD',
Doitac_phapnhan
,(case when month(ngay_dongthuc) < 10 then '0' +CAST(month(ngay_dongthuc) as varchar(2)) else CAST(month(ngay_dongthuc) as varchar(2)) end ) ,'/' , Right(Cast(year(ngay_dongthuc) as nvarchar(4)),2)
)
, mahd
, Doitac_phapnhan


UNION ALL

--- Thu Phí ủy quyền các hợp đồng TD Kim An thu hộ
select null as hienthitreso 
, ngay_dongthuc as  ngay_hach_toan
, ngay_dongthuc as ngay_chung_tu
, concat('CRM-PTD',
Doitac_phapnhan
,(case when month(ngay_dongthuc) < 10 then '0' +CAST(month(ngay_dongthuc) as varchar(2)) else CAST(month(ngay_dongthuc) as varchar(2)) end ) ,'/' , Right(Cast(year(ngay_dongthuc) as nvarchar(4)),2)
) as so_chung_tu
,
case 
	when Doitac_phapnhan = 'TD' AND Groups ='Weekly' THEN 'SPT-TD'
	when Doitac_phapnhan = 'TD' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPK-TD'
	when Doitac_phapnhan = 'TD' AND Groups = 'Daily' THEN 'SPN-TD'
end  as ma_doi_tuong
, null as ten_doi_tuong
, null as diachi
, null as ly_do_nop
, case
	when Doitac_phapnhan = 'TD' THEN concat(N'Thu phí ủy quyền của KH KA hưởng từ KH mã hợp đồng số',mahd)
end as dien_giai_ly_do_nop
, null as nguoi_nop
, null as  nhan_vien_thu
, null as  kem_theo
, null as  loai_tien
, null as  ty_gia
, case 
	when Doitac_phapnhan = 'TD' THEN concat(N'Thu phí ủy quyền của KH KA hưởng từ KH mã hợp đồng số',mahd)
end as dien_giai
, '33884' as TK_no
, '51131' as TK_co
, sum(round(Phi_KA/1.1,0)) as so_tien
, null as   quy_doi
, null as   doi_tuong
, null as   Tk_ngan_hang
, null as hop_dong_ban
, concat('VNTD',(case when len(macn)=1 then '00'+ CAST(macn as varchar(3)) when len(macn)=2 then '0'+ CAST(macn as varchar(3)) else cast(macn as varchar(3)) end)) as don_vi
, mahd
, Doitac_phapnhan
from #tam_bang_thu_sp_ky_gom_thudu
left join (select mahd_crm, ngaymo from #tam_chitiet_hopdong) b on #tam_bang_thu_sp_ky_gom_thudu.mahd = b.mahd_crm 
--- lấy thêm thông tin ngày mở để lọc các hợp đồng đối tác là TD, giải ngân từ ngày 19.03 thì TD Kim An cần trả phí lại cho Toàn Diện VN
where Phi_KA is not null and Phi_KA > 0 and dbo.GETYM(ngay_dongthuc) >= 202203 and ma_loai_hd != '41' and Doitac_phapnhan = 'TD' and dbo.GETYMD(b.ngaymo) >= 20220319
group by ngay_dongthuc
, ngay_dongthuc
, case
	when Doitac_phapnhan = 'TD' AND Groups ='Weekly' THEN 'SPT-TD'
	when Doitac_phapnhan = 'TD' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPK-TD'
	when Doitac_phapnhan = 'TD' AND Groups = 'Daily' THEN 'SPN-TD'
end 
, case 
	when Doitac_phapnhan = 'TD' THEN concat(N'Thu phí ủy quyền của KH KA hưởng từ KH mã hợp đồng số',mahd)
end
, concat('VNTD',(case when len(macn)=1 then '00'+ CAST(macn as varchar(3)) when len(macn)=2 then '0'+ CAST(macn as varchar(3)) else cast(macn as varchar(3)) end))
, concat('CRM-PTD',
Doitac_phapnhan
,(case when month(ngay_dongthuc) < 10 then '0' +CAST(month(ngay_dongthuc) as varchar(2)) else CAST(month(ngay_dongthuc) as varchar(2)) end ) ,'/' , Right(Cast(year(ngay_dongthuc) as nvarchar(4)),2)
)
, mahd
, Doitac_phapnhan

UNION ALL

--- Thu VAT các hợp đồng TD Kim An thu hộ
select null as hienthitreso 
, ngay_dongthuc as  ngay_hach_toan
, ngay_dongthuc as ngay_chung_tu
, concat('CRM-PTD',
Doitac_phapnhan
,(case when month(ngay_dongthuc) < 10 then '0' +CAST(month(ngay_dongthuc) as varchar(2)) else CAST(month(ngay_dongthuc) as varchar(2)) end ) ,'/' , Right(Cast(year(ngay_dongthuc) as nvarchar(4)),2)
) as so_chung_tu
,
case 
	when Doitac_phapnhan = 'TD' AND Groups ='Weekly' THEN 'SPT-TD'
	when Doitac_phapnhan = 'TD' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPK-TD'
	when Doitac_phapnhan = 'TD' AND Groups = 'Daily' THEN 'SPN-TD'
end  as ma_doi_tuong
, null as ten_doi_tuong
, null as diachi
, null as ly_do_nop
, case
	when Doitac_phapnhan = 'TD' THEN concat(N'Thu phí ủy quyền của KH KA hưởng từ KH mã hợp đồng số',mahd)
end as dien_giai_ly_do_nop
, null as nguoi_nop
, null as  nhan_vien_thu
, null as  kem_theo
, null as  loai_tien
, null as  ty_gia
, case 
	when Doitac_phapnhan = 'TD' THEN concat(N'Thu phí ủy quyền của KH KA hưởng từ KH mã hợp đồng số',mahd)
end as dien_giai
, '33884' as TK_no
, '33311' as TK_co
, sum(round(Phi_KA/11,0)) as so_tien
, null as   quy_doi
, null as   doi_tuong
, null as   Tk_ngan_hang
, null as hop_dong_ban
, concat('VNTD',(case when len(macn)=1 then '00'+ CAST(macn as varchar(3)) when len(macn)=2 then '0'+ CAST(macn as varchar(3)) else cast(macn as varchar(3)) end)) as don_vi
, mahd
, Doitac_phapnhan
from #tam_bang_thu_sp_ky_gom_thudu
left join (select mahd_crm, ngaymo from #tam_chitiet_hopdong) b on #tam_bang_thu_sp_ky_gom_thudu.mahd = b.mahd_crm 
--- lấy thêm thông tin ngày mở để lọc các hợp đồng đối tác là TD, giải ngân từ ngày 19.03 thì TD Kim An cần trả phí lại cho Toàn Diện VN
where Phi_KA is not null and Phi_KA > 0 and dbo.GETYM(ngay_dongthuc) >= 202203 and ma_loai_hd != '41' and Doitac_phapnhan = 'TD' and dbo.GETYMD(b.ngaymo) >= 20220319
group by ngay_dongthuc
, ngay_dongthuc
, case
	when Doitac_phapnhan = 'TD' AND Groups ='Weekly' THEN 'SPT-TD'
	when Doitac_phapnhan = 'TD' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPK-TD'
	when Doitac_phapnhan = 'TD' AND Groups = 'Daily' THEN 'SPN-TD'
end 
, case 
	when Doitac_phapnhan = 'TD' THEN concat(N'Thu phí ủy quyền của KH KA hưởng từ KH mã hợp đồng số',mahd)
end
, concat('VNTD',(case when len(macn)=1 then '00'+ CAST(macn as varchar(3)) when len(macn)=2 then '0'+ CAST(macn as varchar(3)) else cast(macn as varchar(3)) end))
, concat('CRM-PTD',
Doitac_phapnhan
,(case when month(ngay_dongthuc) < 10 then '0' +CAST(month(ngay_dongthuc) as varchar(2)) else CAST(month(ngay_dongthuc) as varchar(2)) end ) ,'/' , Right(Cast(year(ngay_dongthuc) as nvarchar(4)),2)
)
, mahd
, Doitac_phapnhan

UNION ALL

--- Thu Phí ủy quyền các hợp đồng sản phẩm ứng vốn
select null as hienthitreso 
, ngay_dongthuc as  ngay_hach_toan
, ngay_dongthuc as ngay_chung_tu
, concat('CRM-PUV',
Doitac_phapnhan
,(case when month(ngay_dongthuc) < 10 then '0' +CAST(month(ngay_dongthuc) as varchar(2)) else CAST(month(ngay_dongthuc) as varchar(2)) end ) ,'/' , Right(Cast(year(ngay_dongthuc) as nvarchar(4)),2)
) as so_chung_tu
,
case 
	when Doitac_phapnhan = 'TD' AND Groups ='Weekly' THEN 'SPT-TD'
	when Doitac_phapnhan = 'TD' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPK-TD'
	when Doitac_phapnhan = 'TD' AND Groups = 'Daily' THEN 'SPN-TD'
end  as ma_doi_tuong
, null as ten_doi_tuong
, null as diachi
, null as ly_do_nop
, case
	when Doitac_phapnhan = 'TD' THEN concat(N'Thu phí ủy quyền của KH KA hưởng từ KH mã hợp đồng số',mahd)
end as dien_giai_ly_do_nop
, null as nguoi_nop
, null as  nhan_vien_thu
, null as  kem_theo
, null as  loai_tien
, null as  ty_gia
, case 
	when Doitac_phapnhan = 'TD' THEN concat(N'Thu phí ủy quyền của KH KA hưởng từ KH mã hợp đồng số',mahd)
end as dien_giai
, '141' as TK_no
, '51131' as TK_co
, sum(round(Phi_KA/1.1,0)) as so_tien
, null as   quy_doi
, null as   doi_tuong
, null as   Tk_ngan_hang
, null as hop_dong_ban
, concat('VNTD',(case when len(macn)=1 then '00'+ CAST(macn as varchar(3)) when len(macn)=2 then '0'+ CAST(macn as varchar(3)) else cast(macn as varchar(3)) end)) as don_vi
, mahd
, Doitac_phapnhan
from #tam_bang_thu_sp_ky_gom_thudu
left join (select mahd_crm, ngaymo from #tam_chitiet_hopdong) b on #tam_bang_thu_sp_ky_gom_thudu.mahd = b.mahd_crm 
--- lấy thêm thông tin ngày mở để lọc các hợp đồng đối tác là TD, giải ngân từ ngày 19.03 thì TD Kim An cần trả phí lại cho Toàn Diện VN
where Phi_KA is not null and Phi_KA > 0 and dbo.GETYM(ngay_dongthuc) >= 202203 and ma_loai_hd = '41'
group by ngay_dongthuc
, ngay_dongthuc
, case
	when Doitac_phapnhan = 'TD' AND Groups ='Weekly' THEN 'SPT-TD'
	when Doitac_phapnhan = 'TD' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPK-TD'
	when Doitac_phapnhan = 'TD' AND Groups = 'Daily' THEN 'SPN-TD'
end 
, case 
	when Doitac_phapnhan = 'TD' THEN concat(N'Thu phí ủy quyền của KH KA hưởng từ KH mã hợp đồng số',mahd)
end
, concat('VNTD',(case when len(macn)=1 then '00'+ CAST(macn as varchar(3)) when len(macn)=2 then '0'+ CAST(macn as varchar(3)) else cast(macn as varchar(3)) end))
, concat('CRM-PUV',
Doitac_phapnhan
,(case when month(ngay_dongthuc) < 10 then '0' +CAST(month(ngay_dongthuc) as varchar(2)) else CAST(month(ngay_dongthuc) as varchar(2)) end ) ,'/' , Right(Cast(year(ngay_dongthuc) as nvarchar(4)),2)
)
, mahd
, Doitac_phapnhan

UNION ALL

--- Thu VAT các hợp đồng TD Kim An thu hộ
select null as hienthitreso 
, ngay_dongthuc as  ngay_hach_toan
, ngay_dongthuc as ngay_chung_tu
, concat('CRM-PUV',
Doitac_phapnhan
,(case when month(ngay_dongthuc) < 10 then '0' +CAST(month(ngay_dongthuc) as varchar(2)) else CAST(month(ngay_dongthuc) as varchar(2)) end ) ,'/' , Right(Cast(year(ngay_dongthuc) as nvarchar(4)),2)
) as so_chung_tu
,
case 
	when Doitac_phapnhan = 'TD' AND Groups ='Weekly' THEN 'SPT-TD'
	when Doitac_phapnhan = 'TD' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPK-TD'
	when Doitac_phapnhan = 'TD' AND Groups = 'Daily' THEN 'SPN-TD'
end  as ma_doi_tuong
, null as ten_doi_tuong
, null as diachi
, null as ly_do_nop
, case
	when Doitac_phapnhan = 'TD' THEN concat(N'Thu phí ủy quyền của KH KA hưởng từ KH mã hợp đồng số',mahd)
end as dien_giai_ly_do_nop
, null as nguoi_nop
, null as  nhan_vien_thu
, null as  kem_theo
, null as  loai_tien
, null as  ty_gia
, case 
	when Doitac_phapnhan = 'TD' THEN concat(N'Thu phí ủy quyền của KH KA hưởng từ KH mã hợp đồng số',mahd)
end as dien_giai
, '141' as TK_no
, '33311' as TK_co
, sum(round(Phi_KA/11,0)) as so_tien
, null as   quy_doi
, null as   doi_tuong
, null as   Tk_ngan_hang
, null as hop_dong_ban
, concat('VNTD', (case when len(macn)=1 then '00'+ CAST(macn as varchar(3)) when len(macn)=2 then '0'+ CAST(macn as varchar(3)) else cast(macn as varchar(3)) end)) as don_vi
, mahd
, Doitac_phapnhan
from #tam_bang_thu_sp_ky_gom_thudu
left join (select mahd_crm, ngaymo from #tam_chitiet_hopdong) b on #tam_bang_thu_sp_ky_gom_thudu.mahd = b.mahd_crm 
--- lấy thêm thông tin ngày mở để lọc các hợp đồng đối tác là TD, giải ngân từ ngày 19.03 thì TD Kim An cần trả phí lại cho Toàn Diện VN
where Phi_KA is not null and Phi_KA > 0 and dbo.GETYM(ngay_dongthuc) >= 202203 and ma_loai_hd = '41'
group by ngay_dongthuc
, ngay_dongthuc
, case
	when Doitac_phapnhan = 'TD' AND Groups ='Weekly' THEN 'SPT-TD'
	when Doitac_phapnhan = 'TD' AND Groups IN ('Monthly', 'Bimonthly') THEN 'SPK-TD'
	when Doitac_phapnhan = 'TD' AND Groups = 'Daily' THEN 'SPN-TD'
end 
, case 
	when Doitac_phapnhan = 'TD' THEN concat(N'Thu phí ủy quyền của KH KA hưởng từ KH mã hợp đồng số',mahd)
end
, concat('VNTD',(case when len(macn)=1 then '00'+ CAST(macn as varchar(3)) when len(macn)=2 then '0'+ CAST(macn as varchar(3)) else cast(macn as varchar(3)) end))
, concat('CRM-PUV',
Doitac_phapnhan
,(case when month(ngay_dongthuc) < 10 then '0' +CAST(month(ngay_dongthuc) as varchar(2)) else CAST(month(ngay_dongthuc) as varchar(2)) end ) ,'/' , Right(Cast(year(ngay_dongthuc) as nvarchar(4)),2)
)
, mahd
, Doitac_phapnhan

) a




----- QUERY CUOI

--- Ten view: Bang_thu_MISA_2022
--- Lấy lại bảng thực thanh toán để check lại kết quả đẩy MISA với bảng thực thu
Select * from #tam_bang_thu_sp_ky_gom_thudu WHERE dbo.GETYM(ngay_dongthuc) = @month

--- Ten view: Bang_day_MISA_TD_KimAn_2022
--- Lấy bảng thu cho TD Kim An
select 
hienthitreso,
ngay_hach_toan,
ngay_chung_tu ,
            concat([so_chung_tu],'-',
		       (case when len(so_chung_tu)<=14 then  
		   ( case when RANK() OVER (PARTITION BY so_chung_tu ORDER BY ngay_chung_tu,don_vi, so_tien,ma_doi_tuong,tk_no, tk_co)<10 then '0000'+ cast( RANK() OVER (PARTITION BY so_chung_tu ORDER BY ngay_chung_tu,don_vi, so_tien,ma_doi_tuong,tk_no, tk_co) as varchar(5)) 
when RANK() OVER (PARTITION BY so_chung_tu ORDER BY ngay_chung_tu,don_vi, so_tien,ma_doi_tuong,tk_no, tk_co)<100 then '000'+ cast( RANK() OVER (PARTITION BY so_chung_tu ORDER BY ngay_chung_tu,don_vi, so_tien,ma_doi_tuong,tk_no, tk_co) as varchar(5)) 
when RANK() OVER (PARTITION BY so_chung_tu ORDER BY ngay_chung_tu, don_vi, so_tien,ma_doi_tuong,tk_no, tk_co)<1000 then '00'+ cast( RANK() OVER (PARTITION BY so_chung_tu ORDER BY ngay_chung_tu,don_vi, so_tien,ma_doi_tuong,tk_no, tk_co) as varchar(5)) 
when RANK() OVER (PARTITION BY so_chung_tu ORDER BY ngay_chung_tu,don_vi, so_tien,ma_doi_tuong,tk_no, tk_co)<10000 then  '0'+ cast( RANK() OVER (PARTITION BY so_chung_tu ORDER BY ngay_chung_tu,don_vi, so_tien,ma_doi_tuong,tk_no, tk_co) as varchar(5)) 
else cast( RANK() OVER (PARTITION BY so_chung_tu ORDER BY ngay_chung_tu,don_vi, so_tien,ma_doi_tuong,tk_no, tk_co) as varchar(5))  end)
		   else 
		   ( case when RANK() OVER (PARTITION BY so_chung_tu ORDER BY ngay_chung_tu,don_vi, so_tien,ma_doi_tuong,tk_no, tk_co)<10 then '000'+ cast( RANK() OVER (PARTITION BY so_chung_tu ORDER BY ngay_chung_tu,don_vi, so_tien,ma_doi_tuong,tk_no, tk_co) as varchar(5)) 
when RANK() OVER (PARTITION BY so_chung_tu ORDER BY ngay_chung_tu,don_vi, so_tien,ma_doi_tuong,tk_no, tk_co)<100 then '00'+ cast( RANK() OVER (PARTITION BY so_chung_tu ORDER BY ngay_chung_tu,don_vi, so_tien,ma_doi_tuong,tk_no, tk_co) as varchar(5)) 
when RANK() OVER (PARTITION BY so_chung_tu ORDER BY ngay_chung_tu, don_vi, so_tien,ma_doi_tuong,tk_no, tk_co)<1000 then '0'+ cast( RANK() OVER (PARTITION BY so_chung_tu ORDER BY ngay_chung_tu,don_vi, so_tien,ma_doi_tuong,tk_no, tk_co) as varchar(5)) 
when RANK() OVER (PARTITION BY so_chung_tu ORDER BY ngay_chung_tu,don_vi, so_tien,ma_doi_tuong,tk_no, tk_co)<10000 then cast( RANK() OVER (PARTITION BY so_chung_tu ORDER BY ngay_chung_tu,don_vi, so_tien,ma_doi_tuong,tk_no, tk_co) as varchar(5)) 
else cast( RANK() OVER (PARTITION BY so_chung_tu ORDER BY ngay_chung_tu,don_vi, so_tien,ma_doi_tuong,tk_no, tk_co) as varchar(5))  end) end  ))
 as so_chung_tu
,ma_doi_tuong,ten_doi_tuong,diachi,ly_do_nop
,dien_giai_ly_do_nop,nguoi_nop,nhan_vien_thu,kem_theo
,loai_tien,ty_gia,dien_giai,TK_no,TK_co,so_tien
,quy_doi,doi_tuong,Tk_ngan_hang,hop_dong_ban, don_vi 
,case when left(TK_co,3) IN ('333','511') then '9.9DT' else '9.9GL' end as Khoan_muc_cp
, mahd
, Doitac_phapnhan
from #bang_thu_MISA_spky
where dbo.GETYM(ngay_hach_toan) = @month


--- Ten view: Bang_day_MISA_ThinhCuong_2022
---- Lấy bảng thu cho Thịnh Cường
select 
hienthitreso,
ngay_hach_toan,
ngay_chung_tu ,
            concat([so_chung_tu],'-',
		       (case when len(so_chung_tu)<=14 then  
		   ( case when RANK() OVER (PARTITION BY so_chung_tu ORDER BY ngay_chung_tu,don_vi, so_tien,ma_doi_tuong,tk_no, tk_co)<10 then '0000'+ cast( RANK() OVER (PARTITION BY so_chung_tu ORDER BY ngay_chung_tu,don_vi, so_tien,ma_doi_tuong,tk_no, tk_co) as varchar(5)) 
when RANK() OVER (PARTITION BY so_chung_tu ORDER BY ngay_chung_tu,don_vi, so_tien,ma_doi_tuong,tk_no, tk_co)<100 then '000'+ cast( RANK() OVER (PARTITION BY so_chung_tu ORDER BY ngay_chung_tu,don_vi, so_tien,ma_doi_tuong,tk_no, tk_co) as varchar(5)) 
when RANK() OVER (PARTITION BY so_chung_tu ORDER BY ngay_chung_tu, don_vi, so_tien,ma_doi_tuong,tk_no, tk_co)<1000 then '00'+ cast( RANK() OVER (PARTITION BY so_chung_tu ORDER BY ngay_chung_tu,don_vi, so_tien,ma_doi_tuong,tk_no, tk_co) as varchar(5)) 
when RANK() OVER (PARTITION BY so_chung_tu ORDER BY ngay_chung_tu,don_vi, so_tien,ma_doi_tuong,tk_no, tk_co)<10000 then  '0'+ cast( RANK() OVER (PARTITION BY so_chung_tu ORDER BY ngay_chung_tu,don_vi, so_tien,ma_doi_tuong,tk_no, tk_co) as varchar(5)) 
else cast( RANK() OVER (PARTITION BY so_chung_tu ORDER BY ngay_chung_tu,don_vi, so_tien,ma_doi_tuong,tk_no, tk_co) as varchar(5))  end)
		   else 
		   ( case when RANK() OVER (PARTITION BY so_chung_tu ORDER BY ngay_chung_tu,don_vi, so_tien,ma_doi_tuong,tk_no, tk_co)<10 then '000'+ cast( RANK() OVER (PARTITION BY so_chung_tu ORDER BY ngay_chung_tu,don_vi, so_tien,ma_doi_tuong,tk_no, tk_co) as varchar(5)) 
when RANK() OVER (PARTITION BY so_chung_tu ORDER BY ngay_chung_tu,don_vi, so_tien,ma_doi_tuong,tk_no, tk_co)<100 then '00'+ cast( RANK() OVER (PARTITION BY so_chung_tu ORDER BY ngay_chung_tu,don_vi, so_tien,ma_doi_tuong,tk_no, tk_co) as varchar(5)) 
when RANK() OVER (PARTITION BY so_chung_tu ORDER BY ngay_chung_tu, don_vi, so_tien,ma_doi_tuong,tk_no, tk_co)<1000 then '0'+ cast( RANK() OVER (PARTITION BY so_chung_tu ORDER BY ngay_chung_tu,don_vi, so_tien,ma_doi_tuong,tk_no, tk_co) as varchar(5)) 
when RANK() OVER (PARTITION BY so_chung_tu ORDER BY ngay_chung_tu,don_vi, so_tien,ma_doi_tuong,tk_no, tk_co)<10000 then cast( RANK() OVER (PARTITION BY so_chung_tu ORDER BY ngay_chung_tu,don_vi, so_tien,ma_doi_tuong,tk_no, tk_co) as varchar(5)) 
else cast( RANK() OVER (PARTITION BY so_chung_tu ORDER BY ngay_chung_tu,don_vi, so_tien,ma_doi_tuong,tk_no, tk_co) as varchar(5))  end) end  ))
 as so_chung_tu
, dien_giai_ly_do_nop
, dien_giai
, TK_no,TK_co,so_tien
, 'PTRK-TDKA' as doi_tuong_no
, ma_doi_tuong as doi_tuong_co
, Tk_ngan_hang
, '9.9GL' as Khoan_muc_cp
, b.Ten_CN as don_vi
, mahd
, Doitac_phapnhan
from #bang_thu_Thinh_Cuong a
left join pr_macns b ON abs(a.don_vi) = abs(b.MaCn)
where dbo.GETYM(ngay_hach_toan) = @month

--- Ten view: Bang_day_MISA_ToandienVN_2022
---- Lấy bảng thu cho Toàn Diện VN
select 
hienthitreso,
ngay_hach_toan,
ngay_chung_tu ,
            concat([so_chung_tu],'-',
		       (case when len(so_chung_tu)<=14 then  
		   ( case when RANK() OVER (PARTITION BY so_chung_tu ORDER BY ngay_chung_tu,don_vi, so_tien,ma_doi_tuong,tk_no, tk_co)<10 then '0000'+ cast( RANK() OVER (PARTITION BY so_chung_tu ORDER BY ngay_chung_tu,don_vi, so_tien,ma_doi_tuong,tk_no, tk_co) as varchar(5)) 
when RANK() OVER (PARTITION BY so_chung_tu ORDER BY ngay_chung_tu,don_vi, so_tien,ma_doi_tuong,tk_no, tk_co)<100 then '000'+ cast( RANK() OVER (PARTITION BY so_chung_tu ORDER BY ngay_chung_tu,don_vi, so_tien,ma_doi_tuong,tk_no, tk_co) as varchar(5)) 
when RANK() OVER (PARTITION BY so_chung_tu ORDER BY ngay_chung_tu, don_vi, so_tien,ma_doi_tuong,tk_no, tk_co)<1000 then '00'+ cast( RANK() OVER (PARTITION BY so_chung_tu ORDER BY ngay_chung_tu,don_vi, so_tien,ma_doi_tuong,tk_no, tk_co) as varchar(5)) 
when RANK() OVER (PARTITION BY so_chung_tu ORDER BY ngay_chung_tu,don_vi, so_tien,ma_doi_tuong,tk_no, tk_co)<10000 then  '0'+ cast( RANK() OVER (PARTITION BY so_chung_tu ORDER BY ngay_chung_tu,don_vi, so_tien,ma_doi_tuong,tk_no, tk_co) as varchar(5)) 
else cast( RANK() OVER (PARTITION BY so_chung_tu ORDER BY ngay_chung_tu,don_vi, so_tien,ma_doi_tuong,tk_no, tk_co) as varchar(5))  end)
		   else 
		   ( case when RANK() OVER (PARTITION BY so_chung_tu ORDER BY ngay_chung_tu,don_vi, so_tien,ma_doi_tuong,tk_no, tk_co)<10 then '000'+ cast( RANK() OVER (PARTITION BY so_chung_tu ORDER BY ngay_chung_tu,don_vi, so_tien,ma_doi_tuong,tk_no, tk_co) as varchar(5)) 
when RANK() OVER (PARTITION BY so_chung_tu ORDER BY ngay_chung_tu,don_vi, so_tien,ma_doi_tuong,tk_no, tk_co)<100 then '00'+ cast( RANK() OVER (PARTITION BY so_chung_tu ORDER BY ngay_chung_tu,don_vi, so_tien,ma_doi_tuong,tk_no, tk_co) as varchar(5)) 
when RANK() OVER (PARTITION BY so_chung_tu ORDER BY ngay_chung_tu, don_vi, so_tien,ma_doi_tuong,tk_no, tk_co)<1000 then '0'+ cast( RANK() OVER (PARTITION BY so_chung_tu ORDER BY ngay_chung_tu,don_vi, so_tien,ma_doi_tuong,tk_no, tk_co) as varchar(5)) 
when RANK() OVER (PARTITION BY so_chung_tu ORDER BY ngay_chung_tu,don_vi, so_tien,ma_doi_tuong,tk_no, tk_co)<10000 then cast( RANK() OVER (PARTITION BY so_chung_tu ORDER BY ngay_chung_tu,don_vi, so_tien,ma_doi_tuong,tk_no, tk_co) as varchar(5)) 
else cast( RANK() OVER (PARTITION BY so_chung_tu ORDER BY ngay_chung_tu,don_vi, so_tien,ma_doi_tuong,tk_no, tk_co) as varchar(5))  end) end  ))
 as so_chung_tu
,ma_doi_tuong,ten_doi_tuong,diachi,ly_do_nop
,dien_giai_ly_do_nop,nguoi_nop,nhan_vien_thu,kem_theo
,loai_tien,ty_gia,dien_giai,TK_no,TK_co,so_tien
,quy_doi,doi_tuong,Tk_ngan_hang,hop_dong_ban, don_vi
, case when left(TK_co,3) IN ('333','511') then '9.9DT' else '9.9GL' end as Khoan_muc_cp
, mahd
, Doitac_phapnhan
from #bang_thu_Toan_Dien_VN
where dbo.GETYM(ngay_hach_toan) = @month

--- Ten view: Bang_ke_VAT_TD_Kiman_2022
--- Bảng kê VAT TD Kim An
SELECT round(Phi_KA/1.1,0) AS 'Phí dịch vụ', round(Phi_KA/1.1,0)/10 AS 'Thuế VAT (10%)'
, Phi_KA AS 'Tổng thanh toán'
, concat(N'Thu phí dịch vụ ngày ',day(ngay_dongthuc), '/', month(ngay_dongthuc), '/', year(ngay_dongthuc), N' của mã hợp đồng số ', mahd) 
AS 'Ghi chú'
, goc + lai + Phi_KA + Thudu AS 'Tổng thu ngày'
, mahd AS 'Mã HĐ'
, Doitac_phapnhan AS 'Đối tác'
, dbo.getymd(ngay_dongthuc) AS Ngaydong
FROM #tam_bang_thu_sp_ky_gom_thudu
left join (select mahd_crm, ngaymo from #tam_chitiet_hopdong) b on #tam_bang_thu_sp_ky_gom_thudu.mahd = b.mahd_crm
WHERE Phi_KA IS NOT NULL and Phi_KA > 0 and ma_loai_hd != '41' and (Doitac_phapnhan != 'TD' or (Doitac_phapnhan = 'TD' and dbo.GETYMD(b.ngaymo) < 20220319)) and dbo.GETYM(ngay_dongthuc) = @month 

--- Ten view: Bang_ke_VAT_ToanDienVN_2022
--- Bảng kê VAT Toan Dien VN
SELECT round(Phi_KA/1.1,0) AS 'Phí dịch vụ', round(Phi_KA/1.1,0)/10 AS 'Thuế VAT (10%)'
, Phi_KA AS 'Tổng thanh toán'
, concat(N'Thu phí dịch vụ ngày ',day(ngay_dongthuc), '/', month(ngay_dongthuc), '/', year(ngay_dongthuc), N' của mã hợp đồng số ', mahd) 
AS 'Ghi chú'
, goc + lai + Phi_KA + Thudu AS 'Tổng thu ngày'
, mahd AS 'Mã HĐ'
, Doitac_phapnhan AS 'Đối tác'
, dbo.getymd(ngay_dongthuc) AS Ngaydong
FROM #tam_bang_thu_sp_ky_gom_thudu 
left join (select mahd_crm, ngaymo from #tam_chitiet_hopdong) b on #tam_bang_thu_sp_ky_gom_thudu.mahd = b.mahd_crm
WHERE Phi_KA IS NOT NULL and Phi_KA > 0 and (ma_loai_hd = '41' or (ma_loai_hd != '41' and Doitac_phapnhan = 'TD' and dbo.GETYMD(b.ngaymo) >= 20220319)) and dbo.GETYM(ngay_dongthuc) = @month
