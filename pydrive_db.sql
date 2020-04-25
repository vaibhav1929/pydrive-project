-- phpMyAdmin SQL Dump
-- version 5.0.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- 
-- Server version: 10.4.11-MariaDB
-- PHP Version: 7.4.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `pydrive_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `app_files`
--

CREATE TABLE `app_files` (
  `id` int(11) NOT NULL,
  `file_title` longtext NOT NULL,
  `file_size` longtext NOT NULL,
  `upload_date` date NOT NULL,
  `file_link` longtext NOT NULL,
  `file_starred` tinyint(1) NOT NULL,
  `user_id` int(11) NOT NULL,
  `file_hidden` tinyint(1) NOT NULL,
  `folder_id` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `app_files`
--

INSERT INTO `app_files` (`id`, `file_title`, `file_size`, `upload_date`, `file_link`, `file_starred`, `user_id`, `file_hidden`, `folder_id`) VALUES
(1, 'ERDiagram.pdf', '83135', '2020-03-29', '/user_data/1/ERDiagram.pdf', 1, 1, 0, NULL),
(2, 'colourful-illustration-programmer-working_23-2148281410.jpg', '52244', '2020-03-29', '/user_data/1/colourful-illustration-programmer-working_23-2148281410.jpg', 0, 1, 0, NULL),
(3, 'She DonT Know-Akh Lad Jaave - mix.mp3', '4201561', '2020-03-29', '/user_data/1/She%20DonT%20Know-Akh%20Lad%20Jaave%20-%20mix.mp3', 0, 1, 0, NULL),
(4, 'Screenshot _5_.png', '345368', '2020-03-29', '/user_data/1/Screenshot%20_5_.png', 1, 1, 0, NULL),
(5, 'Title.mp4', '1239792', '2020-03-30', '/user_data/1/Title.mp4', 0, 1, 1, NULL),
(20, 'Test.java', '1195', '2020-04-08', '/user_data/1/Test.java', 0, 1, 0, NULL),
(26, 'Pizza.java', '256', '2020-04-08', '/user_data/1/Code/Pizza.java', 0, 1, 0, 2);

-- --------------------------------------------------------

--
-- Table structure for table `app_folder`
--

CREATE TABLE `app_folder` (
  `id` int(11) NOT NULL,
  `folder_name` longtext NOT NULL,
  `folder_date` date NOT NULL,
  `folder_starred` tinyint(1) NOT NULL,
  `folder_link` longtext NOT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `app_folder`
--

INSERT INTO `app_folder` (`id`, `folder_name`, `folder_date`, `folder_starred`, `folder_link`, `parent_id`, `user_id`) VALUES
(1, 'Project', '2020-04-07', 0, 'user_data/1/Project', NULL, 1),
(2, 'Code', '2020-04-08', 0, 'user_data/1/Code', NULL, 1),
(3, 'JS', '2020-04-08', 0, 'user_data/1/Code/JS', 2, 1);

-- --------------------------------------------------------

--
-- Table structure for table `app_shared`
--

CREATE TABLE `app_shared` (
  `id` int(11) NOT NULL,
  `date` date NOT NULL,
  `file` int(11) NOT NULL,
  `sharedUser_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `is_folder` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `app_shared`
--

INSERT INTO `app_shared` (`id`, `date`, `file`, `sharedUser_id`, `user_id`, `is_folder`) VALUES
(1, '2020-04-09', 2, 13, 1, 0),
(5, '2020-04-09', 2, 13, 1, 1),
(8, '2020-04-10', 27, 1, 13, 0);

-- --------------------------------------------------------

--
-- Table structure for table `app_user`
--

CREATE TABLE `app_user` (
  `id` int(11) NOT NULL,
  `user_email` longtext NOT NULL,
  `user_password` longtext NOT NULL,
  `user_vault_psw` longtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `app_user`
--

INSERT INTO `app_user` (`id`, `user_email`, `user_password`, `user_vault_psw`) VALUES
(1, 'vaibhavpatel1921@gmail.com', '25d55ad283aa400af464c76d713c07ad', '81dc9bdb52d04dc20036dbd8313ed055'),
(13, 'yash49@gmail.com', '25d55ad283aa400af464c76d713c07ad', '');

-- --------------------------------------------------------

--
-- Table structure for table `app_verification`
--

CREATE TABLE `app_verification` (
  `id` int(11) NOT NULL,
  `otp` int(11) NOT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `auth_group`
--

CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `auth_group_permissions`
--

CREATE TABLE `auth_group_permissions` (
  `id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `auth_permission`
--

CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `auth_permission`
--

INSERT INTO `auth_permission` (`id`, `name`, `content_type_id`, `codename`) VALUES
(1, 'Can add log entry', 1, 'add_logentry'),
(2, 'Can change log entry', 1, 'change_logentry'),
(3, 'Can delete log entry', 1, 'delete_logentry'),
(4, 'Can view log entry', 1, 'view_logentry'),
(5, 'Can add permission', 2, 'add_permission'),
(6, 'Can change permission', 2, 'change_permission'),
(7, 'Can delete permission', 2, 'delete_permission'),
(8, 'Can view permission', 2, 'view_permission'),
(9, 'Can add group', 3, 'add_group'),
(10, 'Can change group', 3, 'change_group'),
(11, 'Can delete group', 3, 'delete_group'),
(12, 'Can view group', 3, 'view_group'),
(13, 'Can add user', 4, 'add_user'),
(14, 'Can change user', 4, 'change_user'),
(15, 'Can delete user', 4, 'delete_user'),
(16, 'Can view user', 4, 'view_user'),
(17, 'Can add content type', 5, 'add_contenttype'),
(18, 'Can change content type', 5, 'change_contenttype'),
(19, 'Can delete content type', 5, 'delete_contenttype'),
(20, 'Can view content type', 5, 'view_contenttype'),
(21, 'Can add session', 6, 'add_session'),
(22, 'Can change session', 6, 'change_session'),
(23, 'Can delete session', 6, 'delete_session'),
(24, 'Can view session', 6, 'view_session'),
(25, 'Can add user', 7, 'add_user'),
(26, 'Can change user', 7, 'change_user'),
(27, 'Can delete user', 7, 'delete_user'),
(28, 'Can view user', 7, 'view_user'),
(29, 'Can add verification', 8, 'add_verification'),
(30, 'Can change verification', 8, 'change_verification'),
(31, 'Can delete verification', 8, 'delete_verification'),
(32, 'Can view verification', 8, 'view_verification'),
(33, 'Can add files', 9, 'add_files'),
(34, 'Can change files', 9, 'change_files'),
(35, 'Can delete files', 9, 'delete_files'),
(36, 'Can view files', 9, 'view_files'),
(37, 'Can add shared', 10, 'add_shared'),
(38, 'Can change shared', 10, 'change_shared'),
(39, 'Can delete shared', 10, 'delete_shared'),
(40, 'Can view shared', 10, 'view_shared');

-- --------------------------------------------------------

--
-- Table structure for table `auth_user`
--

CREATE TABLE `auth_user` (
  `id` int(11) NOT NULL,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(30) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `auth_user_groups`
--

CREATE TABLE `auth_user_groups` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `auth_user_user_permissions`
--

CREATE TABLE `auth_user_user_permissions` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `django_admin_log`
--

CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext DEFAULT NULL,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) UNSIGNED NOT NULL CHECK (`action_flag` >= 0),
  `change_message` longtext NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `django_content_type`
--

CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `django_content_type`
--

INSERT INTO `django_content_type` (`id`, `app_label`, `model`) VALUES
(1, 'admin', 'logentry'),
(9, 'app', 'files'),
(10, 'app', 'shared'),
(7, 'app', 'user'),
(8, 'app', 'verification'),
(3, 'auth', 'group'),
(2, 'auth', 'permission'),
(4, 'auth', 'user'),
(5, 'contenttypes', 'contenttype'),
(6, 'sessions', 'session');

-- --------------------------------------------------------

--
-- Table structure for table `django_migrations`
--

CREATE TABLE `django_migrations` (
  `id` int(11) NOT NULL,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `django_migrations`
--

INSERT INTO `django_migrations` (`id`, `app`, `name`, `applied`) VALUES
(1, 'contenttypes', '0001_initial', '2020-03-11 07:37:17.540291'),
(2, 'auth', '0001_initial', '2020-03-11 07:37:20.237778'),
(3, 'admin', '0001_initial', '2020-03-11 07:37:36.911732'),
(4, 'admin', '0002_logentry_remove_auto_add', '2020-03-11 07:37:38.995655'),
(5, 'admin', '0003_logentry_add_action_flag_choices', '2020-03-11 07:37:39.069457'),
(6, 'app', '0001_initial', '2020-03-11 07:37:40.378642'),
(7, 'contenttypes', '0002_remove_content_type_name', '2020-03-11 07:37:44.307494'),
(8, 'auth', '0002_alter_permission_name_max_length', '2020-03-11 07:37:45.198644'),
(9, 'auth', '0003_alter_user_email_max_length', '2020-03-11 07:37:45.290104'),
(10, 'auth', '0004_alter_user_username_opts', '2020-03-11 07:37:45.332953'),
(11, 'auth', '0005_alter_user_last_login_null', '2020-03-11 07:37:46.654154'),
(12, 'auth', '0006_require_contenttypes_0002', '2020-03-11 07:37:46.720019'),
(13, 'auth', '0007_alter_validators_add_error_messages', '2020-03-11 07:37:46.775865'),
(14, 'auth', '0008_alter_user_username_max_length', '2020-03-11 07:37:46.882251'),
(15, 'auth', '0009_alter_user_last_name_max_length', '2020-03-11 07:37:46.992955'),
(16, 'auth', '0010_alter_group_name_max_length', '2020-03-11 07:37:47.093655'),
(17, 'auth', '0011_update_proxy_permissions', '2020-03-11 07:37:47.498571'),
(18, 'sessions', '0001_initial', '2020-03-11 07:37:47.777858'),
(19, 'app', '0002_files', '2020-03-21 06:39:03.063460'),
(20, 'app', '0003_shared', '2020-03-30 13:45:20.974370'),
(21, 'app', '0004_auto_20200330_2212', '2020-03-30 16:42:46.228024'),
(22, 'app', '0005_auto_20200409_1133', '2020-04-09 06:04:25.632322');

-- --------------------------------------------------------

--
-- Table structure for table `django_session`
--

CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `django_session`
--

INSERT INTO `django_session` (`session_key`, `session_data`, `expire_date`) VALUES
('1zydzraje0s85yq62pfgu888xi9ku30f', 'ODk5Yjc1MmY0NjlhNTE3N2QyYzE2MTk0ZGQyMWU4ZTc2NzA1MzI3MTp7InVzZXJfaWQiOjEsInVzZXJfZW1haWwiOiJ2YWliaGF2cGF0ZWwxOTIxQGdtYWlsLmNvbSIsInZhdWx0X2F1dGgiOnRydWV9', '2020-04-14 12:43:45.087490'),
('2kza107uk38v91g16b8rnsrmvrlu872p', 'M2ZiOGZiYmRkYWYyNGM3N2Y3MDhhMDgxYjNlMTc4MWViZDJhZGRmNDp7InVzZXJfaWQiOjEsInVzZXJfZW1haWwiOiJ2YWliaGF2cGF0ZWwxOTIxQGdtYWlsLmNvbSJ9', '2020-04-13 14:00:36.025354'),
('4wa2pk09bjutga2oxzgsq368xmy4lo22', 'M2ZiOGZiYmRkYWYyNGM3N2Y3MDhhMDgxYjNlMTc4MWViZDJhZGRmNDp7InVzZXJfaWQiOjEsInVzZXJfZW1haWwiOiJ2YWliaGF2cGF0ZWwxOTIxQGdtYWlsLmNvbSJ9', '2020-04-04 07:36:23.127533'),
('6nufg61vjm1rhsirrjnbu2wgc5lk4kuq', 'M2ZiOGZiYmRkYWYyNGM3N2Y3MDhhMDgxYjNlMTc4MWViZDJhZGRmNDp7InVzZXJfaWQiOjEsInVzZXJfZW1haWwiOiJ2YWliaGF2cGF0ZWwxOTIxQGdtYWlsLmNvbSJ9', '2020-04-13 12:55:57.759136'),
('7q2jk1k6he6srgsuzrf04mso4s8l1cr1', 'M2ZiOGZiYmRkYWYyNGM3N2Y3MDhhMDgxYjNlMTc4MWViZDJhZGRmNDp7InVzZXJfaWQiOjEsInVzZXJfZW1haWwiOiJ2YWliaGF2cGF0ZWwxOTIxQGdtYWlsLmNvbSJ9', '2020-04-23 10:05:24.418116'),
('8gaz98koc8pen3n53ahkwpjh31wmo4oq', 'M2ZiOGZiYmRkYWYyNGM3N2Y3MDhhMDgxYjNlMTc4MWViZDJhZGRmNDp7InVzZXJfaWQiOjEsInVzZXJfZW1haWwiOiJ2YWliaGF2cGF0ZWwxOTIxQGdtYWlsLmNvbSJ9', '2020-04-13 06:42:17.170550'),
('8vb2ppb86wzyrthk8vbecxrtizh8z68v', 'M2ZiOGZiYmRkYWYyNGM3N2Y3MDhhMDgxYjNlMTc4MWViZDJhZGRmNDp7InVzZXJfaWQiOjEsInVzZXJfZW1haWwiOiJ2YWliaGF2cGF0ZWwxOTIxQGdtYWlsLmNvbSJ9', '2020-04-04 07:46:28.332464'),
('9vk02pb4m9019fmnl7cudprx5yub93gl', 'M2ZiOGZiYmRkYWYyNGM3N2Y3MDhhMDgxYjNlMTc4MWViZDJhZGRmNDp7InVzZXJfaWQiOjEsInVzZXJfZW1haWwiOiJ2YWliaGF2cGF0ZWwxOTIxQGdtYWlsLmNvbSJ9', '2020-04-06 15:04:38.224134'),
('arnns7pss7nvymdg2q8g6ts0y51hf7rf', 'M2ZiOGZiYmRkYWYyNGM3N2Y3MDhhMDgxYjNlMTc4MWViZDJhZGRmNDp7InVzZXJfaWQiOjEsInVzZXJfZW1haWwiOiJ2YWliaGF2cGF0ZWwxOTIxQGdtYWlsLmNvbSJ9', '2020-04-06 16:28:29.129537'),
('b1dp9xh3ztr6573y648fwadmrv4gldn9', 'M2ZiOGZiYmRkYWYyNGM3N2Y3MDhhMDgxYjNlMTc4MWViZDJhZGRmNDp7InVzZXJfaWQiOjEsInVzZXJfZW1haWwiOiJ2YWliaGF2cGF0ZWwxOTIxQGdtYWlsLmNvbSJ9', '2020-04-12 14:32:25.776784'),
('bazo5dqq0dya1him4norkhrd5weqz9pc', 'ZWY5Y2E4ZDIwNGQ4ZGNkMmYxMmYzY2ZhYjQ2Y2Y2YmQ0ZGViZWRlMzp7InVzZXIiOjEsInVzZXJfZW1haWwiOiJ2YWliaGF2cGF0ZWwxOTIxQGdtYWlsLmNvbSJ9', '2020-04-03 17:54:12.898648'),
('dxn7590fbkeq6zgzih6c0qkyjki1imct', 'ODk5Yjc1MmY0NjlhNTE3N2QyYzE2MTk0ZGQyMWU4ZTc2NzA1MzI3MTp7InVzZXJfaWQiOjEsInVzZXJfZW1haWwiOiJ2YWliaGF2cGF0ZWwxOTIxQGdtYWlsLmNvbSIsInZhdWx0X2F1dGgiOnRydWV9', '2020-04-21 02:50:57.451244'),
('g2ytyps3kc4afkx5vzlgmjql4ql6fpk8', 'M2ZiOGZiYmRkYWYyNGM3N2Y3MDhhMDgxYjNlMTc4MWViZDJhZGRmNDp7InVzZXJfaWQiOjEsInVzZXJfZW1haWwiOiJ2YWliaGF2cGF0ZWwxOTIxQGdtYWlsLmNvbSJ9', '2020-04-12 05:33:26.070135'),
('g58ex6pnzdpm72g3kjzzk2ovctrf9o2g', 'M2ZiOGZiYmRkYWYyNGM3N2Y3MDhhMDgxYjNlMTc4MWViZDJhZGRmNDp7InVzZXJfaWQiOjEsInVzZXJfZW1haWwiOiJ2YWliaGF2cGF0ZWwxOTIxQGdtYWlsLmNvbSJ9', '2020-04-22 09:07:46.281832'),
('hhkvsfx7lmgg2pjjlwyzhszzawhlkjn0', 'M2ZiOGZiYmRkYWYyNGM3N2Y3MDhhMDgxYjNlMTc4MWViZDJhZGRmNDp7InVzZXJfaWQiOjEsInVzZXJfZW1haWwiOiJ2YWliaGF2cGF0ZWwxOTIxQGdtYWlsLmNvbSJ9', '2020-04-22 09:05:17.096412'),
('i88u231gm4t1kk5eki6v8sekrbt5f3c6', 'M2ZiOGZiYmRkYWYyNGM3N2Y3MDhhMDgxYjNlMTc4MWViZDJhZGRmNDp7InVzZXJfaWQiOjEsInVzZXJfZW1haWwiOiJ2YWliaGF2cGF0ZWwxOTIxQGdtYWlsLmNvbSJ9', '2020-04-04 07:52:11.842839'),
('injvy01p8c29u5lcdo0v6iy5z6u7skwx', 'ZTQ3N2RjNzBlOThmNDc1NzMyM2E5Y2EyMGM1MGM1YTY5ZGQwNmNlOTp7InZhdWx0X2F1dGgiOnRydWUsInVzZXJfaWQiOjEsInVzZXJfZW1haWwiOiJ2YWliaGF2cGF0ZWwxOTIxQGdtYWlsLmNvbSJ9', '2020-04-23 10:58:12.294984'),
('kk0q4wm9sqnryn5ggl8kog7s281gnfny', 'M2ZiOGZiYmRkYWYyNGM3N2Y3MDhhMDgxYjNlMTc4MWViZDJhZGRmNDp7InVzZXJfaWQiOjEsInVzZXJfZW1haWwiOiJ2YWliaGF2cGF0ZWwxOTIxQGdtYWlsLmNvbSJ9', '2020-04-13 10:40:54.316650'),
('p2i72g7rhdpfk0g36fbcv7k1zkwbvbut', 'M2ZiOGZiYmRkYWYyNGM3N2Y3MDhhMDgxYjNlMTc4MWViZDJhZGRmNDp7InVzZXJfaWQiOjEsInVzZXJfZW1haWwiOiJ2YWliaGF2cGF0ZWwxOTIxQGdtYWlsLmNvbSJ9', '2020-04-12 07:10:50.582575'),
('r65a2rsj3oxbm8s70fz5603yy0qh9sa8', 'ZWY5Y2E4ZDIwNGQ4ZGNkMmYxMmYzY2ZhYjQ2Y2Y2YmQ0ZGViZWRlMzp7InVzZXIiOjEsInVzZXJfZW1haWwiOiJ2YWliaGF2cGF0ZWwxOTIxQGdtYWlsLmNvbSJ9', '2020-03-26 18:00:28.923109'),
('rsludyqe3f4qwqxnblv3ahydmo3supqv', 'M2ZiOGZiYmRkYWYyNGM3N2Y3MDhhMDgxYjNlMTc4MWViZDJhZGRmNDp7InVzZXJfaWQiOjEsInVzZXJfZW1haWwiOiJ2YWliaGF2cGF0ZWwxOTIxQGdtYWlsLmNvbSJ9', '2020-04-13 07:18:04.008242'),
('sg4sngmgbuj3e0q9y1001xfnxygsd1kh', 'M2ZiOGZiYmRkYWYyNGM3N2Y3MDhhMDgxYjNlMTc4MWViZDJhZGRmNDp7InVzZXJfaWQiOjEsInVzZXJfZW1haWwiOiJ2YWliaGF2cGF0ZWwxOTIxQGdtYWlsLmNvbSJ9', '2020-04-03 18:41:58.531462'),
('tfy1i87y9f29ph8ztuzl6ngrblsk5ya1', 'MmFkOTA5OGNmZTEzNmZjOTEwODQyMTBmYjE4ZTRjZGM1MGY1Yjc3MTp7InVzZXJfaWQiOjEzLCJ1c2VyX2VtYWlsIjoieWFzaDQ5QGdtYWlsLmNvbSJ9', '2020-04-26 08:58:15.937015'),
('ybi4xdar3fgexwx3smd9896skrgbcron', 'ZTQ3N2RjNzBlOThmNDc1NzMyM2E5Y2EyMGM1MGM1YTY5ZGQwNmNlOTp7InZhdWx0X2F1dGgiOnRydWUsInVzZXJfaWQiOjEsInVzZXJfZW1haWwiOiJ2YWliaGF2cGF0ZWwxOTIxQGdtYWlsLmNvbSJ9', '2020-04-26 09:34:57.066933'),
('ypjpxdjvxo79oow2285kniuwz3mfdrry', 'M2ZiOGZiYmRkYWYyNGM3N2Y3MDhhMDgxYjNlMTc4MWViZDJhZGRmNDp7InVzZXJfaWQiOjEsInVzZXJfZW1haWwiOiJ2YWliaGF2cGF0ZWwxOTIxQGdtYWlsLmNvbSJ9', '2020-04-13 06:55:16.023483');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `app_files`
--
ALTER TABLE `app_files`
  ADD PRIMARY KEY (`id`),
  ADD KEY `app_files_user_id_fbc7dfc0_fk_app_user_id` (`user_id`),
  ADD KEY `FK_folder` (`folder_id`);

--
-- Indexes for table `app_folder`
--
ALTER TABLE `app_folder`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `app_shared`
--
ALTER TABLE `app_shared`
  ADD PRIMARY KEY (`id`),
  ADD KEY `app_shared_sharedUser_id_da7e3710_fk_app_user_id` (`sharedUser_id`),
  ADD KEY `app_shared_user_id_f7a33115_fk_app_user_id` (`user_id`);

--
-- Indexes for table `app_user`
--
ALTER TABLE `app_user`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `app_verification`
--
ALTER TABLE `app_verification`
  ADD PRIMARY KEY (`id`),
  ADD KEY `app_verification_user_id_82713bde_fk_app_user_id` (`user_id`);

--
-- Indexes for table `auth_group`
--
ALTER TABLE `auth_group`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  ADD KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`);

--
-- Indexes for table `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`);

--
-- Indexes for table `auth_user`
--
ALTER TABLE `auth_user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  ADD KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`);

--
-- Indexes for table `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  ADD KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`);

--
-- Indexes for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  ADD KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`);

--
-- Indexes for table `django_content_type`
--
ALTER TABLE `django_content_type`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`);

--
-- Indexes for table `django_migrations`
--
ALTER TABLE `django_migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `django_session`
--
ALTER TABLE `django_session`
  ADD PRIMARY KEY (`session_key`),
  ADD KEY `django_session_expire_date_a5c62663` (`expire_date`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `app_files`
--
ALTER TABLE `app_files`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT for table `app_folder`
--
ALTER TABLE `app_folder`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `app_shared`
--
ALTER TABLE `app_shared`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `app_user`
--
ALTER TABLE `app_user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `app_verification`
--
ALTER TABLE `app_verification`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `auth_group`
--
ALTER TABLE `auth_group`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_permission`
--
ALTER TABLE `auth_permission`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT for table `auth_user`
--
ALTER TABLE `auth_user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `django_content_type`
--
ALTER TABLE `django_content_type`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `django_migrations`
--
ALTER TABLE `django_migrations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `app_files`
--
ALTER TABLE `app_files`
  ADD CONSTRAINT `FK_folder` FOREIGN KEY (`folder_id`) REFERENCES `app_folder` (`id`),
  ADD CONSTRAINT `app_files_user_id_fbc7dfc0_fk_app_user_id` FOREIGN KEY (`user_id`) REFERENCES `app_user` (`id`);

--
-- Constraints for table `app_shared`
--
ALTER TABLE `app_shared`
  ADD CONSTRAINT `app_shared_sharedUser_id_da7e3710_fk_app_user_id` FOREIGN KEY (`sharedUser_id`) REFERENCES `app_user` (`id`),
  ADD CONSTRAINT `app_shared_user_id_f7a33115_fk_app_user_id` FOREIGN KEY (`user_id`) REFERENCES `app_user` (`id`);

--
-- Constraints for table `app_verification`
--
ALTER TABLE `app_verification`
  ADD CONSTRAINT `app_verification_user_id_82713bde_fk_app_user_id` FOREIGN KEY (`user_id`) REFERENCES `app_user` (`id`);

--
-- Constraints for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`);

--
-- Constraints for table `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`);

--
-- Constraints for table `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  ADD CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  ADD CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  ADD CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  ADD CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
