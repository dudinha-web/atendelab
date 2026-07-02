-- Cria o banco com o nome correto
DROP DATABASE IF NOT EXISTS atendelab
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci;

-- Move a tabela usuarios para o banco correto
RENAME TABLE atendlab.usuarios TO atendelab.usuarios;

-- Remove o banco antigo após mover a tabela
DROP DATABASE atendlab;