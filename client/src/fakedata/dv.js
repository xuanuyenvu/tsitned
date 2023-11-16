const dv = [
  {
    MADV: "DV01",
    TENDV: "Khám răng",
    MOTA: "Dịch vụ này bao gồm việc khám và tư vấn về tình trạng răng miệng của bệnh nhân",
    DONGIA: 200000,
  },
  {
    MADV: "DV02",
    TENDV: "Chụp X-quang",
    MOTA: "Dịch vụ này cung cấp việc chụp X-quang để đánh giá và chuẩn đoán tình trạng răng miệng",
    DONGIA: 150000,
  },
  {
    MADV: "DV03",
    TENDV: "Đắp răng khiểng",
    MOTA: "Dịch vụ này đảm nhiệm việc đắp răng khiểng để điều chỉnh vị trí của răng",
    DONGIA: 500000,
  },
  {
    MADV: "DV04",
    TENDV: "Tẩy trắng răng",
    MOTA: "Dịch vụ này cung cấp việc tẩy trắng răng để làm sáng và làm trắng răng",
    DONGIA: 500000,
  },
  {
    MADV: "DV05",
    TENDV: "Bọc răng sứ",
    MOTA: "Dịch vụ này bao gồm việc bọc răng bằng vật liệu sứ để cải thiện ngoại hình và chức năng của răng",
    DONGIA: 1000000,
  },
  {
    MADV: "DV06",
    TENDV: "Cấy ghép Implant",
    MOTA: "Dịch vụ này liên quan đến việc cấy ghép Implant nha khoa để thay thế răng hoặc hỗ trợ các công việc nha khoa khác",
    DONGIA: 2000000,
  },
  {
    MADV: "DV07",
    TENDV: "Chỉnh nha",
    MOTA: "Dịch vụ này đảm nhiệm việc chỉnh nha để điều chỉnh vị trí của răng và cải thiện hàm răng",
    DONGIA: 5000000,
  },
  {
    MADV: "DV08",
    TENDV: "Phục hình răng sứ",
    MOTA: "Dịch vụ này liên quan đến việc phục hình răng bằng vật liệu sứ để khôi phục ngoại hình và chức năng của răng",
    DONGIA: 1000000,
  },
  {
    MADV: "DV09",
    TENDV: "Cạo vôi răng",
    MOTA: "Dịch vụ này bao gồm việc cạo vôi trên bề mặt răng nhằm loại bỏ mảng bám và tái tạo vệ sinh răng miệng",
    DONGIA: 500000,
  },
  {
    MADV: "DV10",
    TENDV: "Nhổ răng",
    MOTA: "Dịch vụ này đảm nhiệm việc nhổ răng khi cần thiết, bao gồm cả nhổ răng khôn",
    DONGIA: 250000,
  },
  {
    MADV: "DV11",
    TENDV: "Chữa nha chu",
    MOTA: "Dịch vụ này cung cấp việc chữa trị các bệnh nha chu như viêm nướu, chảy máu nướu, và hôi miệng",
    DONGIA: 300000,
  },
  {
    MADV: "DV12",
    TENDV: "Phẫu thuật trong miệng",
    MOTA: "Dịch vụ này liên quan đến việc phẫu thuật trong miệng như tạo hình lợi, tạo hình mô mềm, hoặc phẫu thuật tuyến nước bọt",
    DONGIA: 5000000,
  },
  {
    MADV: "DV13",
    TENDV: "Chữa tủy răng trẻ em",
    MOTA: "Dịch vụ này cung cấp việc chữa trị tủy răng trẻ em, bao gồm cả việc cấp cứu trong trường hợp cần thiết",
    DONGIA: 1000000,
  },
  {
    MADV: "DV14",
    TENDV: "Trám răng sữa trẻ em",
    MOTA: "Dịch vụ này liên quan đến việc chữa trị các vấn đề răng nội nha như viêm tủy, nhiễm trùng, hoặc đau răng ADD",
    DONGIA: 500000,
  },
  {
    MADV: "DV15",
    TENDV: "Chữa răng nội nha",
    MOTA: "Dịch vụ này bao gồm việc phục hình răng giả để thay thế răng mất, cung cấp chức năng hàm răng",
    DONGIA: 500000,
  },
  {
    MADV: "DV16",
    TENDV: "Phục hình răng giả",
    MOTA: "Dịch vụ này đảm nhiệm việc làm cầu răng bằng vật liệu sứ để thay thế nhiều răng mất liên tiếp",
    DONGIA: 500000,
  },
  {
    MADV: "DV17",
    TENDV: "Cầu răng sứ",
    MOTA: "Dịch vụ này cung cấp các dịch vụ nha khoa tổng quát như khám răng",
    DONGIA: 1100000,
  },
  {
    MADV: "DV18",
    TENDV: "Nha khoa tổng quát",
    MOTA: "Dịch vụ này cung cấp các dịch vụ nha khoa tổng quát như khám răng, tẩy trắng, trám răng, và chữa trị các vấn đề thông thường",
    DONGIA: 350000,
  },
  {
    MADV: "DV19",
    TENDV: "Nha khoa thẩm mỹ",
    MOTA: "Dịch vụ này liên quan đến việc cải thiện ngoại hình và thẩm mỹ răng miệng bằng các phương pháp như tẩy trắng, bọc răng sứ, chỉnh nha thẩm mỹ",
    DONGIA: 500000,
  },
  {
    MADV: "DV20",
    TENDV: "Đính đá răng",
    MOTA: "Dịch vụ này bao gồm việc đính đá ngọc trên răng để tạo điểm nhấn và thẩm mỹ cho những người muốn trang trí cho nụ cười của mình",
    DONGIA: 100000,
  },
  {
    MADV: "DV21",
    TENDV: "Chỉnh nha thẩm mỹ",
    MOTA: "Dịch vụ này đảm nhiệm việc chỉnh nha nhằm cải thiện vị trí và hình dáng của răng một cách thẩm mỹ",
    DONGIA: 1000000,
  },
];

export default dv;
