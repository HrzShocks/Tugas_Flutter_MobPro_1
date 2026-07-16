# UI Screens

## 1. Splash Screen

### Komponen

- Icon buku atau assignment.
- Nama aplikasi: TugasKu.
- Slogan: Atur tugas rumahmu dengan mudah.
- Loading indicator sederhana.

### Navigasi

Setelah 2 detik, arahkan user ke Login Screen.

---

## 2. Login Screen

### Komponen

- Judul: Masuk.
- Subtitle singkat.
- TextField username.
- TextField password.
- Dropdown/Pilihan Role (Dosen / Mahasiswa).
- Button Login.
- Text: Belum punya akun? Daftar.

### Referensi Visual (Mockup)

![Mockup Login Screen](/home/haris/.gemini/antigravity/brain/a0196028-515d-476c-8a54-c03f226e2b7d/login_screen_mockup_1782203709648.png)
*Tampilan login yang user-friendly dengan Segmented Control untuk memilih role Dosen atau Mahasiswa.*

### Behavior

Button Login mengarah ke Main Screen tanpa validasi database, menampilkan simulasi dashboard sesuai role yang dipilih.

---

## 3. Dashboard Screen

### Komponen

- Sapaan pengguna: Halo, [Nama User] (Menyesuaikan Role).
- Subtitle: Siap menyelesaikan tugas hari ini? (Jika Mahasiswa) atau Siap memantau tugas mahasiswa? (Jika Dosen).
- Summary card:
  - Total Tugas.
  - Belum Selesai.
  - Selesai.
- Section Deadline Terdekat.
- List tugas prioritas.

### Referensi Visual (Mockup)

![Mockup Dashboard Screen](/home/haris/.gemini/antigravity/brain/a0196028-515d-476c-8a54-c03f226e2b7d/dashboard_screen_mockup_1782203723459.png)
*Tampilan dashboard yang clean dan modern, dengan summary cards serta daftar tugas kuliah yang mudah dibaca.*

### Data

Gunakan dummy data dari `dummy_data.dart`.

---

## 4. Task List Screen

### Komponen

- AppBar title: Daftar Tugas.
- Search bar dummy.
- Filter chip:
  - Semua.
  - Belum.
  - Proses.
  - Selesai.
- List TaskCard.
- FloatingActionButton untuk membuka Task Form Screen.

### Behavior

- Klik TaskCard membuka Task Detail Screen.
- Klik FloatingActionButton membuka Task Form Screen.

---

## 5. Task Detail Screen

### Komponen

- Judul tugas.
- Mata pelajaran.
- Nama dosen.
- Tanggal diberikan.
- Deadline.
- Status.
- Prioritas.
- Deskripsi tugas.
- Button Edit Tugas.
- Button Tandai Selesai.

### Behavior

Tombol boleh berupa simulasi dan tidak perlu mengubah data permanen.

---

## 6. Task Form Screen

### Komponen

- Input judul tugas.
- Dropdown mata kuliah.
- Input deskripsi.
- Field deadline.
- Dropdown status.
- Dropdown prioritas.
- Button Simpan.

### Behavior

Saat button Simpan ditekan, tampilkan SnackBar:

```text
Data tugas berhasil disimpan (simulasi)
```

---

## 7. Subject Screen

### Komponen

Tampilkan daftar mata kuliah dalam bentuk card.

Contoh data:

- Analisis & Desain Sistem, Dosen: Bu Rina.
- Pemrograman Mobile, Dosen: Pak Andi.
- Komunikasi Data, Dosen: Bu Sari.
- Kalkulus Lanjut II, Dosen: Pak Budi.

---

## 8. History Screen

### Komponen

- Judul: Riwayat Tugas.
- List tugas dengan status Selesai.
- Card tugas selesai.

---

## 9. Profile Screen

### Komponen

- Avatar/icon user.
- Nama: [Nama User].
- Role: Dosen / Mahasiswa.
- Info spesifik role (Misal: NIDN untuk Dosen, NIM/Prodi untuk Mahasiswa).
- Kampus: Universitas Nusantara.
- Statistik total tugas.
- Statistik tugas selesai.
- Statistik tugas belum selesai.
- Button Logout.
