-- ============================================================
-- FULL RESET + SCHEMA + SEED DATA
-- SGA (Student Government Association)
-- Database : Supabase PostgreSQL
-- Generated: 2026-05-09
-- ============================================================


-- ============================================================
-- SECTION 1: DROP ALL TABLES (reverse dependency order)
-- ============================================================
DROP TABLE IF EXISTS "public"."presensi"       CASCADE;
DROP TABLE IF EXISTS "public"."kas_sga"        CASCADE;
DROP TABLE IF EXISTS "public"."pengajuan_dana" CASCADE;
DROP TABLE IF EXISTS "public"."kegiatan"       CASCADE;
DROP TABLE IF EXISTS "public"."proker"         CASCADE;
DROP TABLE IF EXISTS "public"."kepengurusan"   CASCADE;
DROP TABLE IF EXISTS "public"."mahasiswa"      CASCADE;
DROP TABLE IF EXISTS "public"."divisi"         CASCADE;
DROP TABLE IF EXISTS "public"."jabatan"        CASCADE;
DROP TABLE IF EXISTS "public"."periode"        CASCADE;


-- ============================================================
-- SECTION 2: CREATE ALL TABLES (dependency order)
-- ============================================================

-- 1. PERIODE
CREATE TABLE "public"."periode" (
  "id_periode"     INTEGER     GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  "tahun_akademik" VARCHAR(20) NOT NULL
);

-- 2. JABATAN
CREATE TABLE "public"."jabatan" (
  "id_jabatan"   INTEGER      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  "nama_jabatan" VARCHAR(100) NOT NULL
);

-- 3. DIVISI
CREATE TABLE "public"."divisi" (
  "id_divisi"   INTEGER      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  "nama_divisi" VARCHAR(100) NOT NULL
);

-- 4. MAHASISWA
CREATE TABLE "public"."mahasiswa" (
  "id_mahasiswa" INTEGER      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  "nim"          VARCHAR(20)  NOT NULL UNIQUE,
  "nama_lengkap" VARCHAR(100) NOT NULL,
  "jurusan"      VARCHAR(100) NOT NULL,
  "email"        VARCHAR(100) NOT NULL UNIQUE
);

-- 5. KEPENGURUSAN
CREATE TABLE "public"."kepengurusan" (
  "id_pengurus"  INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  "id_mahasiswa" INTEGER NOT NULL REFERENCES "public"."mahasiswa"("id_mahasiswa") ON DELETE CASCADE,
  "id_divisi"    INTEGER NOT NULL REFERENCES "public"."divisi"("id_divisi")       ON DELETE RESTRICT,
  "id_jabatan"   INTEGER NOT NULL REFERENCES "public"."jabatan"("id_jabatan")     ON DELETE RESTRICT,
  "id_periode"   INTEGER NOT NULL REFERENCES "public"."periode"("id_periode")     ON DELETE RESTRICT
);

-- 6. PROKER
CREATE TABLE "public"."proker" (
  "id_proker"   INTEGER      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  "nama_proker" VARCHAR(150) NOT NULL,
  "id_divisi"   INTEGER      NOT NULL REFERENCES "public"."divisi"("id_divisi") ON DELETE RESTRICT
);

-- 7. KEGIATAN
CREATE TABLE "public"."kegiatan" (
  "id_kegiatan"         INTEGER      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  "id_proker"           INTEGER      NOT NULL REFERENCES "public"."proker"("id_proker") ON DELETE CASCADE,
  "nama_kegiatan"       VARCHAR(200) NOT NULL,
  "tanggal_pelaksanaan" DATE         NOT NULL
);

-- 8. PENGAJUAN DANA
CREATE TABLE "public"."pengajuan_dana" (
  "id_pengajuan"       INTEGER        GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  "id_proker"          INTEGER        NOT NULL REFERENCES "public"."proker"("id_proker") ON DELETE RESTRICT,
  "nominal_diajukan"   NUMERIC(15, 2) NOT NULL,
  "status_persetujuan" VARCHAR(20)    NOT NULL DEFAULT 'Pending',
  "tanggal_pengajuan"  DATE           NOT NULL DEFAULT CURRENT_DATE,
  "tanggal_rapat"      DATE,
  "catatan_rapat"      TEXT
);

-- 9. KAS_SGA
CREATE TABLE "public"."kas_sga" (
  "id_transaksi"      INTEGER        GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  "tanggal_transaksi" TIMESTAMP      NOT NULL DEFAULT NOW(),
  "jenis_transaksi"   VARCHAR(20)    NOT NULL CHECK ("jenis_transaksi" IN ('Pemasukan', 'Pengeluaran')),
  "nominal"           NUMERIC(15, 2) NOT NULL,
  "keterangan"        TEXT,
  "id_mahasiswa"      INTEGER        REFERENCES "public"."mahasiswa"("id_mahasiswa")      ON DELETE SET NULL,
  "id_pengajuan"      INTEGER        REFERENCES "public"."pengajuan_dana"("id_pengajuan") ON DELETE SET NULL
);

-- 10. PRESENSI
CREATE TABLE "public"."presensi" (
  "id_presensi"      INTEGER     GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  "id_kegiatan"      INTEGER     NOT NULL REFERENCES "public"."kegiatan"("id_kegiatan")   ON DELETE CASCADE,
  "id_mahasiswa"     INTEGER     NOT NULL REFERENCES "public"."mahasiswa"("id_mahasiswa") ON DELETE CASCADE,
  "status_kehadiran" VARCHAR(10) NOT NULL CHECK ("status_kehadiran" IN ('Hadir', 'Izin', 'Alpa'))
);


-- ============================================================
-- SECTION 3: SEED DATA (dependency order)
-- ============================================================

-- 1. PERIODE
INSERT INTO "public"."periode" ("id_periode", "tahun_akademik")
OVERRIDING SYSTEM VALUE VALUES
  (1, '2025/2026');

-- 2. JABATAN
INSERT INTO "public"."jabatan" ("id_jabatan", "nama_jabatan")
OVERRIDING SYSTEM VALUE VALUES
  (1, 'Ketua SGA'),
  (2, 'Wakil Ketua SGA'),
  (3, 'Secretary'),
  (4, 'Controller'),
  (5, 'BPH'),
  (6, 'Anggota');

-- 3. DIVISI
INSERT INTO "public"."divisi" ("id_divisi", "nama_divisi")
OVERRIDING SYSTEM VALUE VALUES
  (1, 'Pengurus Inti'),
  (2, 'Public Community and Relation'),
  (3, 'Research and Technology'),
  (4, 'Intellectual Career Development'),
  (5, 'Media and Information'),
  (6, 'UKM Development'),
  (7, 'Business & Partnership'),
  (8, 'Student Advocacy and Welfare');

-- 4. MAHASISWA
INSERT INTO "public"."mahasiswa" ("id_mahasiswa", "nim", "nama_lengkap", "jurusan", "email")
OVERRIDING SYSTEM VALUE VALUES
  (1,  '2026001', 'Anggota SGA ke-1',  'Ilmu Komputer',    'sahrul.official@univ.ac.id'),
  (2,  '2026002', 'Anggota SGA ke-2',  'Sistem Informasi', 'user2@univ.ac.id'),
  (3,  '2026003', 'Anggota SGA ke-3',  'Sistem Informasi', 'user3@univ.ac.id'),
  (4,  '2026004', 'Anggota SGA ke-4',  'Sistem Informasi', 'user4@univ.ac.id'),
  (5,  '2026005', 'Anggota SGA ke-5',  'Sistem Informasi', 'user5@univ.ac.id'),
  (6,  '2026006', 'Anggota SGA ke-6',  'Sistem Informasi', 'user6@univ.ac.id'),
  (7,  '2026007', 'Anggota SGA ke-7',  'Sistem Informasi', 'user7@univ.ac.id'),
  (8,  '2026008', 'Anggota SGA ke-8',  'Sistem Informasi', 'user8@univ.ac.id'),
  (9,  '2026009', 'Anggota SGA ke-9',  'Sistem Informasi', 'user9@univ.ac.id'),
  (10, '2026010', 'Anggota SGA ke-10', 'Sistem Informasi', 'user10@univ.ac.id'),
  (11, '2026011', 'Anggota SGA ke-11', 'Sistem Informasi', 'user11@univ.ac.id'),
  (12, '2026012', 'Anggota SGA ke-12', 'Sistem Informasi', 'user12@univ.ac.id'),
  (13, '2026013', 'Anggota SGA ke-13', 'Sistem Informasi', 'user13@univ.ac.id'),
  (14, '2026014', 'Anggota SGA ke-14', 'Sistem Informasi', 'user14@univ.ac.id'),
  (15, '2026015', 'Anggota SGA ke-15', 'Sistem Informasi', 'user15@univ.ac.id'),
  (16, '2026016', 'Anggota SGA ke-16', 'Sistem Informasi', 'user16@univ.ac.id'),
  (17, '2026017', 'Anggota SGA ke-17', 'Sistem Informasi', 'user17@univ.ac.id'),
  (18, '2026018', 'Anggota SGA ke-18', 'Sistem Informasi', 'user18@univ.ac.id'),
  (19, '2026019', 'Anggota SGA ke-19', 'Sistem Informasi', 'user19@univ.ac.id'),
  (20, '2026020', 'Anggota SGA ke-20', 'Sistem Informasi', 'user20@univ.ac.id'),
  (21, '2026021', 'Anggota SGA ke-21', 'Sistem Informasi', 'user21@univ.ac.id'),
  (22, '2026022', 'Anggota SGA ke-22', 'Sistem Informasi', 'user22@univ.ac.id'),
  (23, '2026023', 'Anggota SGA ke-23', 'Sistem Informasi', 'user23@univ.ac.id'),
  (24, '2026024', 'Anggota SGA ke-24', 'Sistem Informasi', 'user24@univ.ac.id'),
  (25, '2026025', 'Anggota SGA ke-25', 'Sistem Informasi', 'user25@univ.ac.id'),
  (26, '2026026', 'Anggota SGA ke-26', 'Sistem Informasi', 'user26@univ.ac.id'),
  (27, '2026027', 'Anggota SGA ke-27', 'Sistem Informasi', 'user27@univ.ac.id'),
  (28, '2026028', 'Anggota SGA ke-28', 'Sistem Informasi', 'user28@univ.ac.id'),
  (29, '2026029', 'Anggota SGA ke-29', 'Sistem Informasi', 'user29@univ.ac.id'),
  (30, '2026030', 'Anggota SGA ke-30', 'Sistem Informasi', 'user30@univ.ac.id'),
  (31, '2026031', 'Anggota SGA ke-31', 'Sistem Informasi', 'user31@univ.ac.id'),
  (32, '2026032', 'Anggota SGA ke-32', 'Sistem Informasi', 'user32@univ.ac.id'),
  (33, '2026033', 'Anggota SGA ke-33', 'Sistem Informasi', 'user33@univ.ac.id'),
  (34, '2026034', 'Anggota SGA ke-34', 'Sistem Informasi', 'user34@univ.ac.id'),
  (35, '2026035', 'Anggota SGA ke-35', 'Sistem Informasi', 'user35@univ.ac.id'),
  (36, '2026036', 'Anggota SGA ke-36', 'Sistem Informasi', 'user36@univ.ac.id'),
  (37, '2026037', 'Anggota SGA ke-37', 'Sistem Informasi', 'user37@univ.ac.id'),
  (38, '2026038', 'Anggota SGA ke-38', 'Sistem Informasi', 'user38@univ.ac.id'),
  (39, '2026039', 'Anggota SGA ke-39', 'Sistem Informasi', 'user39@univ.ac.id'),
  (40, '2026040', 'Anggota SGA ke-40', 'Sistem Informasi', 'user40@univ.ac.id'),
  (41, '2026041', 'Anggota SGA ke-41', 'Sistem Informasi', 'user41@univ.ac.id'),
  (42, '2026042', 'Anggota SGA ke-42', 'Sistem Informasi', 'user42@univ.ac.id'),
  (43, '2026043', 'Anggota SGA ke-43', 'Sistem Informasi', 'user43@univ.ac.id'),
  (44, '2026044', 'Anggota SGA ke-44', 'Sistem Informasi', 'user44@univ.ac.id'),
  (45, '2026045', 'Anggota SGA ke-45', 'Sistem Informasi', 'user45@univ.ac.id'),
  (46, '2026046', 'Anggota SGA ke-46', 'Sistem Informasi', 'user46@univ.ac.id'),
  (47, '2026047', 'Anggota SGA ke-47', 'Sistem Informasi', 'user47@univ.ac.id'),
  (48, '2026048', 'Anggota SGA ke-48', 'Sistem Informasi', 'user48@univ.ac.id'),
  (49, '2026049', 'Anggota SGA ke-49', 'Sistem Informasi', 'user49@univ.ac.id'),
  (50, '2026050', 'Anggota SGA ke-50', 'Sistem Informasi', 'user50@univ.ac.id');

-- 5. KEPENGURUSAN
INSERT INTO "public"."kepengurusan" ("id_pengurus", "id_mahasiswa", "id_divisi", "id_jabatan", "id_periode")
OVERRIDING SYSTEM VALUE VALUES
  (1,  1,  1, 1, 1), (2,  2,  1, 2, 1), (3,  3,  2, 5, 1), (4,  4,  3, 5, 1),
  (5,  5,  4, 6, 1), (6,  6,  4, 6, 1), (7,  7,  5, 6, 1), (8,  8,  3, 6, 1),
  (9,  9,  2, 6, 1), (10, 10, 3, 6, 1), (11, 11, 4, 6, 1), (12, 12, 5, 6, 1),
  (13, 13, 2, 6, 1), (14, 14, 3, 6, 1), (15, 15, 4, 6, 1), (16, 16, 5, 6, 1),
  (17, 17, 2, 6, 1), (18, 18, 3, 6, 1), (19, 19, 4, 6, 1), (20, 20, 5, 6, 1),
  (21, 21, 2, 6, 1), (22, 22, 3, 6, 1), (23, 23, 4, 6, 1), (24, 24, 5, 6, 1),
  (25, 25, 2, 6, 1), (26, 26, 3, 6, 1), (27, 27, 4, 6, 1), (28, 28, 5, 6, 1),
  (29, 29, 2, 6, 1), (30, 30, 3, 6, 1), (31, 31, 4, 6, 1), (32, 32, 5, 6, 1),
  (33, 33, 2, 6, 1), (34, 34, 3, 6, 1), (35, 35, 4, 6, 1), (36, 36, 5, 6, 1),
  (37, 37, 2, 6, 1), (38, 38, 3, 6, 1), (39, 39, 4, 6, 1), (40, 40, 5, 6, 1),
  (41, 41, 2, 6, 1), (42, 42, 3, 6, 1), (43, 43, 4, 6, 1), (44, 44, 5, 6, 1),
  (45, 45, 2, 6, 1), (46, 46, 3, 6, 1), (47, 47, 4, 6, 1), (48, 48, 5, 6, 1),
  (49, 49, 2, 6, 1), (50, 50, 3, 6, 1);

-- 6. PROKER
INSERT INTO "public"."proker" ("id_proker", "nama_proker", "id_divisi")
OVERRIDING SYSTEM VALUE VALUES
  (1, 'SGA Expo',            2),
  (2, 'Tech Workshop',       3),
  (3, 'Career Talk',         4),
  (4, 'UKM Gathering',       6),
  (5, 'Advocacy Day',        8),
  (6, 'Rapat Pengurus Inti', 1);

-- 7. KEGIATAN
INSERT INTO "public"."kegiatan" ("id_kegiatan", "id_proker", "nama_kegiatan", "tanggal_pelaksanaan")
OVERRIDING SYSTEM VALUE VALUES
  (1, 1, 'Opening SGA Expo 2026',          '2026-05-01'),
  (2, 1, 'Closing & Awarding SGA Expo',    '2026-05-03'),
  (3, 2, 'Workshop React & Supabase',      '2026-05-10'),
  (4, 3, 'Seminar Karir di Era AI',        '2026-05-15'),
  (5, 5, 'Sosialisasi Advokasi Mahasiswa', '2026-08-20');

-- 8. PENGAJUAN DANA
INSERT INTO "public"."pengajuan_dana" ("id_pengajuan", "id_proker", "nominal_diajukan", "status_persetujuan", "tanggal_pengajuan", "tanggal_rapat", "catatan_rapat")
OVERRIDING SYSTEM VALUE VALUES
  (1, 1, '5000000.00', 'Disetujui', '2026-04-13', '2026-05-10', 'Disetujui penuh oleh forum BPH'),
  (2, 2, '2000000.00', 'Pending',   '2026-04-13', null, null),
  (3, 3, '1500000.00', 'Disetujui', '2026-04-13', null, null),
  (4, 4, '1000000.00', 'Ditolak',   '2026-04-13', null, null),
  (5, 5, '3000000.00', 'Pending',   '2026-04-13', null, null),
  (6, 1, '4000000.00', 'Pending',   '2026-05-03', null, null);

-- 9. KAS_SGA
INSERT INTO "public"."kas_sga" ("id_transaksi", "tanggal_transaksi", "jenis_transaksi", "nominal", "keterangan", "id_mahasiswa", "id_pengajuan")
OVERRIDING SYSTEM VALUE VALUES
  (1, '2026-05-03 16:22:50.272815', 'Pemasukan',   '5000000.00', 'Iuran bulan Januari',                 1,    null),
  (2, '2026-05-03 16:22:50.272815', 'Pemasukan',   '3000000.00', 'Iuran bulan Februari',                2,    null),
  (3, '2026-05-03 16:22:50.272815', 'Pengeluaran', '4000000.00', 'Pencairan dana proker SGA Tech Fest', null, 1);

-- 10. PRESENSI
INSERT INTO "public"."presensi" ("id_presensi", "id_kegiatan", "id_mahasiswa", "status_kehadiran")
OVERRIDING SYSTEM VALUE VALUES
  (1,  1, 1,  'Hadir'), (2,  2, 2,  'Hadir'), (3,  3, 3,  'Izin'),  (4,  4, 4,  'Hadir'),
  (5,  5, 5,  'Alpa'),  (6,  5, 6,  'Hadir'), (7,  2, 7,  'Hadir'), (8,  3, 8,  'Izin'),
  (9,  4, 9,  'Hadir'), (10, 5, 10, 'Alpa'),  (11, 1, 11, 'Hadir'), (12, 2, 12, 'Hadir'),
  (13, 3, 13, 'Izin'),  (14, 4, 14, 'Hadir'), (15, 5, 15, 'Alpa'),  (16, 1, 16, 'Hadir'),
  (17, 2, 17, 'Hadir'), (18, 3, 18, 'Izin'),  (19, 4, 19, 'Hadir'), (20, 5, 20, 'Alpa'),
  (21, 1, 21, 'Hadir'), (22, 2, 22, 'Hadir'), (23, 3, 23, 'Izin'),  (24, 4, 24, 'Hadir'),
  (25, 5, 25, 'Alpa'),  (26, 1, 26, 'Hadir'), (27, 2, 27, 'Hadir'), (28, 3, 28, 'Izin'),
  (29, 4, 29, 'Hadir'), (30, 5, 30, 'Alpa'),  (31, 1, 31, 'Hadir'), (32, 2, 32, 'Hadir'),
  (33, 3, 33, 'Izin'),  (34, 4, 34, 'Hadir'), (35, 5, 35, 'Alpa'),  (36, 1, 36, 'Hadir'),
  (37, 2, 37, 'Hadir'), (38, 3, 38, 'Izin'),  (39, 4, 39, 'Hadir'), (40, 5, 40, 'Alpa'),
  (41, 1, 41, 'Hadir'), (42, 2, 42, 'Hadir'), (43, 3, 43, 'Izin'),  (44, 4, 44, 'Hadir'),
  (45, 5, 45, 'Alpa'),  (46, 1, 46, 'Hadir'), (47, 2, 47, 'Hadir'), (48, 3, 48, 'Izin'),
  (49, 4, 49, 'Hadir'), (50, 5, 50, 'Alpa');
