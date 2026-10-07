# Chuong-trinh-dich---BTL1
Code cho bài tập lớn 1 cho môn học Chương Trình Dịch.
Phần Code trên bao gồm:
1, Bộ phân tích từ vựng: BTL1.f
2, Bộ phân tích cú pháp: BTL1.y , BTL1.h, BTL1.c
Để chạy, download 4 file, sau đó sử dụng Ubuntu, chạy các lệnh sau:
bison -d BTL1.y 
flex BTL1.l 
gcc BTL1.tab.c lex.yy.c BTL1.c -o BTL1
./BTL1 test.upl  // Thay tên file để test

Trong này tồn tại 3 file UPL để test.
