/*
 * Bài 3. Đếm dấu (DemDau.cs)
 * Yêu cầu: Đếm trong dãy số thực có bao nhiêu số dương, số âm và số không.
 */
using System;

namespace NMLT.Buoi09
{
    public class DemDau
    {
        // Nhập mảng số thực (double) từ bàn phím.
        // Dùng "ref" vì mảng được cấp phát (new) bên trong hàm
        // nên cần trả kết quả cấp phát đó ra ngoài cho biến "day" ở Main.
        // Mảng số thực sẽ được cấp phát và nhập giá trị
        public static void nhapdayso(ref double[] day)
        {
            Console.Write("Moi ban nhap so luong phan tu: ");
            int n = int.Parse(Console.ReadLine()!);
            day = new double[n];

            for (int i = 0; i < n; i++)
            {
                Console.Write("Phan tu {0}: ", i);
                day[i] = double.Parse(Console.ReadLine()!);
            }
        }

        // Đếm số lượng số dương, số âm và số không (bằng 0) trong mảng.
        // Dùng "ref" cho 3 biến đếm để hàm có thể cập nhật trực tiếp
        // giá trị của chúng ra ngoài (thay vì chỉ trả về 1 kết quả duy nhất).
        public static void demdaucacso(double[] day, ref int demDuong, ref int demAm, ref int demKhong)
        {
            // Khởi tạo các biến đếm về 0 trước khi đếm
            demDuong = 0;
            demAm = 0;
            demKhong = 0;

            // Duyệt từng phần tử x trong dãy số bằng foreach
            foreach (double x in day)
            {
                if (x > 0)
                    demDuong++;
                else if (x < 0)
                    demAm++;
                else
                    demKhong++;
            }
        }

        public static void Main(string[] args)
        {
            // Khởi tạo mảng rỗng, sẽ được cấp phát bên trong nhapdayso()
            double[]? a = null;
            nhapdayso(ref a!);

            // Khai báo và khởi tạo các biến đếm trước khi gọi hàm
            int duong = 0, am = 0, khong = 0;

            // Gọi hàm đếm dấu, truyền các biến nhận kết quả bằng "ref"
            demdaucacso(a, ref duong, ref am, ref khong);

            Console.WriteLine("Day so co {0} so am, {1} so khong va {2} so duong.", am, khong, duong);
        }
    }
}