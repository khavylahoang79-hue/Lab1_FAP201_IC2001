# Lab1_FAP201_IC2001
# Lab1_FAP201 - Direct Switch to LED Mapping

## Thông tin chung
- **Môn học:** FAP201 - FPGA Programming
- **Bài thực hành:** Lab01 - Direct Switch-to-LED Buffer (CLO1 & CLO2)
- **Mục tiêu:** Thiết kế, kiểm chứng và hiện thực mạch đệm (buffer) logic gán trực tiếp tín hiệu ngõ vào từ 3 công tắc/nút bấm đến 3 đèn LED tương ứng trên bo mạch FPGA[cite: 1, 2].

## Môi trường và Phần cứng
- **Công cụ phát triển:** Gowin EDA[cite: 1]
- **Bo mạch (Board):** Xiaomeige ACG525
- **Chip FPGA (Target Device):** GW5A-LV25UG324C2/I1
- **Ngôn ngữ:** VHDL (IEEE 1164 STD_LOGIC)[cite: 2]

## Nguyên lý hoạt động & Bảng chân lý
- **Mạch đệm tổ hợp (Direct Pass-Through Buffer):** Các ngõ vào `i_sw1`, `i_sw2`, `i_sw3` được nối trực tiếp sang các ngõ ra `o_led1`, `o_led2`, `o_led3` thông qua các phép gán tín hiệu đồng thời (`o_led1 <= i_sw1;`, `o_led2 <= i_sw2;`, `o_led3 <= i_sw3;`)[cite: 2]. Mạch hoàn toàn là logic tổ hợp, không sử dụng xung nhịp (clock), thanh ghi (register) hay máy trạng thái (FSM).
- **Phân tích cực tính phần cứng (Active-Low Hardware):**
  * **Công tắc ngõ vào (`i_sw1`, `i_sw2`, `i_sw3`):** Mặc định khi thả nút ra mang mức logic `'1'` (nhờ cấu hình điện trở kéo lên `PULL_MODE=UP`), khi nhấn nút xuống mang mức logic `'0'`[cite: 1].
  * **Đèn LED ngõ ra (`o_led1`, `o_led2`, `o_led3`):** Đèn TẮT ở mức logic `'1'` và SÁNG ở mức logic `'0'`.
  * **Logic vận hành:** Vì là mạch đệm trực tiếp, trạng thái logic ngõ ra luôn trùng với trạng thái ngõ vào[cite: 2]. Khi thả nút bấm (ngõ vào là `'1'`), LED tương ứng sẽ TẮT (ngõ ra là `'1'`)[cite: 1, 2]. Khi nhấn nút bấm kéo ngõ vào về `'0'`, LED tương ứng sẽ SÁNG (ngõ ra về `'0'`)[cite: 1, 2].

### Bảng chân lý (Truth Table)
| i_sw1 (KEY0) | i_sw2 (KEY1) | i_sw3 (KEY2) | o_led1 (LED0) | o_led2 (LED1) | o_led3 (LED2) | Trạng thái vật lý |
| :---: | :---: | :---: | :---: | :---: | :---: | :--- |
| `1` (Thả) | `1` (Thả) | `1` (Thả) | `1` | `1` | `1` | Thả cả 3 nút $\rightarrow$ Cả 3 LED TẮT[cite: 1, 2] |
| `0` (Nhấn) | `1` (Thả) | `1` (Thả) | `0` | `1` | `1` | Nhấn SW1 $\rightarrow$ LED1 SÁNG, LED2 & LED3 TẮT[cite: 1, 2] |
| `1` (Thả) | `0` (Nhấn) | `1` (Thả) | `1` | `0` | `1` | Nhấn SW2 $\rightarrow$ LED2 SÁNG, LED1 & LED3 TẮT[cite: 1, 2] |
| `1` (Thả) | `1` (Thả) | `0` (Nhấn) | `1` | `1` | `0` | Nhấn SW3 $\rightarrow$ LED3 SÁNG, LED1 & LED2 TẮT[cite: 1, 2] |
| `0` (Nhấn) | `0` (Nhấn) | `0` (Nhấn) | `0` | `0` | `0` | Nhấn cả 3 nút $\rightarrow$ Cả 3 LED SÁNG[cite: 1, 2] |

## Bảng ánh xạ chân vật lý (Physical Constraints Mapping)
Tín hiệu được cấu hình trong file `Lab1.cst`[cite: 1]:

| Tín hiệu VHDL | Chân FPGA | Linh kiện phần cứng | Cấu hình I/O (3.3V Bank VCCIO) |
| :--- | :---: | :--- | :--- |
| `i_sw1` | `B16` | Switch 1 / KEY0 | `PULL_MODE=UP`, `DRIVE=OFF`[cite: 1] |
| `i_sw2` | `A15` | Switch 2 / KEY1 | `PULL_MODE=UP`, `DRIVE=OFF`[cite: 1] |
| `i_sw3` | `C15` | Switch 3 / KEY2 | `PULL_MODE=UP`, `DRIVE=OFF`[cite: 1] |
| `o_led1` | `D14` | Output LED 1 / LED0 | `PULL_MODE=NONE`, `DRIVE=8mA`[cite: 1] |
| `o_led2` | `C14` | Output LED 2 / LED1 | `PULL_MODE=NONE`, `DRIVE=8mA`[cite: 1] |
| `o_led3` | `B9` | Output LED 3 / LED2 | `PULL_MODE=NONE`, `DRIVE=8mA`[cite: 1] |

## Cấu trúc thư mục dự án (Project Structure)
Kho lưu trữ được tổ chức theo tiêu chuẩn đánh giá của môn học:

- `src/Lab1.vhd`: Mã nguồn VHDL mô tả mạch đệm ngõ vào/ngõ ra[cite: 2].
- `constraints/Lab1.cst`: File gán chân vật lý cho chip Gowin GW5A[cite: 1].
- `sim/lab01_tb.vhd`: File Testbench kiểm thử các vector ngõ vào.
- `waveform/`: Ảnh chụp hoặc file trace dạng sóng mô phỏng (`.ghw`).
- `reports/`: Báo cáo quá trình Tổng hợp (Synthesis) và P&R (Place & Route).
- `evidence/`: Nhật ký Programmer và bằng chứng nghiệm thu trên bo mạch phần cứng.
- `README.md`: Tài liệu hướng dẫn dự án.

## Hướng dẫn Build & Kiểm chứng (Execution & Verification)
1. **Mô phỏng (Simulation):**
   * Mở công cụ mô phỏng (GHDL / Gowin Simulator) và chạy testbench `sim/lab01_tb.vhd`.
   * Đảm bảo các trường hợp tổ hợp ngõ vào đều vượt qua các câu lệnh `assert` và hiển thị kết quả đúng trên sóng dạng waveform.
2. **Tổng hợp & Nạp phần cứng (Synthesis & Programming):**
   * Mở project trong Gowin EDA với target `GW5A-LV25UG324C2/I1`[cite: 1].
   * Chạy quá trình **Synthesis** và **Place & Route**.
   * Kết nối bo mạch Xiaomeige ACG525, sử dụng Gowin Programmer để nạp file bitstream (`.fs`) xuống chip.
   * Thao tác trực tiếp với các nút bấm KEY0, KEY1, KEY2 để đối chiếu kết quả thực tế trên LED0, LED1, LED2[cite: 1].
