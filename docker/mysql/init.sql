# MySQL Initialization Script for Barca Tactical Planner (Flickboard)
# Target Database: barca_tactical_db

CREATE DATABASE IF NOT EXISTS `barca_tactical_db` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `barca_tactical_db`;

-- 1. Tabel users
CREATE TABLE IF NOT EXISTS `users` (
    `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL,
    `email` VARCHAR(255) UNIQUE NOT NULL,
    `password` VARCHAR(255) NOT NULL,
    `role` VARCHAR(50) DEFAULT 'tactical_analyst',
    `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2. Tabel opponents
CREATE TABLE IF NOT EXISTS `opponents` (
    `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `team_name` VARCHAR(150) NOT NULL,
    `logo_url` VARCHAR(255) NULL,
    `attacking_strength` INT NOT NULL CHECK (`attacking_strength` BETWEEN 1 AND 100),
    `defensive_strength` INT NOT NULL CHECK (`defensive_strength` BETWEEN 1 AND 100),
    `pressing_vulnerability` INT NOT NULL CHECK (`pressing_vulnerability` BETWEEN 1 AND 100),
    `counter_attack_threat` INT NOT NULL CHECK (`counter_attack_threat` BETWEEN 1 AND 100),
    `key_player_name` VARCHAR(150) NOT NULL,
    `key_player_pace` INT NOT NULL CHECK (`key_player_pace` BETWEEN 1 AND 100),
    `scouting_notes` TEXT NULL,
    `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3. Tabel barca_players
CREATE TABLE IF NOT EXISTS `barca_players` (
    `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(150) NOT NULL,
    `shirt_number` INT NOT NULL,
    `position` VARCHAR(10) NOT NULL, -- GK, CB, LB, RB, DM, CM, AM, RW, LW, CF
    `overall_rating` INT NOT NULL CHECK (`overall_rating` BETWEEN 1 AND 100),
    `pace` INT NOT NULL CHECK (`pace` BETWEEN 1 AND 100),
    `passing` INT NOT NULL CHECK (`passing` BETWEEN 1 AND 100),
    `defending` INT NOT NULL CHECK (`defending` BETWEEN 1 AND 100),
    `photo_url` VARCHAR(255) NULL,
    `is_active` BOOLEAN DEFAULT TRUE,
    `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 4. Tabel matches
CREATE TABLE IF NOT EXISTS `matches` (
    `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `opponent_id` BIGINT UNSIGNED NOT NULL,
    `match_date` DATETIME NOT NULL,
    `venue` ENUM('HOME', 'AWAY', 'NEUTRAL') DEFAULT 'HOME',
    `competition` VARCHAR(100) DEFAULT 'La Liga EA Sports',
    `context_description` TEXT NOT NULL,
    `status` ENUM('UPCOMING', 'SIMULATED', 'ARCHIVED') DEFAULT 'UPCOMING',
    `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`opponent_id`) REFERENCES `opponents`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 5. Tabel simulations
CREATE TABLE IF NOT EXISTS `simulations` (
    `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `user_id` BIGINT UNSIGNED NOT NULL,
    `match_id` BIGINT UNSIGNED NOT NULL,
    `formation_used` VARCHAR(20) NOT NULL DEFAULT '4-2-3-1',
    `starting_xi_json` JSON NOT NULL,
    `ppda_intensity` DECIMAL(4, 2) NOT NULL,
    `defensive_line_height` DECIMAL(3, 1) NOT NULL,
    `tempo_value` DECIMAL(3, 1) NOT NULL DEFAULT 5.0,
    `win_probability` DECIMAL(5, 4) NOT NULL,
    `draw_probability` DECIMAL(5, 4) NOT NULL,
    `loss_probability` DECIMAL(5, 4) NOT NULL,
    `tactical_grade` VARCHAR(5) NOT NULL,
    `simulation_result_json` JSON NOT NULL,
    `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_user_match` (`user_id`, `match_id`),
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`match_id`) REFERENCES `matches`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
