import express from "express";
import nhaSiController from "../controllers/nhasi.controller.js";

const router = express.Router();
router.post("/lichRanh", nhaSiController.dangKyLichRanh);
router.delete("/lichRanh", nhaSiController.huyLichRanh);
router.post("/benhAn", nhaSiController.taoBenhAn);
router.post("/CTDV", nhaSiController.themCTDV);
router.post("/CTThuoc", nhaSiController.themCTTHUOC);
router.put("/matKhau", nhaSiController.doiMatKhau);
router.get("/caDu2NguoiTruc/:mans", nhaSiController.xemCaDu2NguoiTruc);
router.get("/lichRanhChuaDuocDat/:mans", nhaSiController.xemLichRanhChuaDuocDat);
router.get("/getAllThuoc", nhaSiController.getAllThuoc);
router.get("/getAllDV", nhaSiController.getAllDV);
router.get("/getAllCa", nhaSiController.getAllCa);
router.get("/lichHen/:mans", nhaSiController.xemLichHen);
router.get("/getAllDSNhaSi", nhaSiController.getAllDSNS);
router.get("/benhAn/:sdt", nhaSiController.xemBenhAn);




export default router;