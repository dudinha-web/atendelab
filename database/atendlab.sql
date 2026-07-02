-- ============================================================
-- ATENDELAB - SCRIPT COMPLETO DO BANCO DE DADOS
-- Projeto: Sistema de Controle de Atendimentos Acadêmicos
-- Disciplina: Fábrica de Software
-- Objetivo: criar uma base completa para simulação local antes da aula
-- Banco: MySQL / MariaDB (compatível com XAMPP)
-- Charset: utf8mb4
-- ============================================================

-- ATENÇÃO:
-- Este script recria o banco do zero para facilitar a simulação.
-- Não execute em um ambiente que possua dados importantes sem backup.

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

DROP DATABASE IF EXISTS atendelab;

CREATE DATABASE atendelab
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_general_ci;

USE atendelab;

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================
-- 1. TABELA: usuarios
-- Armazena os usuários que podem acessar a área administrativa.
-- ============================================================
CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    perfil ENUM('admin', 'atendente') NOT NULL DEFAULT 'atendente',
    status ENUM('ativo', 'inativo') NOT NULL DEFAULT 'ativo',
    criado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    atualizado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ============================================================
-- 2. TABELA: pessoas
-- Armazena os alunos ou membros da comunidade atendidos.
-- ============================================================
CREATE TABLE pessoas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    documento VARCHAR(30) NOT NULL UNIQUE,
    telefone VARCHAR(20) NULL,
    email VARCHAR(150) NOT NULL,
    curso VARCHAR(120) NULL,
    periodo VARCHAR(20) NULL,
    observacoes TEXT NULL,
    status ENUM('ativo', 'inativo') NOT NULL DEFAULT 'ativo',
    criado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    atualizado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ============================================================
-- 3. TABELA: tipos_atendimentos
-- Armazena as categorias utilizadas no registro de atendimentos.
-- ============================================================
CREATE TABLE tipos_atendimentos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    descricao TEXT NULL,
    status ENUM('ativo', 'inativo') NOT NULL DEFAULT 'ativo',
    criado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    atualizado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ============================================================
-- 4. TABELA: atendimentos
-- Armazena os registros principais do sistema.
-- ============================================================
CREATE TABLE atendimentos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pessoa_id INT NOT NULL,
    tipo_atendimento_id INT NOT NULL,
    usuario_id INT NOT NULL,
    descricao TEXT NOT NULL,
    status ENUM('aberto', 'em_andamento', 'concluido') NOT NULL DEFAULT 'aberto',
    data_atendimento DATE NOT NULL,
    horario_atendimento TIME NOT NULL,
    observacao_final TEXT NULL,
    criado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    atualizado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_atendimentos_pessoa
        FOREIGN KEY (pessoa_id)
        REFERENCES pessoas(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_atendimentos_tipo
        FOREIGN KEY (tipo_atendimento_id)
        REFERENCES tipos_atendimentos(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_atendimentos_usuario
        FOREIGN KEY (usuario_id)
        REFERENCES usuarios(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ============================================================
-- 5. ÍNDICES AUXILIARES
-- Melhoram filtros, buscas e consultas do dashboard.
-- ============================================================
CREATE INDEX idx_pessoas_nome ON pessoas(nome);
CREATE INDEX idx_pessoas_email ON pessoas(email);
CREATE INDEX idx_pessoas_status ON pessoas(status);
CREATE INDEX idx_pessoas_curso ON pessoas(curso);

CREATE INDEX idx_tipos_status ON tipos_atendimentos(status);

CREATE INDEX idx_atendimentos_pessoa ON atendimentos(pessoa_id);
CREATE INDEX idx_atendimentos_tipo ON atendimentos(tipo_atendimento_id);
CREATE INDEX idx_atendimentos_usuario ON atendimentos(usuario_id);
CREATE INDEX idx_atendimentos_status ON atendimentos(status);
CREATE INDEX idx_atendimentos_data ON atendimentos(data_atendimento);
CREATE INDEX idx_atendimentos_status_data ON atendimentos(status, data_atendimento);

-- ============================================================
-- 6. USUÁRIOS INICIAIS
-- Senha de todos os usuários de teste: 123456
-- O banco armazena apenas o hash gerado com password_hash().
-- ============================================================
INSERT INTO usuarios (nome, email, senha, perfil, status) VALUES
(
    'Administrador',
    'admin@atendelab.com',
    '$2y$10$J9P2kU2BAMZ3TZcuxTsW4e1D/lka8EocYHzvyoOZmCNcWDQz3RuVC',
    'admin',
    'ativo'
),
(
    'Mariana Silva',
    'mariana.silva@atendelab.com',
    '$2y$10$J9P2kU2BAMZ3TZcuxTsW4e1D/lka8EocYHzvyoOZmCNcWDQz3RuVC',
    'atendente',
    'ativo'
),
(
    'Carlos Souza',
    'carlos.souza@atendelab.com',
    '$2y$10$J9P2kU2BAMZ3TZcuxTsW4e1D/lka8EocYHzvyoOZmCNcWDQz3RuVC',
    'atendente',
    'ativo'
),
(
    'Fernanda Lima',
    'fernanda.lima@atendelab.com',
    '$2y$10$J9P2kU2BAMZ3TZcuxTsW4e1D/lka8EocYHzvyoOZmCNcWDQz3RuVC',
    'atendente',
    'ativo'
),
(
    'Usuário Inativo',
    'inativo@atendelab.com',
    '$2y$10$J9P2kU2BAMZ3TZcuxTsW4e1D/lka8EocYHzvyoOZmCNcWDQz3RuVC',
    'atendente',
    'inativo'
);

-- ============================================================
-- 7. PESSOAS ATENDIDAS PARA SIMULAÇÃO
-- ============================================================
INSERT INTO pessoas
    (nome, documento, telefone, email, curso, periodo, observacoes, status)
VALUES
('João da Silva', '123.456.789-00', '(47) 99876-1234', 'joao.silva@univille.br', 'Engenharia de Software', '5º', 'Aluno interessado em orientação sobre atividades práticas.', 'ativo'),
('Ana Carolina', '987.654.321-00', '(47) 98765-4321', 'ana.carolina@univille.br', 'Sistemas de Informação', '7º', NULL, 'ativo'),
('Pedro Santos', '456.789.123-00', '(47) 99123-4567', 'pedro.santos@univille.br', 'Administração', '3º', NULL, 'ativo'),
('Larissa Alves', '321.654.987-00', '(47) 99555-1212', 'larissa.alves@univille.br', 'Direito', '2º', NULL, 'ativo'),
('Roberto Mendes', '147.258.369-00', '(47) 99000-9999', 'roberto.m@univille.br', 'Engenharia de Software', '8º', 'Cadastro mantido apenas para histórico.', 'inativo'),
('Marcos Pereira', '741.852.963-00', '(47) 98888-1111', 'marcos.pereira@univille.br', 'Engenharia de Software', '4º', NULL, 'ativo'),
('Juliana Castro', '852.741.963-00', '(47) 97777-2222', 'juliana.castro@univille.br', 'Sistemas de Informação', '6º', NULL, 'ativo'),
('Felipe Rocha', '963.852.741-00', '(47) 96666-3333', 'felipe.rocha@univille.br', 'Administração', '1º', NULL, 'ativo'),
('Beatriz Martins', '159.357.486-00', '(47) 95555-4444', 'beatriz.martins@univille.br', 'Direito', '5º', NULL, 'ativo'),
('Gabriel Oliveira', '357.159.486-00', '(47) 94444-5555', 'gabriel.oliveira@univille.br', 'Engenharia de Software', '3º', NULL, 'ativo'),
('Camila Fernandes', '486.159.357-00', '(47) 93333-6666', 'camila.fernandes@univille.br', 'Sistemas de Informação', '4º', NULL, 'ativo'),
('Rafael Almeida', '654.123.987-00', '(47) 92222-7777', 'rafael.almeida@univille.br', 'Engenharia de Software', '6º', NULL, 'ativo');

-- ============================================================
-- 8. TIPOS DE ATENDIMENTO PARA SIMULAÇÃO
-- ============================================================
INSERT INTO tipos_atendimentos (nome, descricao, status) VALUES
('Dúvida acadêmica', 'Dúvidas sobre disciplinas, conteúdos, avaliações e atividades.', 'ativo'),
('Orientação de atividade', 'Orientações sobre trabalhos, TCC, projetos e entregas acadêmicas.', 'ativo'),
('Suporte técnico', 'Problemas com sistemas, equipamentos, acessos e recursos digitais.', 'ativo'),
('Matrícula e documentação', 'Solicitações relacionadas à matrícula, declarações e históricos.', 'ativo'),
('Acesso ao laboratório', 'Liberação de uso e agendamento dos laboratórios.', 'ativo'),
('Outros', 'Atendimentos diversos ainda não classificados.', 'inativo');

-- ============================================================
-- 9. ATENDIMENTOS PARA SIMULAÇÃO
-- Utilizamos datas relativas ao dia da execução para manter o dashboard útil.
-- ============================================================
INSERT INTO atendimentos
    (pessoa_id, tipo_atendimento_id, usuario_id, descricao, status, data_atendimento, horario_atendimento, observacao_final)
VALUES
(1, 1, 2, 'Aluno solicitou apoio para compreender os requisitos da atividade prática.', 'aberto', CURRENT_DATE, '09:10:00', NULL),
(2, 3, 3, 'Problema de acesso ao ambiente virtual de aprendizagem.', 'em_andamento', CURRENT_DATE, '10:20:00', NULL),
(3, 2, 2, 'Orientação sobre estrutura de apresentação do projeto integrador.', 'concluido', CURRENT_DATE - INTERVAL 1 DAY, '14:00:00', 'Orientações fornecidas e material revisado com o aluno.'),
(4, 4, 4, 'Solicitação de declaração para fins de estágio.', 'aberto', CURRENT_DATE - INTERVAL 1 DAY, '15:30:00', NULL),
(5, 5, 3, 'Solicitação de liberação de acesso ao laboratório para atividade complementar.', 'concluido', CURRENT_DATE - INTERVAL 2 DAY, '08:40:00', 'Acesso liberado conforme disponibilidade.'),
(6, 1, 2, 'Dúvida sobre cardinalidade e relacionamentos no banco de dados.', 'em_andamento', CURRENT_DATE - INTERVAL 2 DAY, '11:00:00', NULL),
(7, 2, 4, 'Revisão do escopo de um projeto acadêmico.', 'concluido', CURRENT_DATE - INTERVAL 3 DAY, '13:10:00', 'Escopo ajustado e aprovado para continuidade.'),
(8, 3, 3, 'Falha na conexão do computador do laboratório com o banco local.', 'concluido', CURRENT_DATE - INTERVAL 3 DAY, '09:15:00', 'Configuração da porta do MySQL corrigida.'),
(9, 4, 4, 'Orientação sobre envio de documentação acadêmica.', 'aberto', CURRENT_DATE - INTERVAL 4 DAY, '09:30:00', NULL),
(10, 1, 2, 'Dúvida sobre autenticação e sessão em PHP.', 'concluido', CURRENT_DATE - INTERVAL 4 DAY, '16:00:00', 'Fluxo de login revisado com exemplos.'),
(11, 3, 3, 'Usuária não conseguia abrir o phpMyAdmin no laboratório.', 'concluido', CURRENT_DATE - INTERVAL 5 DAY, '17:10:00', 'Porta ajustada para 3307 e serviço reiniciado.'),
(12, 2, 4, 'Orientação sobre organização do repositório GitHub.', 'em_andamento', CURRENT_DATE - INTERVAL 5 DAY, '18:20:00', NULL),
(1, 3, 3, 'Erro ao acessar o sistema após redefinição local de senha.', 'concluido', CURRENT_DATE - INTERVAL 6 DAY, '10:10:00', 'Senha redefinida e acesso validado.'),
(2, 1, 2, 'Dúvida sobre uso de prepared statements com PDO.', 'concluido', CURRENT_DATE - INTERVAL 7 DAY, '11:50:00', 'Consulta reescrita utilizando parâmetros nomeados.'),
(3, 5, 4, 'Solicitação de acesso ao laboratório em período alternativo.', 'aberto', CURRENT_DATE - INTERVAL 8 DAY, '14:40:00', NULL),
(4, 2, 2, 'Orientação inicial para documentação do projeto.', 'em_andamento', CURRENT_DATE - INTERVAL 9 DAY, '09:00:00', NULL),
(6, 4, 4, 'Solicitação de informação sobre documentação acadêmica.', 'concluido', CURRENT_DATE - INTERVAL 10 DAY, '15:15:00', 'Usuário direcionado ao setor responsável.'),
(7, 1, 2, 'Dúvida sobre diferença entre autenticação e autorização.', 'concluido', CURRENT_DATE - INTERVAL 11 DAY, '16:35:00', 'Conceitos revisados e exemplificados.'),
(8, 3, 3, 'Erro ao executar conexão PDO em máquina local.', 'em_andamento', CURRENT_DATE - INTERVAL 12 DAY, '08:20:00', NULL),
(9, 2, 4, 'Revisão de requisitos funcionais do projeto.', 'concluido', CURRENT_DATE - INTERVAL 13 DAY, '12:10:00', 'Requisitos revisados e priorizados.'),
(10, 1, 2, 'Dúvida sobre JOIN entre atendimentos, pessoas e usuários.', 'aberto', CURRENT_DATE - INTERVAL 14 DAY, '13:50:00', NULL),
(11, 5, 3, 'Liberação do laboratório para realização de atividade acadêmica.', 'concluido', CURRENT_DATE - INTERVAL 15 DAY, '19:00:00', 'Agendamento confirmado.'),
(12, 3, 3, 'Problema de configuração do Apache no XAMPP.', 'concluido', CURRENT_DATE - INTERVAL 16 DAY, '10:45:00', 'Porta do Apache ajustada e ambiente testado.'),
(1, 2, 4, 'Orientação sobre critérios de apresentação final.', 'em_andamento', CURRENT_DATE - INTERVAL 17 DAY, '15:55:00', NULL),
(2, 4, 4, 'Solicitação de conferência de dados cadastrais.', 'concluido', CURRENT_DATE - INTERVAL 18 DAY, '16:20:00', 'Dados atualizados com sucesso.'),
(3, 1, 2, 'Dúvida sobre estrutura MVC simplificada.', 'concluido', CURRENT_DATE - INTERVAL 19 DAY, '09:45:00', 'Responsabilidades das camadas revisadas.'),
(4, 3, 3, 'Problema de credencial de acesso em computador institucional.', 'aberto', CURRENT_DATE - INTERVAL 20 DAY, '11:25:00', NULL),
(6, 2, 4, 'Orientação sobre organização das rotas do sistema.', 'concluido', CURRENT_DATE - INTERVAL 21 DAY, '14:10:00', 'Rotas reorganizadas conforme padrão didático.'),
(7, 1, 2, 'Dúvida sobre validação de dados obrigatórios.', 'concluido', CURRENT_DATE - INTERVAL 22 DAY, '15:30:00', 'Validações mínimas definidas.'),
(8, 3, 3, 'Falha de acesso ao banco após troca da porta.', 'concluido', CURRENT_DATE - INTERVAL 23 DAY, '17:40:00', 'Arquivo database.php atualizado.'),
(9, 4, 4, 'Solicitação de histórico acadêmico.', 'aberto', CURRENT_DATE - INTERVAL 24 DAY, '08:50:00', NULL),
(10, 2, 2, 'Orientação para elaboração de relatório do projeto.', 'em_andamento', CURRENT_DATE - INTERVAL 25 DAY, '10:05:00', NULL),
(11, 1, 2, 'Dúvida sobre filtros em listagem de atendimentos.', 'concluido', CURRENT_DATE - INTERVAL 26 DAY, '13:25:00', 'Filtros por status e período implementados.'),
(12, 5, 3, 'Reserva de laboratório para apresentação.', 'concluido', CURRENT_DATE - INTERVAL 27 DAY, '15:00:00', 'Reserva confirmada.'),
(1, 3, 3, 'Erro ao importar script SQL no phpMyAdmin.', 'concluido', CURRENT_DATE - INTERVAL 28 DAY, '16:45:00', 'Banco selecionado e script reexecutado.'),
(2, 2, 4, 'Orientação sobre documentação Swagger e Wiki.', 'aberto', CURRENT_DATE - INTERVAL 29 DAY, '18:00:00', NULL);

-- ============================================================
-- 10. VIEW: vw_atendimentos_detalhados
-- Facilita consultas JOIN para listagens, dashboard e relatórios.
-- O protocolo é formatado a partir do ID e não precisa ser armazenado.
-- ============================================================
CREATE OR REPLACE VIEW vw_atendimentos_detalhados AS
SELECT
    a.id,
    CONCAT('ATD-', LPAD(a.id, 4, '0')) AS protocolo,
    a.pessoa_id,
    p.nome AS pessoa_nome,
    p.documento AS pessoa_documento,
    p.email AS pessoa_email,
    a.tipo_atendimento_id,
    t.nome AS tipo_nome,
    a.usuario_id,
    u.nome AS responsavel_nome,
    a.descricao,
    a.status,
    a.data_atendimento,
    a.horario_atendimento,
    a.observacao_final,
    a.criado_em,
    a.atualizado_em
FROM atendimentos a
INNER JOIN pessoas p
    ON p.id = a.pessoa_id
INNER JOIN tipos_atendimentos t
    ON t.id = a.tipo_atendimento_id
INNER JOIN usuarios u
    ON u.id = a.usuario_id;

-- ============================================================
-- 11. VIEW: vw_dashboard_resumo
-- Facilita a validação inicial dos indicadores do dashboard.
-- ============================================================
CREATE OR REPLACE VIEW vw_dashboard_resumo AS
SELECT
    COUNT(*) AS total_atendimentos,
    SUM(CASE WHEN status = 'aberto' THEN 1 ELSE 0 END) AS total_abertos,
    SUM(CASE WHEN status = 'em_andamento' THEN 1 ELSE 0 END) AS total_em_andamento,
    SUM(CASE WHEN status = 'concluido' THEN 1 ELSE 0 END) AS total_concluidos,
    SUM(
        CASE
            WHEN status = 'concluido'
             AND YEAR(data_atendimento) = YEAR(CURRENT_DATE)
             AND MONTH(data_atendimento) = MONTH(CURRENT_DATE)
            THEN 1
            ELSE 0
        END
    ) AS concluidos_no_mes
FROM atendimentos;

-- ============================================================
-- 12. CONSULTAS DE VALIDAÇÃO
-- Execute após importar o script para confirmar se tudo foi criado.
-- ============================================================

-- 12.1 Conferir tabelas
SHOW TABLES;

-- 12.2 Conferir usuários cadastrados sem exibir hashes de senha
SELECT id, nome, email, perfil, status, criado_em
FROM usuarios
ORDER BY id;

-- 12.3 Conferir pessoas cadastradas
SELECT id, nome, documento, email, curso, periodo, status
FROM pessoas
ORDER BY nome;

-- 12.4 Conferir tipos de atendimento
SELECT id, nome, status
FROM tipos_atendimentos
ORDER BY id;

-- 12.5 Conferir atendimentos com JOIN
SELECT
    id,
    protocolo,
    pessoa_nome,
    tipo_nome,
    responsavel_nome,
    data_atendimento,
    horario_atendimento,
    status
FROM vw_atendimentos_detalhados
ORDER BY data_atendimento DESC, horario_atendimento DESC;

-- 12.6 Conferir indicadores básicos do dashboard
SELECT *
FROM vw_dashboard_resumo;

-- 12.7 Conferir atendimentos por categoria
SELECT
    t.nome AS categoria,
    COUNT(a.id) AS total
FROM tipos_atendimentos t
LEFT JOIN atendimentos a
    ON a.tipo_atendimento_id = t.id
GROUP BY t.id, t.nome
ORDER BY total DESC, t.nome;

-- ============================================================
-- CREDENCIAIS PARA TESTE
-- ============================================================
-- Administrador:
-- E-mail: admin@atendelab.com
-- Senha: 123456
--
-- Atendente:
-- E-mail: mariana.silva@atendelab.com
-- Senha: 123456
--
-- Usuário inativo para validar bloqueio de acesso:
-- E-mail: inativo@atendelab.com
-- Senha: 123456
-- ============================================================
