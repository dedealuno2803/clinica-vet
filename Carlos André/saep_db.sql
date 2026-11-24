-- ============================================================
-- SAEP — Script de criação e população do banco de dados
-- Sistema: ClínicaPet (Clínica Veterinária)
-- Estudante: Carlos André
-- Mínimo de 3 registros por tabela
-- ============================================================

CREATE DATABASE IF NOT EXISTS clinicapet
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE clinicapet;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS agendamentos;
DROP TABLE IF EXISTS pets;
DROP TABLE IF EXISTS tutores;
DROP TABLE IF EXISTS usuarios;

SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE usuarios (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  email VARCHAR(120) NOT NULL UNIQUE,
  senha VARCHAR(255) NOT NULL,
  perfil VARCHAR(30) NOT NULL DEFAULT 'Atendente'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Senha de teste: vet2026
INSERT INTO usuarios (nome, email, senha, perfil) VALUES
('Carlos André Gestor', 'gestor@clinicapet.local', '$2y$10$JFI.yKDYIKbF8QS4YA13j.K1BTZEBCYSr5ASLNb8d487hTkFgxb8.', 'Administrador'),
('Beatriz Recepção', 'recepcao@clinicapet.local', '$2y$10$JFI.yKDYIKbF8QS4YA13j.K1BTZEBCYSr5ASLNb8d487hTkFgxb8.', 'Atendente'),
('Dra. Helena Vet', 'veterinario@clinicapet.local', '$2y$10$JFI.yKDYIKbF8QS4YA13j.K1BTZEBCYSr5ASLNb8d487hTkFgxb8.', 'Veterinário');

CREATE TABLE tutores (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  cpf VARCHAR(255) NOT NULL COMMENT 'CPF criptografado AES-256-CBC',
  telefone VARCHAR(20) NULL,
  email VARCHAR(120) NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- CPFs: 321.654.987-00 | 147.258.369-11 | 852.963.741-22
INSERT INTO tutores (nome, cpf, telefone, email) VALUES
('Amanda Nogueira', 'yn9WNCtHDDJB6sL9nQ6Wdg==', '(81) 99440-1100', 'amanda.nogueira@email.com'),
('Felipe Barbosa', 'uDug1ERC6Ho0EcwOhuMChQ==', '(81) 99330-2200', 'felipe.barbosa@email.com'),
('Patrícia Gomes', 'FJPpofbQQC16Ss3y14xG+g==', '(81) 99220-3300', 'patricia.gomes@email.com');

CREATE TABLE pets (
  id INT AUTO_INCREMENT PRIMARY KEY,
  tutor_id INT NOT NULL,
  nome VARCHAR(80) NOT NULL,
  especie VARCHAR(40) NOT NULL,
  raca VARCHAR(60) NULL,
  idade INT NULL,
  CONSTRAINT fk_pets_tutor
    FOREIGN KEY (tutor_id) REFERENCES tutores(id)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO pets (tutor_id, nome, especie, raca, idade) VALUES
(1, 'Bob', 'Cão', 'Beagle', 3),
(1, 'Nina', 'Gato', 'Maine Coon', 1),
(2, 'Max', 'Cão', 'Golden Retriever', 6),
(3, 'Mel', 'Gato', 'SRD', 4);

CREATE TABLE agendamentos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  tutor_id INT NOT NULL,
  pet_id INT NOT NULL,
  data_agendamento DATETIME NOT NULL,
  servico VARCHAR(150) NOT NULL,
  status VARCHAR(30) NOT NULL DEFAULT 'Agendado',
  observacoes TEXT NULL,
  CONSTRAINT fk_agendamentos_tutor
    FOREIGN KEY (tutor_id) REFERENCES tutores(id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_agendamentos_pet
    FOREIGN KEY (pet_id) REFERENCES pets(id)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO agendamentos (tutor_id, pet_id, data_agendamento, servico, status, observacoes) VALUES
(1, 1, '2026-12-15 08:45:00', 'Vacinação antirrábica', 'Agendado', 'Trazer carteira de vacinação'),
(2, 3, '2026-12-16 13:00:00', 'Consulta dermatológica', 'Agendado', 'Coceira intensa'),
(3, 4, '2026-12-17 16:30:00', 'Exame de sangue', 'Em andamento', 'Jejum de 6 horas'),
(1, 2, '2026-12-18 10:00:00', 'Check-up geral', 'Agendado', NULL);

SELECT 'Banco clinicapet criado e populado.' AS mensagem;
SELECT 'usuarios' AS tabela, COUNT(*) AS qtd FROM usuarios
UNION ALL SELECT 'tutores', COUNT(*) FROM tutores
UNION ALL SELECT 'pets', COUNT(*) FROM pets
UNION ALL SELECT 'agendamentos', COUNT(*) FROM agendamentos;
