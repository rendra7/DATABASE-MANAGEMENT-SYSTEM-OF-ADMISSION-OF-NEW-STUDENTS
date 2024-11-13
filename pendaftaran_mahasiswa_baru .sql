-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 13, 2023 at 03:56 PM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `pendaftaran_mahasiswa_baru`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `Hapus_Informasi_Pendaftaran_By_ID` (IN `p_Pendaftaran_ID` VARCHAR(5))   BEGIN
    DELETE FROM Dokumen_Ijazah WHERE Pendaftaran_ID = p_Pendaftaran_ID;
    DELETE FROM Dokumen_KK WHERE Pendaftaran_ID = p_Pendaftaran_ID;
    DELETE FROM Pendaftaran WHERE Pendaftaran_ID = p_Pendaftaran_ID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertCalonMahasiswa` (IN `p_NISN` VARCHAR(10), IN `p_Nama` VARCHAR(30), IN `p_Alamat` VARCHAR(50), IN `p_Email` VARCHAR(100), IN `p_Tanggal_Lahir` DATE, IN `p_Jenis_Kelamin` VARCHAR(10), IN `p_Agama` VARCHAR(15), IN `p_Jurusan_ID` VARCHAR(10), IN `p_SLTA_ID` VARCHAR(10), IN `p_No_Ujian` VARCHAR(10))   BEGIN
    INSERT INTO calon_mahasiswa (NISN, Nama, Alamat, Email_Akademik, Tanggal_Lahir, Jenis_Kelamin, Agama, Jurusan_ID, SLTA_ID, No_Ujian)
    VALUES (p_NISN, p_Nama, p_Alamat, p_Email, p_Tanggal_Lahir, p_Jenis_Kelamin, p_Agama, p_Jurusan_ID, p_SLTA_ID, p_No_Ujian);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Tampilkan_Info_Mahasiswa_By_NISN` (IN `p_NISN` VARCHAR(10))   BEGIN
    SELECT *
    FROM Calon_Mahasiswa
    WHERE NISN = p_NISN;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Ubah_Alamat_Calon_Mahasiswa` (IN `p_NISN` VARCHAR(10), IN `p_Alamat_Barul` VARCHAR(100))   BEGIN
    UPDATE Calon_Mahasiswa
    SET Alamat = p_Alamat_Barul
    WHERE NISN = p_NISN;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `check_status_diterima` (`tpks_nilai` DECIMAL(5,2), `slta_tahun_lulus` YEAR, `pendaftaran_periode` YEAR) RETURNS VARCHAR(50) CHARSET utf8mb4 COLLATE utf8mb4_general_ci  BEGIN
    DECLARE result VARCHAR(50);

    IF tpks_nilai >= 85 AND slta_tahun_lulus >= pendaftaran_periode - 2 THEN
        SET result = 'DITERIMA';
    ELSE
        SET result = 'DITOLAK';
    END IF;

    RETURN result;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `hitung_rata_rata_nilai_tpks` () RETURNS DECIMAL(5,2)  BEGIN
    DECLARE avg_nilai DECIMAL(5,2);

    SELECT AVG(Nilai) INTO avg_nilai FROM TPKS;

    RETURN avg_nilai;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `hitung_rata_rata_usia_pendaftar` () RETURNS INT(11)  BEGIN
    DECLARE avg_usia INT;

    SELECT AVG(YEAR(CURDATE()) - YEAR(Calon_Mahasiswa.Tanggal_Lahir)) INTO avg_usia
    FROM Calon_Mahasiswa;

    RETURN avg_usia;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `calon_mahasiswa`
--

CREATE TABLE `calon_mahasiswa` (
  `NISN` varchar(10) NOT NULL CHECK (`NISN` regexp 'B[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
  `Nama` varchar(30) DEFAULT NULL,
  `Alamat` varchar(100) DEFAULT NULL,
  `Email_Akademik` varchar(100) DEFAULT NULL CHECK (`Email_Akademik` regexp '^[a-zA-Z0-9._%+-]+@+[a-zA-Z0-9.-]+.ac.id$'),
  `Tanggal_Lahir` date DEFAULT NULL,
  `Jenis_Kelamin` varchar(10) DEFAULT NULL,
  `Agama` varchar(15) DEFAULT NULL,
  `Jurusan_ID` varchar(10) DEFAULT NULL,
  `SLTA_ID` varchar(10) DEFAULT NULL,
  `No_Ujian` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `calon_mahasiswa`
--

INSERT INTO `calon_mahasiswa` (`NISN`, `Nama`, `Alamat`, `Email_Akademik`, `Tanggal_Lahir`, `Jenis_Kelamin`, `Agama`, `Jurusan_ID`, `SLTA_ID`, `No_Ujian`) VALUES
('B260000001', 'Jason Aldrich Immanuel', 'Jl. Jemur Andayani XVI, Siwalankerto, Kec. Wonocolo, Surabaya', 'Jason.aldrich@binus.ac.id', '2003-11-04', 'Laki-laki', 'Kristen', 'CS', '1809589001', 'TP002'),
('B260000002', 'Michelle Clairine ', 'Jl. Taman Golf Citraland, Kecamatan Sambikerep, Kota Surabaya', 'Michelle.cla22@gloria.ac.id', '2003-05-25', 'Perempuan', 'Buddha', 'DKV', '1836331244', 'TP003'),
('B260000003', 'Rhenaldy Wicaksana', 'Jl.Baypass, Kec. Puri, Mojokerto', 'Rhenaldy103@binus.ac.id', '2004-03-06', 'Laki-laki', 'Kristen', 'DKV', '1821742921', 'TP004'),
('B260000004', 'Vanesa Emanuel Dwi Santoso', 'Jl. Rafless Blvd Citraland, Kecamatan Sambikerep, Kota Surabaya', 'Vanesss134@tnh.ac.id', '2005-09-17', 'Perempuan', 'Buddha', 'DI', '1800000001', 'TP005'),
('B260000005', 'Ricky Jonathan', 'Jl. Pahlawan, Kec. Margersari, Mojokerto', 'Ricky.Jonathan@binus.ac.id', '2003-03-08', 'Laki-laki', 'Kristen', 'SI', '1800000002', 'TP006'),
('B260000006', 'Wilson Setiawan', 'Jl. W.R.Supratman, Mojokerto', 'WilsonSetiawan@binus.ac.id', '2003-09-09', 'Laki-laki', 'Kristen', 'CS', '1800000003', 'TP007'),
('B260000007', 'Margareth Nyoto Wijaya', 'Jl. Pisang No 12 Kec. Margersari, Mojokerto', 'Bimbing@binus.ac.id', '2003-10-10', 'Perempuan', 'Kristen', 'EBC', '1800000004', 'TP008'),
('B260000008', 'Galih Rawangga', 'Gg. IV, Lidah Kulon, Kec. Lakarsantri, Surabaya,', 'Galih.rawangga@binus.ac.id', '2003-01-11', 'Laki-laki', 'Islam', 'CS', '1805555533', 'TP009'),
('B260000009', 'Evelyn Wahyu Callista', 'Jl. Apel No 9 Kec. Margersari, Mojokerto', 'Epelinw134@tnh.ac.id', '2003-12-12', 'Perempuan', 'Katolik', 'EBC', '1800233233', 'TP010'),
('B260218839', 'Catherine Angelica', 'Jl. Siwalankerto, Siwalankerto, Kec. Wonocolo, Surabaya', 'Catherine.Angl@petra.ac.id', '2003-03-03', 'Perempuan', 'Katolik', 'PR', '1809599001', 'TP001');

-- --------------------------------------------------------

--
-- Stand-in structure for view `calon_mahasiswa_diatas_rataan`
-- (See below for the actual view)
--
CREATE TABLE `calon_mahasiswa_diatas_rataan` (
`Nama` varchar(30)
,`Nilai_TPKS` decimal(5,2)
,`Periode_Pendaftaran` year(4)
);

-- --------------------------------------------------------

--
-- Table structure for table `dokumen_ijazah`
--

CREATE TABLE `dokumen_ijazah` (
  `Dokumen_Ijazah_ID` varchar(5) NOT NULL CHECK (`Dokumen_Ijazah_ID` regexp 'IJ[0-9][0-9][0-9]'),
  `Tanggal_upload` date DEFAULT NULL,
  `Pendaftaran_ID` varchar(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `dokumen_ijazah`
--

INSERT INTO `dokumen_ijazah` (`Dokumen_Ijazah_ID`, `Tanggal_upload`, `Pendaftaran_ID`) VALUES
('IJ001', '2022-01-17', 'PI001'),
('IJ002', '2022-01-19', 'PI002'),
('IJ003', '2022-01-19', 'PI003'),
('IJ004', '2022-01-20', 'PI004'),
('IJ005', '2022-03-21', 'PI005'),
('IJ006', '2022-03-22', 'PI006'),
('IJ007', '2022-07-23', 'PI007'),
('IJ008', '2022-07-24', 'PI008'),
('IJ009', '2022-07-25', 'PI009'),
('IJ010', '2022-07-26', 'PI010');

-- --------------------------------------------------------

--
-- Table structure for table `dokumen_kk`
--

CREATE TABLE `dokumen_kk` (
  `Dokumen_KK_ID` varchar(5) NOT NULL CHECK (`Dokumen_KK_ID` regexp 'KK[0-9][0-9][0-9]'),
  `Tanggal_upload` date DEFAULT NULL,
  `Pendaftaran_ID` varchar(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `dokumen_kk`
--

INSERT INTO `dokumen_kk` (`Dokumen_KK_ID`, `Tanggal_upload`, `Pendaftaran_ID`) VALUES
('KK001', '2022-01-17', 'PI001'),
('KK002', '2022-01-19', 'PI002'),
('KK003', '2022-01-19', 'PI003'),
('KK004', '2022-01-20', 'PI004'),
('KK005', '2022-03-21', 'PI005'),
('KK006', '2022-03-22', 'PI006'),
('KK007', '2022-07-23', 'PI007'),
('KK008', '2022-07-24', 'PI008'),
('KK009', '2022-07-25', 'PI009'),
('KK010', '2022-07-26', 'PI010');

-- --------------------------------------------------------

--
-- Table structure for table `fakultas`
--

CREATE TABLE `fakultas` (
  `FakultasID` varchar(10) NOT NULL CHECK (cast(`FakultasID` as char charset binary) = ucase(`FakultasID`)),
  `Nama_Fakultas` varchar(50) DEFAULT NULL,
  `KampusID` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `fakultas`
--

INSERT INTO `fakultas` (`FakultasID`, `Nama_Fakultas`, `KampusID`) VALUES
('BOL', 'Binus Online Learning', 'KMG04'),
('BSS', 'Binus Bussiness School', 'SRPNG'),
('FODCAHAT', 'Faculty Of Digital Communication And Hotel And Tou', 'KMG03'),
('FOE', 'Faculty Of Engginering', 'KMG02'),
('FOFC', 'Faculty Of Food Culinery', 'BKS'),
('FOH', 'Faculty Of Humanities', 'BDG'),
('SOA', 'School Of Accounting', 'SMRNG'),
('SOACA', 'School Of Computing And Creative Arts', 'ALSUT'),
('SOCS', 'School Of Computer Science', 'MLG'),
('SOIS', 'School Of Information System', 'KMG01');

-- --------------------------------------------------------

--
-- Stand-in structure for view `informasi_calon_mahasiswa`
-- (See below for the actual view)
--
CREATE TABLE `informasi_calon_mahasiswa` (
`NISN` varchar(10)
,`Nama` varchar(30)
,`Alamat` varchar(100)
,`Email_Akademik` varchar(100)
,`Tanggal_Lahir` date
,`Jenis_Kelamin` varchar(10)
,`Agama` varchar(15)
,`Nama_Sekolah_Asal` varchar(100)
,`Tahun_Lulus` year(4)
,`Nilai_Rata_rata_Rapor` decimal(5,2)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `informasi_jurusan`
-- (See below for the actual view)
--
CREATE TABLE `informasi_jurusan` (
`Nama_Jurusan` varchar(50)
,`Rata_rata_Nilai_TPKS` decimal(4,0)
,`Jumlah_Mahasiswa` bigint(21)
,`Nilai_TPKS_Tertinggi` decimal(4,0)
,`Nilai_TPKS_Terendah` decimal(4,0)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `informasi_pendaftaran`
-- (See below for the actual view)
--
CREATE TABLE `informasi_pendaftaran` (
`Pendaftaran_ID` varchar(5)
,`Nama` varchar(30)
,`No_Ujian` varchar(10)
,`Nilai_TPKS` decimal(5,2)
,`Tanggal_pendaftaran` date
,`Periode` year(4)
,`Dokumen_KK_ID` varchar(5)
,`Dokumen_Ijazah_ID` varchar(5)
,`Nama_Jurusan` varchar(50)
,`Nama_Fakultas` varchar(50)
,`Nama_Kampus` varchar(50)
);

-- --------------------------------------------------------

--
-- Table structure for table `jurusan`
--

CREATE TABLE `jurusan` (
  `JurusanID` varchar(10) NOT NULL CHECK (cast(`JurusanID` as char charset binary) = ucase(`JurusanID`)),
  `Nama_Jurusan` varchar(50) DEFAULT NULL,
  `FakultasID` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `jurusan`
--

INSERT INTO `jurusan` (`JurusanID`, `Nama_Jurusan`, `FakultasID`) VALUES
('BA', 'Bussiness Analytic', 'BSS'),
('CS', 'Computer Science', 'SOCS'),
('CSN', 'Cyber Security', 'SOCS'),
('DI', 'Design Interior', 'SOACA'),
('DKV', 'Design Komunikasi Visual', 'FOH'),
('DS', 'Data Science', 'SOCS'),
('EBC', 'Entreprenurship Bussiness Creation', 'BSS'),
('HM', 'Hotel Management', 'FODCAHAT'),
('PR', 'Public Relation', 'SOACA'),
('SI', 'System Information', 'SOIS');

-- --------------------------------------------------------

--
-- Table structure for table `kampus`
--

CREATE TABLE `kampus` (
  `Kampus_ID` varchar(10) NOT NULL CHECK (cast(`Kampus_ID` as char charset binary) = ucase(`Kampus_ID`)),
  `Nama_Kampus` varchar(50) DEFAULT NULL CHECK (`Nama_Kampus` regexp '^BINUS'),
  `Lokasi_Kampus` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `kampus`
--

INSERT INTO `kampus` (`Kampus_ID`, `Nama_Kampus`, `Lokasi_Kampus`) VALUES
('ALSUT', 'Binus Alam Sutera', 'Tanggerang '),
('BDG', 'Binus Bandung', 'Bandung Jawa Barat'),
('BKS', 'Binus Bekasi', 'Bekasi Jawa Barat'),
('KMG01', 'Binus Syahdan', 'Kemanggisan Jakarta Barat'),
('KMG02', 'Binus Anggrek', 'Kemanggisan Jakarta Barat'),
('KMG03', 'Binus Kijang', 'Kemanggisan Jakarta Barat'),
('KMG04', 'Binus JWC', 'Jakarta Barat'),
('MLG', 'Binus Malang', 'Malang Jawa Timur'),
('SMRNG', 'Binus Semarang', 'Semarang Jawa Tengah'),
('SRPNG', 'Binus Serpong', 'Bogor Jawa Barat');

-- --------------------------------------------------------

--
-- Table structure for table `pendaftaran`
--

CREATE TABLE `pendaftaran` (
  `Pendaftaran_ID` varchar(5) NOT NULL CHECK (`Pendaftaran_ID` regexp 'PI[0-9][0-9][0-9]'),
  `Tanggal_pendaftaran` date DEFAULT NULL,
  `Periode` year(4) DEFAULT NULL,
  `NISN` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pendaftaran`
--

INSERT INTO `pendaftaran` (`Pendaftaran_ID`, `Tanggal_pendaftaran`, `Periode`, `NISN`) VALUES
('PI001', '2022-01-17', '2023', 'B260218839'),
('PI002', '2022-01-19', '2023', 'B260000001'),
('PI003', '2022-01-19', '2022', 'B260000002'),
('PI004', '2022-01-20', '2022', 'B260000003'),
('PI005', '2022-03-21', '2022', 'B260000004'),
('PI006', '2022-03-22', '2022', 'B260000005'),
('PI007', '2022-07-23', '2022', 'B260000006'),
('PI008', '2022-07-24', '2022', 'B260000007'),
('PI009', '2022-07-25', '2022', 'B260000008'),
('PI010', '2022-07-26', '2024', 'B260000009');

-- --------------------------------------------------------

--
-- Stand-in structure for view `pendaftar_nilai_tpks_terendah`
-- (See below for the actual view)
--
CREATE TABLE `pendaftar_nilai_tpks_terendah` (
`Nama` varchar(30)
,`Nilai_TPKS` decimal(5,2)
,`Periode_Pendaftaran` year(4)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `pendaftar_nilai_tpks_tertinggi`
-- (See below for the actual view)
--
CREATE TABLE `pendaftar_nilai_tpks_tertinggi` (
`Nama_Calon_Mahasiswa` varchar(30)
,`Nilai_TPKS` decimal(5,2)
,`Periode` year(4)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `pengumuman`
-- (See below for the actual view)
--
CREATE TABLE `pengumuman` (
`Pendaftaran_ID` varchar(5)
,`Nama` varchar(30)
,`NISN` varchar(10)
,`Jurusan` varchar(50)
,`Fakultas` varchar(50)
,`Lokasi Kampus` varchar(50)
,`Status Penerimaan` varchar(50)
);

-- --------------------------------------------------------

--
-- Table structure for table `slta`
--

CREATE TABLE `slta` (
  `SLTA_ID` char(10) NOT NULL,
  `Nama_Sekolah_Asal` varchar(100) DEFAULT NULL,
  `Tahun_Lulus` year(4) DEFAULT NULL,
  `Nilai_Rata_rata_Rapor` decimal(5,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `slta`
--

INSERT INTO `slta` (`SLTA_ID`, `Nama_Sekolah_Asal`, `Tahun_Lulus`, `Nilai_Rata_rata_Rapor`) VALUES
('1800000001', 'SMA Kristen Gloria  1 Surabaya', '2022', 92.50),
('1800000002', 'SMA Negeri 1 Puri Mojokerto', '2019', 77.50),
('1800000003', 'SMA Kristen Petra 1  Surabaya', '2022', 89.75),
('1800000004', 'SMA Taruna Nusa Harapan Mojokerto', '2022', 90.00),
('1800233233', 'SMA Taruna Nusa Harapan Mojokerto', '2022', 95.00),
('1805555533', 'SMA Negeri 2 Surabaya', '2020', 88.75),
('1809589001', 'SMA Kristen Gloria  1 Surabaya', '2022', 90.00),
('1809599001', 'SMA Kristen Petra 1  Surabaya', '2022', 80.75),
('1821742921', 'SMA Taruna Nusa Harapan Mojokerto', '2022', 82.25),
('1836331244', 'SMK Katolik Santo Yusuf 4 Sidoarjo', '2022', 99.00);

-- --------------------------------------------------------

--
-- Stand-in structure for view `statistik_pendaftaran`
-- (See below for the actual view)
--
CREATE TABLE `statistik_pendaftaran` (
`Jumlah_Pendaftar` bigint(21)
,`Jumlah_Diterima` decimal(22,0)
,`Rata_rata_Usia_Pendaftar` decimal(14,8)
,`Rata_rata_Nilai_TPKS` decimal(9,6)
,`Nilai_TPKS_Terendah` decimal(5,2)
,`Nilai_TPKS_Tertinggi` decimal(5,2)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `status_diterima_ditolak_by_jurusan`
-- (See below for the actual view)
--
CREATE TABLE `status_diterima_ditolak_by_jurusan` (
`Nama_Jurusan` varchar(50)
,`Jumlah_Diterima` decimal(22,0)
,`Jumlah_Ditolak` decimal(22,0)
);

-- --------------------------------------------------------

--
-- Table structure for table `tpks`
--

CREATE TABLE `tpks` (
  `No_Ujian` varchar(5) NOT NULL CHECK (`No_Ujian` regexp 'TP[0-9][0-9][0-9]'),
  `Tanggal_Ujian` date DEFAULT NULL,
  `Nilai` decimal(5,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tpks`
--

INSERT INTO `tpks` (`No_Ujian`, `Tanggal_Ujian`, `Nilai`) VALUES
('TP001', '2022-11-02', 90.25),
('TP002', '2022-11-02', 100.00),
('TP003', '2022-11-02', 87.00),
('TP004', '2022-11-02', 92.00),
('TP005', '2022-11-10', 97.00),
('TP006', '2022-11-10', 100.00),
('TP007', '2022-11-10', 60.50),
('TP008', '2022-11-10', 75.50),
('TP009', '2022-11-10', 85.25),
('TP010', '2022-11-10', 82.75);

-- --------------------------------------------------------

--
-- Structure for view `calon_mahasiswa_diatas_rataan`
--
DROP TABLE IF EXISTS `calon_mahasiswa_diatas_rataan`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `calon_mahasiswa_diatas_rataan`  AS SELECT `cm`.`Nama` AS `Nama`, `tpks`.`Nilai` AS `Nilai_TPKS`, `pendaftaran`.`Periode` AS `Periode_Pendaftaran` FROM ((`calon_mahasiswa` `cm` join `tpks` on(`cm`.`No_Ujian` = `tpks`.`No_Ujian`)) join `pendaftaran` on(`cm`.`NISN` = `pendaftaran`.`NISN`)) WHERE `tpks`.`Nilai` > (select avg(`tpks`.`Nilai`) from `tpks`) ;

-- --------------------------------------------------------

--
-- Structure for view `informasi_calon_mahasiswa`
--
DROP TABLE IF EXISTS `informasi_calon_mahasiswa`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `informasi_calon_mahasiswa`  AS SELECT `cm`.`NISN` AS `NISN`, `cm`.`Nama` AS `Nama`, `cm`.`Alamat` AS `Alamat`, `cm`.`Email_Akademik` AS `Email_Akademik`, `cm`.`Tanggal_Lahir` AS `Tanggal_Lahir`, `cm`.`Jenis_Kelamin` AS `Jenis_Kelamin`, `cm`.`Agama` AS `Agama`, `s`.`Nama_Sekolah_Asal` AS `Nama_Sekolah_Asal`, `s`.`Tahun_Lulus` AS `Tahun_Lulus`, `s`.`Nilai_Rata_rata_Rapor` AS `Nilai_Rata_rata_Rapor` FROM (`calon_mahasiswa` `cm` join `slta` `s` on(`cm`.`SLTA_ID` = `s`.`SLTA_ID`)) ;

-- --------------------------------------------------------

--
-- Structure for view `informasi_jurusan`
--
DROP TABLE IF EXISTS `informasi_jurusan`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `informasi_jurusan`  AS SELECT `j`.`Nama_Jurusan` AS `Nama_Jurusan`, round(avg(`tpks`.`Nilai`),0) AS `Rata_rata_Nilai_TPKS`, count(0) AS `Jumlah_Mahasiswa`, round(max(`tpks`.`Nilai`),0) AS `Nilai_TPKS_Tertinggi`, round(min(`tpks`.`Nilai`),0) AS `Nilai_TPKS_Terendah` FROM ((`calon_mahasiswa` `cm` join `tpks` on(`cm`.`No_Ujian` = `tpks`.`No_Ujian`)) join `jurusan` `j` on(`cm`.`Jurusan_ID` = `j`.`JurusanID`)) GROUP BY `j`.`Nama_Jurusan` ;

-- --------------------------------------------------------

--
-- Structure for view `informasi_pendaftaran`
--
DROP TABLE IF EXISTS `informasi_pendaftaran`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `informasi_pendaftaran`  AS SELECT `p`.`Pendaftaran_ID` AS `Pendaftaran_ID`, `cm`.`Nama` AS `Nama`, `cm`.`No_Ujian` AS `No_Ujian`, `t`.`Nilai` AS `Nilai_TPKS`, `p`.`Tanggal_pendaftaran` AS `Tanggal_pendaftaran`, `p`.`Periode` AS `Periode`, `dk_kk`.`Dokumen_KK_ID` AS `Dokumen_KK_ID`, `dk_ijazah`.`Dokumen_Ijazah_ID` AS `Dokumen_Ijazah_ID`, `j`.`Nama_Jurusan` AS `Nama_Jurusan`, `f`.`Nama_Fakultas` AS `Nama_Fakultas`, `k`.`Nama_Kampus` AS `Nama_Kampus` FROM (((((((`pendaftaran` `p` join `calon_mahasiswa` `cm` on(`p`.`NISN` = `cm`.`NISN`)) join `tpks` `t` on(`cm`.`No_Ujian` = `t`.`No_Ujian`)) left join `dokumen_kk` `dk_kk` on(`p`.`Pendaftaran_ID` = `dk_kk`.`Pendaftaran_ID`)) left join `dokumen_ijazah` `dk_ijazah` on(`p`.`Pendaftaran_ID` = `dk_ijazah`.`Pendaftaran_ID`)) join `jurusan` `j` on(`cm`.`Jurusan_ID` = `j`.`JurusanID`)) join `fakultas` `f` on(`j`.`FakultasID` = `f`.`FakultasID`)) join `kampus` `k` on(`f`.`KampusID` = `k`.`Kampus_ID`)) ;

-- --------------------------------------------------------

--
-- Structure for view `pendaftar_nilai_tpks_terendah`
--
DROP TABLE IF EXISTS `pendaftar_nilai_tpks_terendah`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `pendaftar_nilai_tpks_terendah`  AS SELECT `cm`.`Nama` AS `Nama`, `tpks`.`Nilai` AS `Nilai_TPKS`, `pendaftaran`.`Periode` AS `Periode_Pendaftaran` FROM ((`calon_mahasiswa` `cm` join `tpks` on(`cm`.`No_Ujian` = `tpks`.`No_Ujian`)) join `pendaftaran` on(`cm`.`NISN` = `pendaftaran`.`NISN`)) WHERE `tpks`.`Nilai` = (select min(`tpks`.`Nilai`) from `tpks`) ;

-- --------------------------------------------------------

--
-- Structure for view `pendaftar_nilai_tpks_tertinggi`
--
DROP TABLE IF EXISTS `pendaftar_nilai_tpks_tertinggi`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `pendaftar_nilai_tpks_tertinggi`  AS SELECT `cm`.`Nama` AS `Nama_Calon_Mahasiswa`, `tpks`.`Nilai` AS `Nilai_TPKS`, `pendaftaran`.`Periode` AS `Periode` FROM ((`calon_mahasiswa` `cm` join `tpks` on(`cm`.`No_Ujian` = `tpks`.`No_Ujian`)) join `pendaftaran` on(`cm`.`NISN` = `pendaftaran`.`NISN`)) WHERE `tpks`.`Nilai` = (select max(`tpks`.`Nilai`) from `tpks`) ;

-- --------------------------------------------------------

--
-- Structure for view `pengumuman`
--
DROP TABLE IF EXISTS `pengumuman`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `pengumuman`  AS SELECT `pendaftaran`.`Pendaftaran_ID` AS `Pendaftaran_ID`, `calon_mahasiswa`.`Nama` AS `Nama`, `calon_mahasiswa`.`NISN` AS `NISN`, `jurusan`.`Nama_Jurusan` AS `Jurusan`, `fakultas`.`Nama_Fakultas` AS `Fakultas`, `kampus`.`Lokasi_Kampus` AS `Lokasi Kampus`, `check_status_diterima`(`tpks`.`Nilai`,`slta`.`Tahun_Lulus`,`pendaftaran`.`Periode`) AS `Status Penerimaan` FROM ((((((`calon_mahasiswa` left join `pendaftaran` on(`calon_mahasiswa`.`NISN` = `pendaftaran`.`NISN`)) left join `tpks` on(`calon_mahasiswa`.`No_Ujian` = `tpks`.`No_Ujian`)) left join `slta` on(`calon_mahasiswa`.`SLTA_ID` = `slta`.`SLTA_ID`)) left join `jurusan` on(`calon_mahasiswa`.`Jurusan_ID` = `jurusan`.`JurusanID`)) left join `fakultas` on(`jurusan`.`FakultasID` = `fakultas`.`FakultasID`)) left join `kampus` on(`fakultas`.`KampusID` = `kampus`.`Kampus_ID`)) ;

-- --------------------------------------------------------

--
-- Structure for view `statistik_pendaftaran`
--
DROP TABLE IF EXISTS `statistik_pendaftaran`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `statistik_pendaftaran`  AS SELECT count(distinct `calon_mahasiswa`.`NISN`) AS `Jumlah_Pendaftar`, sum(if(`check_status_diterima`(`tpks`.`Nilai`,`slta`.`Tahun_Lulus`,`pendaftaran`.`Periode`) * 'DITERIMA',1,0)) AS `Jumlah_Diterima`, avg((to_days(curdate()) - to_days(`calon_mahasiswa`.`Tanggal_Lahir`)) / 365) AS `Rata_rata_Usia_Pendaftar`, avg(`tpks`.`Nilai`) AS `Rata_rata_Nilai_TPKS`, min(`tpks`.`Nilai`) AS `Nilai_TPKS_Terendah`, max(`tpks`.`Nilai`) AS `Nilai_TPKS_Tertinggi` FROM (((`calon_mahasiswa` left join `pendaftaran` on(`calon_mahasiswa`.`NISN` = `pendaftaran`.`NISN`)) left join `tpks` on(`calon_mahasiswa`.`No_Ujian` = `tpks`.`No_Ujian`)) left join `slta` on(`calon_mahasiswa`.`SLTA_ID` = `slta`.`SLTA_ID`)) ;

-- --------------------------------------------------------

--
-- Structure for view `status_diterima_ditolak_by_jurusan`
--
DROP TABLE IF EXISTS `status_diterima_ditolak_by_jurusan`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `status_diterima_ditolak_by_jurusan`  AS SELECT `jurusan`.`Nama_Jurusan` AS `Nama_Jurusan`, sum(case when `tpks`.`Nilai` >= 85 then 1 else 0 end) AS `Jumlah_Diterima`, sum(case when `tpks`.`Nilai` < 85 then 1 else 0 end) AS `Jumlah_Ditolak` FROM (((`calon_mahasiswa` join `tpks` on(`calon_mahasiswa`.`No_Ujian` = `tpks`.`No_Ujian`)) join `pendaftaran` on(`calon_mahasiswa`.`NISN` = `pendaftaran`.`NISN`)) join `jurusan` on(`calon_mahasiswa`.`Jurusan_ID` = `jurusan`.`JurusanID`)) GROUP BY `jurusan`.`Nama_Jurusan` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `calon_mahasiswa`
--
ALTER TABLE `calon_mahasiswa`
  ADD PRIMARY KEY (`NISN`),
  ADD KEY `Jurusan_ID` (`Jurusan_ID`),
  ADD KEY `SLTA_ID` (`SLTA_ID`),
  ADD KEY `No_Ujian` (`No_Ujian`);

--
-- Indexes for table `dokumen_ijazah`
--
ALTER TABLE `dokumen_ijazah`
  ADD PRIMARY KEY (`Dokumen_Ijazah_ID`),
  ADD KEY `Pendaftaran_ID` (`Pendaftaran_ID`);

--
-- Indexes for table `dokumen_kk`
--
ALTER TABLE `dokumen_kk`
  ADD PRIMARY KEY (`Dokumen_KK_ID`),
  ADD KEY `Pendaftaran_ID` (`Pendaftaran_ID`);

--
-- Indexes for table `fakultas`
--
ALTER TABLE `fakultas`
  ADD PRIMARY KEY (`FakultasID`),
  ADD KEY `Kampus` (`KampusID`);

--
-- Indexes for table `jurusan`
--
ALTER TABLE `jurusan`
  ADD PRIMARY KEY (`JurusanID`),
  ADD KEY `Fakultas` (`FakultasID`);

--
-- Indexes for table `kampus`
--
ALTER TABLE `kampus`
  ADD PRIMARY KEY (`Kampus_ID`);

--
-- Indexes for table `pendaftaran`
--
ALTER TABLE `pendaftaran`
  ADD PRIMARY KEY (`Pendaftaran_ID`),
  ADD KEY `calon_mahasiswa` (`NISN`);

--
-- Indexes for table `slta`
--
ALTER TABLE `slta`
  ADD PRIMARY KEY (`SLTA_ID`);

--
-- Indexes for table `tpks`
--
ALTER TABLE `tpks`
  ADD PRIMARY KEY (`No_Ujian`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `calon_mahasiswa`
--
ALTER TABLE `calon_mahasiswa`
  ADD CONSTRAINT `calon_mahasiswa_ibfk_1` FOREIGN KEY (`Jurusan_ID`) REFERENCES `jurusan` (`JurusanID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `calon_mahasiswa_ibfk_2` FOREIGN KEY (`SLTA_ID`) REFERENCES `slta` (`SLTA_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `calon_mahasiswa_ibfk_3` FOREIGN KEY (`No_Ujian`) REFERENCES `tpks` (`No_Ujian`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `dokumen_ijazah`
--
ALTER TABLE `dokumen_ijazah`
  ADD CONSTRAINT `dokumen_ijazah_ibfk_1` FOREIGN KEY (`Pendaftaran_ID`) REFERENCES `pendaftaran` (`Pendaftaran_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `dokumen_kk`
--
ALTER TABLE `dokumen_kk`
  ADD CONSTRAINT `dokumen_kk_ibfk_1` FOREIGN KEY (`Pendaftaran_ID`) REFERENCES `pendaftaran` (`Pendaftaran_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `fakultas`
--
ALTER TABLE `fakultas`
  ADD CONSTRAINT `Kampus` FOREIGN KEY (`KampusID`) REFERENCES `kampus` (`Kampus_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `jurusan`
--
ALTER TABLE `jurusan`
  ADD CONSTRAINT `Fakultas` FOREIGN KEY (`FakultasID`) REFERENCES `fakultas` (`FakultasID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `pendaftaran`
--
ALTER TABLE `pendaftaran`
  ADD CONSTRAINT `calon_mahasiswa` FOREIGN KEY (`NISN`) REFERENCES `calon_mahasiswa` (`NISN`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
