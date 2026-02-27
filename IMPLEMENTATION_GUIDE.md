# Smart Note - Hướng dẫn Triển khai (Implementation Guide)

## 📋 Tóm tắt

Ứng dụng **Smart Note** đã được xây dựng hoàn chỉnh theo yêu cầu của bài thực hành 2. Toàn bộ mã nguồn được tổ chức trong `lib/main.dart` với các thành phần sau:

## 🏗️ Cấu trúc Mã Nguồn

### 1. **Model Layer**
```
Note Model
  - id (String) - UUID duy nhất
  - title (String) - Tiêu đề
  - content (String) - Nội dung
  - createdAt (DateTime) - Thời gian tạo
  - updatedAt (DateTime) - Thời gian cập nhật
  
  Methods:
  - toJson() - Chuyển đổi sang JSON
  - fromJson() - Tạo từ JSON
```

### 2. **Service Layer - NoteService**
```
NoteService (Singleton Pattern)
  - init() - Khởi tạo SharedPreferences
  - _loadNotes() - Đọc dữ liệu từ storage
  - _saveNotes() - Lưu dữ liệu xuống storage
  - addNote() - Thêm ghi chú mới
  - updateNote() - Cập nhật ghi chú
  - deleteNote() - Xóa ghi chú
  - searchNotes() - Tìm kiếm theo tiêu đề
```

### 3. **UI Layer - Screens & Widgets**

#### SmartNoteApp (Root Widget)
- Cấu hình Material 3 Theme
- Định nghĩa routes và navigation

#### HomeScreen (Màn hình chính)
- Hiển thị AppBar với thông tin sinh viên
- Thanh tìm kiếm với real-time search
- GridView 2 cột để hiển thị ghi chú
- Trạng thái trống (Empty State)
- FAB (+) để tạo ghi chú mới

#### NoteCard Widget (Thẻ ghi chú)
- Hiển thị tiêu đề, nội dung tóm tắt, thời gian
- Hỗ trợ Dismissible (Vuốt xóa)
- Nền đỏ + icon thùng rác khi vuốt
- Dialog xác nhận trước khi xóa

#### DetailScreen (Màn hình soạn thảo)
- Giao diện tối giản (Paper Style)
- TextField cho tiêu đề và nội dung (multiline)
- Auto-save khi back
- Không có nút "Lưu" (Save)

## ✅ Checklist Yêu Cầu - Đã Hoàn Thành

### Giao Diện (UI/UX) ✓
- [x] AppBar hiển thị: "Smart Note - [Họ tên] - [Mã SV]"
- [x] Thanh tìm kiếm bo góc, có icon kính lúp
- [x] Real-time search lọc theo tiêu đề
- [x] Danh sách ghi chú dạng lưới 2 cột
- [x] Thẻ ghi chú có: tiêu đề đậm, nội dung tóm tắt, thời gian
- [x] Text overflow với dấu "..." tự động
- [x] Trạng thái trống với hình ảnh và thông báo
- [x] FAB (+) ở góc dưới phải
- [x] Màn hình soạn thảo tối giản (no border)
- [x] Textarea multiline tự giãn chiều cao
- [x] Không có nút "Lưu"

### Tính Năng (Features) ✓
- [x] Thêm ghi chú mới
- [x] Chỉnh sửa ghi chú cũ
- [x] Vuốt xóa với nền đỏ + icon
- [x] Dialog xác nhận trước xóa
- [x] Auto-save khi back
- [x] Real-time search
- [x] Auto-refresh danh sách

### Kỹ Thuật (Technical) ✓
- [x] JSON Serialization (toJson/fromJson)
- [x] SharedPreferences lưu trữ
- [x] UUID cho ID unique
- [x] DateTime tracking (created/updated)
- [x] Offline hoàn toàn
- [x] Data persistence (tồn tại sau kill app)
- [x] Code analysis: Không lỗi

## 📝 Thông tin Sinh viên

**CẦN CẬP NHẬT:** Mở `lib/main.dart` và tìm các dòng:
```dart
const String studentName = "Nguyễn Văn A";  // Thay đổi tên
const String studentId = "SV001";           // Thay đổi mã SV
```

## 🚀 Hướng dẫn Chạy Ứng dụng

### 1. Cập nhật Thông tin
```bash
# Mở lib/main.dart
# Thay đổi studentName và studentId
```

### 2. Cài đặt Dependencies
```bash
cd e:\flutter_projects\job_list
flutter pub get
```

### 3. Chạy Ứng dụng
```bash
# Trên Android
flutter run

# Trên iOS
flutter run -d "Device Name"

# Trên Web
flutter run -d chrome
```

### 4. Build APK (Android)
```bash
flutter build apk --release
```

## 🧪 Kế Hoạch Kiểm Thử

### Test 1: Tạo Ghi Chú
1. Nhấn nút (+)
2. Gõ tiêu đề: "Tiêu đề Test"
3. Gõ nội dung: "Nội dung test"
4. Nhấn Back/Quay lại
5. ✓ Ghi chú xuất hiện trong danh sách

### Test 2: Chỉnh Sửa Ghi Chú
1. Nhấn vào ghi chú trong danh sách
2. Sửa tiêu đề hoặc nội dung
3. Nhấn Back
4. ✓ Ghi chú được cập nhật ngay

### Test 3: Tìm Kiếm
1. Gõ từ khóa trong thanh tìm kiếm
2. ✓ Danh sách tự động lọc theo tiêu đề

### Test 4: Xóa Ghi Chú
1. Vuốt từ phải sang trái trên ghi chú
2. ✓ Hiện nền đỏ + icon thùng rác
3. Nhấn "Xóa" trong dialog
4. ✓ Ghi chú bị xóa khỏi danh sách

### Test 5: Data Persistence (QUAN TRỌNG)
1. Tạo 3-4 ghi chú
2. Tắt ứng dụng hoàn toàn (Kill App)
3. Mở lại ứng dụng
4. ✓ Tất cả ghi chú vẫn còn nguyên vẹn
5. (Tùy chọn) Khởi động lại máy ảo
6. ✓ Dữ liệu vẫn được bảo lưu

## 🔍 Kiểm Tra Code Quality

```bash
# Phân tích code
flutter analyze

# Định dạng code
dart format lib/

# Chạy unit tests
flutter test
```

## 📦 Dependencies

| Package | Version | Mục đích |
|---------|---------|---------|
| flutter | sdk | Framework chính |
| uuid | ^4.0.0 | Tạo ID unique |
| shared_preferences | ^2.2.0 | Lưu dữ liệu cục bộ |
| intl | ^0.19.0 | Định dạng ngày giờ |

## 🔐 Bảo Mật & Tính Ổn Định

- ✓ Mọi dữ liệu được mã hóa JSON
- ✓ Sử dụng try-catch trong load dữ liệu
- ✓ Validation khi nhập dữ liệu
- ✓ Error handling cho SharedPreferences

## 📱 Tương Thích

- **Android**: API 16+ (Minimum)
- **iOS**: iOS 11.0+ (Minimum)
- **Web**: Chrome, Firefox, Safari
- **Desktop**: Windows, macOS, Linux (tùy cấu hình)

## 🎓 Bài Học Được Áp Dụng

1. **Model & JSON Serialization**: Class Note với toJson/fromJson
2. **SharedPreferences**: Lưu trữ dữ liệu offline
3. **State Management**: setState() cho UI updates
4. **Navigation**: Push/Pop screens
5. **Widgets**: StatefulWidget, StatelessWidget, Dismissible
6. **Real-time Search**: OnChanged listener
7. **DateTime Handling**: Tạo và định dạng thời gian
8. **Dialog & Confirmation**: AlertDialog cho xác nhận

## 🐛 Troubleshooting

### Lỗi: "Undefined class 'Note'"
→ Đảm bảo `lib/main.dart` không bị xóa định nghĩa class

### Lỗi: "SharedPreferences not initialized"
→ Đảm bảo gọi `_noteService.init()` trước khi sử dụng

### Dữ liệu không lưu
→ Kiểm tra `await _saveNotes()` được gọi sau mỗi thao tác

### Search không hoạt động
→ Đảm bảo `_searchQuery` được update trong `onChanged`

## 📞 Support

Nếu gặp vấn đề:
1. Kiểm tra `flutter analyze` có lỗi không
2. Xóa `pubspec.lock` và chạy `flutter pub get` lại
3. Xóa folder `build` và rebuild
4. Kiểm tra version Flutter: `flutter --version`

## 🎉 Hoàn Thành!

Ứng dụng Smart Note đã được triển khai hoàn chỉnh theo tất cả yêu cầu của bài thực hành. 

**Hãy cập nhật thông tin sinh viên và chạy thử nghiệm toàn bộ tính năng!**
