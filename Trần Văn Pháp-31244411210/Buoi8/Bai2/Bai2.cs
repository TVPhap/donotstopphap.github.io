/*
 * Bài 2. Liệt kê số hoàn hảo (LietKeSoHoanHao.cs)
 * Yêu cầu: Nhập số nguyên dương n. Liệt kê các số hoàn hảo trong đoạn [1, n] theo thứ tự giảm dần.
 * (Số hoàn hảo là số có tổng các ước tự nhiên nhỏ hơn nó bằng chính nó, ví dụ 6 = 1 + 2 + 3)
 */
using System;

namespace NMLT.Buoi08
{
    public class LietKeSoHoanHao
    {
        // Kiểm tra n có phải là số hoàn hảo hay không bằng cách cộng dồn tất cả ước số nhỏ hơn n và so sánh với n.
        // Trả về true nếu n là số hoàn hảo, false nếu không.
        public static bool sangsohoanhao(int n)
        {
            if (n <= 1) return false;

            int tongUoc = 0;
            // Duyệt tìm ước từ 1 đến n - 1
            for (int i = 1; i < n; i++)
            {
                if (n % i == 0)
                {
                    tongUoc += i; // Cộng dồn các ước
                }
            
            }

            // Nếu tổng ước bằng chính n thì là số hoàn hảo
            return tongUoc == n;
        }

        // Liệt kê các số hoàn hảo trong đoạn [1, n], duyệt từ n về 1 để in ra theo thứ tự giảm dần.
        public static void lietkesohoanhaogiamdan(int n)
        {
            Console.Write("Cac so hoan hao trong doan [1, {0}]: ", n);
            for (int i = n; i >= 1; i--)
            {
                if (sangsohoanhao(i))
                {
                    Console.Write("{0} ", i);
                }
            }
            Console.WriteLine();
        }

        public static void Main(string[] args)
        {
            Console.Write("Moi ban nhap so n: ");
            int n = int.Parse(Console.ReadLine()!);

            lietkesohoanhaogiamdan(n);
        }
    }
}