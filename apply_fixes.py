import os
import re

MD_DIR = 'manual_book'
LIB_DIR = 'lib'

def replace_terms(text):
    # Only replace outside of code blocks
    lines = text.split('\n')
    new_lines = []
    in_code = False
    for line in lines:
        if line.strip().startswith('```'):
            in_code = not in_code
            new_lines.append(line)
            continue
            
        if not in_code:
            # Match whole words to avoid issues, though simple replace might be enough for Indonesian
            line = re.sub(r'\bDosen\b', 'Guru', line)
            line = re.sub(r'\bdosen\b', 'guru', line)
            line = re.sub(r'\bMahasiswa\b', 'Siswa', line)
            line = re.sub(r'\bmahasiswa\b', 'siswa', line)
            line = re.sub(r'\bMata Kuliah\b', 'Mata Pelajaran', line)
            line = re.sub(r'\bmata kuliah\b', 'mata pelajaran', line)
            line = line.replace('Locations:', 'Lokasi:')
            new_lines.append(line)
        else:
            new_lines.append(line)
            
    return '\n'.join(new_lines)

def replace_code_blocks(text):
    lines = text.split('\n')
    new_lines = []
    i = 0
    while i < len(lines):
        line = lines[i]
        
        # Special case for pubspec.yaml in Part 1
        if "Nama File:** `pubspec.yaml`" in line:
            new_lines.append(line)
            i += 1
            while i < len(lines) and not lines[i].strip().startswith('```yaml'):
                new_lines.append(lines[i])
                i += 1
            if i < len(lines):
                new_lines.append(lines[i]) # ```yaml
                i += 1
                yaml_content = []
                while i < len(lines) and not lines[i].strip() == '```':
                    yaml_content.append(lines[i])
                    i += 1
                
                old_yaml = '\n'.join(yaml_content)
                new_yaml = old_yaml.replace('google_fonts: ^6.2.0\n  intl: ^0.19.0', 'cupertino_icons: ^1.0.8\n  google_fonts: ^6.2.1\n  intl: ^0.19.0')
                new_yaml = new_yaml.replace('- assets/images/logo.png', '- assets/images/')
                new_lines.extend(new_yaml.split('\n'))
                new_lines.append('```')
                i += 1
            continue

        # For theme_manager and main.dart in Part 1 (they share the same location block in the md)
        if "Nama File:** `theme_manager.dart` (Lokasi: `lib/theme/theme_manager.dart`)" in line:
            # We know we need to replace theme_manager and main
            new_lines.append(line)
            i += 1
            while i < len(lines) and not lines[i].strip() == '**theme_manager.dart**':
                new_lines.append(lines[i])
                i += 1
            
            if i < len(lines):
                new_lines.append(lines[i])
                i += 1
                while i < len(lines) and not lines[i].strip().startswith('```dart'):
                    new_lines.append(lines[i])
                    i += 1
                new_lines.append(lines[i])
                i += 1
                # skip old code
                while i < len(lines) and not lines[i].strip() == '```':
                    i += 1
                
                with open('lib/theme/theme_manager.dart', 'r') as f:
                    new_lines.append(f.read().strip())
                new_lines.append('```')
                i += 1
                
                # Next should be main.dart
                while i < len(lines) and not lines[i].strip() == '**main.dart**':
                    new_lines.append(lines[i])
                    i += 1
                
                new_lines.append(lines[i])
                i += 1
                while i < len(lines) and not lines[i].strip().startswith('```dart'):
                    new_lines.append(lines[i])
                    i += 1
                new_lines.append(lines[i])
                i += 1
                # skip old code
                while i < len(lines) and not lines[i].strip() == '```':
                    i += 1
                
                with open('lib/main.dart', 'r') as f:
                    new_lines.append(f.read().strip())
                new_lines.append('```')
                i += 1
            continue
            
        # General case: finding file locations
        match = re.search(r'Lokasi:\*\* `(lib/[^`]+)`', line)
        if not match:
            match = re.search(r'Lokasi: (lib/[^`]+)`', line)
        
        if match:
            filepath = match.group(1)
            new_lines.append(line)
            i += 1
            # advance to code block
            while i < len(lines) and not lines[i].strip().startswith('```dart'):
                new_lines.append(lines[i])
                i += 1
                
            if i < len(lines):
                new_lines.append(lines[i]) # ```dart
                i += 1
                # skip old code
                while i < len(lines) and not lines[i].strip() == '```':
                    i += 1
                
                # insert new code
                try:
                    with open(filepath, 'r') as f:
                        code = f.read().strip()
                        new_lines.append(code)
                except Exception as e:
                    print(f"Error reading {filepath}: {e}")
                    new_lines.append("// GAGAL MEMBACA FILE")
                    
                new_lines.append('```')
                i += 1
            continue
            
        new_lines.append(line)
        i += 1
        
    return '\n'.join(new_lines)

def process_file(filename):
    path = os.path.join(MD_DIR, filename)
    with open(path, 'r') as f:
        content = f.read()
        
    content = replace_terms(content)
    content = replace_code_blocks(content)
    
    with open(path, 'w') as f:
        f.write(content)
    print(f"Processed {filename}")

for filename in os.listdir(MD_DIR):
    if filename.endswith('.md'):
        process_file(filename)

# Add new chapters to Part 1
part1_path = os.path.join(MD_DIR, 'Part_1_Pondasi_dan_Widget.md')
with open(part1_path, 'r') as f:
    content = f.read()

# Find position before Bab 3
bab3_pos = content.find('## Bab 3: Konfigurasi Tema (ThemeManager)')
if bab3_pos != -1:
    # Read new files
    with open('lib/models/task_model.dart', 'r') as f:
        model_code = f.read().strip()
    with open('lib/data/dummy_data.dart', 'r') as f:
        dummy_code = f.read().strip()
    with open('lib/utils/status_helpers.dart', 'r') as f:
        helper_code = f.read().strip()
        
    new_chapters = f"""
## Bab 2.1: Model Data Aplikasi

Class-class model yang mendefinisikan struktur data tugas, komentar, dan mata pelajaran untuk seluruh aplikasi.

### 1. Penjelasan Komponen
Berisi tiga class utama: `CommentModel` untuk data komentar diskusi, `TaskModel` untuk data tugas lengkap beserta status dan deadline, dan `SubjectModel` untuk data mata pelajaran.

### 2. Lokasi File
- **Nama File:** `task_model.dart`
- **Lokasi:** `lib/models/task_model.dart`

### 3. Kode Sumber
```dart
{model_code}
```

---

## Bab 2.2: Data Dummy Aplikasi

File ini menyediakan data contoh (dummy) yang digunakan sebagai pengganti database untuk simulasi seluruh tampilan aplikasi.

### 1. Penjelasan Komponen
Berisi daftar mata pelajaran (`dummySubjects`), daftar tugas (`dummyTasks`) dengan berbagai status dan prioritas, profil pengguna siswa dan guru (`dummyStudentProfile`, `dummyTeacherProfile`), serta daftar siswa dummy (`dummyStudents`).

### 2. Lokasi File
- **Nama File:** `dummy_data.dart`
- **Lokasi:** `lib/data/dummy_data.dart`

### 3. Kode Sumber
```dart
{dummy_code}
```

---

## Bab 2.3: Helper Warna Status & Prioritas

Class utilitas yang menyediakan fungsi-fungsi helper untuk menentukan warna berdasarkan status tugas, tingkat prioritas, serta pengecekan keterlambatan deadline.

### 1. Penjelasan Komponen
Berisi method statis untuk mendapatkan warna prioritas (`getPriorityColor`), warna status (`getStatusColor`), label status yang ditampilkan berdasarkan role (`getDisplayStatus`), dan fungsi cek keterlambatan (`isLate`).

### 2. Lokasi File
- **Nama File:** `status_helpers.dart`
- **Lokasi:** `lib/utils/status_helpers.dart`

### 3. Kode Sumber
```dart
{helper_code}
```

---

"""
    if "Bab 2.1: Model Data Aplikasi" not in content:
        content = content[:bab3_pos] + new_chapters + content[bab3_pos:]
        with open(part1_path, 'w') as f:
            f.write(content)
        print("Added new chapters to Part 1")
