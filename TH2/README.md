# Smart Note - Ứng dụng Ghi chú thông minh

Một ứng dụng Flutter để quản lý ghi chú cá nhân với khả năng lưu trữ dữ liệu cục bộ (Offline) sử dụng SharedPreferences.

## ✨ Các tính năng chính

### 1. **Màn hình chính (Home Screen)**
- Thanh AppBar hiển thị: "Smart Note - [Họ tên] - [Mã SV]"
- Thanh tìm kiếm thời gian thực lọc ghi chú theo tiêu đề
- Danh sách ghi chú dạng lưới 2 cột (Grid View)
- Mỗi thẻ ghi chú hiển thị:
  - Tiêu đề (in đậm, cắt dài tự động)
  - Nội dung tóm tắt (tối đa 3 dòng)
  - Thời gian sửa/tạo (dd/MM/yyyy HH:mm)
- Trạng thái trống với hình ảnh và thông báo
- Nút Thêm (+) nổi ở góc dưới phải

### 2. **Màn hình Soạn thảo (Detail Screen)**
- Giao diện tối giản giống trang giấy trắng
- Ô nhập tiêu đề và nội dung (multiline, tự giãn chiều cao)
- **Auto-save**: Tự động lưu khi lưới về màn hình chính
- Không có nút "Lưu" (Save)
- Dữ liệu được mã hóa JSON trước khi lưu

### 3. **Tính năng Vuốt Xóa (Swipe to Delete)**
- Vuốt từ phải sang trái trên thẻ ghi chú
- Hiển thị nền đỏ với icon thùng rác
- Hộp thoại xác nhận trước khi xóa

### 4. **Lưu trữ dữ liệu (Data Persistence)**
- Sử dụng SharedPreferences lưu dữ liệu JSON
- Dữ liệu tồn tại ngay cả sau khi tắt ứng dụng
- Hỗ trợ hoàn toàn Offline

## 🛠️ Yêu cầu Kỹ thuật

- Flutter SDK 3.10.7+
- Dart 3.10.7+
- Android SDK hoặc iOS SDK (tùy nền tảng)

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  uuid: ^4.0.0                    # Tạo ID unique cho ghi chú
  shared_preferences: ^2.2.0      # Lưu dữ liệu cục bộ
  intl: ^0.19.0                   # Định dạng ngày giờ
```

## 🚀 Hướng dẫn sử dụng

### Cập nhật thông tin sinh viên
Mở file `lib/main.dart` và cập nhật các dòng sau:
```dart
const String studentName = "Tên của bạn";
const String studentId = "Mã SV của bạn";
```

### Chạy ứng dụng
```bash
flutter pub get
flutter run
```

## 📱 Cấu trúc Dữ liệu

### Model Note
```dart
class Note {
  final String id;               // ID unique (UUID)
  String title;                  // Tiêu đề
  String content;                // Nội dung
  final DateTime createdAt;      // Thời gian tạo
  DateTime updatedAt;            // Thời gian chỉnh sửa
}
```

### JSON Format
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "title": "Tiêu đề ghi chú",
  "content": "Nội dung ghi chú",
  "createdAt": "2026-02-27T10:30:00.000Z",
  "updatedAt": "2026-02-27T10:35:00.000Z"
}
```

## 🎯 Luồng ứng dụng

```
Khởi động App
    ↓
Đọc dữ liệu từ SharedPreferences
    ↓
Hiển thị danh sách ghi chú hoặc trạng thái trống
    ↓
Người dùng có thể:
  • Tìm kiếm ghi chú
  • Tạo ghi chú mới (+)
  • Chỉnh sửa ghi chú cũ
  • Xóa ghi chú (vuốt)
    ↓
Auto-save khi lưới về màn hình chính
    ↓
Danh sách cập nhật tự động
```

## 🧪 Kiểm thử

### Test Persistence
1. Tạo một vài ghi chú
2. Tắt hoàn toàn ứng dụng (Kill App)
3. Mở lại ứng dụng
4. Xác nhận dữ liệu vẫn còn nguyên vẹn

### Test Deletion
1. Vuốt sang trái trên ghi chú
2. Xác nhận xóa trong hộp thoại
3. Xác nhận ghi chú bị xóa khỏi danh sách

### Test Search
1. Gõ từ khóa trong thanh tìm kiếm
2. Danh sách phải lọc kết quả theo tiêu đề

## 📄 License

This project is created for educational purposes.

## 💡 Ghi chú

- Ứng dụng hoạt động hoàn toàn offline
- Dữ liệu được lưu trữ cục bộ trên thiết bị
- Không cần kết nối internet
- Tất cả dữ liệu là cá nhân và được lưu riêng biệt
