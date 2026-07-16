# Tasks

Kerjakan secara bertahap. Jangan membuat fitur di luar scope.

## Task 1 - Setup Project Structure

Buat struktur folder:

- data.
- models.
- screens.
- widgets.
- utils.

Buat file:

- `app_colors.dart`.
- `task_model.dart`.
- `dummy_data.dart`.

Jangan buat database.

---

## Task 2 - Create Theme and App Entry

Edit `main.dart`:

- Gunakan `MaterialApp`.
- Hilangkan debug banner.
- Set theme warna biru.
- Initial screen: `SplashScreen`.

---

## Task 3 - Create Splash Screen

Buat `SplashScreen`:

- Tampilkan icon buku atau assignment.
- Tampilkan nama aplikasi `TugasKu`.
- Tampilkan slogan `Atur tugas rumahmu dengan mudah`.
- Setelah 2 detik arahkan ke `LoginScreen`.

---

## Task 4 - Create Login Screen

Buat `LoginScreen`:

- TextField username.
- TextField password.
- Dropdown/Pilihan Role (Dosen / Mahasiswa).
- Button Login.
- Ketika tombol ditekan, simpan role sementara dan arahkan ke `MainScreen`.
- Tidak perlu validasi database.

---

## Task 5 - Create Main Screen with Bottom Navigation

Buat `MainScreen` dengan `BottomNavigationBar` berisi 5 menu:

1. Dashboard.
2. Tugas.
3. Matkul.
4. Riwayat.
5. Profil.

---

## Task 6 - Create Dashboard Screen

Buat `DashboardScreen`:

- Sapaan pengguna menyesuaikan role (Dosen/Mahasiswa).
- SummaryCard total tugas.
- SummaryCard tugas belum selesai.
- SummaryCard tugas selesai.
- Section deadline terdekat.
- Gunakan dummy data.

---

## Task 7 - Create Task List Screen

Buat `TaskListScreen`:

- Search bar dummy.
- Filter chip dummy.
- List `TaskCard`.
- FloatingActionButton menuju `TaskFormScreen`.
- Klik `TaskCard` menuju `TaskDetailScreen`.

---

## Task 8 - Create Task Detail Screen

Buat `TaskDetailScreen`:

- Tampilkan semua detail tugas.
- Button Edit Tugas.
- Button Tandai Selesai.
- Tombol boleh belum mengubah data permanen.

---

## Task 9 - Create Task Form Screen

Buat `TaskFormScreen`:

- Form input tugas.
- Dropdown mata kuliah.
- Dropdown status.
- Dropdown prioritas.
- Button Simpan.
- Saat klik simpan tampilkan SnackBar simulasi.

Pesan SnackBar:

```text
Data tugas berhasil disimpan (simulasi)
```

---

## Task 10 - Create Subject, History, and Profile Screen

Buat:

- `SubjectScreen`.
- `HistoryScreen`.
- `ProfileScreen`.

Gunakan dummy data.

---

## Task 11 - UI Finishing

Rapikan:

- Padding.
- Card radius.
- Spacing.
- Icon.
- Warna status.
- Warna prioritas.
- Konsistensi font.

---

## Task 12 - Final Check

Pastikan:

- Aplikasi bisa berjalan.
- Tidak ada error import.
- Semua halaman bisa dibuka.
- Bottom navigation berfungsi.
- Task card bisa membuka detail.
- FloatingActionButton bisa membuka form.
- Tombol simpan menampilkan SnackBar.
