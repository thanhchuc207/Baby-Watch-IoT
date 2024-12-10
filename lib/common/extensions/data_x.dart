// Hàm chuẩn hóa DateTime để chỉ lấy phần ngày, tháng, năm
DateTime normalizeDate(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}
