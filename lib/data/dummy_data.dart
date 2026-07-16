import '../models/task_model.dart';

final List<SubjectModel> dummySubjects = [
  SubjectModel(name: 'Matematika', teacher: 'Fuad, S.Pd.', code: 'x7qz9b', className: 'X MIPA 1', createdBy: 'Fuad, S.Pd.', major: 'MIPA'),
  SubjectModel(name: 'Fisika', teacher: 'Andi, S.Pd.', code: 'm4k2lp', className: 'XI MIPA 2', createdBy: 'Andi, S.Pd.', major: 'MIPA'),
  SubjectModel(name: 'Biologi', teacher: 'Sari, S.Pd., M.Si.', code: 'z8xw1q', className: 'XII IPS 1', createdBy: 'Sari, S.Pd., M.Si.', major: 'IPS'),
  SubjectModel(name: 'Kimia', teacher: 'Budi, S.Pd.', code: 'p3rt5n', className: 'X MIPA 1', createdBy: 'Budi, S.Pd.', major: 'MIPA'),
  SubjectModel(name: 'Bahasa Inggris', teacher: 'Clara, S.Pd.', code: 'c9v2b1', className: 'X Bahasa 1', createdBy: 'Clara, S.Pd.', major: 'Bahasa'),
  SubjectModel(name: 'Sejarah', teacher: 'Fuad, S.Pd.', code: 'a1b2c3', className: 'X MIPA 1', createdBy: 'Fuad, S.Pd.', major: 'MIPA'),
  SubjectModel(name: 'Sejarah', teacher: 'Fuad, S.Pd.', code: 'd4e5f6', className: 'X Bahasa 1', createdBy: 'Fuad, S.Pd.', major: 'MIPA'),
];

final List<TaskModel> dummyTasks = [
  TaskModel(
    title: 'Tugas Aljabar',
    subject: 'Matematika',
    className: 'X MIPA 1',
    teacher: 'Fuad, S.Pd.',
    description: 'Kerjakan soal aljabar halaman 10-15.',
    givenDate: '03 Juni 2026',
    deadline: '05 Juni 2026',
    status: 'Belum Dikerjakan',
    priority: 'Tinggi',
    comments: [
      CommentModel(
        author: 'Andi (Siswa)',
        role: 'Siswa',
        text: 'Bu, untuk tugas aljabar apakah perlu menggunakan cara penyelesaian?',
        timestamp: '10:30',
      ),
      CommentModel(
        author: 'Fuad, S.Pd.',
        role: 'Guru',
        text: 'Ya, ya, cara penyelesaian wajib disertakan untuk semua soal.',
        timestamp: '11:15',
      ),
    ],
  ),
  TaskModel(
    title: 'Praktikum Gerak Lurus',
    subject: 'Fisika',
    className: 'XI MIPA 2',
    teacher: 'Andi, S.Pd.',
    description: 'Buat laporan hasil praktikum gerak lurus beraturan.',
    givenDate: '03 Juni 2026',
    deadline: '07 Juni 2026',
    status: 'Belum Dikerjakan',
    priority: 'Sedang',
    comments: [
      CommentModel(
        author: 'Budi (Siswa)',
        role: 'Siswa',
        text: 'Pak, boleh pakai kertas folio bergaris?',
        timestamp: '14:20',
      ),
    ],
  ),
  TaskModel(
    title: 'Praktikum Biologi',
    subject: 'Biologi',
    className: 'XII IPS 1',
    teacher: 'Sari, S.Pd., M.Si.',
    description: 'Lakukan pembedahan pada katak dan catat anatominya.',
    givenDate: '02 Juni 2026',
    deadline: '06 Juni 2026',
    status: 'Selesai',
    priority: 'Tinggi',
    submissionLink: 'https://github.com/haris/cisco-packet-tracer',
    submittedDate: '05 Juni 2026, 14:30 WIB',
    grade: '95',
    feedback: 'Laporan praktikum sangat rapi, pertahankan!',
  ),
  TaskModel(
    title: 'Tugas Reaksi Kimia',
    subject: 'Kimia',
    className: 'X MIPA 1',
    teacher: 'Budi, S.Pd.',
    description: 'Setarakan 10 persamaan reaksi reduksi oksidasi.',
    givenDate: '01 Juni 2026',
    deadline: '04 Juni 2026',
    status: 'Belum Dikerjakan',
    priority: 'Sedang',
  ),
  TaskModel(
    title: 'Essay Narrative Text',
    subject: 'Bahasa Inggris',
    className: 'X Bahasa 1',
    teacher: 'Clara, S.Pd.',
    description: 'Write a 500-word essay using narrative text structure.',
    givenDate: '03 Juni 2026',
    deadline: '08 Juni 2026',
    status: 'Selesai',
    priority: 'Rendah',
    submittedDate: '07 Juni 2026, 09:15 WIB',
  ),
  TaskModel(
    title: 'Tugas Susulan Aljabar',
    subject: 'Matematika',
    className: 'X MIPA 1',
    teacher: 'Fuad, S.Pd.',
    description: 'Bagi siswa yang belum mengumpulkan tugas aljabar, silakan kumpulkan di sini.',
    givenDate: '01 Januari 2026',
    deadline: '02 Januari 2026',
    status: 'Belum Dikerjakan',
    priority: 'Sedang',
  ),
  TaskModel(
    title: 'Kuis 1: Sistem Persamaan Linear',
    subject: 'Matematika',
    className: 'X MIPA 1',
    teacher: 'Fuad, S.Pd.',
    description: 'Kuis pilihan ganda mengenai sistem persamaan linear dua variabel.',
    givenDate: '10 Februari 2026',
    deadline: '12 Februari 2026',
    status: 'Selesai',
    priority: 'Tinggi',
    submittedDate: '11 Februari 2026, 10:00 WIB',
  ),
  TaskModel(
    title: 'Tugas Sejarah Kemerdekaan',
    subject: 'Sejarah',
    className: 'X MIPA 1',
    teacher: 'Fuad, S.Pd.',
    description: 'Buat makalah tentang peristiwa proklamasi kemerdekaan untuk kelas X MIPA 1.',
    givenDate: '10 Juni 2026',
    deadline: '15 Juni 2026',
    status: 'Belum Dikerjakan',
    priority: 'Tinggi',
  ),
  TaskModel(
    title: 'Tugas Kerajaan Hindu-Buddha',
    subject: 'Sejarah',
    className: 'X Bahasa 1',
    teacher: 'Fuad, S.Pd.',
    description: 'Buat peta konsep mengenai persebaran kerajaan Hindu-Buddha di Indonesia.',
    givenDate: '10 Juni 2026',
    deadline: '17 Juni 2026',
    status: 'Belum Dikerjakan',
    priority: 'Sedang',
  ),
];

class UserProfile {
  String name;
  String? degree;
  String id;
  String university;
  String? major;
  
  UserProfile({
    required this.name,
    this.degree,
    required this.id,
    required this.university,
    this.major,
  });

  String get fullName => degree != null && degree!.isNotEmpty ? '$name, $degree' : name;
}

final UserProfile dummyStudentProfile = UserProfile(
  name: 'Haris',
  id: 'NISN: 0041234567',
  university: 'SMA Negeri 1 Jakarta',
  major: 'MIPA',
);

final UserProfile dummyTeacherProfile = UserProfile(
  name: 'Fuad',
  degree: 'S.Pd.',
  id: 'NIP: 198001012005012001',
  university: 'SMA Negeri 1 Jakarta',
  major: 'Matematika',
);

final List<UserProfile> dummyStudents = [
  UserProfile(name: 'Haris', id: 'NISN: 0041234567', university: 'SMA Negeri 1 Jakarta', major: 'MIPA'),
  UserProfile(name: 'Budi Santoso', id: 'NISN: 0041234568', university: 'SMA Negeri 1 Jakarta', major: 'MIPA'),
  UserProfile(name: 'Siti Aminah', id: 'NISN: 0041234569', university: 'SMA Negeri 1 Jakarta', major: 'MIPA'),
  UserProfile(name: 'Andi Saputra', id: 'NISN: 0041234570', university: 'SMA Negeri 1 Jakarta', major: 'MIPA'),
  UserProfile(name: 'Dewi Lestari', id: 'NISN: 0041234571', university: 'SMA Negeri 1 Jakarta', major: 'MIPA'),
];
