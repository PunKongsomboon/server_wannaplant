-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 28, 2021 at 06:50 PM
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
  `customer` mediumint(7) NOT NULL,
  `planter` mediumint(7) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `favorites`
--

CREATE TABLE `favorites` (
  `user_id` mediumint(7) NOT NULL,
  `land_id` mediumint(7) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

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
(20, 300, 'Square Centimeter', 'fasdfasdf', 32);

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
(22, '1638117928118_image_picker45157347.jpg', 20);

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
(28, 'carrat', 20, 20),
(29, 'apple', 30, 20);

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
  `promptpay` varchar(15) COLLATE utf8_unicode_ci NOT NULL,
  `facephoto` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `idcardphoto` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `identify` tinyint(4) NOT NULL,
  `role` tinyint(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`user_id`, `name`, `username`, `password`, `phonenumber`, `address`, `promptpay`, `facephoto`, `idcardphoto`, `identify`, `role`) VALUES
(32, 'pun Kongsomboon', 'punonly', '$2b$10$6T9TyvNk1kNohVPW0aBmRu6uuuGjdyygeN/6jsTl3HO4ikZ/wpJqy', '0655060401', 'dfsdfas', '0655060401', '', '', 1, 2);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `activities`
--
ALTER TABLE `activities`
  ADD PRIMARY KEY (`activity_id`),
  ADD KEY `customer` (`customer`),
  ADD KEY `planter` (`planter`);

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
  ADD PRIMARY KEY (`user_id`);

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
  MODIFY `land_id` mediumint(7) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `picture`
--
ALTER TABLE `picture`
  MODIFY `pic_id` mediumint(7) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `plants`
--
ALTER TABLE `plants`
  MODIFY `plants_id` mediumint(7) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `user_id` mediumint(7) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `activities`
--
ALTER TABLE `activities`
  ADD CONSTRAINT `activities_ibfk_1` FOREIGN KEY (`customer`) REFERENCES `user` (`user_id`),
  ADD CONSTRAINT `activities_ibfk_2` FOREIGN KEY (`planter`) REFERENCES `user` (`user_id`);

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