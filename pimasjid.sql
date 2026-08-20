-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Jan 22, 2026 at 03:51 PM
-- Server version: 11.8.3-MariaDB-log
-- PHP Version: 7.2.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `u171288397_pimasjid`
--

-- --------------------------------------------------------

--
-- Table structure for table `agendas`
--

CREATE TABLE `agendas` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `date` date NOT NULL,
  `time` time NOT NULL,
  `location` varchar(255) NOT NULL DEFAULT 'Masjid Utama',
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `agendas`
--

INSERT INTO `agendas` (`id`, `title`, `slug`, `description`, `date`, `time`, `location`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'Kajian Subuh Rutin', 'kajian-subuh-rutin-Tugfi0', 'Kajian subuh setiap hari dengan tema tafsir Al-Quran', '2026-01-23', '05:00:00', 'Masjid Utama', 1, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(2, 'Pengajian Ahad Pagi', 'pengajian-ahad-pagi-ojsO3w', 'Pengajian rutin setiap hari Ahad pagi', '2026-01-25', '07:00:00', 'Aula Masjid', 1, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(3, 'Kajian Rabu Malam', 'kajian-rabu-malam-QFeRNq', 'Kajian rutin malam Rabu dengan Ustadz Ahmad', '2026-01-28', '19:30:00', 'Masjid Utama', 1, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(4, 'Tarawih Ramadhan', 'tarawih-ramadhan-Zn8Ybu', 'Sholat tarawih berjamaah setiap malam di bulan Ramadhan', '2026-02-15', '20:00:00', 'Masjid Utama', 1, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(5, 'Buka Puasa Bersama', 'buka-puasa-bersama-yVZhEG', 'Buka puasa bersama jamaah dan anak yatim', '2026-02-20', '18:00:00', 'Halaman Masjid', 1, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(6, 'Kelas Tahsin Al-Quran', 'kelas-tahsin-al-quran-jOlmAU', 'Kelas perbaikan bacaan Al-Quran untuk jamaah', '2026-01-27', '16:00:00', 'Ruang Kelas', 1, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(7, 'Halaqah Hafalan Juz Amma', 'halaqah-hafalan-juz-amma-8V6wL6', 'Program tahfidz juz amma untuk anak-anak', '2026-01-25', '15:30:00', 'Aula Masjid', 1, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(8, 'Peringatan Maulid Nabi', 'peringatan-maulid-nabi-sq4pwL', 'Peringatan maulid Nabi Muhammad SAW', '2025-12-15', '19:00:00', 'Masjid Utama', 0, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(9, 'Santunan Anak Yatim', 'santunan-anak-yatim-hUtj5R', 'Pemberian santunan kepada anak yatim', '2025-11-20', '09:00:00', 'Aula Masjid', 0, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(10, 'Bakti Sosial Ramadhan', 'bakti-sosial-ramadhan-4OO2ri', 'Pembagian sembako untuk warga kurang mampu', '2025-09-25', '10:00:00', 'Halaman Masjid', 0, '2026-01-22 08:26:13', '2026-01-22 08:26:13');

-- --------------------------------------------------------

--
-- Table structure for table `assets`
--

CREATE TABLE `assets` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `condition` enum('good','damaged','lost') NOT NULL DEFAULT 'good',
  `quantity` int(11) NOT NULL DEFAULT 1,
  `purchase_date` date DEFAULT NULL,
  `purchase_price` decimal(15,2) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `assets`
--

INSERT INTO `assets` (`id`, `name`, `condition`, `quantity`, `purchase_date`, `purchase_price`, `notes`, `created_at`, `updated_at`) VALUES
(1, 'Kulkas Masjid Vision', 'good', 1, '2026-01-22', 1000000.00, 'infaq', '2026-01-22 08:36:46', '2026-01-22 13:41:33');

-- --------------------------------------------------------

--
-- Table structure for table `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cache`
--

INSERT INTO `cache` (`key`, `value`, `expiration`) VALUES
('laravel_cache_dashboard.category_breakdown.expense', 'a:2:{s:6:\"labels\";a:3:{i:0;s:8:\"Utilitas\";i:1;s:8:\"Konsumsi\";i:2;s:11:\"Operasional\";}s:7:\"amounts\";a:3:{i:0;d:980000;i:1;d:850000;i:2;d:600000;}}', 1769088641),
('laravel_cache_dashboard.category_breakdown.income', 'a:2:{s:6:\"labels\";a:3:{i:0;s:6:\"Donasi\";i:1;s:5:\"Infaq\";i:2;s:11:\"Kotak Jumat\";}s:7:\"amounts\";a:3:{i:0;d:18500000;i:1;d:12700000;i:2;d:1750000;}}', 1769088993),
('laravel_cache_dashboard.monthly_trends.12', 'a:3:{s:6:\"labels\";a:12:{i:0;s:8:\"Feb 2025\";i:1;s:8:\"Mar 2025\";i:2;s:8:\"Apr 2025\";i:3;s:8:\"May 2025\";i:4;s:8:\"Jun 2025\";i:5;s:8:\"Jul 2025\";i:6;s:8:\"Aug 2025\";i:7;s:8:\"Sep 2025\";i:8;s:8:\"Oct 2025\";i:9;s:8:\"Nov 2025\";i:10;s:8:\"Dec 2025\";i:11;s:8:\"Jan 2026\";}s:6:\"income\";a:12:{i:0;d:0;i:1;d:0;i:2;d:0;i:3;d:0;i:4;d:0;i:5;d:0;i:6;d:6700000;i:7;d:24250000;i:8;d:12300000;i:9;d:5850000;i:10;d:10650000;i:11;d:32950000;}s:7:\"expense\";a:12:{i:0;d:0;i:1;d:0;i:2;d:0;i:3;d:0;i:4;d:0;i:5;d:0;i:6;d:1350000;i:7;d:1670000;i:8;d:1530000;i:9;d:2600000;i:10;d:6600000;i:11;d:2430000;}}', 1769089246),
('laravel_cache_dashboard.monthly_trends.6', 'a:3:{s:6:\"labels\";a:6:{i:0;s:8:\"Aug 2025\";i:1;s:8:\"Sep 2025\";i:2;s:8:\"Oct 2025\";i:3;s:8:\"Nov 2025\";i:4;s:8:\"Dec 2025\";i:5;s:8:\"Jan 2026\";}s:6:\"income\";a:6:{i:0;d:6700000;i:1;d:24250000;i:2;d:12300000;i:3;d:5850000;i:4;d:10650000;i:5;d:32950000;}s:7:\"expense\";a:6:{i:0;d:1350000;i:1;d:1670000;i:2;d:1530000;i:3;d:2600000;i:4;d:6600000;i:5;d:2430000;}}', 1769088993),
('laravel_cache_dashboard.performance_metrics', 'a:4:{s:6:\"labels\";a:7:{i:0;s:3:\"Fri\";i:1;s:3:\"Sat\";i:2;s:3:\"Sun\";i:3;s:3:\"Mon\";i:4;s:3:\"Tue\";i:5;s:3:\"Wed\";i:6;s:3:\"Thu\";}s:12:\"responseTime\";a:7:{i:0;i:0;i:1;i:0;i:2;i:0;i:3;i:0;i:4;i:0;i:5;i:0;i:6;d:184.9;}s:11:\"memoryUsage\";a:7:{i:0;i:0;i:1;i:0;i:2;i:0;i:3;i:0;i:4;i:0;i:5;i:0;i:6;d:27.88;}s:10:\"queryCount\";a:7:{i:0;i:0;i:1;i:0;i:2;i:0;i:3;i:0;i:4;i:0;i:5;i:0;i:6;d:6.07;}}', 1769089246),
('laravel_cache_global_favicon', 's:62:\"/storage/settings/LaQehSZ0MzzU89TOYzK5ILOYIih76UerUg5PIRWd.png\";', 1769091072),
('laravel_cache_global_settings', 'O:29:\"Illuminate\\Support\\Collection\":2:{s:8:\"\0*\0items\";a:30:{s:9:\"site_name\";s:12:\"pimasjid\";s:9:\"logo_path\";s:62:\"/storage/settings/XumoV2iW799vhP0rmBd7Rloc3J9thkcwwjE27eb1.png\";s:13:\"chairman_name\";s:18:\"H. Fulan Bin Fulan\";s:14:\"treasurer_name\";s:11:\"Hj. Fulanah\";s:10:\"hero_title\";s:28:\"Pusat Ibadah & Kegiatan Umat\";s:13:\"hero_subtitle\";s:49:\"pimasjid, Jl. Contoh No. 123, Jakarta Selatan\";s:13:\"hero_bg_image\";s:93:\"https://images.unsplash.com/photo-1519817650390-64a93db51149?q=80&w=2000&auto=format&fit=crop\";s:7:\"address\";s:54:\"Jl. Contoh No. 123, Jakarta Selatan, DKI Jakarta 12345\";s:5:\"email\";s:24:\"info@masjidalhidayah.com\";s:5:\"phone\";s:17:\"+62 823 4671 9219\";s:8:\"whatsapp\";s:13:\"6281234567890\";s:14:\"maps_embed_url\";s:254:\"https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d126907.08660340324!2d106.726588!3d-6.284028!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x2e69f0322ba7b2c7%3A0x6e6e28ce073c1d0!2sMasjid%20Istiqlal!5e0!3m2!1sid!2sid!4v1705739000000!5m2!1sid!2sid\";s:12:\"facebook_url\";s:1:\"#\";s:13:\"instagram_url\";s:1:\"#\";s:11:\"youtube_url\";s:1:\"#\";s:11:\"footer_text\";s:134:\"pimasjid adalah pusat kegiatan ibadah dan sosial kemasyarakatan yang bertujuan membangun peradaban islam yang rahmatan lil alamin.\";s:14:\"copyright_text\";s:42:\"© 2026 pimasjid. All rights reserved.\";s:17:\"location_latitude\";s:9:\"-0.935255\";s:18:\"location_longitude\";s:10:\"100.429244\";s:13:\"location_city\";s:6:\"Padang\";s:17:\"location_timezone\";s:12:\"Asia/Jakarta\";s:12:\"favicon_path\";s:62:\"/storage/settings/LaQehSZ0MzzU89TOYzK5ILOYIih76UerUg5PIRWd.png\";s:16:\"about_hero_title\";s:12:\"Tentang Kami\";s:19:\"about_hero_subtitle\";s:55:\"Sejarah dan visi misi pimasjid dalam melayani umat.\";s:12:\"about_vision\";s:80:\"Menjadi pusat peradaban umat yang mandiri, transparan, dan rahmatan lil \'alamin.\";s:13:\"about_mission\";s:163:\"1. Menyelenggarakan ibadah yang khusyuk dan nyaman.\r\n2. Mengelola dana umat secara transparan dan akuntabel.\r\n3. Memberdayakan ekonomi umat melalui program sosial.\";s:13:\"about_history\";s:312:\"Masjid pimasjid didirikan pada tahun 1990 di atas tanah wakaf seluas 500m2. Seiring berjalannya waktu, masjid ini mengalami renovasi besar pada tahun 2005 untuk menampung jamaah yang semakin banyak. Kini, kami terus berinovasi dengan menerapkan sistem manajemen modern untuk transparansi dan kenyamanan umat.\";s:11:\"about_image\";s:62:\"/storage/settings/BsUYdPEJWefWJc4K13RtypZr4oBXooaxNI294NCe.png\";s:19:\"donation_qris_image\";s:62:\"/storage/settings/ilKqtPm2752fDqjjrK1NcI0XQu1CaF6eprRLU0UL.png\";s:18:\"donation_bank_info\";s:72:\"Bank Syariah Indonesia (BSI)\r\nNo. Rek: 1234599999\r\nA.n Masjid Al-Hidayah\";}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}', 1769094701),
('laravel_cache_prayer_times_-0.945_100.357_2026-01-22', 'a:5:{s:5:\"subuh\";s:5:\"05:03\";s:6:\"dzuhur\";s:5:\"12:30\";s:5:\"ashar\";s:5:\"15:53\";s:7:\"maghrib\";s:5:\"18:35\";s:4:\"isya\";s:5:\"19:48\";}', 1769156971),
('pimasjid_cache_global_favicon', 's:62:\"/storage/settings/LaQehSZ0MzzU89TOYzK5ILOYIih76UerUg5PIRWd.png\";', 1769099526),
('pimasjid_cache_global_settings', 'O:29:\"Illuminate\\Support\\Collection\":2:{s:8:\"\0*\0items\";a:30:{s:9:\"site_name\";s:12:\"pimasjid\";s:9:\"logo_path\";s:62:\"/storage/settings/XumoV2iW799vhP0rmBd7Rloc3J9thkcwwjE27eb1.png\";s:13:\"chairman_name\";s:18:\"H. Fulan Bin Fulan\";s:14:\"treasurer_name\";s:11:\"Hj. Fulanah\";s:10:\"hero_title\";s:28:\"Pusat Ibadah & Kegiatan Umat\";s:13:\"hero_subtitle\";s:49:\"pimasjid, Jl. Contoh No. 123, Jakarta Selatan\";s:13:\"hero_bg_image\";s:93:\"https://images.unsplash.com/photo-1519817650390-64a93db51149?q=80&w=2000&auto=format&fit=crop\";s:7:\"address\";s:54:\"Jl. Contoh No. 123, Jakarta Selatan, DKI Jakarta 12345\";s:5:\"email\";s:24:\"info@masjidalhidayah.com\";s:5:\"phone\";s:17:\"+62 823 4671 9219\";s:8:\"whatsapp\";s:13:\"6281234567890\";s:14:\"maps_embed_url\";s:254:\"https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d126907.08660340324!2d106.726588!3d-6.284028!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x2e69f0322ba7b2c7%3A0x6e6e28ce073c1d0!2sMasjid%20Istiqlal!5e0!3m2!1sid!2sid!4v1705739000000!5m2!1sid!2sid\";s:12:\"facebook_url\";s:1:\"#\";s:13:\"instagram_url\";s:1:\"#\";s:11:\"youtube_url\";s:1:\"#\";s:11:\"footer_text\";s:134:\"pimasjid adalah pusat kegiatan ibadah dan sosial kemasyarakatan yang bertujuan membangun peradaban islam yang rahmatan lil alamin.\";s:14:\"copyright_text\";s:42:\"© 2026 pimasjid. All rights reserved.\";s:17:\"location_latitude\";s:9:\"-0.935255\";s:18:\"location_longitude\";s:10:\"100.429244\";s:13:\"location_city\";s:6:\"Padang\";s:17:\"location_timezone\";s:12:\"Asia/Jakarta\";s:12:\"favicon_path\";s:62:\"/storage/settings/LaQehSZ0MzzU89TOYzK5ILOYIih76UerUg5PIRWd.png\";s:16:\"about_hero_title\";s:12:\"Tentang Kami\";s:19:\"about_hero_subtitle\";s:55:\"Sejarah dan visi misi pimasjid dalam melayani umat.\";s:12:\"about_vision\";s:80:\"Menjadi pusat peradaban umat yang mandiri, transparan, dan rahmatan lil \'alamin.\";s:13:\"about_mission\";s:163:\"1. Menyelenggarakan ibadah yang khusyuk dan nyaman.\r\n2. Mengelola dana umat secara transparan dan akuntabel.\r\n3. Memberdayakan ekonomi umat melalui program sosial.\";s:13:\"about_history\";s:312:\"Masjid pimasjid didirikan pada tahun 1990 di atas tanah wakaf seluas 500m2. Seiring berjalannya waktu, masjid ini mengalami renovasi besar pada tahun 2005 untuk menampung jamaah yang semakin banyak. Kini, kami terus berinovasi dengan menerapkan sistem manajemen modern untuk transparansi dan kenyamanan umat.\";s:11:\"about_image\";s:62:\"/storage/settings/BsUYdPEJWefWJc4K13RtypZr4oBXooaxNI294NCe.png\";s:19:\"donation_qris_image\";s:62:\"/storage/settings/ilKqtPm2752fDqjjrK1NcI0XQu1CaF6eprRLU0UL.png\";s:18:\"donation_bank_info\";s:72:\"Bank Syariah Indonesia (BSI)\r\nNo. Rek: 1234599999\r\nA.n Masjid Al-Hidayah\";}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}', 1769099526),
('pimasjid_cache_prayer_times_-0.938_100.403_2026-01-22', 'a:5:{s:5:\"subuh\";s:5:\"05:03\";s:6:\"dzuhur\";s:5:\"12:30\";s:5:\"ashar\";s:5:\"15:53\";s:7:\"maghrib\";s:5:\"18:35\";s:4:\"isya\";s:5:\"19:48\";}', 1769178850),
('pimasjid_cache_prayer_times_-0.945_100.357_2026-01-22', 'a:5:{s:5:\"subuh\";s:5:\"05:03\";s:6:\"dzuhur\";s:5:\"12:30\";s:5:\"ashar\";s:5:\"15:54\";s:7:\"maghrib\";s:5:\"18:35\";s:4:\"isya\";s:5:\"19:48\";}', 1769178581);

-- --------------------------------------------------------

--
-- Table structure for table `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `committee_members`
--

CREATE TABLE `committee_members` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `position` varchar(255) NOT NULL,
  `division` varchar(255) NOT NULL,
  `photo_path` varchar(255) DEFAULT NULL,
  `order` int(11) NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `committee_members`
--

INSERT INTO `committee_members` (`id`, `name`, `position`, `division`, `photo_path`, `order`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'H. Ahmad Dahlan', 'Ketua DKM', 'Inti', 'committee/9ri1UpOZPpUeUcjtgMHdVFLlwgybfvjht5mAY5lk.png', 1, 1, '2026-01-22 08:26:13', '2026-01-22 11:59:59'),
(2, 'Muhammad Ridwan, S.Pd', 'Sekretaris', 'Inti', 'committee/0hkpicO5QvPmSJ0ytQrTfwSEUqh4B2kcRq9blw60.png', 2, 1, '2026-01-22 08:26:13', '2026-01-22 12:10:42'),
(3, 'Budi Santoso, S.E', 'Bendahara', 'Inti', 'committee/WhtLMBAPqcVL95UavaNKzbZbc7hJFmujpinGQ5vr.png', 3, 1, '2026-01-22 08:26:13', '2026-01-22 12:10:48'),
(4, 'Umar Bakri', 'Kepala Seksi Ibadah', 'Ibadah', 'committee/dq1ZX5pCJqFhruF6gaOnc6BWHnLa6w0deST2WMxe.png', 1, 1, '2026-01-22 08:26:13', '2026-01-22 11:59:12'),
(5, 'Ali Rahman', 'Kepala Seksi Pembangunan', 'Pembangunan', 'committee/OZq723BboeyUbdEtPgk4MVThcmd95O4aXJBcj1zF.png', 1, 1, '2026-01-22 08:26:13', '2026-01-22 12:14:37'),
(6, 'Hasan Abdullah', 'Kepala Seksi Pendidikan', 'Pendidikan', 'committee/UACNJgXcL7BEQfnheqyqUNpRtRtoI9jxYTXcFePk.png', 1, 1, '2026-01-22 08:26:13', '2026-01-22 12:11:01'),
(7, 'Ibrahim Malik', 'Kepala Seksi Sosial', 'Sosial', 'committee/pB0fpj7SjgyTf1TSdfPQKnRifkzas9GvAT4ZI5Pv.png', 1, 1, '2026-01-22 08:26:13', '2026-01-22 12:11:07'),
(8, 'Kang Marbot', 'Marbot', 'Inti', 'committee/4bajGm2Pn73DM42tqBhV8JLDIwERpgz4Ig7QDpHC.png', 4, 1, '2026-01-22 12:16:05', '2026-01-22 12:16:40');

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `friday_schedules`
--

CREATE TABLE `friday_schedules` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `date` date NOT NULL,
  `time` time NOT NULL DEFAULT '12:00:00',
  `khatib` varchar(255) NOT NULL,
  `imam` varchar(255) NOT NULL,
  `muadzin` varchar(255) NOT NULL,
  `bilal` varchar(255) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `friday_schedules`
--

INSERT INTO `friday_schedules` (`id`, `date`, `time`, `khatib`, `imam`, `muadzin`, `bilal`, `title`, `created_at`, `updated_at`) VALUES
(1, '2026-01-23', '12:00:00', 'Ustadz AaAhmad Dahlan, Lc', 'H. MMuhammad Ridwan', 'Sdr. AAli Rahman', 'Sdr. Aliii Rahman', 'Keutamaan Bulan Rajab', '2026-01-22 11:41:56', '2026-01-22 11:47:31');

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2026_01_20_064742_create_prayer_times_table', 1),
(5, '2026_01_20_064744_create_transactions_table', 1),
(6, '2026_01_20_064745_create_slides_table', 1),
(7, '2026_01_20_064747_create_wishlists_table', 1),
(8, '2026_01_20_074421_create_assets_table', 1),
(9, '2026_01_20_080247_create_committee_members_table', 1),
(10, '2026_01_20_091803_create_settings_table', 1),
(11, '2026_01_20_101348_create_personal_access_tokens_table', 1),
(12, '2026_01_20_104429_create_agendas_table', 1),
(13, '2026_01_21_204111_create_zakats_table', 1),
(14, '2026_01_21_204112_create_zakat_distributions_table', 1),
(15, '2026_01_21_204114_create_qurbans_table', 1),
(16, '2026_01_21_204115_create_qurban_distributions_table', 1),
(17, '2026_01_22_134436_create_performance_logs_table', 1),
(18, '2026_01_22_183734_create_friday_schedules_table', 2),
(19, '2026_01_22_184519_add_time_to_friday_schedules_table', 3),
(20, '2026_01_22_193346_create_posts_table', 4);

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `performance_logs`
--

CREATE TABLE `performance_logs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `request_path` varchar(255) NOT NULL,
  `response_time_ms` int(11) NOT NULL,
  `memory_usage_mb` decimal(8,2) NOT NULL,
  `query_count` int(11) NOT NULL DEFAULT 0,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` varchar(500) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `performance_logs`
--

INSERT INTO `performance_logs` (`id`, `request_path`, `response_time_ms`, `memory_usage_mb`, `query_count`, `user_id`, `ip_address`, `user_agent`, `created_at`, `updated_at`) VALUES
(1, 'login', 213, 28.00, 5, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 08:31:13', '2026-01-22 08:31:13'),
(2, 'dashboard', 27, 26.00, 44, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 08:31:13', '2026-01-22 08:31:13'),
(3, 'display', 310, 30.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 08:31:19', '2026-01-22 08:31:19'),
(4, 'display', 140, 30.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 08:31:29', '2026-01-22 08:31:29'),
(5, '/', 1061, 30.00, 4, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 08:31:43', '2026-01-22 08:31:43'),
(6, 'display', 268, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 08:32:30', '2026-01-22 08:32:30'),
(7, 'approvals', 11, 28.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 08:32:39', '2026-01-22 08:32:39'),
(8, 'keuangan', 23, 28.00, 18, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 08:32:45', '2026-01-22 08:32:45'),
(9, 'transactions', 5, 26.00, 0, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 08:32:46', '2026-01-22 08:32:46'),
(10, 'slides', 7, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 08:33:01', '2026-01-22 08:33:01'),
(11, 'display', 795, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 08:33:30', '2026-01-22 08:33:30'),
(12, 'agendas', 12, 26.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 08:33:43', '2026-01-22 08:33:43'),
(13, 'slides', 7, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 08:33:44', '2026-01-22 08:33:44'),
(14, 'settings', 9, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 08:33:47', '2026-01-22 08:33:47'),
(15, 'display', 636, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 08:34:30', '2026-01-22 08:34:30'),
(16, 'settings', 51, 28.00, 45, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 08:35:22', '2026-01-22 08:35:22'),
(17, 'settings', 8, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 08:35:22', '2026-01-22 08:35:22'),
(18, 'display', 212, 30.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 08:35:27', '2026-01-22 08:35:27'),
(19, 'display', 1081, 30.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 08:35:31', '2026-01-22 08:35:31'),
(20, 'slides', 8, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 08:35:46', '2026-01-22 08:35:46'),
(21, 'assets', 7, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 08:36:17', '2026-01-22 08:36:17'),
(22, 'display', 728, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 08:36:32', '2026-01-22 08:36:32'),
(23, 'assets', 14, 28.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 08:36:46', '2026-01-22 08:36:46'),
(24, 'assets', 7, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 08:36:46', '2026-01-22 08:36:46'),
(25, 'transparansi/aset', 7, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 08:36:59', '2026-01-22 08:36:59'),
(26, 'assets/1', 14, 28.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 08:37:17', '2026-01-22 08:37:17'),
(27, 'assets', 7, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 08:37:17', '2026-01-22 08:37:17'),
(28, 'transparansi/aset', 25, 28.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 08:37:30', '2026-01-22 08:37:30'),
(29, 'display', 712, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 08:37:33', '2026-01-22 08:37:33'),
(30, 'transparansi/keuangan', 14, 28.00, 4, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 08:37:34', '2026-01-22 08:37:34'),
(31, 'ibadah/jumat', 112, 28.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 08:37:40', '2026-01-22 08:37:40'),
(32, 'users', 6, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 08:37:46', '2026-01-22 08:37:46'),
(33, 'display', 726, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 08:38:34', '2026-01-22 08:38:34'),
(34, 'dashboard', 34, 28.00, 46, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 08:39:19', '2026-01-22 08:39:19'),
(35, 'display', 467, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 08:39:33', '2026-01-22 08:39:33'),
(36, 'settings', 9, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 08:39:37', '2026-01-22 08:39:37'),
(37, 'settings', 696, 30.00, 43, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 08:40:14', '2026-01-22 08:40:14'),
(38, 'settings', 9, 28.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 08:40:14', '2026-01-22 08:40:14'),
(39, 'ibadah/jumat', 1043, 30.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 08:40:18', '2026-01-22 08:40:18'),
(40, '/', 433, 28.00, 4, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 08:40:22', '2026-01-22 08:40:22'),
(41, 'display', 454, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 08:40:34', '2026-01-22 08:40:34'),
(42, 'transparansi/keuangan', 21, 28.00, 4, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 08:40:48', '2026-01-22 08:40:48'),
(43, 'info/qurban', 5, 26.00, 0, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 08:40:50', '2026-01-22 08:40:50'),
(44, 'display', 1046, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 08:41:35', '2026-01-22 08:41:35'),
(45, 'info/zakat', 6, 26.00, 0, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 08:41:59', '2026-01-22 08:41:59'),
(46, 'display', 445, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 08:42:34', '2026-01-22 08:42:34'),
(47, '/', 1050, 28.00, 4, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 08:43:01', '2026-01-22 08:43:01'),
(48, 'ibadah/jadwal', 267, 28.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 08:43:07', '2026-01-22 08:43:07'),
(49, '/', 444, 28.00, 4, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 08:43:13', '2026-01-22 08:43:13'),
(50, 'ibadah/agenda', 9, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 08:43:23', '2026-01-22 08:43:23'),
(51, 'display', 125, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 08:43:34', '2026-01-22 08:43:34'),
(52, 'transparansi/keuangan', 17, 28.00, 4, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 08:43:40', '2026-01-22 08:43:40'),
(53, 'display', 944, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 08:44:36', '2026-01-22 08:44:36'),
(54, 'display', 993, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 08:45:36', '2026-01-22 08:45:36'),
(55, 'display', 3442, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 08:46:40', '2026-01-22 08:46:40'),
(56, 'login', 686, 28.00, 5, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 10:56:43', '2026-01-22 10:56:43'),
(57, 'dashboard', 154, 28.00, 46, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 10:56:44', '2026-01-22 10:56:44'),
(58, 'login', 207, 28.00, 5, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 10:57:31', '2026-01-22 10:57:31'),
(59, 'dashboard', 14, 26.00, 11, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 10:57:32', '2026-01-22 10:57:32'),
(60, 'approvals', 44, 28.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 10:57:34', '2026-01-22 10:57:34'),
(61, 'keuangan', 146, 28.00, 18, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 10:57:36', '2026-01-22 10:57:36'),
(62, 'approvals', 10, 28.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 10:57:46', '2026-01-22 10:57:46'),
(63, 'keuangan', 22, 28.00, 18, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 10:57:47', '2026-01-22 10:57:47'),
(64, '/', 775, 30.00, 4, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 10:58:06', '2026-01-22 10:58:06'),
(65, 'approvals', 11, 28.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 10:58:37', '2026-01-22 10:58:37'),
(66, 'approvals/24/approve', 25, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 10:58:42', '2026-01-22 10:58:42'),
(67, 'approvals', 10, 28.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 10:58:42', '2026-01-22 10:58:42'),
(68, 'approvals/27/approve', 7, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 10:58:48', '2026-01-22 10:58:48'),
(69, 'approvals', 11, 28.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 10:58:48', '2026-01-22 10:58:48'),
(70, '/', 193, 30.00, 4, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 10:58:50', '2026-01-22 10:58:50'),
(71, 'approvals/30/approve', 7, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 10:58:55', '2026-01-22 10:58:55'),
(72, 'approvals', 10, 28.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 10:58:55', '2026-01-22 10:58:55'),
(73, 'approvals/31/approve', 7, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 10:58:57', '2026-01-22 10:58:57'),
(74, 'approvals', 7, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 10:58:57', '2026-01-22 10:58:57'),
(75, '/', 137, 30.00, 4, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 10:58:59', '2026-01-22 10:58:59'),
(76, 'transparansi/keuangan', 15, 28.00, 5, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 10:59:08', '2026-01-22 10:59:08'),
(77, 'login', 3, 26.00, 0, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 10:59:41', '2026-01-22 10:59:41'),
(78, 'dashboard', 12, 26.00, 11, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 10:59:41', '2026-01-22 10:59:41'),
(79, 'login', 211, 28.00, 5, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:03:14', '2026-01-22 11:03:14'),
(80, 'dashboard', 35, 28.00, 46, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:03:14', '2026-01-22 11:03:14'),
(81, 'settings', 9, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:03:17', '2026-01-22 11:03:17'),
(82, 'keuangan', 22, 28.00, 18, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:05:58', '2026-01-22 11:05:58'),
(83, 'keuangan', 37, 28.00, 18, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:05:59', '2026-01-22 11:05:59'),
(84, '/', 2056, 30.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:06:25', '2026-01-22 11:06:25'),
(85, 'transparansi/keuangan', 17, 28.00, 5, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:06:27', '2026-01-22 11:06:27'),
(86, 'keuangan', 23, 28.00, 18, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:06:37', '2026-01-22 11:06:37'),
(87, 'keuangan', 42, 28.00, 21, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:06:37', '2026-01-22 11:06:37'),
(88, 'settings', 9, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:06:51', '2026-01-22 11:06:51'),
(89, 'settings', 1021, 30.00, 48, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:07:02', '2026-01-22 11:07:02'),
(90, 'settings', 10, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:07:02', '2026-01-22 11:07:02'),
(91, 'transparansi/keuangan', 37, 28.00, 8, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:07:06', '2026-01-22 11:07:06'),
(92, 'profil/tentang', 26, 28.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:07:11', '2026-01-22 11:07:11'),
(93, 'transactions', 5, 26.00, 0, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:07:18', '2026-01-22 11:07:18'),
(94, 'keuangan', 21, 28.00, 18, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:07:22', '2026-01-22 11:07:22'),
(95, 'approvals', 6, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:08:10', '2026-01-22 11:08:10'),
(96, 'keuangan', 20, 28.00, 18, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:08:13', '2026-01-22 11:08:13'),
(97, 'transactions', 5, 26.00, 0, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:08:14', '2026-01-22 11:08:14'),
(98, 'zakat', 77, 26.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:08:17', '2026-01-22 11:08:17'),
(99, 'zakat/reports', 39, 26.00, 5, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:08:19', '2026-01-22 11:08:19'),
(100, 'approvals', 6, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:08:23', '2026-01-22 11:08:23'),
(101, 'keuangan', 20, 28.00, 18, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:08:24', '2026-01-22 11:08:24'),
(102, 'transparansi/keuangan', 37, 28.00, 6, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:09:02', '2026-01-22 11:09:02'),
(103, 'keuangan', 41, 28.00, 19, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:09:05', '2026-01-22 11:09:05'),
(104, 'keuangan', 21, 28.00, 18, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:10:14', '2026-01-22 11:10:14'),
(105, 'transparansi/aset', 12, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:12:20', '2026-01-22 11:12:20'),
(106, 'display', 206, 30.00, 8, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:12:44', '2026-01-22 11:12:44'),
(107, 'display', 178, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:13:45', '2026-01-22 11:13:45'),
(108, 'keuangan', 36, 28.00, 19, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:14:17', '2026-01-22 11:14:17'),
(109, 'transactions', 17, 28.00, 3, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:14:37', '2026-01-22 11:14:37'),
(110, 'display', 215, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:14:45', '2026-01-22 11:14:45'),
(111, 'keuangan', 23, 28.00, 18, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:14:52', '2026-01-22 11:14:52'),
(112, 'keuangan', 39, 28.00, 19, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:15:42', '2026-01-22 11:15:42'),
(113, 'display', 174, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:15:46', '2026-01-22 11:15:46'),
(114, 'keuangan', 21, 28.00, 18, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:15:46', '2026-01-22 11:15:46'),
(115, 'transparansi/aset', 23, 28.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:16:35', '2026-01-22 11:16:35'),
(116, 'transparansi/keuangan', 16, 28.00, 5, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:16:39', '2026-01-22 11:16:39'),
(117, 'display', 707, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:16:47', '2026-01-22 11:16:47'),
(118, 'display', 138, 30.00, 8, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:16:48', '2026-01-22 11:16:48'),
(119, 'keuangan', 37, 28.00, 19, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:16:48', '2026-01-22 11:16:48'),
(120, 'keuangan', 38, 28.00, 19, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:16:50', '2026-01-22 11:16:50'),
(121, 'transactions', 16, 28.00, 3, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:16:51', '2026-01-22 11:16:51'),
(122, 'keuangan', 21, 28.00, 18, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:16:55', '2026-01-22 11:16:55'),
(123, 'transactions', 15, 28.00, 3, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:16:57', '2026-01-22 11:16:57'),
(124, 'keuangan', 20, 28.00, 18, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:17:01', '2026-01-22 11:17:01'),
(125, 'transactions', 14, 28.00, 3, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:17:18', '2026-01-22 11:17:18'),
(126, 'transactions', 9, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:17:36', '2026-01-22 11:17:36'),
(127, 'transactions', 9, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:17:39', '2026-01-22 11:17:39'),
(128, 'transactions', 7, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:17:41', '2026-01-22 11:17:41'),
(129, 'transactions', 8, 28.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:17:43', '2026-01-22 11:17:43'),
(130, 'transactions', 14, 28.00, 3, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:17:45', '2026-01-22 11:17:45'),
(131, 'display', 537, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:17:49', '2026-01-22 11:17:49'),
(132, 'transactions/export', 1574, 34.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:17:57', '2026-01-22 11:17:57'),
(133, 'transactions/export', 86, 34.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:17:57', '2026-01-22 11:17:57'),
(134, 'keuangan', 24, 28.00, 18, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:18:29', '2026-01-22 11:18:29'),
(135, 'transactions', 15, 28.00, 3, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:18:35', '2026-01-22 11:18:35'),
(136, 'display', 214, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:18:50', '2026-01-22 11:18:50'),
(137, 'transactions', 973, 28.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:18:53', '2026-01-22 11:18:53'),
(138, 'transactions', 15, 28.00, 3, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:18:53', '2026-01-22 11:18:53'),
(139, 'transparansi/keuangan', 34, 28.00, 6, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:19:00', '2026-01-22 11:19:00'),
(140, 'transactions', 22, 28.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:19:29', '2026-01-22 11:19:29'),
(141, 'transactions', 15, 28.00, 3, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:19:29', '2026-01-22 11:19:29'),
(142, 'transparansi/keuangan', 32, 28.00, 6, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:19:32', '2026-01-22 11:19:32'),
(143, 'display', 179, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:19:50', '2026-01-22 11:19:50'),
(144, 'display', 222, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:20:51', '2026-01-22 11:20:51'),
(145, 'users', 6, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:21:06', '2026-01-22 11:21:06'),
(146, 'settings', 9, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:21:08', '2026-01-22 11:21:08'),
(147, 'keuangan', 22, 28.00, 18, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:21:16', '2026-01-22 11:21:16'),
(148, 'transactions', 16, 28.00, 3, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:21:17', '2026-01-22 11:21:17'),
(149, 'keuangan', 20, 28.00, 18, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:21:46', '2026-01-22 11:21:46'),
(150, 'display', 523, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:21:51', '2026-01-22 11:21:51'),
(151, 'transparansi/keuangan', 38, 28.00, 6, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:22:03', '2026-01-22 11:22:03'),
(152, 'transactions', 14, 28.00, 3, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:22:16', '2026-01-22 11:22:16'),
(153, 'keuangan', 21, 28.00, 18, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:22:17', '2026-01-22 11:22:17'),
(154, 'approvals', 7, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:22:19', '2026-01-22 11:22:19'),
(155, 'dashboard', 36, 28.00, 46, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:22:22', '2026-01-22 11:22:22'),
(156, 'keuangan', 18, 28.00, 18, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:22:48', '2026-01-22 11:22:48'),
(157, 'keuangan', 38, 28.00, 19, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:22:49', '2026-01-22 11:22:49'),
(158, 'transactions', 15, 28.00, 3, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:22:50', '2026-01-22 11:22:50'),
(159, 'display', 175, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:22:52', '2026-01-22 11:22:52'),
(160, 'display', 138, 30.00, 8, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:22:52', '2026-01-22 11:22:52'),
(161, 'transactions', 15, 28.00, 3, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:23:10', '2026-01-22 11:23:10'),
(162, 'transactions', 14, 28.00, 3, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:23:13', '2026-01-22 11:23:13'),
(163, 'transactions/24', 40, 28.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:23:24', '2026-01-22 11:23:24'),
(164, 'transactions', 16, 28.00, 3, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:23:24', '2026-01-22 11:23:24'),
(165, 'transparansi/keuangan', 31, 28.00, 6, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:23:27', '2026-01-22 11:23:27'),
(166, 'display', 498, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:23:54', '2026-01-22 11:23:54'),
(167, '/', 122, 28.00, 4, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:24:08', '2026-01-22 11:24:08'),
(168, 'ibadah/jumat', 106, 28.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:24:13', '2026-01-22 11:24:13'),
(169, 'zakat', 12, 26.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:24:17', '2026-01-22 11:24:17'),
(170, 'transactions', 14, 28.00, 3, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:24:21', '2026-01-22 11:24:21'),
(171, 'transactions', 15, 28.00, 3, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:24:24', '2026-01-22 11:24:24'),
(172, 'transactions', 8, 28.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:24:37', '2026-01-22 11:24:37'),
(173, 'transactions', 8, 28.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:24:43', '2026-01-22 11:24:43'),
(174, 'transactions', 14, 28.00, 3, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:24:46', '2026-01-22 11:24:46'),
(175, 'transactions', 14, 28.00, 3, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:24:48', '2026-01-22 11:24:48'),
(176, 'transactions', 13, 28.00, 3, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:24:51', '2026-01-22 11:24:51'),
(177, 'display', 162, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:24:53', '2026-01-22 11:24:53'),
(178, 'transactions', 7, 28.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:25:09', '2026-01-22 11:25:09'),
(179, 'transactions', 14, 28.00, 3, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:25:12', '2026-01-22 11:25:12'),
(180, 'transactions/export', 172, 40.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:25:15', '2026-01-22 11:25:15'),
(181, 'transactions/export', 156, 40.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:25:15', '2026-01-22 11:25:15'),
(182, 'display', 177, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:25:54', '2026-01-22 11:25:54'),
(183, 'zakat', 12, 26.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:26:32', '2026-01-22 11:26:32'),
(184, 'zakat/reports', 9, 26.00, 5, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:26:34', '2026-01-22 11:26:34'),
(185, 'zakat/export', 412, 34.00, 5, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:26:39', '2026-01-22 11:26:39'),
(186, 'zakat/export', 77, 34.00, 5, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:26:41', '2026-01-22 11:26:41'),
(187, 'zakat/export', 82, 34.00, 5, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:26:41', '2026-01-22 11:26:41'),
(188, 'display', 179, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:26:55', '2026-01-22 11:26:55'),
(189, 'users', 6, 28.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:27:00', '2026-01-22 11:27:00'),
(190, 'settings', 9, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:27:02', '2026-01-22 11:27:02'),
(191, 'zakat', 10, 26.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:27:07', '2026-01-22 11:27:07'),
(192, 'display', 502, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:27:55', '2026-01-22 11:27:55'),
(193, 'qurban', 16, 26.00, 11, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:28:28', '2026-01-22 11:28:28'),
(194, 'zakat', 10, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:28:30', '2026-01-22 11:28:30'),
(195, 'zakat/distribute', 11, 28.00, 5, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:28:36', '2026-01-22 11:28:36'),
(196, 'qurban', 14, 28.00, 11, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:28:42', '2026-01-22 11:28:42'),
(197, 'display', 183, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:28:56', '2026-01-22 11:28:56'),
(198, 'transactions', 15, 28.00, 3, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:29:00', '2026-01-22 11:29:00'),
(199, 'transactions/export', 194, 36.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:29:03', '2026-01-22 11:29:03'),
(200, 'transactions/export', 90, 36.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:29:03', '2026-01-22 11:29:03'),
(201, 'transactions', 15, 28.00, 3, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:29:31', '2026-01-22 11:29:31'),
(202, 'display', 244, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:29:56', '2026-01-22 11:29:56'),
(203, 'settings', 9, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:30:06', '2026-01-22 11:30:06'),
(204, 'display', 3303, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:31:00', '2026-01-22 11:31:00'),
(205, 'settings', 35, 28.00, 49, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:31:31', '2026-01-22 11:31:31'),
(206, 'settings', 9, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:31:32', '2026-01-22 11:31:32'),
(207, 'keuangan', 21, 28.00, 18, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:31:36', '2026-01-22 11:31:36'),
(208, 'transactions', 15, 28.00, 3, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:31:37', '2026-01-22 11:31:37'),
(209, 'transactions/export', 103, 36.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:31:38', '2026-01-22 11:31:38'),
(210, 'transactions/export', 95, 36.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:31:40', '2026-01-22 11:31:40'),
(211, 'display', 522, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:31:57', '2026-01-22 11:31:57'),
(212, 'display', 178, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:32:57', '2026-01-22 11:32:57'),
(213, 'display', 562, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:33:57', '2026-01-22 11:33:57'),
(214, 'transactions', 39, 28.00, 6, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:34:05', '2026-01-22 11:34:05'),
(215, 'transactions', 15, 28.00, 3, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:34:06', '2026-01-22 11:34:06'),
(216, 'transactions', 31, 28.00, 4, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:34:07', '2026-01-22 11:34:07'),
(217, 'transactions/export', 496, 40.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:34:09', '2026-01-22 11:34:09'),
(218, 'transactions/export', 386, 40.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:34:12', '2026-01-22 11:34:12'),
(219, 'transactions/export', 389, 40.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:34:12', '2026-01-22 11:34:12'),
(220, 'transactions/export', 418, 40.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:34:13', '2026-01-22 11:34:13'),
(221, 'transactions/export', 388, 40.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:34:13', '2026-01-22 11:34:13'),
(222, 'transactions/export', 405, 40.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:34:14', '2026-01-22 11:34:14'),
(223, 'zakat', 13, 38.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:34:22', '2026-01-22 11:34:22'),
(224, 'qurban', 14, 32.00, 11, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:34:24', '2026-01-22 11:34:24'),
(225, 'zakat', 10, 30.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:34:25', '2026-01-22 11:34:25'),
(226, 'agendas', 34, 28.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:34:26', '2026-01-22 11:34:26'),
(227, '/', 122, 28.00, 4, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:34:46', '2026-01-22 11:34:46'),
(228, 'ibadah/jumat', 139, 28.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:34:49', '2026-01-22 11:34:49'),
(229, 'display', 240, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:34:57', '2026-01-22 11:34:57'),
(230, 'display', 1278, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:35:59', '2026-01-22 11:35:59'),
(231, 'display', 751, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:36:59', '2026-01-22 11:36:59'),
(232, 'display', 548, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:37:59', '2026-01-22 11:37:59'),
(233, 'display', 288, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:39:00', '2026-01-22 11:39:00'),
(234, 'transparansi/aset', 8, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:39:40', '2026-01-22 11:39:40'),
(235, 'profil/tentang', 5, 26.00, 0, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:39:43', '2026-01-22 11:39:43'),
(236, 'profil/struktur', 8, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:39:45', '2026-01-22 11:39:45'),
(237, 'display', 174, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:40:00', '2026-01-22 11:40:00'),
(238, '/', 121, 28.00, 4, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:40:11', '2026-01-22 11:40:11'),
(239, 'agendas', 32, 28.00, 3, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:40:57', '2026-01-22 11:40:57'),
(240, 'display', 175, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:41:00', '2026-01-22 11:41:00'),
(241, 'friday-schedules', 10, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:41:01', '2026-01-22 11:41:01'),
(242, 'display', 231, 30.00, 8, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:41:01', '2026-01-22 11:41:01'),
(243, 'friday-schedules', 59, 28.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:41:47', '2026-01-22 11:41:47'),
(244, 'friday-schedules', 8, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:41:47', '2026-01-22 11:41:47'),
(245, 'friday-schedules', 15, 28.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:41:56', '2026-01-22 11:41:56'),
(246, 'friday-schedules', 9, 26.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:41:56', '2026-01-22 11:41:56'),
(247, 'display', 178, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:42:02', '2026-01-22 11:42:02'),
(248, 'ibadah/jumat', 134, 30.00, 4, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:42:02', '2026-01-22 11:42:02'),
(249, 'ibadah/jumat', 180, 30.00, 4, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:42:25', '2026-01-22 11:42:25'),
(250, 'friday-schedules/1', 16, 28.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:42:42', '2026-01-22 11:42:42'),
(251, 'friday-schedules', 9, 26.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:42:42', '2026-01-22 11:42:42'),
(252, 'ibadah/jumat', 137, 30.00, 4, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:42:46', '2026-01-22 11:42:46'),
(253, 'ibadah/jumat', 133, 30.00, 4, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:42:47', '2026-01-22 11:42:47'),
(254, 'ibadah/jumat', 544, 30.00, 4, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:42:50', '2026-01-22 11:42:50'),
(255, 'friday-schedules/1', 14, 28.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:42:57', '2026-01-22 11:42:57'),
(256, 'friday-schedules', 10, 26.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:42:57', '2026-01-22 11:42:57'),
(257, 'ibadah/jumat', 136, 30.00, 4, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:42:59', '2026-01-22 11:42:59'),
(258, 'display', 232, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:43:03', '2026-01-22 11:43:03'),
(259, 'ibadah/jumat', 220, 30.00, 4, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:44:02', '2026-01-22 11:44:02'),
(260, 'display', 503, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:44:04', '2026-01-22 11:44:04'),
(261, 'display', 140, 30.00, 8, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:44:04', '2026-01-22 11:44:04'),
(262, 'friday-schedules', 9, 26.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:44:27', '2026-01-22 11:44:27'),
(263, 'friday-schedules', 25, 28.00, 3, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:44:27', '2026-01-22 11:44:27'),
(264, 'ibadah/jumat', 134, 30.00, 4, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:44:58', '2026-01-22 11:44:58'),
(265, 'profil/tentang', 5, 26.00, 0, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:45:02', '2026-01-22 11:45:02'),
(266, 'display', 620, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:45:05', '2026-01-22 11:45:05'),
(267, 'users', 6, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:45:08', '2026-01-22 11:45:08'),
(268, 'settings', 9, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:45:11', '2026-01-22 11:45:11'),
(269, 'display', 466, 30.00, 8, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:45:14', '2026-01-22 11:45:14'),
(270, 'assets', 10, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:45:15', '2026-01-22 11:45:15'),
(271, 'agendas', 11, 26.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:45:25', '2026-01-22 11:45:25'),
(272, 'friday-schedules', 9, 26.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:45:26', '2026-01-22 11:45:26'),
(273, 'zakat', 11, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:45:27', '2026-01-22 11:45:27'),
(274, 'transactions', 17, 28.00, 3, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:45:28', '2026-01-22 11:45:28'),
(275, 'keuangan', 25, 28.00, 18, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:45:28', '2026-01-22 11:45:28'),
(276, 'approvals', 7, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:45:29', '2026-01-22 11:45:29'),
(277, 'approvals', 6, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:45:29', '2026-01-22 11:45:29'),
(278, 'keuangan', 27, 28.00, 18, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:45:31', '2026-01-22 11:45:31');
INSERT INTO `performance_logs` (`id`, `request_path`, `response_time_ms`, `memory_usage_mb`, `query_count`, `user_id`, `ip_address`, `user_agent`, `created_at`, `updated_at`) VALUES
(279, 'transactions', 15, 28.00, 3, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:45:45', '2026-01-22 11:45:45'),
(280, 'settings', 10, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:46:04', '2026-01-22 11:46:04'),
(281, 'display', 3175, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:46:09', '2026-01-22 11:46:09'),
(282, 'friday-schedules', 10, 26.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:46:42', '2026-01-22 11:46:42'),
(283, 'friday-schedules', 35, 28.00, 3, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:46:42', '2026-01-22 11:46:42'),
(284, 'friday-schedules/1', 16, 28.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:46:51', '2026-01-22 11:46:51'),
(285, 'friday-schedules', 9, 26.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:46:51', '2026-01-22 11:46:51'),
(286, 'ibadah/jadwal', 441, 28.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:46:59', '2026-01-22 11:46:59'),
(287, 'ibadah/jadwal', 386, 30.00, 3, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:46:59', '2026-01-22 11:46:59'),
(288, 'ibadah/jumat', 118, 28.00, 3, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:47:02', '2026-01-22 11:47:02'),
(289, 'display', 171, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:47:06', '2026-01-22 11:47:06'),
(290, 'display', 142, 30.00, 8, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:47:07', '2026-01-22 11:47:07'),
(291, 'friday-schedules/1', 15, 28.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:47:15', '2026-01-22 11:47:15'),
(292, 'friday-schedules', 9, 26.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:47:15', '2026-01-22 11:47:15'),
(293, 'ibadah/jumat', 209, 30.00, 4, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:47:20', '2026-01-22 11:47:20'),
(294, 'friday-schedules/1', 15, 28.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:47:31', '2026-01-22 11:47:31'),
(295, 'friday-schedules', 10, 26.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:47:31', '2026-01-22 11:47:31'),
(296, 'ibadah/jumat', 344, 30.00, 4, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:47:34', '2026-01-22 11:47:34'),
(297, 'profil/struktur', 8, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:47:53', '2026-01-22 11:47:53'),
(298, 'display', 177, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:48:08', '2026-01-22 11:48:08'),
(299, 'display', 392, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:49:09', '2026-01-22 11:49:09'),
(300, 'display', 169, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:50:09', '2026-01-22 11:50:09'),
(301, 'display', 175, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:51:09', '2026-01-22 11:51:09'),
(302, 'display', 245, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:52:09', '2026-01-22 11:52:09'),
(303, 'dashboard', 39, 28.00, 46, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:52:22', '2026-01-22 11:52:22'),
(304, 'dashboard', 36, 28.00, 12, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:52:53', '2026-01-22 11:52:53'),
(305, 'dashboard', 31, 28.00, 12, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:52:55', '2026-01-22 11:52:55'),
(306, 'display', 195, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:53:09', '2026-01-22 11:53:09'),
(307, 'display', 222, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:54:10', '2026-01-22 11:54:10'),
(308, 'display', 3127, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:55:13', '2026-01-22 11:55:13'),
(309, 'display', 188, 30.00, 8, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:55:14', '2026-01-22 11:55:14'),
(310, 'dashboard', 29, 28.00, 12, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:55:36', '2026-01-22 11:55:36'),
(311, 'committee-members', 50, 28.00, 0, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:55:41', '2026-01-22 11:55:41'),
(312, 'dashboard', 30, 28.00, 12, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:55:50', '2026-01-22 11:55:50'),
(313, 'committee-members', 10, 28.00, 0, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:55:54', '2026-01-22 11:55:54'),
(314, 'components-showcase', 6, 26.00, 0, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:56:09', '2026-01-22 11:56:09'),
(315, 'display', 202, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:56:15', '2026-01-22 11:56:15'),
(316, 'components-showcase', 24, 28.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:56:36', '2026-01-22 11:56:36'),
(317, 'committee-members', 11, 28.00, 0, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:56:37', '2026-01-22 11:56:37'),
(318, 'profil/struktur', 24, 28.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:57:04', '2026-01-22 11:57:04'),
(319, 'display', 505, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:57:16', '2026-01-22 11:57:16'),
(320, 'committee-members', 11, 26.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:57:41', '2026-01-22 11:57:41'),
(321, 'display', 180, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:58:16', '2026-01-22 11:58:16'),
(322, 'committee-members', 30, 28.00, 3, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:58:55', '2026-01-22 11:58:55'),
(323, 'committee-members/1', 33, 30.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:59:02', '2026-01-22 11:59:02'),
(324, 'committee-members', 10, 26.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:59:02', '2026-01-22 11:59:02'),
(325, 'committee-members/4', 26, 30.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:59:12', '2026-01-22 11:59:12'),
(326, 'committee-members', 10, 26.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:59:13', '2026-01-22 11:59:13'),
(327, 'profil/struktur', 26, 28.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:59:15', '2026-01-22 11:59:15'),
(328, 'display', 492, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:59:17', '2026-01-22 11:59:17'),
(329, 'display', 184, 30.00, 8, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:59:17', '2026-01-22 11:59:17'),
(330, 'committee-members', 27, 28.00, 3, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:59:28', '2026-01-22 11:59:28'),
(331, 'committee-members/1', 32, 30.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:59:59', '2026-01-22 11:59:59'),
(332, 'committee-members', 11, 26.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 11:59:59', '2026-01-22 11:59:59'),
(333, 'profil/struktur', 29, 28.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:00:04', '2026-01-22 12:00:04'),
(334, 'display', 253, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:00:17', '2026-01-22 12:00:17'),
(335, 'display', 170, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:01:18', '2026-01-22 12:01:18'),
(336, 'display', 173, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:02:18', '2026-01-22 12:02:18'),
(337, 'display', 172, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:03:18', '2026-01-22 12:03:18'),
(338, 'display', 497, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:04:19', '2026-01-22 12:04:19'),
(339, 'display', 504, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:05:19', '2026-01-22 12:05:19'),
(340, 'display', 178, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:06:19', '2026-01-22 12:06:19'),
(341, 'display', 509, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:07:19', '2026-01-22 12:07:19'),
(342, 'display', 172, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:08:19', '2026-01-22 12:08:19'),
(343, 'display', 1461, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:09:21', '2026-01-22 12:09:21'),
(344, 'display', 508, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:10:21', '2026-01-22 12:10:21'),
(345, 'committee-members', 32, 28.00, 3, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:10:23', '2026-01-22 12:10:23'),
(346, 'profil/struktur', 25, 28.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:10:29', '2026-01-22 12:10:29'),
(347, 'committee-members/2', 31, 30.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:10:42', '2026-01-22 12:10:42'),
(348, 'committee-members', 12, 26.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:10:42', '2026-01-22 12:10:42'),
(349, 'committee-members/3', 26, 30.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:10:48', '2026-01-22 12:10:48'),
(350, 'committee-members', 11, 26.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:10:49', '2026-01-22 12:10:49'),
(351, 'committee-members/5', 26, 30.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:10:55', '2026-01-22 12:10:55'),
(352, 'committee-members', 11, 26.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:10:55', '2026-01-22 12:10:55'),
(353, 'committee-members/6', 26, 30.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:11:01', '2026-01-22 12:11:01'),
(354, 'committee-members', 11, 26.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:11:01', '2026-01-22 12:11:01'),
(355, 'committee-members/7', 26, 30.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:11:07', '2026-01-22 12:11:07'),
(356, 'committee-members', 11, 26.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:11:07', '2026-01-22 12:11:07'),
(357, 'profil/struktur', 25, 28.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:11:10', '2026-01-22 12:11:10'),
(358, 'display', 998, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:11:22', '2026-01-22 12:11:22'),
(359, 'display', 185, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:12:22', '2026-01-22 12:12:22'),
(360, 'galeri', 12, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:12:29', '2026-01-22 12:12:29'),
(361, 'profil/struktur', 8, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:13:05', '2026-01-22 12:13:05'),
(362, 'profil/struktur', 30, 28.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:13:06', '2026-01-22 12:13:06'),
(363, 'display', 173, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:13:22', '2026-01-22 12:13:22'),
(364, 'display', 344, 30.00, 8, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:13:23', '2026-01-22 12:13:23'),
(365, 'profil/struktur', 24, 28.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:13:26', '2026-01-22 12:13:26'),
(366, 'committee-members/5', 16, 28.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:14:09', '2026-01-22 12:14:09'),
(367, 'committee-members', 11, 26.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:14:09', '2026-01-22 12:14:09'),
(368, 'committee-members', 37, 28.00, 3, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:14:09', '2026-01-22 12:14:09'),
(369, 'profil/struktur', 25, 28.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:14:13', '2026-01-22 12:14:13'),
(370, 'display', 177, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:14:24', '2026-01-22 12:14:24'),
(371, 'committee-members/5', 15, 28.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:14:37', '2026-01-22 12:14:37'),
(372, 'committee-members', 11, 26.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:14:37', '2026-01-22 12:14:37'),
(373, 'profil/struktur', 26, 28.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:14:40', '2026-01-22 12:14:40'),
(374, 'display', 503, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:15:25', '2026-01-22 12:15:25'),
(375, 'users', 7, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:15:33', '2026-01-22 12:15:33'),
(376, 'committee-members', 10, 26.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:15:42', '2026-01-22 12:15:42'),
(377, 'committee-members', 29, 30.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:16:05', '2026-01-22 12:16:05'),
(378, 'committee-members', 10, 28.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:16:06', '2026-01-22 12:16:06'),
(379, 'profil/struktur', 29, 28.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:16:15', '2026-01-22 12:16:15'),
(380, 'display', 225, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:16:25', '2026-01-22 12:16:25'),
(381, 'committee-members/8', 16, 28.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:16:40', '2026-01-22 12:16:40'),
(382, 'committee-members', 11, 26.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:16:40', '2026-01-22 12:16:40'),
(383, 'profil/struktur', 25, 28.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:16:44', '2026-01-22 12:16:44'),
(384, 'profil/tentang', 5, 26.00, 0, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:17:08', '2026-01-22 12:17:08'),
(385, 'display', 183, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:17:25', '2026-01-22 12:17:25'),
(386, 'display', 218, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:18:26', '2026-01-22 12:18:26'),
(387, 'profil/tentang', 7, 26.00, 0, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:19:04', '2026-01-22 12:19:04'),
(388, 'profil/struktur', 8, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:19:05', '2026-01-22 12:19:05'),
(389, 'settings', 9, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:19:16', '2026-01-22 12:19:16'),
(390, 'display', 180, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:19:26', '2026-01-22 12:19:26'),
(391, 'display', 162, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:20:26', '2026-01-22 12:20:26'),
(392, 'profil/tentang', 9, 26.00, 6, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:20:30', '2026-01-22 12:20:30'),
(393, 'profil/struktur', 10, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:20:32', '2026-01-22 12:20:32'),
(394, '/', 654, 28.00, 4, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:20:34', '2026-01-22 12:20:34'),
(395, 'settings', 33, 28.00, 47, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:20:54', '2026-01-22 12:20:54'),
(396, 'settings', 9, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:20:54', '2026-01-22 12:20:54'),
(397, 'settings', 34, 28.00, 4, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:20:54', '2026-01-22 12:20:54'),
(398, '/', 464, 30.00, 5, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:20:57', '2026-01-22 12:20:57'),
(399, 'profil/tentang', 8, 26.00, 6, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:21:00', '2026-01-22 12:21:00'),
(400, 'settings', 27, 28.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:21:12', '2026-01-22 12:21:12'),
(401, 'display', 137, 30.00, 8, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:21:14', '2026-01-22 12:21:14'),
(402, 'settings', 11, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:21:16', '2026-01-22 12:21:16'),
(403, 'display', 182, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:21:27', '2026-01-22 12:21:27'),
(404, 'display', 152, 30.00, 8, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:21:27', '2026-01-22 12:21:27'),
(405, 'profil/tentang', 8, 26.00, 6, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:21:31', '2026-01-22 12:21:31'),
(406, 'settings', 50, 30.00, 60, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:21:51', '2026-01-22 12:21:51'),
(407, 'settings', 9, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:21:52', '2026-01-22 12:21:52'),
(408, 'profil/tentang', 27, 28.00, 9, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:21:55', '2026-01-22 12:21:55'),
(409, '/', 448, 28.00, 4, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:22:09', '2026-01-22 12:22:09'),
(410, 'profil/tentang', 7, 26.00, 6, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:22:25', '2026-01-22 12:22:25'),
(411, 'display', 177, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:22:28', '2026-01-22 12:22:28'),
(412, 'settings', 10, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:23:11', '2026-01-22 12:23:11'),
(413, 'display', 262, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:23:28', '2026-01-22 12:23:28'),
(414, 'display', 214, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:24:28', '2026-01-22 12:24:28'),
(415, 'profil/tentang', 30, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:25:27', '2026-01-22 12:25:27'),
(416, 'display', 179, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:25:28', '2026-01-22 12:25:28'),
(417, 'display', 482, 30.00, 8, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:25:29', '2026-01-22 12:25:29'),
(418, '/', 196, 28.00, 4, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:25:30', '2026-01-22 12:25:30'),
(419, '/', 462, 28.00, 4, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:25:30', '2026-01-22 12:25:30'),
(420, 'settings', 38, 28.00, 60, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:26:03', '2026-01-22 12:26:03'),
(421, 'settings', 10, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:26:03', '2026-01-22 12:26:03'),
(422, 'settings', 29, 28.00, 4, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:26:04', '2026-01-22 12:26:04'),
(423, 'settings', 36, 28.00, 59, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:26:17', '2026-01-22 12:26:17'),
(424, 'settings', 9, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:26:17', '2026-01-22 12:26:17'),
(425, 'display', 227, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:26:30', '2026-01-22 12:26:30'),
(426, 'settings', 9, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:26:30', '2026-01-22 12:26:30'),
(427, 'settings', 27, 28.00, 4, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:26:32', '2026-01-22 12:26:32'),
(428, 'settings', 36, 28.00, 59, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:26:51', '2026-01-22 12:26:51'),
(429, 'settings', 9, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:26:51', '2026-01-22 12:26:51'),
(430, '/', 119, 28.00, 4, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:26:54', '2026-01-22 12:26:54'),
(431, 'profil/tentang', 8, 26.00, 6, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:27:02', '2026-01-22 12:27:02'),
(432, 'profil/struktur', 8, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:27:05', '2026-01-22 12:27:05'),
(433, 'transparansi/keuangan', 16, 28.00, 5, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:27:08', '2026-01-22 12:27:08'),
(434, 'transparansi/aset', 8, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:27:10', '2026-01-22 12:27:10'),
(435, 'galeri', 7, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:27:12', '2026-01-22 12:27:12'),
(436, 'ibadah/jadwal', 157, 28.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:27:14', '2026-01-22 12:27:14'),
(437, 'ibadah/agenda', 8, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:27:16', '2026-01-22 12:27:16'),
(438, 'ibadah/jumat', 327, 28.00, 3, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:27:18', '2026-01-22 12:27:18'),
(439, 'info/zakat', 8, 26.00, 0, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:27:20', '2026-01-22 12:27:20'),
(440, 'ibadah/jumat', 118, 28.00, 3, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:27:22', '2026-01-22 12:27:22'),
(441, 'info/qurban', 5, 26.00, 0, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:27:27', '2026-01-22 12:27:27'),
(442, 'display', 419, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:27:30', '2026-01-22 12:27:30'),
(443, 'info/zakat', 5, 26.00, 0, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:27:37', '2026-01-22 12:27:37'),
(444, 'info/qurban', 5, 26.00, 0, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:27:49', '2026-01-22 12:27:49'),
(445, 'info/zakat', 5, 26.00, 0, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:28:24', '2026-01-22 12:28:24'),
(446, 'display', 207, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:28:30', '2026-01-22 12:28:30'),
(447, 'settings', 9, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:28:59', '2026-01-22 12:28:59'),
(448, 'display', 214, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:29:30', '2026-01-22 12:29:30'),
(449, '/', 125, 28.00, 4, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:30:04', '2026-01-22 12:30:04'),
(450, '/', 357, 30.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:30:05', '2026-01-22 12:30:05'),
(451, 'info/zakat', 5, 26.00, 0, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:30:26', '2026-01-22 12:30:26'),
(452, 'display', 222, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:30:31', '2026-01-22 12:30:31'),
(453, 'display', 139, 30.00, 8, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:30:31', '2026-01-22 12:30:31'),
(454, 'info/zakat', 5, 26.00, 0, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:30:38', '2026-01-22 12:30:38'),
(455, 'info/qurban', 5, 26.00, 0, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:30:45', '2026-01-22 12:30:45'),
(456, '/', 447, 28.00, 4, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:30:50', '2026-01-22 12:30:50'),
(457, 'display', 508, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:31:33', '2026-01-22 12:31:33'),
(458, '/', 444, 28.00, 4, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:31:35', '2026-01-22 12:31:35'),
(459, 'display', 226, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:32:33', '2026-01-22 12:32:33'),
(460, 'display', 176, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:33:34', '2026-01-22 12:33:34'),
(461, 'display', 522, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:34:35', '2026-01-22 12:34:35'),
(462, 'display', 493, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:35:36', '2026-01-22 12:35:36'),
(463, 'users', 7, 28.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:36:00', '2026-01-22 12:36:00'),
(464, 'users', 27, 28.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:36:00', '2026-01-22 12:36:00'),
(465, 'display', 519, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:36:36', '2026-01-22 12:36:36'),
(466, '/', 140, 30.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:37:17', '2026-01-22 12:37:17'),
(467, 'galeri', 7, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:37:25', '2026-01-22 12:37:25'),
(468, 'display', 194, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:37:36', '2026-01-22 12:37:36'),
(469, 'galeri', 9, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:37:41', '2026-01-22 12:37:41'),
(470, 'ibadah/jadwal', 182, 28.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:37:43', '2026-01-22 12:37:43'),
(471, 'ibadah/agenda', 8, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:37:46', '2026-01-22 12:37:46'),
(472, 'profil/tentang', 10, 26.00, 6, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:37:49', '2026-01-22 12:37:49'),
(473, '/', 135, 28.00, 6, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:37:51', '2026-01-22 12:37:51'),
(474, '/', 478, 30.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:37:52', '2026-01-22 12:37:52'),
(475, 'display', 167, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:38:37', '2026-01-22 12:38:37'),
(476, 'display', 184, 30.00, 8, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:38:37', '2026-01-22 12:38:37'),
(477, 'users', 25, 28.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:38:46', '2026-01-22 12:38:46'),
(478, 'users', 24, 28.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:38:47', '2026-01-22 12:38:47'),
(479, 'posts', 9, 26.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:38:49', '2026-01-22 12:38:49'),
(480, 'display', 215, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:39:39', '2026-01-22 12:39:39'),
(481, 'profile', 5, 26.00, 0, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:40:09', '2026-01-22 12:40:09'),
(482, 'profile', 304, 28.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:40:30', '2026-01-22 12:40:30'),
(483, 'profile', 5, 26.00, 0, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:40:30', '2026-01-22 12:40:30'),
(484, '/', 152, 30.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:40:32', '2026-01-22 12:40:32'),
(485, 'dashboard', 42, 28.00, 46, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:40:37', '2026-01-22 12:40:37'),
(486, 'display', 228, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:40:39', '2026-01-22 12:40:39'),
(487, 'posts', 10, 26.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:40:50', '2026-01-22 12:40:50'),
(488, 'posts', 31, 28.00, 3, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:40:52', '2026-01-22 12:40:52'),
(489, 'posts', 25, 28.00, 3, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:41:37', '2026-01-22 12:41:37'),
(490, 'display', 181, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:41:39', '2026-01-22 12:41:39'),
(491, 'display', 140, 30.00, 8, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:41:40', '2026-01-22 12:41:40'),
(492, 'posts/1', 33, 30.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:41:44', '2026-01-22 12:41:44'),
(493, 'posts', 11, 26.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:41:44', '2026-01-22 12:41:44'),
(494, 'posts/2', 27, 30.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:41:50', '2026-01-22 12:41:50'),
(495, 'posts', 9, 26.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:41:51', '2026-01-22 12:41:51'),
(496, 'posts/3', 26, 30.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:41:56', '2026-01-22 12:41:56'),
(497, 'posts', 9, 26.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:41:56', '2026-01-22 12:41:56'),
(498, '/', 143, 30.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:41:59', '2026-01-22 12:41:59'),
(499, 'display', 194, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:42:41', '2026-01-22 12:42:41'),
(500, 'display', 320, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:43:41', '2026-01-22 12:43:41'),
(501, 'display', 192, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:44:42', '2026-01-22 12:44:42'),
(502, 'display', 354, 30.00, 8, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:44:42', '2026-01-22 12:44:42'),
(503, 'posts', 33, 28.00, 3, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:44:59', '2026-01-22 12:44:59'),
(504, 'posts', 26, 28.00, 3, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:45:00', '2026-01-22 12:45:00'),
(505, 'posts', 25, 30.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:45:14', '2026-01-22 12:45:14'),
(506, 'posts', 10, 26.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:45:14', '2026-01-22 12:45:14'),
(507, '/', 147, 30.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:45:25', '2026-01-22 12:45:25'),
(508, 'display', 177, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:45:44', '2026-01-22 12:45:44'),
(509, 'display', 524, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:46:45', '2026-01-22 12:46:45'),
(510, 'display', 213, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:47:45', '2026-01-22 12:47:45'),
(511, 'profil/tentang', 7, 26.00, 6, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:48:04', '2026-01-22 12:48:04'),
(512, 'profil/tentang', 30, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:48:04', '2026-01-22 12:48:04'),
(513, 'profil/struktur', 8, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:48:15', '2026-01-22 12:48:15'),
(514, 'transparansi/aset', 8, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:48:18', '2026-01-22 12:48:18'),
(515, 'transparansi/keuangan', 15, 28.00, 5, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:48:20', '2026-01-22 12:48:20'),
(516, 'galeri', 7, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:48:28', '2026-01-22 12:48:28'),
(517, 'ibadah/jadwal', 1600, 28.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:48:33', '2026-01-22 12:48:33'),
(518, '/', 122, 28.00, 6, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:48:35', '2026-01-22 12:48:35'),
(519, 'display', 230, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:48:45', '2026-01-22 12:48:45'),
(520, 'display', 373, 30.00, 8, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:48:46', '2026-01-22 12:48:46'),
(521, 'berita/kajian-rutin-malam-ahad-69721bda3e375', 8, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:48:47', '2026-01-22 12:48:47'),
(522, '/', 123, 28.00, 6, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:49:01', '2026-01-22 12:49:01'),
(523, 'berita/kajian-rutin-malam-ahad-69721b0ed684f', 8, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:49:09', '2026-01-22 12:49:09'),
(524, 'berita/kajian-rutin-malam-ahad-69721b0ed684f', 25, 28.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:49:15', '2026-01-22 12:49:15'),
(525, '/', 478, 28.00, 6, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:49:21', '2026-01-22 12:49:21'),
(526, 'display', 181, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:49:47', '2026-01-22 12:49:47'),
(527, 'display', 513, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:50:48', '2026-01-22 12:50:48'),
(528, '/', 144, 30.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:51:14', '2026-01-22 12:51:14'),
(529, 'display', 183, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:51:48', '2026-01-22 12:51:48'),
(530, 'display', 278, 30.00, 8, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:51:48', '2026-01-22 12:51:48'),
(531, 'settings', 9, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:52:05', '2026-01-22 12:52:05'),
(532, 'settings', 29, 28.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:52:05', '2026-01-22 12:52:05'),
(533, '/', 142, 30.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:52:30', '2026-01-22 12:52:30'),
(534, 'berita', 13, 28.00, 3, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:52:32', '2026-01-22 12:52:32'),
(535, '/', 167, 28.00, 6, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:52:42', '2026-01-22 12:52:42'),
(536, 'display', 537, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:52:49', '2026-01-22 12:52:49'),
(537, 'display', 154, 30.00, 8, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:52:50', '2026-01-22 12:52:50'),
(538, 'berita/kegiatan-santunan-anak-yatim-69721b0885a5e', 9, 28.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:53:31', '2026-01-22 12:53:31'),
(539, '/', 125, 28.00, 6, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:53:40', '2026-01-22 12:53:40'),
(540, 'berita/kajian-rutin-malam-ahad-69721bda3e375', 8, 28.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:53:46', '2026-01-22 12:53:46'),
(541, 'display', 229, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:53:50', '2026-01-22 12:53:50'),
(542, '/', 123, 28.00, 6, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:53:57', '2026-01-22 12:53:57'),
(543, 'galeri', 7, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:54:12', '2026-01-22 12:54:12'),
(544, '/', 125, 28.00, 6, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:54:15', '2026-01-22 12:54:15'),
(545, 'berita/kajian-rutin-malam-ahad-69721bda3e375', 8, 28.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:54:21', '2026-01-22 12:54:21'),
(546, 'display', 512, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:54:51', '2026-01-22 12:54:51'),
(547, 'display', 508, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:55:51', '2026-01-22 12:55:51'),
(548, 'display', 3123, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:56:55', '2026-01-22 12:56:55'),
(549, 'berita/kajian-rutin-malam-ahad-69721bda3e375', 29, 28.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:57:40', '2026-01-22 12:57:40'),
(550, '/', 123, 28.00, 6, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:57:50', '2026-01-22 12:57:50'),
(551, 'display', 3150, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:57:55', '2026-01-22 12:57:55'),
(552, 'berita/kegiatan-santunan-anak-yatim-69721b0885a5e', 9, 28.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:57:56', '2026-01-22 12:57:56'),
(553, 'display', 140, 30.00, 8, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:57:56', '2026-01-22 12:57:56'),
(554, '/', 128, 28.00, 6, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:58:23', '2026-01-22 12:58:23'),
(555, '/', 122, 28.00, 6, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:58:24', '2026-01-22 12:58:24');
INSERT INTO `performance_logs` (`id`, `request_path`, `response_time_ms`, `memory_usage_mb`, `query_count`, `user_id`, `ip_address`, `user_agent`, `created_at`, `updated_at`) VALUES
(556, 'display', 192, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 12:58:57', '2026-01-22 12:58:57'),
(557, 'display', 3119, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:00:00', '2026-01-22 13:00:00'),
(558, 'display', 460, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:00:58', '2026-01-22 13:00:58'),
(559, 'display', 763, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:01:59', '2026-01-22 13:01:59'),
(560, 'settings', 33, 28.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:02:03', '2026-01-22 13:02:03'),
(561, 'display', 186, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:02:59', '2026-01-22 13:02:59'),
(562, '/', 126, 28.00, 6, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:03:24', '2026-01-22 13:03:24'),
(563, 'display', 238, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:04:00', '2026-01-22 13:04:00'),
(564, 'display', 181, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:05:00', '2026-01-22 13:05:00'),
(565, 'display', 511, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:06:01', '2026-01-22 13:06:01'),
(566, 'display', 218, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:07:01', '2026-01-22 13:07:01'),
(567, 'display', 1119, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:08:10', '2026-01-22 13:08:10'),
(568, 'display', 441, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:09:02', '2026-01-22 13:09:02'),
(569, 'display', 178, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:10:02', '2026-01-22 13:10:02'),
(570, '/', 1357, 30.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:10:35', '2026-01-22 13:10:35'),
(571, 'settings', 33, 28.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:10:50', '2026-01-22 13:10:50'),
(572, 'display', 494, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:11:02', '2026-01-22 13:11:02'),
(573, 'display', 185, 30.00, 8, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:11:03', '2026-01-22 13:11:03'),
(574, 'settings', 501, 30.00, 64, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:11:07', '2026-01-22 13:11:07'),
(575, 'settings', 10, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:11:08', '2026-01-22 13:11:08'),
(576, '/', 141, 30.00, 9, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:11:12', '2026-01-22 13:11:12'),
(577, 'display', 574, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:12:04', '2026-01-22 13:12:04'),
(578, 'display', 236, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:13:04', '2026-01-22 13:13:04'),
(579, 'display', 145, 30.00, 8, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:13:05', '2026-01-22 13:13:05'),
(580, '/', 174, 30.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:13:28', '2026-01-22 13:13:28'),
(581, 'profil/tentang', 8, 26.00, 6, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:13:39', '2026-01-22 13:13:39'),
(582, 'profil/struktur', 8, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:13:42', '2026-01-22 13:13:42'),
(583, 'transparansi/keuangan', 14, 28.00, 5, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:13:48', '2026-01-22 13:13:48'),
(584, 'transparansi/keuangan', 15, 28.00, 5, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:13:58', '2026-01-22 13:13:58'),
(585, 'profil/tentang', 8, 26.00, 6, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:14:04', '2026-01-22 13:14:04'),
(586, 'display', 178, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:14:06', '2026-01-22 13:14:06'),
(587, 'profil/struktur', 9, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:14:07', '2026-01-22 13:14:07'),
(588, 'transparansi/keuangan', 14, 28.00, 5, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:14:09', '2026-01-22 13:14:09'),
(589, 'transparansi/aset', 8, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:14:23', '2026-01-22 13:14:23'),
(590, 'transparansi/keuangan', 15, 28.00, 5, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:14:25', '2026-01-22 13:14:25'),
(591, 'transparansi/keuangan', 15, 28.00, 5, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:14:25', '2026-01-22 13:14:25'),
(592, 'profil/tentang', 8, 26.00, 6, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:14:28', '2026-01-22 13:14:28'),
(593, 'profil/struktur', 8, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:14:30', '2026-01-22 13:14:30'),
(594, 'transparansi/keuangan', 14, 28.00, 5, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:14:33', '2026-01-22 13:14:33'),
(595, 'transparansi/aset', 7, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:14:36', '2026-01-22 13:14:36'),
(596, 'galeri', 7, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:14:37', '2026-01-22 13:14:37'),
(597, 'ibadah/jadwal', 118, 28.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:14:40', '2026-01-22 13:14:40'),
(598, 'ibadah/agenda', 8, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:14:41', '2026-01-22 13:14:41'),
(599, 'ibadah/jumat', 117, 28.00, 3, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:14:45', '2026-01-22 13:14:45'),
(600, 'info/zakat', 23, 26.00, 0, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:14:47', '2026-01-22 13:14:47'),
(601, 'transparansi/keuangan', 14, 28.00, 5, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:15:00', '2026-01-22 13:15:00'),
(602, 'display', 506, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:15:06', '2026-01-22 13:15:06'),
(603, '/', 129, 28.00, 6, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:15:29', '2026-01-22 13:15:29'),
(604, 'settings', 9, 28.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:15:37', '2026-01-22 13:15:37'),
(605, 'settings', 33, 28.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:15:38', '2026-01-22 13:15:38'),
(606, 'users', 39, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:15:49', '2026-01-22 13:15:49'),
(607, 'display', 385, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:16:07', '2026-01-22 13:16:07'),
(608, 'display', 3204, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:17:10', '2026-01-22 13:17:10'),
(609, '/', 150, 30.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:17:10', '2026-01-22 13:17:10'),
(610, 'display', 141, 30.00, 8, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:17:11', '2026-01-22 13:17:11'),
(611, 'transparansi/keuangan', 15, 28.00, 5, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:17:14', '2026-01-22 13:17:14'),
(612, '/', 122, 28.00, 6, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:17:18', '2026-01-22 13:17:18'),
(613, 'display', 220, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:18:12', '2026-01-22 13:18:12'),
(614, 'display', 3115, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:19:16', '2026-01-22 13:19:16'),
(615, 'display', 194, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:20:14', '2026-01-22 13:20:14'),
(616, 'display', 186, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:21:14', '2026-01-22 13:21:14'),
(617, 'display', 223, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:22:15', '2026-01-22 13:22:15'),
(618, 'display', 402, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:23:15', '2026-01-22 13:23:15'),
(619, 'display', 261, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:24:15', '2026-01-22 13:24:15'),
(620, 'display', 503, 30.00, 8, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:24:16', '2026-01-22 13:24:16'),
(621, 'users', 25, 28.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:24:49', '2026-01-22 13:24:49'),
(622, 'settings', 10, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:24:56', '2026-01-22 13:24:56'),
(623, 'users', 6, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:24:59', '2026-01-22 13:24:59'),
(624, 'display', 1246, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:25:17', '2026-01-22 13:25:17'),
(625, 'users/2/impersonate', 22, 26.00, 1, 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:25:25', '2026-01-22 13:25:25'),
(626, 'dashboard', 36, 28.00, 25, 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:25:25', '2026-01-22 13:25:25'),
(627, 'approvals', 6, 26.00, 1, 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:25:28', '2026-01-22 13:25:28'),
(628, 'dashboard', 13, 26.00, 10, 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:25:29', '2026-01-22 13:25:29'),
(629, 'users/stop-impersonation', 5, 26.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:25:34', '2026-01-22 13:25:34'),
(630, 'dashboard', 43, 28.00, 46, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:25:34', '2026-01-22 13:25:34'),
(631, 'users', 6, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:25:37', '2026-01-22 13:25:37'),
(632, 'users/3/impersonate', 5, 26.00, 1, 3, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:25:41', '2026-01-22 13:25:41'),
(633, 'dashboard', 14, 26.00, 10, 3, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:25:41', '2026-01-22 13:25:41'),
(634, 'keuangan', 125, 28.00, 18, 3, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:25:44', '2026-01-22 13:25:44'),
(635, 'transactions', 49, 28.00, 3, 3, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:25:49', '2026-01-22 13:25:49'),
(636, 'zakat', 39, 28.00, 7, 3, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:25:54', '2026-01-22 13:25:54'),
(637, 'qurban', 15, 28.00, 11, 3, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:25:58', '2026-01-22 13:25:58'),
(638, 'users/stop-impersonation', 5, 28.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:26:00', '2026-01-22 13:26:00'),
(639, 'dashboard', 13, 26.00, 11, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:26:00', '2026-01-22 13:26:00'),
(640, 'users', 6, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:26:05', '2026-01-22 13:26:05'),
(641, 'users/4/impersonate', 5, 26.00, 1, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:26:09', '2026-01-22 13:26:09'),
(642, 'dashboard', 11, 26.00, 4, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:26:10', '2026-01-22 13:26:10'),
(643, 'users/stop-impersonation', 6, 26.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:26:12', '2026-01-22 13:26:12'),
(644, 'dashboard', 13, 26.00, 11, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:26:13', '2026-01-22 13:26:13'),
(645, 'display', 192, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:26:17', '2026-01-22 13:26:17'),
(646, 'users', 6, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:26:18', '2026-01-22 13:26:18'),
(647, 'users/5/impersonate', 5, 26.00, 1, 5, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:26:22', '2026-01-22 13:26:22'),
(648, 'dashboard', 8, 26.00, 4, 5, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:26:22', '2026-01-22 13:26:22'),
(649, 'friday-schedules', 9, 26.00, 2, 5, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:26:25', '2026-01-22 13:26:25'),
(650, 'agendas', 12, 26.00, 2, 5, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:26:26', '2026-01-22 13:26:26'),
(651, 'slides', 8, 26.00, 1, 5, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:26:29', '2026-01-22 13:26:29'),
(652, 'assets', 7, 26.00, 1, 5, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:26:30', '2026-01-22 13:26:30'),
(653, 'dashboard', 7, 26.00, 4, 5, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:26:33', '2026-01-22 13:26:33'),
(654, 'display', 140, 30.00, 8, 5, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:26:37', '2026-01-22 13:26:37'),
(655, 'slides', 7, 26.00, 1, 5, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:26:39', '2026-01-22 13:26:39'),
(656, 'slides', 7, 26.00, 1, 5, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:26:40', '2026-01-22 13:26:40'),
(657, 'slides', 7, 26.00, 1, 5, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:26:43', '2026-01-22 13:26:43'),
(658, 'assets', 12, 26.00, 1, 5, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:26:43', '2026-01-22 13:26:43'),
(659, 'slides', 7, 26.00, 1, 5, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:26:45', '2026-01-22 13:26:45'),
(660, 'agendas', 10, 26.00, 2, 5, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:26:47', '2026-01-22 13:26:47'),
(661, 'friday-schedules', 9, 26.00, 2, 5, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:26:48', '2026-01-22 13:26:48'),
(662, 'dashboard', 16, 26.00, 4, 5, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:26:49', '2026-01-22 13:26:49'),
(663, 'assets', 8, 26.00, 1, 5, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:26:55', '2026-01-22 13:26:55'),
(664, 'dashboard', 8, 26.00, 4, 5, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:26:57', '2026-01-22 13:26:57'),
(665, 'users/stop-impersonation', 5, 26.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:27:05', '2026-01-22 13:27:05'),
(666, 'dashboard', 14, 26.00, 11, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:27:05', '2026-01-22 13:27:05'),
(667, 'display', 501, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:27:18', '2026-01-22 13:27:18'),
(668, 'dashboard', 13, 26.00, 11, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:27:25', '2026-01-22 13:27:25'),
(669, 'users', 7, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:27:28', '2026-01-22 13:27:28'),
(670, 'posts', 11, 26.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:27:35', '2026-01-22 13:27:35'),
(671, 'dashboard', 14, 26.00, 11, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:27:37', '2026-01-22 13:27:37'),
(672, 'approvals', 6, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:27:39', '2026-01-22 13:27:39'),
(673, 'keuangan', 19, 28.00, 18, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:27:41', '2026-01-22 13:27:41'),
(674, 'dashboard', 13, 26.00, 11, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:27:42', '2026-01-22 13:27:42'),
(675, 'posts', 10, 26.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:27:57', '2026-01-22 13:27:57'),
(676, 'display', 183, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:28:17', '2026-01-22 13:28:17'),
(677, 'display', 457, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:29:18', '2026-01-22 13:29:18'),
(678, 'users', 6, 28.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:29:20', '2026-01-22 13:29:20'),
(679, 'users/2/impersonate', 6, 26.00, 1, 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:29:24', '2026-01-22 13:29:24'),
(680, 'dashboard', 13, 26.00, 10, 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:29:24', '2026-01-22 13:29:24'),
(681, 'approvals', 6, 26.00, 1, 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:29:25', '2026-01-22 13:29:25'),
(682, 'dashboard', 13, 26.00, 10, 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:29:28', '2026-01-22 13:29:28'),
(683, 'dashboard', 13, 26.00, 10, 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:29:28', '2026-01-22 13:29:28'),
(684, 'users/stop-impersonation', 5, 26.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:29:42', '2026-01-22 13:29:42'),
(685, 'dashboard', 12, 26.00, 11, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:29:43', '2026-01-22 13:29:43'),
(686, 'display', 189, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:30:18', '2026-01-22 13:30:18'),
(687, 'display', 526, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:31:19', '2026-01-22 13:31:19'),
(688, 'users', 9, 28.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:31:29', '2026-01-22 13:31:29'),
(689, 'users/2/impersonate', 7, 26.00, 1, 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:31:33', '2026-01-22 13:31:33'),
(690, 'dashboard', 25, 28.00, 27, 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:31:33', '2026-01-22 13:31:33'),
(691, 'display', 375, 28.00, 7, 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:32:19', '2026-01-22 13:32:19'),
(692, 'transactions', 14, 28.00, 3, 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:32:23', '2026-01-22 13:32:23'),
(693, 'dashboard', 12, 28.00, 10, 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:32:31', '2026-01-22 13:32:31'),
(694, 'dashboard', 34, 28.00, 11, 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:32:41', '2026-01-22 13:32:41'),
(695, 'dashboard', 30, 28.00, 11, 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:32:58', '2026-01-22 13:32:58'),
(696, 'display', 180, 28.00, 7, 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:33:19', '2026-01-22 13:33:19'),
(697, 'dashboard', 32, 28.00, 11, 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:33:28', '2026-01-22 13:33:28'),
(698, 'dashboard', 30, 28.00, 11, 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:33:29', '2026-01-22 13:33:29'),
(699, 'approvals', 7, 26.00, 1, 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:33:31', '2026-01-22 13:33:31'),
(700, 'approvals', 24, 28.00, 2, 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:34:15', '2026-01-22 13:34:15'),
(701, 'posts', 10, 26.00, 2, 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:34:17', '2026-01-22 13:34:17'),
(702, 'display', 220, 28.00, 7, 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:34:20', '2026-01-22 13:34:20'),
(703, 'display', 142, 30.00, 8, 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:34:20', '2026-01-22 13:34:20'),
(704, 'display', 249, 28.00, 7, 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:35:21', '2026-01-22 13:35:21'),
(705, 'users/stop-impersonation', 6, 26.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:35:46', '2026-01-22 13:35:46'),
(706, 'dashboard', 49, 28.00, 46, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:35:46', '2026-01-22 13:35:46'),
(707, 'users', 6, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:35:49', '2026-01-22 13:35:49'),
(708, 'settings', 10, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:36:18', '2026-01-22 13:36:18'),
(709, 'display', 571, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:36:22', '2026-01-22 13:36:22'),
(710, 'users', 9, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:36:37', '2026-01-22 13:36:37'),
(711, 'display', 506, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:37:22', '2026-01-22 13:37:22'),
(712, 'posts', 12, 26.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:38:00', '2026-01-22 13:38:00'),
(713, 'display', 681, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:38:22', '2026-01-22 13:38:22'),
(714, 'display', 477, 30.00, 8, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:38:23', '2026-01-22 13:38:23'),
(715, 'posts', 27, 28.00, 3, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:38:25', '2026-01-22 13:38:25'),
(716, 'posts', 27, 28.00, 3, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:38:26', '2026-01-22 13:38:26'),
(717, 'posts', 27, 28.00, 3, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:38:54', '2026-01-22 13:38:54'),
(718, 'posts', 27, 28.00, 3, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:38:56', '2026-01-22 13:38:56'),
(719, 'posts', 26, 28.00, 3, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:38:56', '2026-01-22 13:38:56'),
(720, 'posts', 26, 28.00, 3, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:38:57', '2026-01-22 13:38:57'),
(721, 'posts/4', 102, 28.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:39:10', '2026-01-22 13:39:10'),
(722, 'posts', 11, 26.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:39:10', '2026-01-22 13:39:10'),
(723, '/', 146, 30.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:39:17', '2026-01-22 13:39:17'),
(724, 'berita/kajian-rutin-malam-ahad-69721b0ed684f', 7, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:39:19', '2026-01-22 13:39:19'),
(725, 'display', 187, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:39:24', '2026-01-22 13:39:24'),
(726, 'posts/1', 14, 28.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:39:37', '2026-01-22 13:39:37'),
(727, 'posts', 12, 26.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:39:37', '2026-01-22 13:39:37'),
(728, '/', 104, 28.00, 6, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:39:40', '2026-01-22 13:39:40'),
(729, 'berita', 11, 28.00, 3, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:39:45', '2026-01-22 13:39:45'),
(730, 'berita', 11, 28.00, 3, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:39:52', '2026-01-22 13:39:52'),
(731, '/', 131, 28.00, 6, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:39:54', '2026-01-22 13:39:54'),
(732, 'transparansi/aset', 9, 28.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:40:06', '2026-01-22 13:40:06'),
(733, 'users', 6, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:40:13', '2026-01-22 13:40:13'),
(734, 'display', 182, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:40:25', '2026-01-22 13:40:25'),
(735, 'slides', 7, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:40:45', '2026-01-22 13:40:45'),
(736, 'assets', 7, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:40:48', '2026-01-22 13:40:48'),
(737, 'display', 173, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:41:26', '2026-01-22 13:41:26'),
(738, 'assets/1', 17, 28.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:41:33', '2026-01-22 13:41:33'),
(739, 'assets', 10, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:41:34', '2026-01-22 13:41:34'),
(740, 'display', 185, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:42:27', '2026-01-22 13:42:27'),
(741, 'users', 7, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:43:01', '2026-01-22 13:43:01'),
(742, 'users', 29, 28.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:43:01', '2026-01-22 13:43:01'),
(743, 'users/4', 10, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:43:06', '2026-01-22 13:43:06'),
(744, 'users', 6, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:43:06', '2026-01-22 13:43:06'),
(745, 'assets', 7, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:43:19', '2026-01-22 13:43:19'),
(746, 'display', 249, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:43:27', '2026-01-22 13:43:27'),
(747, 'display', 139, 30.00, 8, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:43:27', '2026-01-22 13:43:27'),
(748, 'display', 223, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:44:29', '2026-01-22 13:44:29'),
(749, 'display', 178, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:45:29', '2026-01-22 13:45:29'),
(750, 'assets', 31, 28.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:46:30', '2026-01-22 13:46:30'),
(751, 'display', 406, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:46:31', '2026-01-22 13:46:31'),
(752, 'assets', 8, 26.00, 1, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:46:36', '2026-01-22 13:46:36'),
(753, 'display', 185, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:47:30', '2026-01-22 13:47:30'),
(754, 'display', 190, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:48:31', '2026-01-22 13:48:31'),
(755, 'display', 545, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:49:32', '2026-01-22 13:49:32'),
(756, 'display', 544, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:50:33', '2026-01-22 13:50:33'),
(757, 'assets', 32, 28.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:51:22', '2026-01-22 13:51:22'),
(758, 'assets/export', 2124, 38.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:51:26', '2026-01-22 13:51:26'),
(759, 'assets/export', 393, 38.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:51:27', '2026-01-22 13:51:27'),
(760, 'assets/export', 389, 38.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:51:28', '2026-01-22 13:51:28'),
(761, 'assets/export', 383, 38.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:51:28', '2026-01-22 13:51:28'),
(762, 'assets/export', 434, 38.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:51:29', '2026-01-22 13:51:29'),
(763, 'assets/export', 369, 38.00, 2, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:51:30', '2026-01-22 13:51:30'),
(764, 'display', 185, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:51:33', '2026-01-22 13:51:33'),
(765, 'display', 146, 30.00, 8, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:51:33', '2026-01-22 13:51:33'),
(766, 'display', 183, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:52:34', '2026-01-22 13:52:34'),
(767, 'display', 197, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:53:34', '2026-01-22 13:53:34'),
(768, 'display', 184, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:54:34', '2026-01-22 13:54:34'),
(769, 'display', 269, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:55:34', '2026-01-22 13:55:34'),
(770, 'display', 3126, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:56:37', '2026-01-22 13:56:37'),
(771, 'display', 121, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:57:35', '2026-01-22 13:57:35'),
(772, 'display', 3109, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:58:39', '2026-01-22 13:58:39'),
(773, 'display', 503, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 13:59:37', '2026-01-22 13:59:37'),
(774, 'display', 221, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 14:00:37', '2026-01-22 14:00:37'),
(775, 'display', 229, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 14:01:37', '2026-01-22 14:01:37'),
(776, 'display', 180, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 14:02:38', '2026-01-22 14:02:38'),
(777, 'display', 185, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 14:03:38', '2026-01-22 14:03:38'),
(778, 'display', 3130, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 14:04:41', '2026-01-22 14:04:41'),
(779, 'display', 122, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 14:05:38', '2026-01-22 14:05:38'),
(780, 'display', 220, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 14:06:39', '2026-01-22 14:06:39'),
(781, 'display', 185, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 14:07:39', '2026-01-22 14:07:39'),
(782, 'display', 228, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 14:08:39', '2026-01-22 14:08:39'),
(783, 'display', 174, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 14:09:40', '2026-01-22 14:09:40'),
(784, 'display', 3131, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 14:10:43', '2026-01-22 14:10:43'),
(785, 'display', 441, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 14:11:41', '2026-01-22 14:11:41'),
(786, 'display', 208, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 14:12:41', '2026-01-22 14:12:41'),
(787, 'display', 189, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 14:13:42', '2026-01-22 14:13:42'),
(788, 'display', 519, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 14:14:42', '2026-01-22 14:14:42'),
(789, 'display', 196, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 14:15:42', '2026-01-22 14:15:42'),
(790, 'display', 193, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 14:16:43', '2026-01-22 14:16:43'),
(791, 'display', 515, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 14:17:43', '2026-01-22 14:17:43'),
(792, 'display', 222, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 14:18:44', '2026-01-22 14:18:44'),
(793, 'display', 182, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 14:19:44', '2026-01-22 14:19:44'),
(794, 'display', 497, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 14:20:44', '2026-01-22 14:20:44'),
(795, 'display', 183, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 14:21:44', '2026-01-22 14:21:44'),
(796, 'display', 198, 28.00, 7, 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-01-22 14:22:44', '2026-01-22 14:22:44');

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` text NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `posts`
--

CREATE TABLE `posts` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `excerpt` text DEFAULT NULL,
  `content` longtext NOT NULL,
  `image_path` varchar(255) DEFAULT NULL,
  `author_id` bigint(20) UNSIGNED NOT NULL,
  `published_at` timestamp NULL DEFAULT NULL,
  `is_published` tinyint(1) NOT NULL DEFAULT 0,
  `views` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `posts`
--

INSERT INTO `posts` (`id`, `title`, `slug`, `excerpt`, `content`, `image_path`, `author_id`, `published_at`, `is_published`, `views`, `created_at`, `updated_at`) VALUES
(1, 'Kegiatan Santunan Anak Yatim', 'kegiatan-santunan-anak-yatim-6972289922a0a', 'Alhamdulillah, telah terlaksana kegiatan santunan anak yatim bulanan masjid.', 'Alhamdulillah, pada hari Jumat lalu telah terlaksana kegiatan santunan anak yatim. Sebanyak 50 anak yatim mendapatkan santunan berupa paket sembako dan uang tunai. Terima kasih kepada para donatur yang telah menyisihkan sebagian rezekinya. Semoga Allah membalas dengan kebaikan yang berlipat ganda.', 'posts/Q7JqqvXylNRohxl8kAkNLaq9hfxxCiOTOdQveMZz.png', 1, '2026-01-01 05:34:00', 1, 0, '2026-01-22 12:34:48', '2026-01-22 13:39:37'),
(2, 'Kajian Rutin Malam Ahad', 'kajian-rutin-malam-ahad-69721b0ed684f', 'Jangan lewatkan kajian rutin setiap malam Ahad bersama Ustadz Fulan.', 'Hadirilah kajian rutin pembahasan Kitab Riyadhus Shalihin setiap malam Ahad ba\'da maghrib. Kajian akan diisi oleh Ustadz Fulan bin Fulan. Mari ajak keluarga dan sahabat untuk memakmurkan masjid kita tercinta.', 'posts/zDImYavLxDN8gE0b3mGo0NtZbDnFgyCX4fIrBolH.png', 1, '2026-01-17 12:34:48', 1, 0, '2026-01-22 12:34:48', '2026-01-22 12:41:50'),
(3, 'Renovasi Tempat Wudhu', 'renovasi-tempat-wudhu-69721b146f7f9', 'Progress renovasi tempat wudhu wanita sudah mencapai 80%.', 'Kami informasikan bahwa renovasi tempat wudhu wanita saat ini sudah mencapai tahap penyelesaian keramik dinidng dan lantai. Insya Allah dalam 2 minggu ke depan sudah dapat digunakan kembali dengan lebih nyaman. Mohon doanya agar pembangunan berjalan lancar.', 'posts/p9bOYIz2BtN4s9qGRl52LMUDYHA6Q85y7LH7Gcqs.png', 1, '2026-01-15 12:34:48', 1, 0, '2026-01-22 12:34:48', '2026-01-22 12:41:56'),
(4, 'Kajian Rutin Malam Ahad', 'kajian-rutin-malam-ahad-6972287e091d6', 'Kajian Rutin Malam AhadKajian Rutin Malam AhadKajian Rutin Malam AhadKajian Rutin Malam AhadKajian Rutin Malam Ahad', 'Kajian Rutin Malam AhadKajian Rutin Malam AhadKajian Rutin Malam AhadKajian Rutin Malam AhadKajian Rutin Malam AhadKajian Rutin Malam AhadKajian Rutin Malam AhadKajian Rutin Malam AhadKajian Rutin Malam AhadKajian Rutin Malam AhadKajian Rutin Malam AhadKajian Rutin Malam AhadKajian Rutin Malam AhadKajian Rutin Malam AhadKajian Rutin Malam AhadKajian Rutin Malam Ahad', 'posts/50iA9greTltzaCtLE8Rq6nSoSmukXlyd2Qaxwmlw.png', 1, '2026-01-20 06:45:00', 1, 0, '2026-01-22 12:45:14', '2026-01-22 13:39:10');

-- --------------------------------------------------------

--
-- Table structure for table `prayer_times`
--

CREATE TABLE `prayer_times` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `date` date NOT NULL COMMENT 'Gregorian date',
  `hijri_date` varchar(50) DEFAULT NULL COMMENT 'Hijri date (e.g., 15 Rajab 1448)',
  `subuh` time NOT NULL COMMENT 'Subuh/Fajr prayer time',
  `sunrise` time NOT NULL COMMENT 'Sunrise time',
  `dhuhr` time NOT NULL COMMENT 'Dhuhr/Zuhr prayer time',
  `asr` time NOT NULL COMMENT 'Asr prayer time',
  `maghrib` time NOT NULL COMMENT 'Maghrib prayer time',
  `isha` time NOT NULL COMMENT 'Isha prayer time',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `prayer_times`
--

INSERT INTO `prayer_times` (`id`, `date`, `hijri_date`, `subuh`, `sunrise`, `dhuhr`, `asr`, `maghrib`, `isha`, `created_at`, `updated_at`) VALUES
(1, '2026-01-22', '20 Rajab 1448', '04:30:00', '05:45:00', '12:00:00', '15:15:00', '18:20:00', '19:30:00', '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(2, '2026-01-23', '21 Rajab 1448', '04:31:00', '05:46:00', '12:01:00', '15:16:00', '18:21:00', '19:31:00', '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(3, '2026-01-24', '22 Rajab 1448', '04:32:00', '05:47:00', '12:02:00', '15:17:00', '18:22:00', '19:32:00', '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(4, '2026-01-25', '23 Rajab 1448', '04:33:00', '05:48:00', '12:03:00', '15:18:00', '18:23:00', '19:33:00', '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(5, '2026-01-26', '24 Rajab 1448', '04:34:00', '05:49:00', '12:04:00', '15:19:00', '18:24:00', '19:34:00', '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(6, '2026-01-27', '25 Rajab 1448', '04:30:00', '05:45:00', '12:05:00', '15:20:00', '18:25:00', '19:35:00', '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(7, '2026-01-28', '26 Rajab 1448', '04:31:00', '05:46:00', '12:06:00', '15:21:00', '18:26:00', '19:36:00', '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(8, '2026-01-29', '27 Rajab 1448', '04:32:00', '05:47:00', '12:07:00', '15:22:00', '18:27:00', '19:37:00', '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(9, '2026-01-30', '28 Rajab 1448', '04:33:00', '05:48:00', '12:08:00', '15:23:00', '18:28:00', '19:38:00', '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(10, '2026-01-31', '29 Rajab 1448', '04:34:00', '05:49:00', '12:09:00', '15:24:00', '18:29:00', '19:39:00', '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(11, '2026-02-01', '30 Rajab 1448', '04:30:00', '05:45:00', '12:00:00', '15:15:00', '18:20:00', '19:30:00', '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(12, '2026-02-02', '31 Rajab 1448', '04:31:00', '05:46:00', '12:01:00', '15:16:00', '18:21:00', '19:31:00', '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(13, '2026-02-03', '32 Rajab 1448', '04:32:00', '05:47:00', '12:02:00', '15:17:00', '18:22:00', '19:32:00', '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(14, '2026-02-04', '33 Rajab 1448', '04:33:00', '05:48:00', '12:03:00', '15:18:00', '18:23:00', '19:33:00', '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(15, '2026-02-05', '34 Rajab 1448', '04:34:00', '05:49:00', '12:04:00', '15:19:00', '18:24:00', '19:34:00', '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(16, '2026-02-06', '35 Rajab 1448', '04:30:00', '05:45:00', '12:05:00', '15:20:00', '18:25:00', '19:35:00', '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(17, '2026-02-07', '36 Rajab 1448', '04:31:00', '05:46:00', '12:06:00', '15:21:00', '18:26:00', '19:36:00', '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(18, '2026-02-08', '37 Rajab 1448', '04:32:00', '05:47:00', '12:07:00', '15:22:00', '18:27:00', '19:37:00', '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(19, '2026-02-09', '38 Rajab 1448', '04:33:00', '05:48:00', '12:08:00', '15:23:00', '18:28:00', '19:38:00', '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(20, '2026-02-10', '39 Rajab 1448', '04:34:00', '05:49:00', '12:09:00', '15:24:00', '18:29:00', '19:39:00', '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(21, '2026-02-11', '40 Rajab 1448', '04:30:00', '05:45:00', '12:00:00', '15:15:00', '18:20:00', '19:30:00', '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(22, '2026-02-12', '41 Rajab 1448', '04:31:00', '05:46:00', '12:01:00', '15:16:00', '18:21:00', '19:31:00', '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(23, '2026-02-13', '42 Rajab 1448', '04:32:00', '05:47:00', '12:02:00', '15:17:00', '18:22:00', '19:32:00', '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(24, '2026-02-14', '43 Rajab 1448', '04:33:00', '05:48:00', '12:03:00', '15:18:00', '18:23:00', '19:33:00', '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(25, '2026-02-15', '44 Rajab 1448', '04:34:00', '05:49:00', '12:04:00', '15:19:00', '18:24:00', '19:34:00', '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(26, '2026-02-16', '45 Rajab 1448', '04:30:00', '05:45:00', '12:05:00', '15:20:00', '18:25:00', '19:35:00', '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(27, '2026-02-17', '46 Rajab 1448', '04:31:00', '05:46:00', '12:06:00', '15:21:00', '18:26:00', '19:36:00', '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(28, '2026-02-18', '47 Rajab 1448', '04:32:00', '05:47:00', '12:07:00', '15:22:00', '18:27:00', '19:37:00', '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(29, '2026-02-19', '48 Rajab 1448', '04:33:00', '05:48:00', '12:08:00', '15:23:00', '18:28:00', '19:38:00', '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(30, '2026-02-20', '49 Rajab 1448', '04:34:00', '05:49:00', '12:09:00', '15:24:00', '18:29:00', '19:39:00', '2026-01-22 08:26:13', '2026-01-22 08:26:13');

-- --------------------------------------------------------

--
-- Table structure for table `qurbans`
--

CREATE TABLE `qurbans` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL,
  `participant_name` varchar(255) NOT NULL,
  `participant_nik` varchar(255) DEFAULT NULL,
  `participant_phone` varchar(255) NOT NULL,
  `participant_address` text DEFAULT NULL,
  `animal_type` enum('kambing','domba','sapi','kerbau','unta') NOT NULL,
  `animal_weight` decimal(10,2) DEFAULT NULL,
  `animal_price` decimal(15,2) NOT NULL,
  `is_shared` tinyint(1) NOT NULL DEFAULT 0,
  `share_count` int(11) NOT NULL DEFAULT 1,
  `share_position` int(11) DEFAULT NULL,
  `share_group_id` varchar(255) DEFAULT NULL,
  `status` enum('registered','paid','slaughtered','distributed') NOT NULL DEFAULT 'registered',
  `year` int(11) NOT NULL,
  `registration_date` date NOT NULL,
  `notes` text DEFAULT NULL,
  `registered_by` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `qurbans`
--

INSERT INTO `qurbans` (`id`, `uuid`, `participant_name`, `participant_nik`, `participant_phone`, `participant_address`, `animal_type`, `animal_weight`, `animal_price`, `is_shared`, `share_count`, `share_position`, `share_group_id`, `status`, `year`, `registration_date`, `notes`, `registered_by`, `created_at`, `updated_at`) VALUES
(1, '5c6fc7c6-102b-440e-9d8d-2c6624746528', 'Haji Ahmad', NULL, '081212341234', NULL, 'sapi', NULL, 21000000.00, 0, 1, NULL, NULL, 'paid', 1446, '2025-08-15', NULL, 3, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(2, '4596b7fd-9036-472e-8ba7-fba4db739010', 'Pak Budi', NULL, '081223452345', NULL, 'kambing', NULL, 3000000.00, 0, 1, NULL, NULL, 'paid', 1446, '2025-08-16', NULL, 3, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(3, '45e8b492-abeb-45ea-9626-040d198bf026', 'Ibu Siti', NULL, '081234563456', NULL, 'sapi', NULL, 3000000.00, 1, 7, NULL, '776f4acc-8e7b-4102-a658-c27e649169f6', 'paid', 1446, '2025-08-17', NULL, 3, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(4, '2b2e924d-267c-4375-bc31-ada729f2a5f4', 'Keluarga Rahman', NULL, '081245674567', NULL, 'kambing', NULL, 2500000.00, 0, 1, NULL, NULL, 'registered', 1446, '2025-08-18', NULL, 3, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(5, '98ff7041-01b8-4add-aedb-d09a09846ac4', 'Dr. Hendra', NULL, '081256785678', NULL, 'sapi', NULL, 22000000.00, 0, 1, NULL, NULL, 'paid', 1446, '2025-08-19', NULL, 3, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(6, 'ac161fa2-7d9f-4662-9b3b-38555f09bd17', 'Ibu Dewi', NULL, '081267896789', NULL, 'sapi', NULL, 3000000.00, 1, 7, NULL, '7742c1cd-744a-48e7-b500-506ffc073a4e', 'paid', 1446, '2025-08-20', NULL, 3, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(7, '18894602-697a-4768-8faa-856559a17320', 'Pak Yusuf', NULL, '081278907890', NULL, 'kambing', NULL, 3500000.00, 0, 1, NULL, NULL, 'registered', 1446, '2025-08-21', NULL, 3, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(8, '229f2dcf-0f8b-4acf-990e-60fc9ffe38e8', 'Haji Ismail', NULL, '081289018901', NULL, 'sapi', NULL, 23000000.00, 0, 1, NULL, NULL, 'paid', 1446, '2025-08-22', NULL, 3, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(9, '9d4b4cf8-676c-4cb3-9306-3d6d24255dc6', 'Ibu Fatimah', NULL, '081290129012', NULL, 'kambing', NULL, 2800000.00, 0, 1, NULL, NULL, 'paid', 1446, '2025-08-23', NULL, 3, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(10, 'ce2043ed-3d8b-4aa0-b02a-4c2c0b84b4ac', 'Keluarga Hakim', NULL, '081201230123', NULL, 'sapi', NULL, 21500000.00, 0, 1, NULL, NULL, 'paid', 1446, '2025-08-24', NULL, 3, '2026-01-22 08:26:13', '2026-01-22 08:26:13');

-- --------------------------------------------------------

--
-- Table structure for table `qurban_distributions`
--

CREATE TABLE `qurban_distributions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL,
  `qurban_id` bigint(20) UNSIGNED NOT NULL,
  `recipient_name` varchar(255) NOT NULL,
  `recipient_type` enum('mustahik','aqiqah','participant','masjid') NOT NULL,
  `meat_kg` decimal(10,2) NOT NULL,
  `date` date NOT NULL,
  `notes` text DEFAULT NULL,
  `distributed_by` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('1pQ4NtfXGpW1NhQSX3BY0joRaRoaURfgpJ9i9JMr', NULL, '192.175.111.235', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoia2tsbXlLbmIydGVISkQ2Y3lQaTlzUWdJOExzRnFta25sUWNuTDB2TSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzc6Imh0dHBzOi8vbWFzamlkdmlzaW9uLnllc3N5bWFyem9uYS5jb20iO3M6NToicm91dGUiO3M6Nzoid2VsY29tZSI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1769094251),
('2xgAwVA8Yb6wTAhPcmlEWfgAt9Ihz6o5ZTyk0JqT', NULL, '16.145.8.185', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/144.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTVBXS09RMzNLWGlIUGczaUpBMjh1R1NZd3VLYjU5b3UxVjFBV3VhZSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzc6Imh0dHBzOi8vbWFzamlkdmlzaW9uLnllc3N5bWFyem9uYS5jb20iO3M6NToicm91dGUiO3M6Nzoid2VsY29tZSI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1769095941),
('52wWZUGTo2Lf3S7jBTYBOZc5xhcTfVCOTx8isNq4', NULL, '192.175.111.228', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiQlBnTGtNdDJsQ2lkZFAxbURoQmQwRGRoVXQ3N0JqakhaeHF0WDJYQyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzc6Imh0dHBzOi8vbWFzamlkdmlzaW9uLnllc3N5bWFyem9uYS5jb20iO3M6NToicm91dGUiO3M6Nzoid2VsY29tZSI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1769094241),
('56bNKQxzQBJ4mvlZbJS9pzhYxZwsz8aoHJnHKY5P', NULL, '34.217.31.201', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/144.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoidG12MHNYeGhuTTRpU0RVSGhSb095UjJWRWFZWnZmWDRiU2dnczJUSSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzc6Imh0dHBzOi8vbWFzamlkdmlzaW9uLnllc3N5bWFyem9uYS5jb20iO3M6NToicm91dGUiO3M6Nzoid2VsY29tZSI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1769092778),
('8sSpXwGkeJ7dTBuTdK992p2yKu0mo4hiiFa1tjhX', NULL, '103.144.227.222', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Mobile Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTHo0a2ZLYTJoNnV4aDBPUE4zd1hrSFMyY2dtSkx5VkFycnVMbEdEOCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzc6Imh0dHBzOi8vbWFzamlkdmlzaW9uLnllc3N5bWFyem9uYS5jb20iO3M6NToicm91dGUiO3M6Nzoid2VsY29tZSI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1769092637),
('dUU4sd9p58FPR9yCFFOKJ64qWMM9Egy5Id4FjNJH', NULL, '64.15.129.100', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTmU1bDE3dkJrTVRON3dSYzIzZHlhTVp3SGVqdWVSZm1kWkFFOHZraCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzc6Imh0dHBzOi8vbWFzamlkdmlzaW9uLnllc3N5bWFyem9uYS5jb20iO3M6NToicm91dGUiO3M6Nzoid2VsY29tZSI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1769094244),
('eYUd6UOvxRJ0EN8v1srTbHvdfqNbAZqDMoqEOA7D', NULL, '2001:448a:8130:1351:b752:ffd0:4a46:9719', 'WhatsApp/2.23.20.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSWx1UlYyOWl4QVpTeDU3WkNwUHY0MmdKRVJvTnM1ZE5DZ1h5bENiMCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzc6Imh0dHBzOi8vbWFzamlkdmlzaW9uLnllc3N5bWFyem9uYS5jb20iO3M6NToicm91dGUiO3M6Nzoid2VsY29tZSI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1769092497),
('IQmNKioEDfLhb8SLIQ5ayJ4oQgW1Quo1l2c96pxQ', NULL, '16.145.8.185', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/144.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiR0xKSWltRzBNdEMyNDczYkQzWFZpczNjdHFscFZTem91WkxEUHY0ZiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzc6Imh0dHBzOi8vbWFzamlkdmlzaW9uLnllc3N5bWFyem9uYS5jb20iO3M6NToicm91dGUiO3M6Nzoid2VsY29tZSI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1769095928),
('PbYkWt0I74VMr3KzkyPmrK5DRyxHKnX2ED8ii3Pg', NULL, '44.247.243.88', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/144.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiUFBRQ052b0d2blJWdGl2ZXhNRjZ2OTBOdDVtYlVoRDRPYzRIZTlCbyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzc6Imh0dHBzOi8vbWFzamlkdmlzaW9uLnllc3N5bWFyem9uYS5jb20iO3M6NToicm91dGUiO3M6Nzoid2VsY29tZSI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1769094225),
('pLb2XgnK1Ny9Q7m0KAkDMhnGJnIcFwtbDkof7rVK', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiZGFhRDc2Ujh4VHlNeW8xUFV5bEhhcVRoWGxqNkF5cVk5ZE9FOXdlNCI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czozMDoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3NldHRpbmdzIjt9czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjc6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9sb2dpbiI7czo1OiJyb3V0ZSI7czo1OiJsb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1769085400),
('Sr2S9eYlTC54G395Dwfv8WfFqb9oRHrDOgmHhvFM', NULL, '2001:448a:8130:1351:c845:98ac:e274:9696', 'WhatsApp/2.2587.9 W', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZjM1R3pGcWNhTU5rMkhpN3VmZ1JSb3dDbjZ4NU5iclZDZTVJNHFBZCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzc6Imh0dHBzOi8vbWFzamlkdmlzaW9uLnllc3N5bWFyem9uYS5jb20iO3M6NToicm91dGUiO3M6Nzoid2VsY29tZSI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1769092273),
('tIxhmmYoW292zUVQsk6GBiVt7rEiojnwC7Cv4fvQ', NULL, '64.15.129.113', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVzhuY3NVb1pIWWUyeHVsUnpRY2pVYzY1Q2dVNk9uVW1sYVNlSGpCOCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzc6Imh0dHBzOi8vbWFzamlkdmlzaW9uLnllc3N5bWFyem9uYS5jb20iO3M6NToicm91dGUiO3M6Nzoid2VsY29tZSI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1769094252),
('wFFSzeBI54iYok80hDDrKv7mj5r7Nr3mMLiSg0Qi', NULL, '34.217.31.201', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/144.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiaVE5TnJQMGduOGZlWU1sRmVMcWlnbVV0MDhCdFNwWXY5Z1I4Um1VOCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzc6Imh0dHBzOi8vbWFzamlkdmlzaW9uLnllc3N5bWFyem9uYS5jb20iO3M6NToicm91dGUiO3M6Nzoid2VsY29tZSI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1769092766),
('Wfx7pEOVVIx5j7tW93rDbwmB55eLhOTNjZwoKXvg', NULL, '36.68.184.41', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Mobile Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibndNaTBkQjE5RmxFWWdKUGtSQ1hsZElzRk5qdDBjdlZLV3cybDlwcyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6ODI6Imh0dHBzOi8vbWFzamlkdmlzaW9uLnllc3N5bWFyem9uYS5jb20vYmVyaXRhL2thamlhbi1ydXRpbi1tYWxhbS1haGFkLTY5NzIyODdlMDkxZDYiO3M6NToicm91dGUiO3M6MTE6InB1YmxpYy5wb3N0Ijt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1769094574),
('Wjrjy9il8YzvtOhZetK8tgIhNM28WkHvw0dKnSVF', NULL, '2001:448a:8130:1351:c845:98ac:e274:9696', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSXNwWGIxWk1udEh4anZ6cTU1YVJ6UFBia0FnT0l3MnV4UzBjcVVJayI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzc6Imh0dHBzOi8vbWFzamlkdmlzaW9uLnllc3N5bWFyem9uYS5jb20iO3M6NToicm91dGUiO3M6Nzoid2VsY29tZSI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1769096982),
('X20uWqvdCnX0ydA9kKB6WPATvW1pfmAQf3cjmWd3', NULL, '44.247.243.88', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/144.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiWXQ1SXp0cVJnQ0ZzWWtvUGU2Y2FmQzdLVmg5UlpzbFJlUXdFTUxHMyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzc6Imh0dHBzOi8vbWFzamlkdmlzaW9uLnllc3N5bWFyem9uYS5jb20iO3M6NToicm91dGUiO3M6Nzoid2VsY29tZSI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1769094240),
('X4sPSMeOtArTs1nUyYdksSKbIjLLus40NU5G8TC3', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiTDJRYWJIeUpmb3VJdHNnQkJMakN5OHl3QUNrcURSMTR5RTFJRGUwQSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjk6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9kaXNwbGF5IjtzOjU6InJvdXRlIjtzOjEzOiJkaXNwbGF5LmluZGV4Ijt9czo1MDoibG9naW5fd2ViXzU5YmEzNmFkZGMyYjJmOTQwMTU4MGYwMTRjN2Y1OGVhNGUzMDk4OWQiO2k6MTt9', 1769091764);

-- --------------------------------------------------------

--
-- Table structure for table `settings`
--

CREATE TABLE `settings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `key` varchar(255) NOT NULL,
  `value` text DEFAULT NULL,
  `type` enum('text','textarea','image','boolean') NOT NULL DEFAULT 'text',
  `group` varchar(255) NOT NULL,
  `label` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `settings`
--

INSERT INTO `settings` (`id`, `key`, `value`, `type`, `group`, `label`, `created_at`, `updated_at`) VALUES
(1, 'site_name', 'pimasjid', 'text', 'general', 'Nama Masjid', '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(2, 'logo_path', '/storage/settings/XumoV2iW799vhP0rmBd7Rloc3J9thkcwwjE27eb1.png', 'image', 'general', 'Logo Masjid', '2026-01-22 08:26:13', '2026-01-22 11:07:02'),
(3, 'chairman_name', 'H. Fulan Bin Fulan', 'text', 'report', 'Nama Ketua DKM (Tanda Tangan)', '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(4, 'treasurer_name', 'Hj. Fulanah', 'text', 'report', 'Nama Bendahara (Tanda Tangan)', '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(5, 'hero_title', 'Pusat Ibadah & Kegiatan Umat', 'text', 'hero', 'Judul Hero', '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(6, 'hero_subtitle', 'pimasjid, Jl. Contoh No. 123, Jakarta Selatan', 'textarea', 'hero', 'Subjudul / Alamat Singkat', '2026-01-22 08:26:13', '2026-01-22 12:20:54'),
(7, 'hero_bg_image', 'https://images.unsplash.com/photo-1519817650390-64a93db51149?q=80&w=2000&auto=format&fit=crop', 'image', 'hero', 'Background Hero', '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(8, 'address', 'Jl. Contoh No. 123, Jakarta Selatan, DKI Jakarta 12345', 'textarea', 'contact', 'Alamat Lengkap', '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(9, 'email', 'info@masjidalhidayah.com', 'text', 'contact', 'Email', '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(10, 'phone', '+62 823 4671 9219', 'text', 'contact', 'Nomor Telepon', '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(11, 'whatsapp', '6282346719219', 'text', 'contact', 'Nomor WhatsApp (format: 62...)', '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(12, 'maps_embed_url', 'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d126907.08660340324!2d106.726588!3d-6.284028!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x2e69f0322ba7b2c7%3A0x6e6e28ce073c1d0!2sMasjid%20Istiqlal!5e0!3m2!1sid!2sid!4v1705739000000!5m2!1sid!2sid', 'textarea', 'contact', 'Link Google Maps Embed', '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(13, 'facebook_url', '#', 'text', 'social', 'Facebook URL', '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(14, 'instagram_url', '#', 'text', 'social', 'Instagram URL', '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(15, 'youtube_url', '#', 'text', 'social', 'YouTube URL', '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(16, 'footer_text', 'pimasjid adalah pusat kegiatan ibadah dan sosial kemasyarakatan yang bertujuan membangun peradaban islam yang rahmatan lil alamin.', 'textarea', 'footer', 'Teks Footer', '2026-01-22 08:26:13', '2026-01-22 12:26:17'),
(17, 'copyright_text', '© 2026 pimasjid. All rights reserved.', 'text', 'footer', 'Teks Copyright', '2026-01-22 08:26:13', '2026-01-22 12:26:51'),
(18, 'location_latitude', '-0.935255', 'text', 'location', 'Latitude (Koordinat Lintang)', '2026-01-22 08:26:13', '2026-01-22 11:31:31'),
(19, 'location_longitude', '100.429244', 'text', 'location', 'Longitude (Koordinat Bujur)', '2026-01-22 08:26:13', '2026-01-22 11:31:31'),
(20, 'location_city', 'Padang', 'text', 'location', 'Kota/Daerah', '2026-01-22 08:26:13', '2026-01-22 11:31:31'),
(21, 'location_timezone', 'Asia/Jakarta', 'text', 'location', 'Zona Waktu', '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(22, 'favicon_path', '/storage/settings/LaQehSZ0MzzU89TOYzK5ILOYIih76UerUg5PIRWd.png', 'image', 'general', 'Favicon Website', '2026-01-22 11:06:02', '2026-01-22 11:07:02'),
(23, 'about_hero_title', 'Tentang Kami', 'text', 'about', 'Judul Hero', '2026-01-22 12:19:46', '2026-01-22 12:19:46'),
(24, 'about_hero_subtitle', 'Sejarah dan visi misi pimasjid dalam melayani umat.', 'textarea', 'about', 'Subjudul Hero', '2026-01-22 12:19:46', '2026-01-22 12:26:03'),
(25, 'about_vision', 'Menjadi pusat peradaban umat yang mandiri, transparan, dan rahmatan lil \'alamin.', 'textarea', 'about', 'Visi', '2026-01-22 12:19:46', '2026-01-22 12:19:46'),
(26, 'about_mission', '1. Menyelenggarakan ibadah yang khusyuk dan nyaman.\r\n2. Mengelola dana umat secara transparan dan akuntabel.\r\n3. Memberdayakan ekonomi umat melalui program sosial.', 'textarea', 'about', 'Misi (Pisahkan dengan baris baru)', '2026-01-22 12:19:46', '2026-01-22 12:21:51'),
(27, 'about_history', 'Masjid pimasjid didirikan pada tahun 1990 di atas tanah wakaf seluas 500m2. Seiring berjalannya waktu, masjid ini mengalami renovasi besar pada tahun 2005 untuk menampung jamaah yang semakin banyak. Kini, kami terus berinovasi dengan menerapkan sistem manajemen modern untuk transparansi dan kenyamanan umat.', 'textarea', 'about', 'Sejarah Singkat', '2026-01-22 12:19:46', '2026-01-22 12:26:03'),
(28, 'about_image', '/storage/settings/BsUYdPEJWefWJc4K13RtypZr4oBXooaxNI294NCe.png', 'image', 'about', 'Gambar Utama (Tentang)', '2026-01-22 12:19:46', '2026-01-22 12:21:51'),
(29, 'donation_qris_image', '/storage/settings/ilKqtPm2752fDqjjrK1NcI0XQu1CaF6eprRLU0UL.png', 'image', 'donation', 'QRIS Code Image', '2026-01-22 13:03:40', '2026-01-22 13:11:07'),
(30, 'donation_bank_info', 'Bank Syariah Indonesia (BSI)\r\nNo. Rek: 1234599999\r\nA.n Masjid Al-Hidayah', 'textarea', 'donation', 'Informasi Rekening & NMID', '2026-01-22 13:03:40', '2026-01-22 13:11:07');

-- --------------------------------------------------------

--
-- Table structure for table `slides`
--

CREATE TABLE `slides` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(200) NOT NULL COMMENT 'Slide title',
  `content` text DEFAULT NULL COMMENT 'Slide content/description',
  `image_path` varchar(255) DEFAULT NULL COMMENT 'Path to slide image',
  `is_active` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'Whether slide is active',
  `order` int(11) NOT NULL DEFAULT 0 COMMENT 'Display order (ascending)',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `slides`
--

INSERT INTO `slides` (`id`, `title`, `content`, `image_path`, `is_active`, `order`, `created_at`, `updated_at`) VALUES
(1, 'Jadwal Sholat Hari Ini', 'Mari sholat berjamaah tepat waktu', NULL, 1, 1, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(2, 'Transparansi Keuangan', 'Laporan keuangan masjid dapat diakses melalui website', NULL, 1, 2, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(3, 'Kajian Rutin', 'Setiap Rabu malam pukul 19:30 WIB bersama Ustadz Ahmad', NULL, 1, 3, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(4, 'Infaq Jumat', 'Silakan berinfaq setiap hari Jumat untuk operasional masjid', NULL, 1, 4, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(5, 'Program Tahfidz', 'Daftarkan putra-putri Anda di program tahfidz Juz Amma', NULL, 1, 5, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(6, 'Donasi Qurban', 'Mari berqurban untuk kebaikan bersama', NULL, 0, 6, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(7, 'Kelas Tahsin', 'Perbaiki bacaan Al-Quran Anda setiap hari Jumat jam 16:00', NULL, 1, 7, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(8, 'Website Masjid', 'Kunjungi website kami untuk informasi lengkap kegiatan masjid', NULL, 1, 8, '2026-01-22 08:26:13', '2026-01-22 08:26:13');

-- --------------------------------------------------------

--
-- Table structure for table `transactions`
--

CREATE TABLE `transactions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL COMMENT 'Public identifier for sharing transaction links',
  `type` enum('income','expense') NOT NULL COMMENT 'Transaction type: income or expense',
  `category` varchar(100) NOT NULL COMMENT 'Category (e.g., Kotak Jumat, Renovasi, Operasional)',
  `amount` decimal(15,2) NOT NULL COMMENT 'Transaction amount',
  `description` text DEFAULT NULL COMMENT 'Transaction description/notes',
  `proof_image_path` varchar(255) DEFAULT NULL COMMENT 'Path to proof image (REQUIRED for expenses)',
  `verified_by` bigint(20) UNSIGNED DEFAULT NULL,
  `date` date NOT NULL COMMENT 'Transaction date',
  `status` enum('approved','pending','rejected') NOT NULL DEFAULT 'approved' COMMENT 'Approval status for large expenses',
  `approved_by` bigint(20) UNSIGNED DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL COMMENT 'Approval timestamp',
  `rejection_reason` text DEFAULT NULL COMMENT 'Reason for rejection if status is rejected',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `transactions`
--

INSERT INTO `transactions` (`id`, `uuid`, `type`, `category`, `amount`, `description`, `proof_image_path`, `verified_by`, `date`, `status`, `approved_by`, `approved_at`, `rejection_reason`, `created_at`, `updated_at`) VALUES
(1, 'a711c6fb-5b5c-4044-8e24-ccbdf6c84621', 'income', 'Infaq', 200000.00, 'Infaq Jumat pertama', NULL, 3, '2025-08-01', 'approved', NULL, '2026-01-22 08:26:13', NULL, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(2, '88a6830f-bae7-4301-a4f8-db063add67ed', 'income', 'Donasi', 5000000.00, 'Donasi dari Haji Ahmad', NULL, 3, '2025-08-15', 'approved', NULL, '2026-01-22 08:26:13', NULL, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(3, '2728208d-022d-48fd-86ac-7a38b254da6c', 'income', 'Kotak Jumat', 1500000.00, 'Kotak amal Jumat Agustus minggu ke-3', NULL, 1, '2025-08-20', 'approved', NULL, '2026-01-22 08:26:13', NULL, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(4, '33c0b666-194a-4fd0-a714-7de9a087881e', 'income', 'Zakat Fitrah', 3500000.00, 'Penerimaan zakat fitrah', NULL, 3, '2025-09-10', 'approved', NULL, '2026-01-22 08:26:13', NULL, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(5, 'e419857c-6495-4c87-917d-3ef57cd25886', 'income', 'Infaq', 750000.00, 'Infaq jumat kedua September', NULL, 1, '2025-09-12', 'approved', NULL, '2026-01-22 08:26:13', NULL, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(6, 'e0a6f8e6-9229-4d26-abcc-632c87b51b14', 'income', 'Qurban', 20000000.00, 'Penerimaan dana qurban sapi', NULL, 3, '2025-09-25', 'approved', NULL, '2026-01-22 08:26:13', NULL, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(7, 'a5d8d3ad-54d1-4a6e-982e-a12fc73e7c4a', 'income', 'Donasi', 10000000.00, 'Donasi renovasi dari warga', NULL, 3, '2025-10-05', 'approved', NULL, '2026-01-22 08:26:13', NULL, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(8, '7e61e2c6-9723-4a57-abf7-de2264ea804b', 'income', 'Kotak Jumat', 1800000.00, 'Kotak amal Jumat Oktober minggu pertama', NULL, 1, '2025-10-10', 'approved', NULL, '2026-01-22 08:26:13', NULL, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(9, '741810d1-1cd9-4be3-b392-186835230d56', 'income', 'Infaq', 500000.00, 'Infaq bulanan', NULL, 3, '2025-10-20', 'approved', NULL, '2026-01-22 08:26:13', NULL, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(10, '1edca0e1-9fc9-420c-859f-53039db41542', 'income', 'Donasi', 3000000.00, 'Donasi sound system', NULL, 1, '2025-11-01', 'approved', NULL, '2026-01-22 08:26:13', NULL, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(11, '8b99ba80-9f62-4cb9-b303-7ea8b50cafba', 'income', 'Kotak Jumat', 2000000.00, 'Kotak amal Jumat November', NULL, 1, '2025-11-15', 'approved', NULL, '2026-01-22 08:26:13', NULL, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(12, 'ff6349b7-b8ee-4a1b-afac-a6b51fb1d3d4', 'income', 'Infaq', 850000.00, 'Infaq dari jamaah', NULL, 3, '2025-11-25', 'approved', NULL, '2026-01-22 08:26:13', NULL, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(13, '107ace68-80d5-4c55-be97-932c210bfa69', 'income', 'Donasi', 7500000.00, 'Donasi karpet masjid', NULL, 3, '2025-12-05', 'approved', NULL, '2026-01-22 08:26:13', NULL, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(14, '5d3dae0c-8a10-47c7-95a7-5fb24664146b', 'income', 'Kotak Jumat', 2200000.00, 'Kotak amal Jumat Desember', NULL, 1, '2025-12-13', 'approved', NULL, '2026-01-22 08:26:13', NULL, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(15, 'd2547752-6516-4672-a47e-7ba9702203b3', 'income', 'Infaq', 950000.00, 'Infaq akhir tahun', NULL, 3, '2025-12-28', 'approved', NULL, '2026-01-22 08:26:13', NULL, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(16, 'fd087c86-6bae-4ed0-8fd6-953969d0c9c0', 'income', 'Donasi', 15000000.00, 'Donasi dari yayasan', NULL, 3, '2026-01-03', 'approved', NULL, '2026-01-22 08:26:13', NULL, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(17, '73efe486-7272-44e5-b389-228edfb5c53b', 'income', 'Kotak Jumat', 1750000.00, 'Kotak amal Jumat Januari pertama', NULL, 1, '2026-01-10', 'approved', NULL, '2026-01-22 08:26:13', NULL, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(18, 'fc9dc87f-e3a6-4711-be18-d3265b4de440', 'income', 'Infaq', 200000.00, 'Infaq jamaah', NULL, 1, '2026-01-20', 'approved', NULL, '2026-01-22 08:26:13', NULL, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(19, '902351bb-6ced-4ec9-960e-f0d49ee54067', 'income', 'Donasi', 3500000.00, 'Donasi perawatan', NULL, 3, '2026-01-22', 'approved', NULL, '2026-01-22 08:26:13', NULL, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(20, '5ea77098-2d88-4078-a860-3ff68d74b7b4', 'expense', 'Utilitas', 850000.00, 'Listrik dan air Agustus', 'transactions/default.jpg', 3, '2025-08-05', 'approved', NULL, '2026-01-22 08:26:13', NULL, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(21, '6b1ef164-89f9-4195-89ac-01b39d523baf', 'expense', 'Operasional', 500000.00, 'Kebersihan dan pemeliharaan', 'transactions/default.jpg', 1, '2025-08-12', 'approved', NULL, '2026-01-22 08:26:13', NULL, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(22, '79a57655-ece2-4966-ae7c-a735a0f860c0', 'expense', 'Konsumsi', 750000.00, 'Konsumsi kajian rutin', 'transactions/default.jpg', 1, '2025-09-01', 'approved', NULL, '2026-01-22 08:26:13', NULL, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(23, '2ff04d35-00ff-4977-b3af-b48c9554555e', 'expense', 'Utilitas', 920000.00, 'Listrik dan air September', 'transactions/default.jpg', 3, '2025-09-05', 'approved', NULL, '2026-01-22 08:26:13', NULL, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(25, '378479e1-7739-4c4b-ba37-52c80b511101', 'expense', 'Operasional', 650000.00, 'Perlengkapan ibadah', 'transactions/default.jpg', 1, '2025-10-20', 'approved', NULL, '2026-01-22 08:26:13', NULL, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(26, '9d00224e-2eb9-49cc-9d60-88ab620e4125', 'expense', 'Utilitas', 880000.00, 'Listrik dan air Oktober', 'transactions/default.jpg', 3, '2025-10-05', 'approved', NULL, '2026-01-22 08:26:13', NULL, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(27, '3d427358-5c3d-4492-aed7-6d1e0bceb624', 'expense', 'Konsumsi', 1200000.00, 'Konsumsi pengajian akbar', 'transactions/default.jpg', 1, '2025-11-08', 'approved', 1, '2026-01-22 10:58:48', NULL, '2026-01-22 08:26:13', '2026-01-22 10:58:48'),
(28, '878224e8-e7c4-4178-a4be-951cd5167d9c', 'expense', 'Operasional', 450000.00, 'ATK dan administrasi', 'transactions/default.jpg', 1, '2025-11-15', 'approved', NULL, '2026-01-22 08:26:13', NULL, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(29, '96aaad3a-246a-4f37-ad1b-4777a529731f', 'expense', 'Utilitas', 950000.00, 'Listrik dan air November', 'transactions/default.jpg', 3, '2025-11-05', 'approved', NULL, '2026-01-22 08:26:13', NULL, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(30, 'a28ff501-d593-42c9-a808-568c6e6e0e2d', 'expense', 'Renovasi', 5500000.00, 'Perbaikan sound system', 'transactions/default.jpg', 3, '2025-12-10', 'approved', 1, '2026-01-22 10:58:55', NULL, '2026-01-22 08:26:13', '2026-01-22 10:58:55'),
(31, 'dee4d8bb-7ac8-42ec-ab57-fc7a0a851284', 'expense', 'Utilitas', 1100000.00, 'Listrik dan air Desember', 'transactions/default.jpg', 3, '2025-12-05', 'approved', 1, '2026-01-22 10:58:57', NULL, '2026-01-22 08:26:13', '2026-01-22 10:58:57'),
(32, '5446fb3f-2785-425b-ba41-d5bb35223039', 'expense', 'Konsumsi', 850000.00, 'Konsumsi tahun baru hijriah', 'transactions/default.jpg', 1, '2026-01-07', 'approved', NULL, '2026-01-22 08:26:13', NULL, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(33, '009f0af8-f19f-47b9-8eb9-f6367fe38527', 'expense', 'Operasional', 600000.00, 'Honorarium marbot', 'transactions/default.jpg', 3, '2026-01-15', 'approved', NULL, '2026-01-22 08:26:13', NULL, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(34, 'd96f1daa-fa55-4d11-a846-64d8e84a5ffe', 'expense', 'Utilitas', 980000.00, 'Listrik dan air Januari', 'transactions/default.jpg', 3, '2026-01-05', 'approved', NULL, '2026-01-22 08:26:13', NULL, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(35, '6fe76500-682b-49c0-a121-63b614cc8661', 'income', 'Infaq', 2500000.00, NULL, NULL, 1, '2026-01-22', 'approved', 1, '2026-01-22 11:18:53', NULL, '2026-01-22 11:18:53', '2026-01-22 11:18:53'),
(36, 'e390e280-5e1c-4006-9724-e322fa18e394', 'income', 'Infaq', 10000000.00, 'hamba', NULL, 1, '2026-01-22', 'approved', 1, '2026-01-22 11:19:29', NULL, '2026-01-22 11:19:29', '2026-01-22 11:19:29');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `role` enum('super_admin','ketua','bendahara','sekretaris','marbot') NOT NULL DEFAULT 'marbot' COMMENT 'User role for access control',
  `is_active` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'Account status',
  `password` varchar(255) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `role`, `is_active`, `password`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'Mimin Ganteng', 'dev@masjid.com', '2026-01-22 08:26:12', 'super_admin', 1, '$2y$12$rJ8kZEjJBv99qejfI8YrjeIM.Msj3qYZdYZ5Z4UM2rfFs35SM5KCq', NULL, '2026-01-22 08:26:12', '2026-01-22 12:40:29'),
(2, 'Pak Ketua', 'ketua@masjid.com', '2026-01-22 08:26:13', 'ketua', 1, '$2y$12$338fZH9wm9gCIG9.3EhB0uxf6MW90VSkBn6CNAtJzAVwvDs4If96C', NULL, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(3, 'Pak Bendahara', 'bendahara@masjid.com', '2026-01-22 08:26:13', 'bendahara', 1, '$2y$12$u./HZzeVhoCvdjLT6y8np.bWJP4OT.R2mj1TFEuvcaWrNgmYCiL8i', NULL, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(5, 'Kang Marbot', 'marbot@masjid.com', '2026-01-22 08:26:13', 'marbot', 1, '$2y$12$DC2U3Bc14DxMblCSrmFpOONyPuhEMRw3rk6lyZNSR1/gdN/NKUe7W', NULL, '2026-01-22 08:26:13', '2026-01-22 08:26:13');

-- --------------------------------------------------------

--
-- Table structure for table `wishlists`
--

CREATE TABLE `wishlists` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `item_name` varchar(200) NOT NULL COMMENT 'Name of the item/need',
  `target_qty` int(11) NOT NULL DEFAULT 1 COMMENT 'Target quantity needed',
  `fulfilled_qty` int(11) NOT NULL DEFAULT 0 COMMENT 'Quantity already fulfilled',
  `unit_price` decimal(15,2) NOT NULL COMMENT 'Price per unit',
  `status` enum('active','pending','completed','cancelled') NOT NULL DEFAULT 'active' COMMENT 'Wishlist status',
  `description` text DEFAULT NULL COMMENT 'Item description/notes',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `wishlists`
--

INSERT INTO `wishlists` (`id`, `item_name`, `target_qty`, `fulfilled_qty`, `unit_price`, `status`, `description`, `created_at`, `updated_at`) VALUES
(1, 'Karpet Masjid', 50, 32, 250000.00, 'active', 'Karpet untuk ruang sholat utama ukuran 120x600 cm', '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(2, 'Al-Quran Terjemahan', 100, 100, 150000.00, 'completed', 'Al-Quran terjemahan untuk jamaah', '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(3, 'Kipas Angin Berdiri', 10, 0, 800000.00, 'pending', 'Kipas angin untuk ruang sholat', '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(4, 'Sound System', 1, 0, 15000000.00, 'active', 'Sound system untuk adzan dan pengajian', '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(5, 'Rak Sepatu', 20, 15, 350000.00, 'active', 'Rak sepatu bertingkat untuk jamaah', '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(6, 'Lampu LED', 30, 30, 120000.00, 'completed', 'Lampu LED hemat energi', '2026-01-22 08:26:13', '2026-01-22 08:26:13');

-- --------------------------------------------------------

--
-- Table structure for table `zakats`
--

CREATE TABLE `zakats` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL,
  `muzakki_name` varchar(255) NOT NULL,
  `muzakki_nik` varchar(255) DEFAULT NULL,
  `muzakki_phone` varchar(255) DEFAULT NULL,
  `muzakki_address` text DEFAULT NULL,
  `type` enum('fitrah','mal','profesi') NOT NULL,
  `amount` decimal(15,2) NOT NULL,
  `payment_type` enum('uang','beras') NOT NULL DEFAULT 'uang',
  `rice_kg` decimal(10,2) DEFAULT NULL,
  `person_count` int(11) DEFAULT NULL,
  `year` int(11) NOT NULL,
  `date` date NOT NULL,
  `notes` text DEFAULT NULL,
  `collected_by` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `zakats`
--

INSERT INTO `zakats` (`id`, `uuid`, `muzakki_name`, `muzakki_nik`, `muzakki_phone`, `muzakki_address`, `type`, `amount`, `payment_type`, `rice_kg`, `person_count`, `year`, `date`, `notes`, `collected_by`, `created_at`, `updated_at`) VALUES
(1, '33dbda87-0bc0-4853-a63f-4d2b22ac5768', 'Ahmad Fahrezi', NULL, '081234567890', NULL, 'fitrah', 35000.00, 'uang', NULL, 1, 1446, '2025-09-08', NULL, 3, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(2, '2699878a-8493-4c76-8d1e-980614438dbb', 'Budi Santoso', NULL, '081234567891', NULL, 'fitrah', 140000.00, 'uang', NULL, 4, 1446, '2025-09-08', NULL, 3, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(3, 'f8c3f07e-3180-40a6-bff2-f69b66a23059', 'Siti Nurhaliza', NULL, '081234567892', NULL, 'mal', 500000.00, 'uang', NULL, NULL, 1446, '2025-09-10', NULL, 3, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(4, '03fb7c66-25f4-419f-a3f7-178f212df695', 'Haji Abdullah', NULL, '081234567893', NULL, 'fitrah', 210000.00, 'uang', NULL, 6, 1446, '2025-09-09', NULL, 3, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(5, '3fc67de2-da25-4eba-acde-161bc8f2b8f2', 'Dewi Lestari', NULL, '081234567894', NULL, 'fitrah', 35000.00, 'uang', NULL, 1, 1446, '2025-09-08', NULL, 3, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(6, '2e279fcf-e014-4649-9394-a22a62d25f98', 'Pak Hendra', NULL, '081234567895', NULL, 'fitrah', 105000.00, 'uang', NULL, 3, 1446, '2025-09-10', NULL, 3, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(7, 'd262d5bb-c81f-4e25-86b5-5d504c234696', 'Ibu Fatimah', NULL, '081234567896', NULL, 'mal', 750000.00, 'uang', NULL, NULL, 1446, '2025-09-11', NULL, 3, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(8, 'ce3655aa-79e5-4012-9a3d-4406b28ae7be', 'Keluarga Wijaya', NULL, '081234567897', NULL, 'fitrah', 175000.00, 'uang', NULL, 5, 1446, '2025-09-09', NULL, 3, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(9, 'f81e5760-14e0-431d-bc00-429dcc4d6b58', 'Pak Darmawan', NULL, '081234567898', NULL, 'mal', 1000000.00, 'uang', NULL, NULL, 1446, '2025-09-13', NULL, 3, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(10, '075b4287-bcb2-4a3d-9129-fc6870990346', 'Ibu Aminah', NULL, '081234567899', NULL, 'fitrah', 70000.00, 'uang', NULL, 2, 1446, '2025-09-08', NULL, 3, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(11, 'd6493af1-1058-4c63-b842-82d8bd17e6a7', 'Keluarga Hakim', NULL, '081234567800', NULL, 'fitrah', 140000.00, 'uang', NULL, 4, 1446, '2025-09-10', NULL, 3, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(12, 'c5080d33-2521-41e8-a13b-62a77a1a6416', 'Dr. Rahmat', NULL, '081234567801', NULL, 'mal', 2000000.00, 'uang', NULL, NULL, 1446, '2025-09-12', NULL, 3, '2026-01-22 08:26:13', '2026-01-22 08:26:13'),
(13, 'a6e9ab92-1e1e-447f-a5f8-075425580441', 'Ibu Khadijah', NULL, '081234567802', NULL, 'fitrah', 105000.00, 'uang', NULL, 3, 1446, '2025-09-11', NULL, 3, '2026-01-22 08:26:13', '2026-01-22 08:26:13');

-- --------------------------------------------------------

--
-- Table structure for table `zakat_distributions`
--

CREATE TABLE `zakat_distributions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL,
  `mustahik_name` varchar(255) NOT NULL,
  `mustahik_category` enum('fakir','miskin','amil','muallaf','riqab','gharim','sabilillah','ibnu_sabil') NOT NULL,
  `amount` decimal(15,2) NOT NULL,
  `type` enum('uang','beras') NOT NULL DEFAULT 'uang',
  `rice_kg` decimal(10,2) DEFAULT NULL,
  `year` int(11) NOT NULL,
  `date` date NOT NULL,
  `notes` text DEFAULT NULL,
  `distributed_by` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `agendas`
--
ALTER TABLE `agendas`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `agendas_slug_unique` (`slug`);

--
-- Indexes for table `assets`
--
ALTER TABLE `assets`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `committee_members`
--
ALTER TABLE `committee_members`
  ADD PRIMARY KEY (`id`),
  ADD KEY `committee_members_division_order_index` (`division`,`order`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `friday_schedules`
--
ALTER TABLE `friday_schedules`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `friday_schedules_date_unique` (`date`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indexes for table `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `performance_logs`
--
ALTER TABLE `performance_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `performance_logs_created_at_index` (`created_at`),
  ADD KEY `performance_logs_request_path_created_at_index` (`request_path`,`created_at`),
  ADD KEY `performance_logs_user_id_index` (`user_id`);

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`),
  ADD KEY `personal_access_tokens_expires_at_index` (`expires_at`);

--
-- Indexes for table `posts`
--
ALTER TABLE `posts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `posts_slug_unique` (`slug`),
  ADD KEY `posts_author_id_foreign` (`author_id`);

--
-- Indexes for table `prayer_times`
--
ALTER TABLE `prayer_times`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `prayer_times_date_unique` (`date`),
  ADD KEY `prayer_times_date_index` (`date`);

--
-- Indexes for table `qurbans`
--
ALTER TABLE `qurbans`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `qurbans_uuid_unique` (`uuid`),
  ADD KEY `qurbans_registered_by_foreign` (`registered_by`),
  ADD KEY `qurbans_animal_type_year_index` (`animal_type`,`year`),
  ADD KEY `qurbans_status_year_index` (`status`,`year`),
  ADD KEY `qurbans_share_group_id_year_index` (`share_group_id`,`year`),
  ADD KEY `qurbans_participant_nik_index` (`participant_nik`),
  ADD KEY `qurbans_animal_type_index` (`animal_type`),
  ADD KEY `qurbans_is_shared_index` (`is_shared`),
  ADD KEY `qurbans_share_group_id_index` (`share_group_id`),
  ADD KEY `qurbans_status_index` (`status`),
  ADD KEY `qurbans_year_index` (`year`),
  ADD KEY `qurbans_registration_date_index` (`registration_date`);

--
-- Indexes for table `qurban_distributions`
--
ALTER TABLE `qurban_distributions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `qurban_distributions_uuid_unique` (`uuid`),
  ADD KEY `qurban_distributions_distributed_by_foreign` (`distributed_by`),
  ADD KEY `qurban_distributions_qurban_id_recipient_type_index` (`qurban_id`,`recipient_type`),
  ADD KEY `qurban_distributions_recipient_type_index` (`recipient_type`),
  ADD KEY `qurban_distributions_date_index` (`date`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indexes for table `settings`
--
ALTER TABLE `settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `settings_key_unique` (`key`),
  ADD KEY `settings_group_index` (`group`);

--
-- Indexes for table `slides`
--
ALTER TABLE `slides`
  ADD PRIMARY KEY (`id`),
  ADD KEY `slides_is_active_order_index` (`is_active`,`order`);

--
-- Indexes for table `transactions`
--
ALTER TABLE `transactions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `transactions_uuid_unique` (`uuid`),
  ADD KEY `transactions_verified_by_foreign` (`verified_by`),
  ADD KEY `transactions_approved_by_foreign` (`approved_by`),
  ADD KEY `transactions_type_date_index` (`type`,`date`),
  ADD KEY `transactions_category_index` (`category`),
  ADD KEY `transactions_date_index` (`date`),
  ADD KEY `transactions_status_index` (`status`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- Indexes for table `wishlists`
--
ALTER TABLE `wishlists`
  ADD PRIMARY KEY (`id`),
  ADD KEY `wishlists_status_index` (`status`);

--
-- Indexes for table `zakats`
--
ALTER TABLE `zakats`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `zakats_uuid_unique` (`uuid`),
  ADD KEY `zakats_collected_by_foreign` (`collected_by`),
  ADD KEY `zakats_type_year_index` (`type`,`year`),
  ADD KEY `zakats_year_date_index` (`year`,`date`),
  ADD KEY `zakats_muzakki_nik_index` (`muzakki_nik`),
  ADD KEY `zakats_type_index` (`type`),
  ADD KEY `zakats_year_index` (`year`),
  ADD KEY `zakats_date_index` (`date`);

--
-- Indexes for table `zakat_distributions`
--
ALTER TABLE `zakat_distributions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `zakat_distributions_uuid_unique` (`uuid`),
  ADD KEY `zakat_distributions_distributed_by_foreign` (`distributed_by`),
  ADD KEY `zakat_distributions_mustahik_category_year_index` (`mustahik_category`,`year`),
  ADD KEY `zakat_distributions_mustahik_category_index` (`mustahik_category`),
  ADD KEY `zakat_distributions_year_index` (`year`),
  ADD KEY `zakat_distributions_date_index` (`date`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `agendas`
--
ALTER TABLE `agendas`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `assets`
--
ALTER TABLE `assets`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `committee_members`
--
ALTER TABLE `committee_members`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `friday_schedules`
--
ALTER TABLE `friday_schedules`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `performance_logs`
--
ALTER TABLE `performance_logs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=797;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `posts`
--
ALTER TABLE `posts`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `prayer_times`
--
ALTER TABLE `prayer_times`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `qurbans`
--
ALTER TABLE `qurbans`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `qurban_distributions`
--
ALTER TABLE `qurban_distributions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `settings`
--
ALTER TABLE `settings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `slides`
--
ALTER TABLE `slides`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `transactions`
--
ALTER TABLE `transactions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `wishlists`
--
ALTER TABLE `wishlists`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `zakats`
--
ALTER TABLE `zakats`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `zakat_distributions`
--
ALTER TABLE `zakat_distributions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `performance_logs`
--
ALTER TABLE `performance_logs`
  ADD CONSTRAINT `performance_logs_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `posts`
--
ALTER TABLE `posts`
  ADD CONSTRAINT `posts_author_id_foreign` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `qurbans`
--
ALTER TABLE `qurbans`
  ADD CONSTRAINT `qurbans_registered_by_foreign` FOREIGN KEY (`registered_by`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `qurban_distributions`
--
ALTER TABLE `qurban_distributions`
  ADD CONSTRAINT `qurban_distributions_distributed_by_foreign` FOREIGN KEY (`distributed_by`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `qurban_distributions_qurban_id_foreign` FOREIGN KEY (`qurban_id`) REFERENCES `qurbans` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `transactions`
--
ALTER TABLE `transactions`
  ADD CONSTRAINT `transactions_approved_by_foreign` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `transactions_verified_by_foreign` FOREIGN KEY (`verified_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `zakats`
--
ALTER TABLE `zakats`
  ADD CONSTRAINT `zakats_collected_by_foreign` FOREIGN KEY (`collected_by`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `zakat_distributions`
--
ALTER TABLE `zakat_distributions`
  ADD CONSTRAINT `zakat_distributions_distributed_by_foreign` FOREIGN KEY (`distributed_by`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
