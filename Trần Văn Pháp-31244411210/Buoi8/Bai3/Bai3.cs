/*
 * Bài 3. Rút gọn phân số (RutGonPhanSo.cs)
 * Yêu cầu: Nhập tử số và mẫu số của một phân số. Hãy rút gọn phân số đó.
 */
using System;

namespace NMLT.Buoi08
{
    public class RutGonPhanSo
    {
        // Tìm ước số chung lớn nhất (USCLN) của hai số a, b bằng giải thuật Euclid (lấy phần dư liên tiếp cho đến khi dư = 0).
        // Trả về USCLN của a và b (luôn không âm).
        public static int uocchunglonnhat(int a, int b)
        {
            a = Math.Abs(a);
            b = Math.Abs(b);
            while (b != 0)
            {
                int tmp = a % b;
                a = b;
                b = tmp;
            }
            return a;
        }

        // Rút gọn phân số tuSo/mauSo bằng cách chia cả tử và mẫu cho USCLN của chúng.
        // Dùng "ref" vì hàm cần thay đổi trực tiếp giá trị tử số, mẫu số ở nơi gọi (Main) sau khi rút gọn.
        public static void rutgonphanso(ref int tuSo, ref int mauSo)
        {
            int uscln = uocchunglonnhat(tuSo, mauSo);
            tuSo = tuSo / uscln; // Chia cả tử và mẫu cho USCLN
            mauSo = mauSo / uscln;
        }

        public static void Main(string[] args)
        {
            Console.Write("Moi ban nhap tu so: ");
            int tu = int.Parse(Console.ReadLine()!);

            Console.Write("Moi ban nhap mau so: ");
            int mau = int.Parse(Console.ReadLine()!);

            // Mẫu số phải khác 0 vì phép chia cho 0 không hợp lệ
            if (mau == 0)
            {
                Console.WriteLine("Mau so phai khac 0!");
            }
            else
            {
                // Lưu lại giá trị ban đầu để hiển thị phân số gốc
                int tuBanDau = tu;
                int mauBanDau = mau;

                rutgonphanso(ref tu, ref mau);

                Console.WriteLine("Phan so {0}/{1} duoc rut gon thanh {2}/{3}.", tuBanDau, mauBanDau, tu, mau);
            }
        }
    }
}