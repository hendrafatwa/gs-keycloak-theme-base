# Panduan Theme Keycloak — GS Battery

Panduan pemeliharaan theme login Keycloak 26.4.7 untuk portal-portal GS Battery.

- **Source (tempat kerja):** `D:\PROJECT\Keycloak\Themes-Base\`
- **Deploy (dibaca Keycloak):** `D:\PROJECT\keycloak-26.4.7\themes\`

Dua folder ini **terpisah**, bukan symlink. Setiap perubahan harus disinkron. Lihat bagian [Deploy](#4-deploy).

---

## 1. Konsep

Satu theme induk berisi seluruh template dan aset. Theme turunan **tidak punya file `.ftl` sama sekali** — hanya `theme.properties` berisi warna, teks, dan nama gambar.

```
Themes-Base\
├── gs-base\                       ← INDUK. Semua .ftl + semua aset ada di sini.
│   └── login\
│       ├── theme.properties       ← nilai default seluruh brand
│       ├── template.ftl           ← layout: <head>, CSS, panel kiri/kanan, footer
│       ├── login.ftl              ← halaman login
│       ├── ...24 halaman lain...
│       └── resources\assets\      ← font, CSS, JS, img (±1300 file)
│
├── claim-theme\login\theme.properties        ← parent=gs-base, ungu,  "CLAIM"
├── gssmart-theme\login\theme.properties      ← parent=gs-base, merah, "GS SMART"
└── gstrack-theme\login\theme.properties      ← parent=gs-base, navy,  "GS TRACK"
```

`template.ftl` membaca `theme.properties` dan mengubah warnanya menjadi CSS custom property di `:root`. Jadi menambah portal baru dengan warna dan gambar berbeda **tidak perlu menyentuh satu pun file `.ftl`**.

**Dua aturan letak file yang wajib dipatuhi Keycloak:**

1. `theme.properties` harus berada di **dalam folder tipe** (`<theme>\login\theme.properties`), bukan di root theme. Kalau ditaruh di root, file itu diabaikan total — `parent=`, `import=`, dan semua warna tidak terbaca.
2. Folder `login\` harus ada. Keycloak menentukan tipe theme dari nama folder tipe; tanpa folder itu, theme tidak muncul di dropdown Admin Console.

---

## 2. Daftar property

Semua diisi di `<theme>\login\theme.properties`. Yang tidak diisi mewarisi nilai `gs-base`.

### Wajib di setiap theme turunan

| Property | Contoh | Keterangan |
|---|---|---|
| `parent` | `gs-base` | Wajib. Tanpa ini theme tidak mewarisi apa pun. |

### Teks

| Property | Default | Dipakai di |
|---|---|---|
| `gsAppName` | `GS Portal` | Judul tab browser, nama brand di panel kanan |
| `gsCompanyName` | `PT. GS BATTERY` | Baris copyright di footer |
| `gsAppVersion` | `v1.0` | Label versi di kanan footer |

### Warna

| Property | Default | Dipakai di |
|---|---|---|
| `gsPrimaryColor` | `#ED3237` | Tombol, link, border input fokus, radio terpilih |
| `gsPrimaryHoverColor` | ikut `gsPrimaryColor` | Tombol saat disorot |
| `gsPrimaryActiveColor` | ikut `gsPrimaryColor` | Tombol saat ditekan |
| `gsPrimaryColorRgb` | `237, 50, 55` | Focus ring `rgba()` |
| `gsCoverBgColor` | ikut `gsPrimaryColor` | Latar panel ilustrasi kiri |

> **`gsPrimaryColorRgb` harus triplet desimal dari `gsPrimaryColor`.** CSS tidak bisa mengurai hex di dalam `rgba()`, jadi nilai ini tidak bisa dihitung otomatis. Kalau salah, focus ring tombol akan berwarna lain. Konversi: `#0F9D58` → `15, 157, 88`.

Panduan hover/active: hover sekitar 10% lebih gelap, active sekitar 20% lebih gelap. Boleh dikosongkan — tombol tetap jalan, hanya kehilangan efek sorot dan tekan.

### Gambar

Path relatif ke `login\resources\assets\`.

| Property | Default |
|---|---|
| `gsFavicon` | `img/gs/logo_gs_battery_nonbg.png` |
| `gsBrandIcon` | `img/gs/key.png` |
| `gsSlide1` | `img/gs/GSSMART2.png` |
| `gsSlide2` | `img/gs/bg2.png` |

---

## 3. Menambah theme baru

Contoh: portal baru bernama `portal-baru`, warna hijau `#0F9D58`.

### Langkah 1 — folder dan `theme.properties`

Buat `Themes-Base\portal-baru\login\theme.properties`:

```properties
parent=gs-base

gsAppName=PORTAL BARU
gsCompanyName=PT. GS BATTERY
gsAppVersion=v1.0

gsPrimaryColor=#0F9D58
gsPrimaryHoverColor=#0C8149
gsPrimaryActiveColor=#0A6739
gsPrimaryColorRgb=15, 157, 88
gsCoverBgColor=#0F9D58
```

Kalau tidak punya gambar sendiri, **berhenti di sini** — theme sudah berfungsi dan memakai aset GS SMART.

### Langkah 2 — gambar khusus (opsional)

Taruh file di folder theme baru, bukan di `gs-base`:

```
Themes-Base\portal-baru\login\resources\assets\img\gs\slide-1.png
Themes-Base\portal-baru\login\resources\assets\img\gs\slide-2.png
Themes-Base\portal-baru\login\resources\assets\img\gs\icon.png
Themes-Base\portal-baru\login\resources\assets\img\gs\favicon.png
```

Tambahkan ke `theme.properties`:

```properties
gsSlide1=img/gs/slide-1.png
gsSlide2=img/gs/slide-2.png
gsBrandIcon=img/gs/icon.png
gsFavicon=img/gs/favicon.png
```

Aset yang tidak kamu sediakan tetap diambil dari `gs-base` — font, CSS, JS, dan ikon tidak perlu di-copy.

Catatan gambar: slide panel kiri memakai `object-fit: contain` dengan sudut membulat 20px, rasio kira-kira 7:12 pada layar lebar. Ikon brand dirender 15×15 px.

### Langkah 3 — deploy dan daftarkan

```powershell
robocopy "D:\PROJECT\Keycloak\Themes-Base" "D:\PROJECT\keycloak-26.4.7\themes" /MIR /XF README.md
```

Restart Keycloak, lalu **Admin Console → pilih realm → Realm settings → Themes → Login theme → `portal-baru`**.

Nama di dropdown sama dengan nama folder.

---

## 4. Deploy

### Cara yang benar

```powershell
robocopy "D:\PROJECT\Keycloak\Themes-Base" "D:\PROJECT\keycloak-26.4.7\themes" /MIR /XF README.md
```

- `/MIR` membuat deploy jadi cermin persis source, **termasuk menghapus file yang sudah tidak ada di source**.
- `/XF README.md` melindungi README milik Keycloak agar tidak terhapus.

### Jangan pakai `xcopy` atau `Copy-Item -Recurse`

Keduanya hanya menimpa dan menambah, **tidak menghapus file yatim**. Ini sudah pernah menyebabkan Internal Server Error: file `template.ftl` versi lama tertinggal di folder theme turunan di deploy, dan karena theme turunan menang atas induk, Keycloak terus mem-parse file lama yang ber-bug walaupun source sudah diperbaiki.

### Alternatif: junction (tidak perlu sync lagi)

Jalankan PowerShell **sebagai Administrator**, hentikan Keycloak dulu:

```powershell
Remove-Item "D:\PROJECT\keycloak-26.4.7\themes\gs-base" -Recurse -Force
New-Item -ItemType Junction -Path "D:\PROJECT\keycloak-26.4.7\themes\gs-base" -Target "D:\PROJECT\Keycloak\Themes-Base\gs-base"
```

Ulangi untuk setiap theme. Dengan `start-dev`, edit di source langsung terlihat tanpa copy dan tanpa restart.

### Cache

- `start-dev` — theme tidak di-cache, cukup refresh browser.
- `start` (production) — template di-cache, **wajib restart** setelah perubahan. Untuk sementara bisa dilonggarkan:
  ```
  --spi-theme-cache-themes=false --spi-theme-cache-templates=false
  ```

### Verifikasi sebelum restart

```
# harus hanya menyisakan "Only in ...: README.md"
diff -rq "D:/PROJECT/Keycloak/Themes-Base" "D:/PROJECT/keycloak-26.4.7/themes"
```

---

## 5. Mengubah flow atau halaman

**Edit langsung di `gs-base\login\`, satu tempat saja. Semua theme ikut berubah.**

```
1. edit    Themes-Base\gs-base\login\<file>.ftl
2. sync    robocopy ... /MIR /XF README.md
3. restart Keycloak (kecuali start-dev)
```

### Aturan 1 — jangan copy `.ftl` ke theme turunan

Theme turunan menang atas induk. Satu file `.ftl` yatim di `gssmart-theme\login\` akan membekukan versi lama untuk theme itu selamanya, dan tidak akan pernah ikut perbaikan di `gs-base`.

Pengecualian sah hanya satu: portal yang butuh **layout berbeda**, bukan sekadar warna berbeda — misalnya form login tanpa pilihan Plant. Baru saat itu copy **hanya file yang bersangkutan** ke folder theme tersebut, dengan konsekuensi file itu jadi tanggung jawab sendiri dan lepas dari `gs-base`. Sebelum copy, cek dulu apakah kebutuhannya bisa diselesaikan dengan menambah property baru.

### Aturan 2 — warna baru lewat CSS variable, bukan hex

Saat menambah elemen berwarna brand di `.ftl` mana pun:

```html
<!-- BENAR -->
<a href="#" style="color: var(--gs-primary);">Lupa password?</a>

<!-- SALAH — theme lain akan tetap merah -->
<a href="#" style="color: #ED3237;">Lupa password?</a>
```

Variabel yang tersedia di semua halaman: `--gs-primary`, `--gs-primary-hover`, `--gs-primary-active`, `--gs-primary-rgb`, `--gs-cover-bg`. Semuanya di-inject di `:root` oleh `template.ftl`.

### Aturan 3 — teks brand dan batas namespace

Di **dalam** macro `registrationLayout` (yaitu di `template.ftl`) pakai variabel yang sudah di-assign:

```
${appName}   ${companyName}   ${appVersion}
```

Di **file halaman** seperti `login.ftl`, variabel itu tidak terlihat karena beda namespace FreeMarker. Baca langsung dari properties:

```
${properties.gsAppName!'GS Portal'}
```

Ini alasan kenapa dulu `<#if pageTitle?? && ...>` di `template.ftl` selalu bernilai salah: `pageTitle` di-assign di namespace `login.ftl`, tidak terlihat dari dalam macro. Sekarang kondisi itu memakai parameter macro `title`.

### Aturan 4 — jangan pakai `${...}` di dalam tag FreeMarker

```
<#-- SALAH — Internal Server Error, syntax error saat parse -->
<#assign appName = ${properties.gsAppName!'GS Portal'}>

<#-- BENAR — di dalam tag sudah mode ekspresi -->
<#assign appName = properties.gsAppName!'GS Portal'>
```

`${...}` hanya untuk mencetak nilai di antara HTML, atau di dalam string literal. Di dalam `<#assign>`, `<#if>`, `<#list>` dan sejenisnya, tulis ekspresinya langsung.

### Menambah property baru

1. Beri nilai default di `gs-base\login\theme.properties`.
2. Assign di awal macro `registrationLayout` di `template.ftl` **dengan operator default `!`**:
   ```
   <#assign namaBaru = properties.gsNamaBaru!'nilai default'>
   ```
   Operator `!` wajib. Tanpa itu, theme turunan yang belum mengisi property tersebut akan error.
3. Pakai `${namaBaru}` di template, atau tambahkan sebagai CSS variable di blok `:root` kalau berupa warna.
4. Timpa nilainya di theme turunan yang butuh berbeda.

---

## 6. Troubleshooting

| Gejala | Penyebab tersering |
|---|---|
| **Internal Server Error** dengan Error id | Cek log server untuk pesan aslinya — browser tidak menampilkan detail. Biasanya syntax error FreeMarker. |
| Log bilang syntax error di baris yang **sudah diperbaiki** | Deploy masih memegang file lama. Jalankan `robocopy /MIR`, lalu restart. |
| `You can't use ${...} here as you are already in FreeMarker-expression-mode` | `${...}` dipakai di dalam tag FreeMarker. Lihat Aturan 4. |
| `Failed at: #import "template.ftl"` | `template.ftl` gagal di-parse, atau tidak ditemukan karena `parent=` tidak terbaca. Pastikan `theme.properties` ada di dalam `login\`. |
| Theme tidak muncul di dropdown Admin Console | Folder `login\` atau `theme.properties` di dalamnya belum ada. |
| Warna dan nama tidak berubah, tetap merah "GS SMART" | Ada `.ftl` yatim di folder theme turunan yang menimpa induk. Hapus, lalu `robocopy /MIR`. |
| Perubahan `.ftl` tidak muncul | Cache template. Restart, atau pakai `start-dev`. |
| Aset 404 | Path di property harus relatif ke `login\resources\assets\`, tanpa slash di depan. |
| Warna berubah tapi focus ring tombol salah warna | `gsPrimaryColorRgb` belum disesuaikan dengan `gsPrimaryColor`. |

---

## 7. Catatan pemeliharaan

**File sisa yang belum dibersihkan** di `gs-base\login\`:

- `login-copy.ftl`
- `mfa-rfid copy.ftl`

Keduanya duplikat lama, masih menghardcode `GS SMART` dan `#ED3237`, dan tidak dipakai halaman mana pun. Nama dengan spasi juga rawan bermasalah kalau theme suatu saat dipaket jadi JAR. Aman untuk dihapus setelah dipastikan tidak ada yang merujuknya.

**`styles=` di `theme.properties`.** Baris `styles=css/style.css` sudah dihapus karena file tersebut tidak pernah ada dan hanya menghasilkan request 404. Kalau nanti mau menambah stylesheet sendiri, buat file di `login\resources\css\` lalu daftarkan kembali.
