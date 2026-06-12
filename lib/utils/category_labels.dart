String categoryLabelVi(String category) {
  switch (category) {
    case '전체 / Tất cả':
    case 'all':
      return 'Tất cả';
    case 'favorite':
      return 'Yêu thích';
    case 'greeting':
    case '인사':
      return 'Chào hỏi';
    case 'daily':
    case '일상':
      return 'Hằng ngày';
    case 'food':
    case 'restaurant':
    case '음식':
    case '식당':
      return 'Ăn uống';
    case '과일':
      return 'Trái cây';
    case '채소':
      return 'Rau củ';
    case 'shopping':
    case '쇼핑':
      return 'Mua sắm';
    case 'travel':
    case '여행':
      return 'Du lịch';
    case 'transport':
    case '교통':
      return 'Giao thông';
    case 'emergency':
    case '긴급':
      return 'Khẩn cấp';
    case 'hospital':
    case '병원':
      return 'Bệnh viện';
    case '약국':
      return 'Nhà thuốc';
    case '은행':
      return 'Ngân hàng';
    case '우체국':
      return 'Bưu điện';
    case '공항':
      return 'Sân bay';
    case '호텔':
      return 'Khách sạn';
    case '한국생활':
      return 'Cuộc sống ở Hàn Quốc';
    case '직업':
      return 'Nghề nghiệp';
    case '장소':
      return 'Địa điểm';
    case '가족':
      return 'Gia đình';
    case '시간/날짜':
      return 'Thời gian / Ngày tháng';
    case '숫자':
      return 'Số đếm';
    case 'work':
    case '일':
      return 'Công việc';
    case 'school':
    case '학교':
      return 'Trường học';
    case '감정':
      return 'Cảm xúc';
    case '기본 회화':
      return 'Giao tiếp cơ bản';
    default:
      return category;
  }
}
