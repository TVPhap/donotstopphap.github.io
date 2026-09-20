/*
 * Bài 1. Tính tổ hợp C(k, n) (GiaiThua.cs)
 * Yêu cầu: Nhập số nguyên dương n, k với k <= n. Tính C(n,k) = n! / (k! * (n-k)!)
 */
using System;

namespace NMLT.Buoi08
{
    public class GiaiThua
    {
        // Tính giai thừa n! = 1 * 2 * ... * n bằng vòng lặp.
        // Dùng kiểu long vì n! tăng rất nhanh, dễ tràn số int.
        // Trả về giá trị n!
        public static long tinhgiaithua(int n)
        {
            long gt = 1;
            for (int i = 1; i <= n; i++)
            {
                gt = gt * i;
            }
            return gt;
        }

        // Tính tổ hợp chập k của n phần tử C(n,k) = n! / (k! * (n-k)!) bằng cách gọi hàm tinhgiaithua() 3 lần.
        // Trả về giá trị tổ hợp C(n,k)
        public static long tinhtohop(int k, int n)
        {
            long gtN = tinhgiaithua(n);
            long gtK = tinhgiaithua(k);
            long gtN_K = tinhgiaithua(n - k);

            return gtN / (gtK * gtN_K);
        }

        public static void Main(string[] args)
        {
            int k, n;

            // Nhập k và n
            Console.Write("Moi ban nhap k: ");
            k = int.Parse(Console.ReadLine()!);

            Console.Write("Moi ban nhap n: ");
            n = int.Parse(Console.ReadLine()!);

            // Kiểm tra điều kiện hợp lệ: 0 <= k <= n
            if (k <= n && k >= 0)
            {
                long kq = tinhtohop(k, n);
                Console.WriteLine("C({0}, {1}) = {2}.", k, n, kq);
            }
            else
            {
                Console.WriteLine("Du lieu khong hop le! (Yeu cau 0 <= k <= n)");
            }
        }
    }
}