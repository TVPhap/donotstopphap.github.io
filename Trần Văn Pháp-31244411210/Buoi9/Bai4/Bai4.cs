/*
 * Bài 4. Tìm kiếm (TimKiem.cs)
 * Yêu cầu: Tìm vị trí đầu tiên, cuối cùng và số lần xuất hiện của một số thực x trong mảng.
 */
using System;

namespace NMLT.Buoi09
{
    public class TimKiem
    {
        // Nhập mảng số thực (double) từ bàn phím.
        // Dùng "ref" vì mảng được cấp phát (new) bên trong hàm nên cần trả kết quả cấp phát đó ra ngoài cho biến "day" ở Main.
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

        // Xuất số lượng và các phần tử trong mảng ra màn hình theo định dạng: Day so co n phan tu: ...
        public static void xuatdayso(double[] day)
        {
            Console.Write("Day so co {0} phan tu: ", day.Length);
            for (int i = 0; i < day.Length; i++)
            {
                Console.Write("{0} ", day[i]);
            }
            Console.WriteLine();
        }

        // Tìm vị trí xuất hiện đầu tiên, cuối cùng và tổng số lần xuất hiện của giá trị x trong mảng, bằng cách duyệt toàn bộ mảng một lần.
        // Dùng "ref" cho 3 biến kết quả vì cần trả về đồng thời nhiều giá trị.
        public static void timkiemx(double[] day, double x, ref int vtDau, ref int vtCuoi, ref int soLan)
        {
            // Gán giá trị khởi tạo: -1 nghĩa là chưa tìm thấy
            vtDau = -1;
            vtCuoi = -1;
            soLan = 0;

            // Duyệt mảng từ đầu đến cuối, so sánh từng phần tử với x
            for (int i = 0; i < day.Length; i++)
            {
                if (day[i] == x)
                {
                    // Nếu là lần đầu tiên tìm thấy x thì lưu lại vị trí đầu
                    if (vtDau == -1)
                        vtDau = i;

                    // Mỗi lần gặp x, cập nhật vị trí cuối cùng và tăng bộ đếm
                    vtCuoi = i;
                    soLan++;
                }
            }
        }

        public static void Main(string[] args)
        {
            // Khởi tạo mảng rỗng, sẽ được cấp phát bên trong nhapdayso()
            double[]? a = null;
            nhapdayso(ref a!);

            // In thông tin và các phần tử của dãy số ra màn hình
            xuatdayso(a);

            Console.Write("Moi ban nhap gia tri x can tim: ");
            double x = double.Parse(Console.ReadLine()!);

            // Khai báo các biến nhận kết quả tìm kiếm
            int vtDau = -1, vtCuoi = -1, soLan = 0;
            timkiemx(a, x, ref vtDau, ref vtCuoi, ref soLan);

            // In kết quả ra màn hình
            if (soLan == 0)
            {
                Console.WriteLine("Gia tri {0} khong ton tai trong day so.", x);
            }
            else
            {
                Console.WriteLine("Gia tri {0} xuat hien {1} lan o vi tri dau tien {2} va cuoi cung {3}.", x, soLan, vtDau, vtCuoi);
            }
        }
    }
}