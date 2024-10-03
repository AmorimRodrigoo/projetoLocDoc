-- Criando o banco de dados
CREATE DATABASE IF NOT EXISTS locdoc_sistema;
USE locdoc_sistema;

-- Tabela de Usuários (administradores, funcionários, etc.)
CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    senha VARCHAR(100) NOT NULL,
    cargo VARCHAR(50),
    nivel_acesso ENUM('admin', 'usuario', 'visualizador') DEFAULT 'usuario',
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de Documentos
CREATE TABLE documentos (
    id_documento INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    tipo_documento ENUM('contrato', 'nota_fiscal', 'relatorio', 'outro') NOT NULL,
    caminho_arquivo VARCHAR(255) NOT NULL,
    criado_por INT,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    atualizado_por INT,
    atualizado_em TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (criado_por) REFERENCES usuarios(id_usuario),
    FOREIGN KEY (atualizado_por) REFERENCES usuarios(id_usuario)
);

-- Tabela de Histórico de Acessos e Modificações de Documentos
CREATE TABLE historico_documentos (
    id_historico INT AUTO_INCREMENT PRIMARY KEY,
    id_documento INT NOT NULL,
    id_usuario INT NOT NULL,
    tipo_acesso ENUM('acesso', 'modificacao') NOT NULL,
    data_acesso TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_documento) REFERENCES documentos(id_documento),
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
);

-- Tabela de Permissões (definindo quem pode acessar o quê)
CREATE TABLE permissoes (
    id_permissao INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_documento INT NOT NULL,
    tipo_permissao ENUM('leitura', 'escrita', 'admin') NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
    FOREIGN KEY (id_documento) REFERENCES documentos(id_documento)
);

-- Tabela de Relatórios Semanais (dados sobre uso de documentos)
CREATE TABLE relatorios_semanais (
    id_relatorio INT AUTO_INCREMENT PRIMARY KEY,
    semana_inicio DATE NOT NULL,
    semana_fim DATE NOT NULL,
    total_documentos_retidados INT NOT NULL,
    percentual_usuarios_ativos DECIMAL(5,2) NOT NULL
);
