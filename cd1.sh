#!/bin/bash

# Tên file cơ sở dữ liệu lưu thông tin CD
DB_FILE="cd_database.txt"

# ============================================================
#                   MÀU SẮC & TIỆN ÍCH HIỂN THỊ
# ============================================================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m' # No Color

print_success() { echo -e "${GREEN}✔ $1${NC}"; }
print_error()   { echo -e "${RED}✘ $1${NC}"; }
print_warn()    { echo -e "${YELLOW}⚠ $1${NC}"; }
print_title()   { echo -e "${CYAN}${BOLD}$1${NC}"; }

# Định dạng số tiền có dấu phân cách hàng nghìn (150000 -> 150,000)
format_money() {
    printf "%'d" "$1" 2>/dev/null || echo "$1"
}

# Vẽ một đường kẻ ngang lặp ký tự cho đủ độ rộng
draw_line() {
    local char="${1:-─}"
    local width="${2:-56}"
    printf "%${width}s\n" | tr ' ' "$char"
}

# Hàm dừng màn hình, chờ người dùng nhấn Enter để quay lại menu
pause_screen() {
    echo -e "${YELLOW}$(draw_line "─" 56)${NC}"
    read -p "↩  Nhấn [Enter] để quay lại menu..." temp
}

# --- KHỞI TẠO DATA MẪU (Nếu file chưa tồn tại hoặc đang trống) ---
if [ ! -s "$DB_FILE" ]; then
    cat << EOF > "$DB_FILE"
CD01|Tình Ca Muôn Thuở|Trữ tình|Quang Lê|150000|50|Về đâu mái tóc người thương, Gõ cửa trái tim, Sầu tím thiệp hồng
CD02|Rap Việt Cực Chất|Rap/HipHop|Binz|180000|30|Bigcityboi, Don't break my heart, Nguyên team đi vào hết
CD03|Nhạc Trẻ Hot Hit|Pop|Sơn Tùng M-TP|200000|25|Chúng ta của tương lai, Hãy trao cho anh, Lạc trôi
CD04|Giai Điệu Quê Hương|Dân ca|Cẩm Ly|120000|40|Chim trắng mồ côi, Thím hai sang sông, Phố hoa
CD05|Rock Xuyên Đêm|Rock|Bức Tường|160000|15|Bông hồng thủy tinh, Đường đến ngày vinh quang, Mắt đen
EOF
fi

# Định dạng lưu trong file:
# Mã CD | Tên CD | Thể loại | Tác giả | Giá bán | Số lượng | Danh sách bài hát (cách nhau bởi dấu phẩy)

# Biến lưu thông tin giao dịch bán hàng gần nhất (dùng để in hóa đơn)
LAST_MA_CD=""
LAST_TEN_CD=""
LAST_GIA_BAN=""
LAST_SL_MUA=""
LAST_THANH_TIEN=""

# ============================================================
#                   CÁC HÀM TIỆN ÍCH (HELPER)
# ============================================================

# Hàm kiểm tra chuỗi không để trống
read_non_empty() {
    local prompt="$1"
    local value
    while true; do
        read -p "$prompt" value
        if [ -n "$value" ]; then
            printf '%s' "$value"
            return 0
        fi
        print_error "Giá trị không được để trống. Vui lòng nhập lại." >&2
    done
}

# Hàm kiểm tra số nguyên dương (bắt buộc nhập)
read_positive_int() {
    local prompt="$1"
    local value
    while true; do
        read -p "$prompt" value
        if [[ "$value" =~ ^[0-9]+$ ]] && [ "$value" -gt 0 ]; then
            printf '%s' "$value"
            return 0
        fi
        print_error "Vui lòng nhập một số nguyên dương hợp lệ." >&2
    done
}

# Hàm kiểm tra số nguyên dương nhưng cho phép để trống (dùng khi sửa - giữ giá trị cũ)
read_optional_positive_int() {
    local prompt="$1"
    local value
    while true; do
        read -p "$prompt" value
        if [ -z "$value" ]; then
            printf ''
            return 0
        fi
        if [[ "$value" =~ ^[0-9]+$ ]] && [ "$value" -gt 0 ]; then
            printf '%s' "$value"
            return 0
        fi
        print_error "Vui lòng nhập một số nguyên dương hợp lệ hoặc để trống để giữ nguyên." >&2
    done
}

# Kiểm tra mã CD đã tồn tại trong DB chưa (trả về 0 nếu có, 1 nếu không)
record_exists() {
    local ma_cd="$1"
    awk -F'|' -v key="$ma_cd" '$1==key {found=1; exit} END {exit !found}' "$DB_FILE"
}

# Lấy dòng dữ liệu đầy đủ ứng với mã CD
get_record() {
    local ma_cd="$1"
    awk -F'|' -v key="$ma_cd" '$1==key {print; exit}' "$DB_FILE"
}

# Cập nhật (ghi đè) dòng dữ liệu ứng với mã CD
update_db_line() {
    local ma_cd="$1"
    local new_line="$2"
    local tmp_file="${DB_FILE}.tmp"
    awk -F'|' -v key="$ma_cd" -v newline="$new_line" \
        'BEGIN{OFS=FS} $1==key {print newline; found=1; next} {print} END {exit !found}' \
        "$DB_FILE" > "$tmp_file" && mv "$tmp_file" "$DB_FILE"
}

# Xóa dòng dữ liệu ứng với mã CD
delete_db_line() {
    local ma_cd="$1"
    local tmp_file="${DB_FILE}.tmp"
    awk -F'|' -v key="$ma_cd" '$1!=key {print}' "$DB_FILE" > "$tmp_file" && mv "$tmp_file" "$DB_FILE"
}

# ============================================================
#         a. THÊM CD
# ============================================================
them_cd() {
    clear
    print_title "=== THÊM CD MỚI ==="
    ma_cd=$(read_non_empty "Nhập mã CD (duy nhất): ")

    if record_exists "$ma_cd"; then
        print_error "Mã CD này đã tồn tại!"
        pause_screen
        return
    fi

    ten_cd=$(read_non_empty "Nhập tên CD: ")
    the_loai=$(read_non_empty "Nhập thể loại: ")
    tac_gia=$(read_non_empty "Nhập tác giả/ca sĩ: ")
    gia_ban=$(read_positive_int "Nhập giá bán (VNĐ): ")
    so_luong=$(read_positive_int "Nhập số lượng tồn kho: ")

    echo "$ma_cd|$ten_cd|$the_loai|$tac_gia|$gia_ban|$so_luong|" >> "$DB_FILE"
    print_success "Đã thêm thông tin cơ bản của CD thành công!"
    pause_screen
}

# ============================================================
#         b. THÊM THÔNG TIN CHI TIẾT CD (DANH SÁCH BÀI HÁT)
# ============================================================
them_chi_tiet_cd() {
    clear
    print_title "=== THÊM THÔNG TIN CHI TIẾT CD (BÀI HÁT) ==="
    ma_cd=$(read_non_empty "Nhập mã CD cần thêm chi tiết: ")

    if ! record_exists "$ma_cd"; then
        print_error "Không tìm thấy mã CD này!"
        pause_screen
        return
    fi

    ds_bai_hat=$(read_non_empty "Nhập danh sách bài hát (các bài cách nhau bằng dấu phẩy): ")

    old_line=$(get_record "$ma_cd")
    base_info=$(echo "$old_line" | cut -d'|' -f1-6)
    new_line="$base_info|$ds_bai_hat"

    if update_db_line "$ma_cd" "$new_line"; then
        print_success "Đã cập nhật chi tiết danh sách bài hát thành công!"
    else
        print_error "Lỗi khi cập nhật dữ liệu. Vui lòng thử lại."
    fi
    pause_screen
}

# ============================================================
#         c. HIỂN THỊ THÔNG TIN CD NGẮN GỌN
# ============================================================
hien_thi_ngan_gon() {
    clear
    print_title "=== DANH SÁCH CD (RÚT GỌN) ==="
    echo ""
    printf "${BOLD}%-8s │ %-25s │ %-15s │ %12s${NC}\n" "Mã CD" "Tên CD" "Tác giả" "Giá bán"
    draw_line "─" 70
    while IFS='|' read -r ma_cd ten_cd the_loai tac_gia gia_ban so_luong ds_bai_hat; do
        if [ -n "$ma_cd" ]; then
            local gia_fmt="$(format_money "$gia_ban") đ"
            printf "%-8s │ %-25.25s │ %-15.15s │ %12s\n" "$ma_cd" "$ten_cd" "$tac_gia" "$gia_fmt"
        fi
    done < "$DB_FILE"
    draw_line "─" 70
    pause_screen
}

# ============================================================
#         d. HIỂN THỊ THÔNG TIN CD ĐẦY ĐỦ
# ============================================================
hien_thi_day_du() {
    clear
    print_title "=== DANH SÁCH CD (ĐẦY ĐỦ CHI TIẾT) ==="
    echo ""
    while IFS='|' read -r ma_cd ten_cd the_loai tac_gia gia_ban so_luong ds_bai_hat; do
        if [ -n "$ma_cd" ]; then
            echo -e "${CYAN}┌─ CD: ${BOLD}$ma_cd${NC}${CYAN} ─────────────────────────${NC}"
            echo "│ Tên CD:       $ten_cd"
            echo "│ Thể loại:     $the_loai"
            echo "│ Tác giả:      $tac_gia"
            echo "│ Giá bán:      $(format_money "$gia_ban") đ"
            echo "│ Số lượng tồn: $so_luong"
            echo "│ Bài hát:      ${ds_bai_hat:-(Chưa cập nhật)}"
            echo -e "${CYAN}└──────────────────────────────────────────${NC}"
        fi
    done < "$DB_FILE"
    pause_screen
}

# ============================================================
#         e. TÌM KIẾM CD THEO THỂ LOẠI
# ============================================================
tim_kiem_the_loai() {
    clear
    print_title "=== TÌM KIẾM THEO THỂ LOẠI ==="
    read -p "Nhập thể loại cần tìm: " tu_khoa
    draw_line "─" 70
    found=0
    while IFS='|' read -r ma_cd ten_cd the_loai tac_gia gia_ban so_luong ds_bai_hat; do
        if [ -n "$ma_cd" ] && echo "$the_loai" | grep -iq -- "$tu_khoa"; then
            echo "[$ma_cd] - Tên: $ten_cd | Thể loại: $the_loai | Tác giả: $tac_gia | Giá: $(format_money "$gia_ban") đ"
            found=1
        fi
    done < "$DB_FILE"
    [ "$found" -eq 0 ] && print_warn "Không tìm thấy CD nào thuộc thể loại: '$tu_khoa'"
    pause_screen
}

# ============================================================
#         f. TÌM KIẾM CD THEO TÁC GIẢ
# ============================================================
tim_kiem_tac_gia() {
    clear
    print_title "=== TÌM KIẾM THEO TÁC GIẢ ==="
    read -p "Nhập tên tác giả cần tìm: " tu_khoa
    draw_line "─" 70
    found=0
    while IFS='|' read -r ma_cd ten_cd the_loai tac_gia gia_ban so_luong ds_bai_hat; do
        if [ -n "$ma_cd" ] && echo "$tac_gia" | grep -iq -- "$tu_khoa"; then
            echo "[$ma_cd] - Tên: $ten_cd | Tác giả: $tac_gia | Thể loại: $the_loai | Giá: $(format_money "$gia_ban") đ"
            found=1
        fi
    done < "$DB_FILE"
    [ "$found" -eq 0 ] && print_warn "Không tìm thấy CD nào của tác giả: '$tu_khoa'"
    pause_screen
}

# ============================================================
#         g. TÌM KIẾM CD THEO TÊN BÀI HÁT
# ============================================================
tim_kiem_bai_hat() {
    clear
    print_title "=== TÌM KIẾM THEO TÊN BÀI HÁT ==="
    read -p "Nhập tên bài hát cần tìm: " tu_khoa
    draw_line "─" 70
    found=0
    while IFS='|' read -r ma_cd ten_cd the_loai tac_gia gia_ban so_luong ds_bai_hat; do
        if [ -n "$ma_cd" ] && echo "$ds_bai_hat" | grep -iq -- "$tu_khoa"; then
            echo "[$ma_cd] - CD: $ten_cd chứa bài hát phù hợp."
            echo "       Danh sách bài hát: $ds_bai_hat"
            found=1
        fi
    done < "$DB_FILE"
    [ "$found" -eq 0 ] && print_warn "Không tìm thấy CD nào có bài hát chứa: '$tu_khoa'"
    pause_screen
}

# ============================================================
#         h. BÁN CD
# ============================================================
ban_cd() {
    clear
    print_title "=== BÁN ĐĨA CD ==="
    ma_cd=$(read_non_empty "Nhập mã CD khách muốn mua: ")

    if ! record_exists "$ma_cd"; then
        print_error "Không tìm thấy đĩa CD này trong hệ thống!"
        pause_screen
        return
    fi

    cd_line=$(get_record "$ma_cd")
    ten_cd=$(echo "$cd_line" | cut -d'|' -f2)
    gia_ban=$(echo "$cd_line" | cut -d'|' -f5)
    so_luong_kho=$(echo "$cd_line" | cut -d'|' -f6)
    base_info=$(echo "$cd_line" | cut -d'|' -f1-5)
    ds_bai_hat=$(echo "$cd_line" | cut -d'|' -f7-)

    echo -e "Sản phẩm: ${BOLD}$ten_cd${NC} | Giá: $(format_money "$gia_ban") đ | Tồn kho: $so_luong_kho"
    sl_mua=$(read_positive_int "Nhập số lượng khách mua: ")

    if [ "$sl_mua" -gt "$so_luong_kho" ]; then
        print_error "Kho không đủ hàng! (Hiện còn: $so_luong_kho)"
        pause_screen
        return
    fi

    # Trừ số lượng tồn kho và cập nhật vào file
    new_so_luong=$((so_luong_kho - sl_mua))
    if ! update_db_line "$ma_cd" "$base_info|$new_so_luong|$ds_bai_hat"; then
        print_error "Lỗi khi cập nhật số lượng tồn kho. Vui lòng thử lại."
        pause_screen
        return
    fi

    # Lưu lại thông tin giao dịch để dùng cho chức năng "In hóa đơn"
    LAST_MA_CD="$ma_cd"
    LAST_TEN_CD="$ten_cd"
    LAST_GIA_BAN="$gia_ban"
    LAST_SL_MUA="$sl_mua"
    LAST_THANH_TIEN=$((gia_ban * sl_mua))

    print_success "Bán CD thành công! Kho còn lại: $new_so_luong"
    print_warn "(Chọn mục 'In hóa đơn bán hàng' để in hóa đơn cho giao dịch này)"
    pause_screen
}

# ============================================================
#         i. IN HÓA ĐƠN BÁN HÀNG
# ============================================================
in_hoa_don() {
    clear
    if [ -z "$LAST_MA_CD" ]; then
        print_warn "Chưa có giao dịch bán hàng nào trong phiên làm việc này để in hóa đơn!"
        pause_screen
        return
    fi

    echo -e "${MAGENTA}╔══════════════════════════════════════════╗${NC}"
    echo -e "${MAGENTA}║${NC}${BOLD}           HÓA ĐƠN BÁN HÀNG               ${NC}${MAGENTA}║${NC}"
    echo -e "${MAGENTA}╚══════════════════════════════════════════╝${NC}"
    echo " Thời gian:  $(date '+%Y-%m-%d %H:%M:%S')"
    echo " Sản phẩm:   $LAST_TEN_CD (Mã: $LAST_MA_CD)"
    echo " Đơn giá:    $(format_money "$LAST_GIA_BAN") đ"
    echo " Số lượng:   $LAST_SL_MUA"
    draw_line "─" 44
    echo -e " ${BOLD}TỔNG TIỀN:  $(format_money "$LAST_THANH_TIEN") đ${NC}"
    echo -e "${MAGENTA}════════════════════════════════════════════${NC}"
    echo "      CẢM ƠN QUÝ KHÁCH VÀ HẸN GẶP LẠI!"
    echo -e "${MAGENTA}════════════════════════════════════════════${NC}"
    pause_screen
}

# ============================================================
#                    BANNER CHÀO (1 lần khi mở app)
# ============================================================
show_banner() {
    clear
    echo -e "${CYAN}${BOLD}"
    cat << "EOF"
   ____  ____    ____  _   _  ____  ____
  / __ \|  _ \  / ___|| | | |/ __ \|  _ \
 | |  | | | | | \___ \| |_| | |  | | |_) |
 | |__| | |_| |  ___) |  _  | |__| |  __/
  \____/|____/  |____/|_| |_|\____/|_|
EOF
    echo -e "${NC}"
    echo -e "${YELLOW}        Hệ Thống Quản Lý Tiệm Bán Đĩa CD${NC}"
    sleep 1
}

# ============================================================
#                       MENU CHÍNH
# ============================================================
show_banner

while true; do
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}${BOLD}      HỆ THỐNG QUẢN LÝ TIỆM BÁN ĐĨA CD             ${NC}${CYAN}║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════╝${NC}"
    echo -e "  ${GREEN}a.${NC} Thêm CD"
    echo -e "  ${GREEN}b.${NC} Thêm thông tin chi tiết CD"
    echo -e "  ${GREEN}c.${NC} Hiển thị thông tin CD ngắn gọn"
    echo -e "  ${GREEN}d.${NC} Hiển thị thông tin CD đầy đủ"
    echo -e "  ${GREEN}e.${NC} Tìm kiếm CD theo thể loại"
    echo -e "  ${GREEN}f.${NC} Tìm kiếm CD theo tác giả"
    echo -e "  ${GREEN}g.${NC} Tìm kiếm CD theo tên bài hát"
    echo -e "  ${GREEN}h.${NC} Bán CD"
    echo -e "  ${GREEN}i.${NC} In hóa đơn bán hàng"
    echo -e "  ${GREEN}j.${NC} Thoát chương trình"
    echo -e "${CYAN}╚══════════════════════════════════════════════════╝${NC}"
    read -p "Vui lòng chọn chức năng: " lua_chon

    case $lua_chon in
        a|A) them_cd ;;
        b|B) them_chi_tiet_cd ;;
        c|C) hien_thi_ngan_gon ;;
        d|D) hien_thi_day_du ;;
        e|E) tim_kiem_the_loai ;;
        f|F) tim_kiem_tac_gia ;;
        g|G) tim_kiem_bai_hat ;;
        h|H) ban_cd ;;
        i|I) in_hoa_don ;;
        j|J)
            read -p "Bạn có chắc muốn thoát chương trình? (y/N): " xac_nhan
            case "$xac_nhan" in
                [yY])
                    echo -e "${CYAN}Tạm biệt và hẹn gặp lại!${NC}"
                    exit 0
                    ;;
            esac
            ;;
        *)
            print_error "Lựa chọn không hợp lệ, vui lòng chọn lại!"
            sleep 1
            ;;
    esac
done