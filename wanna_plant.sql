-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 06, 2021 at 06:02 PM
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
  `tracking` tinyint(3) NOT NULL,
  `status` tinyint(4) NOT NULL,
  `rating` float NOT NULL,
  `datetime` varchar(30) COLLATE utf8_unicode_ci NOT NULL,
  `date_confirm` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `date_prepare` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `date_planting` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `date_harvest` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `date_delivery` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `date_success` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
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

-- --------------------------------------------------------

--
-- Table structure for table `picture`
--

CREATE TABLE `picture` (
  `pic_id` mediumint(7) NOT NULL,
  `pic_name` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `land_id` mediumint(7) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

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
  MODIFY `activity_id` mediumint(7) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

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
