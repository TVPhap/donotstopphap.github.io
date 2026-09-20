/*
 * Bài 4. Liệt kê / Đếm chữ số (DemChuSo.cs)
 * Yêu cầu: Nhập số nguyên dương n. Đếm số lần xuất hiện của từng chữ số từ 0 đến 9 có trong n.
 */
using System;

namespace NMLT.Buoi08
{
    public class DemChuSo
    {
        // Đếm số lần chữ số "chuSo" xuất hiện trong số n bằng cách tách từng chữ số cuối cùng (n % 10) rồi dịch phải (n / 10).
        // Trả về số lần chuSo xuất hiện trong n.
        public static int demsolanxuatthien(long n, int chuSo)
        {
            int dem = 0;
            // Trường hợp đặc biệt: n = 0 thì số 0 "xuất hiện" đúng 1 lần
            if (n == 0 && chuSo == 0) return 1;

            long tmp = Math.Abs(n);
            while (tmp > 0)
            {
                int cs = (int)(tmp % 10); // Lấy chữ số cuối
                if (cs == chuSo)
                {
                    dem++;
                }
                tmp = tmp / 10; // Dịch phải (bỏ chữ số vừa xét)
            }
            return dem;
        }

        // Thống kê và in ra số lần xuất hiện của tất cả các chữ số (0-9) trong n, chỉ in ra những chữ số có xuất hiện (số lần > 0).
        public static void thongkechuso(long n)
        {
            for (int cs = 0; cs <= 9; cs++)
            {
                int sl = demsolanxuatthien(n, cs);
                if (sl > 0)
                {
                    Console.WriteLine("Chu so {0} xuat hien {1} lan.", cs, sl);
                }
            }
        }

        public static void Main(string[] args)
        {
            Console.Write("Moi ban nhap so nguyen n: ");
            long n = long.Parse(Console.ReadLine()!);

            thongkechuso(n);
        }
    }
}
