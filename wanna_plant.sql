-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 03, 2021 at 07:43 PM
-- Server version: 10.4.21-MariaDB
-- PHP Version: 7.3.31

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `wanna_plant`
--
CREATE DATABASE IF NOT EXISTS `wanna_plant` DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
USE `wanna_plant`;

-- --------------------------------------------------------

--
-- Table structure for table `activities`
--

CREATE TABLE `activities` (
  `activity_id` mediumint(7) NOT NULL,
  `activity_type` tinyint(3) NOT NULL,
  `tracking` tinyint(3) NOT NULL,
  `rating` float NOT NULL,
  `datetime` date NOT NULL,
  `plants_name` varchar(30) COLLATE utf8_unicode_ci NOT NULL,
  `total_price` int(11) NOT NULL,
  `customer` mediumint(7) NOT NULL,
  `planter` mediumint(7) NOT NULL,
  `land_id` mediumint(7) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `favorites`
--

CREATE TABLE `favorites` (
  `user_id` mediumint(7) NOT NULL,
  `land_id` mediumint(7) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `favorites`
--

INSERT INTO `favorites` (`user_id`, `land_id`) VALUES
(32, 21),
(32, 23);

-- --------------------------------------------------------

--
-- Table structure for table `lands`
--

CREATE TABLE `lands` (
  `land_id` mediumint(7) NOT NULL,
  `land_area` smallint(5) NOT NULL,
  `land_unit` varchar(30) COLLATE utf8_unicode_ci NOT NULL,
  `land_description` varchar(150) COLLATE utf8_unicode_ci NOT NULL,
  `user_id` mediumint(7) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `lands`
--

INSERT INTO `lands` (`land_id`, `land_area`, `land_unit`, `land_description`, `user_id`) VALUES
(20, 300, 'Square Centimeter', 'fasdfasdf', 32),
(21, 125, 'Square Meter', 'My land beautiful', 33),
(23, 788, 'Square Meter', 'Please wait for a long time until we open farm .', 39),
(24, 300, 'Square Centimeter', 'sdfgsdfg', 40);

-- --------------------------------------------------------

--
-- Table structure for table `picture`
--

CREATE TABLE `picture` (
  `pic_id` mediumint(7) NOT NULL,
  `pic_name` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `land_id` mediumint(7) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `picture`
--

INSERT INTO `picture` (`pic_id`, `pic_name`, `land_id`) VALUES
(21, '1638117927573_image_picker801988174.jpg', 20),
(22, '1638117928118_image_picker45157347.jpg', 20),
(23, '1638162050530_image_picker466360730.jpg', 21),
(24, '1638162052241_image_picker1750043865.jpg', 21),
(25, '1638162052243_image_picker1701577681.jpg', 21),
(28, '1638297013133_image_picker1815946559.jpg', 23),
(29, '1638297013964_image_picker466538752.jpg', 23),
(30, '1638297013967_image_picker2083530155.jpg', 23),
(31, '1638297014245_image_picker748553730.jpg', 23),
(32, '1638297015375_image_picker243809803.jpg', 23),
(33, '1638297015658_image_picker1981397545.jpg', 23),
(34, '1638301299686_image_picker1039363836.jpg', 24);

-- --------------------------------------------------------

--
-- Table structure for table `plants`
--

CREATE TABLE `plants` (
  `plants_id` mediumint(7) NOT NULL,
  `plants_name` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `plants_price` smallint(5) NOT NULL,
  `land_id` mediumint(7) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `plants`
--

INSERT INTO `plants` (`plants_id`, `plants_name`, `plants_price`, `land_id`) VALUES
(28, 'carrot', 20, 20),
(29, 'apple', 30, 20),
(30, 'carrot', 150, 21),
(33, 'fuck', 7411, 23),
(34, 'popcorn', 144, 23),
(35, 'susa', 1477, 23),
(36, 'carr', 20, 24),
(37, 'asdfa', 30, 24),
(38, 'adsf', 20, 24);

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `user_id` mediumint(7) NOT NULL,
  `name` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `username` varchar(30) COLLATE utf8_unicode_ci NOT NULL,
  `password` varchar(60) COLLATE utf8_unicode_ci NOT NULL,
  `phonenumber` varchar(10) COLLATE utf8_unicode_ci NOT NULL,
  `address` varchar(150) COLLATE utf8_unicode_ci NOT NULL,
  `province` varchar(60) COLLATE utf8_unicode_ci NOT NULL,
  `promptpay` varchar(15) COLLATE utf8_unicode_ci NOT NULL,
  `facephoto` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `idcardphoto` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `identify` tinyint(4) NOT NULL,
  `role` tinyint(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`user_id`, `name`, `username`, `password`, `phonenumber`, `address`, `province`, `promptpay`, `facephoto`, `idcardphoto`, `identify`, `role`) VALUES
(32, 'pun Kongsomboon', 'punonly', '$2b$10$6T9TyvNk1kNohVPW0aBmRu6uuuGjdyygeN/6jsTl3HO4ikZ/wpJqy', '0655060401', 'dfsdfas', 'Chiang Mai', '0655060401', '', '', 1, 2),
(33, 'Peetikorn', 'kunnkorn', '$2b$10$E2VNgDbLdN12YONCSvXnIOPZEKqcj.1pzKbJPg/36a6AQVD.SF/dC', '0992088711', '104 Aloha thailand', 'Chiang Rai', '0992088711', '', '', 1, 2),
(39, 'yeelo', 'im', '$2b$10$bNe9iOQ9ddhriWRWfSkboOotweQs6JyVxCN5mcyWakFVl2gWYTvaK', '0833612917', '413', 'Chiang Rai', '15471111120', NULL, NULL, 1, 2),
(40, 'test', 'testonly', '$2b$10$2DrBO.g6dvPPhKoQdxj0O.LKsNRuJhgVn8sZxw9V1ehNxOWviG9oC', '22', 'sdfg', 'Chanthaburi', '654564', NULL, NULL, 1, 2),
(43, 'rtsdfg', 'orderbotton', '$2b$10$YHx9IQlSYUUGHJGtpaAZzOsn.BXMdLPkpqhn3kfFn1ByRF.T2kihy', '0655060401', 'dfadf', 'Chanthaburi', '546465', NULL, NULL, 0, 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `activities`
--
ALTER TABLE `activities`
  ADD PRIMARY KEY (`activity_id`),
  ADD KEY `customer` (`customer`),
  ADD KEY `planter` (`planter`),
  ADD KEY `land_id` (`land_id`);

--
-- Indexes for table `favorites`
--
ALTER TABLE `favorites`
  ADD PRIMARY KEY (`user_id`,`land_id`),
  ADD KEY `user_id` (`user_id`,`land_id`),
  ADD KEY `land_id` (`land_id`);

--
-- Indexes for table `lands`
--
ALTER TABLE `lands`
  ADD PRIMARY KEY (`land_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `picture`
--
ALTER TABLE `picture`
  ADD PRIMARY KEY (`pic_id`),
  ADD KEY `land_id` (`land_id`);

--
-- Indexes for table `plants`
--
ALTER TABLE `plants`
  ADD PRIMARY KEY (`plants_id`),
  ADD KEY `land_id` (`land_id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`user_id`,`username`) USING BTREE;

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `activities`
--
ALTER TABLE `activities`
  MODIFY `activity_id` mediumint(7) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `lands`
--
ALTER TABLE `lands`
  MODIFY `land_id` mediumint(7) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `picture`
--
ALTER TABLE `picture`
  MODIFY `pic_id` mediumint(7) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT for table `plants`
--
ALTER TABLE `plants`
  MODIFY `plants_id` mediumint(7) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `user_id` mediumint(7) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `activities`
--
ALTER TABLE `activities`
  ADD CONSTRAINT `activities_ibfk_1` FOREIGN KEY (`customer`) REFERENCES `user` (`user_id`),
  ADD CONSTRAINT `activities_ibfk_2` FOREIGN KEY (`planter`) REFERENCES `user` (`user_id`),
  ADD CONSTRAINT `activities_ibfk_3` FOREIGN KEY (`land_id`) REFERENCES `lands` (`land_id`);

--
-- Constraints for table `favorites`
--
ALTER TABLE `favorites`
  ADD CONSTRAINT `favorites_ibfk_1` FOREIGN KEY (`land_id`) REFERENCES `lands` (`land_id`),
  ADD CONSTRAINT `favorites_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`);

--
-- Constraints for table `lands`
--
ALTER TABLE `lands`
  ADD CONSTRAINT `lands_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`);

--
-- Constraints for table `picture`
--
ALTER TABLE `picture`
  ADD CONSTRAINT `picture_ibfk_1` FOREIGN KEY (`land_id`) REFERENCES `lands` (`land_id`);

--
-- Constraints for table `plants`
--
ALTER TABLE `plants`
  ADD CONSTRAINT `plants_ibfk_1` FOREIGN KEY (`land_id`) REFERENCES `lands` (`land_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
