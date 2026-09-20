/*
 * Bài 2. Tìm giá trị chẵn đầu tiên, cuối cùng (TimKiemGiaTriChan.cs)
 * Yêu cầu: Tìm vị trí của giá trị chẵn đầu tiên và cuối cùng trong mảng.
 */
using System;

namespace NMLT.Buoi09
{
    public class TimKiemGiaTriChan
    {
        // Nhập mảng số nguyên từ bàn phím.
        // Dùng "ref" vì mảng được cấp phát (new) bên trong hàm
        // nên cần trả kết quả cấp phát đó ra ngoài cho biến "day" ở Main.
        // Mảng số nguyên sẽ được cấp phát và nhập giá trị
        public static void nhapdayso(ref int[] day)
        {
            Console.Write("Moi ban nhap so luong phan tu: ");
            int n = int.Parse(Console.ReadLine()!);
            day = new int[n];

            for (int i = 0; i < n; i++)
            {
                Console.Write("Phan tu {0}: ", i);
                day[i] = int.Parse(Console.ReadLine()!);
            }
        }

        // Tìm vị trí (chỉ số) của phần tử chẵn đầu tiên
        // bằng cách duyệt mảng từ đầu đến cuối.
        // Trả về vị trí (chỉ số) nếu tìm thấy, ngược lại trả về -1.
        public static int timchandautien(int[] day)
        {
            for (int i = 0; i < day.Length; i++)
            {
                if (day[i] % 2 == 0)
                    return i; // Trả về vị trí ngay khi tìm thấy số chẵn đầu tiên
            }
            return -1; // Trả về -1 nếu không có số chẵn nào
        }

        // Tìm vị trí (chỉ số) của phần tử chẵn cuối cùng
        // bằng cách duyệt mảng từ cuối về đầu.
        // Trả về vị trí (chỉ số) nếu tìm thấy, ngược lại trả về -1.
        public static int timchancuoicung(int[] day)
        {
            for (int i = day.Length - 1; i >= 0; i--)
            {
                if (day[i] % 2 == 0)
                    return i; // Trả về vị trí ngay khi tìm thấy số chẵn từ cuối lên
            }
            return -1; // Trả về -1 nếu không có số chẵn nào
        }

        public static void Main(string[] args)
        {
            // Khởi tạo mảng rỗng, sẽ được cấp phát bên trong nhapdayso()
            int[]? a = null;

            // Gọi hàm nhập dãy số từ người dùng
            nhapdayso(ref a!);

            // Tìm vị trí chẵn đầu tiên và cuối cùng
            int vtDau = timchandautien(a);
            int vtCuoi = timchancuoicung(a);

            // Xử lý kết quả tìm kiếm
            if (vtDau == -1)
            {
                // Nếu không tìm thấy số chẵn đầu tiên thì chắc chắn mảng không có số chẵn nào
                Console.WriteLine("Day so khong co gia tri chan.");
            }
            else
            {
                Console.WriteLine("Gia tri chan dau tien o vi tri {0} co gia tri {1}.", vtDau, a[vtDau]);
                Console.WriteLine("Gia tri chan cuoi cung o vi tri {0} co gia tri {1}.", vtCuoi, a[vtCuoi]);
            }
        }
    }
}