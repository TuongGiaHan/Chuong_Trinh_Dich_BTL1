# Chuong-trinh-dich---BTL1
Code cho bài tập lớn 1 cho môn học Chương Trình Dịch.

Phần Code trên bao gồm:

1, Bộ phân tích từ vựng: BTL1.l

2, Bộ phân tích cú pháp: BTL1.y , BTL1.h, BTL1.c

Để chạy, download 4 file trên (các file còn lại sẽ sinh ra sau khi chạy nên chỉ cần 4 file trên và các file upl test), sau đó sử dụng Ubuntu, chạy các lệnh sau:

bison -d BTL1.y 

flex BTL1.l 

gcc BTL1.tab.c lex.yy.c BTL1.c -o BTL1

./BTL1 test.upl  // Thay tên file để test

Trong này tồn tại 3 file UPL để test: BTL1_1.upl, BTL1_2.upl, BTL1_3.upl. Khi test sẽ thấy file BTL1_1 và BTL1_3 là file không lỗi, file BTL1_2 là file tồn tại lỗi. 

Các yêu cầu còn lại lưu trong Google Drive: https://docs.google.com/document/d/1jLRimY1Y_pQrCi-5H5D84xv_2e3l7CSvCbG3UP86_yA/edit?usp=sharing
