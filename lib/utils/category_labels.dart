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
      return 'Ăn uống';
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
    case 'work':
    case '일':
      return 'Công việc';
    case 'school':
    case '학교':
      return 'Trường học';
    case '감정':
      return 'Cảm xúc';
    default:
      return category;
  }
}
