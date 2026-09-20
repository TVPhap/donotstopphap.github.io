/*
 * Bài 1. Liệt kê các số chẵn (LietKeChan.cs)
 * Yêu cầu: Nhập mảng số nguyên, liệt kê các phần tử chẵn theo thứ tự từ phải sang trái.
 */
using System;

namespace NMLT.Buoi09
{
    public class LietKeChan
    {
        /// Nhập số lượng phần tử và các giá trị của mảng từ bàn phím.
        /// Trả về mảng số nguyên đã khởi tạo.
        public static int[] NhapDaySo()
        {
            int n;
            while (true)
            {
                Console.Write("Moi ban nhap so luong phan tu: ");
                string? input = Console.ReadLine();

                if (int.TryParse(input, out n) && n > 0)
                {
                    break;
                }
                Console.WriteLine("Loi: So luong phan tu phai la so nguyen duong. Vui long nhap lai!");
            }

            int[] day = new int[n];

            for (int i = 0; i < n; i++)
            {
                while (true)
                {
                    Console.Write("Phan tu [{0}]: ", i);
                    string? input = Console.ReadLine();

                    if (int.TryParse(input, out day[i]))
                    {
                        break;
                    }
                    Console.WriteLine("Loi: Gia tri khong hop le. Vui long nhap lai so nguyen!");
                }
            }

            return day;
        }
        /// Duyệt mảng từ phần tử cuối về đầu (phải sang trái) và in ra những phần tử chẵn.
        public static void LietKeChanPhaiSangTrai(int[]? day)
        {
            if (day == null || day.Length == 0)
            {
                Console.WriteLine("Mang rong hoac khong hop le.");
                return;
            }

            Console.Write("Cac phan tu chan trong mang: ");
            bool coPhanTuChan = false;

            for (int i = day.Length - 1; i >= 0; i--)
            {
                if (day[i] % 2 == 0)
                {
                    Console.Write("{0} ", day[i]);
                    coPhanTuChan = true;
                }
            }

            if (!coPhanTuChan)
            {
                Console.Write("(Khong co so chan)");
            }

            Console.WriteLine();
        }

        public static void Main(string[] args)
        {
            // Nhập mảng từ người dùng
            int[] a = NhapDaySo();

            // Liệt kê số chẵn theo thứ tự từ phải sang trái
            LietKeChanPhaiSangTrai(a);
        }
    }
}