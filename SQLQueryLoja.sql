-- a. Criação do logon e usuário loja
USE master;
CREATE LOGIN loja WITH PASSWORD = 'loja';
GO
CREATE USER loja FOR LOGIN loja;
ALTER SERVER ROLE sysadmin ADD MEMBER loja;
GO

-- b. Criar banco com o novo usuário (logado como loja depois)
CREATE DATABASE LojaDB;
GO
USE LojaDB;
GO

-- c. Criar a sequence para geração de IDs
CREATE SEQUENCE seq_pessoa_id START WITH 1 INCREMENT BY 1;

-- d. Criação das tabelas
CREATE TABLE Usuario (
    id_usuario INT PRIMARY KEY IDENTITY,
    nome NVARCHAR(100),
    login NVARCHAR(50) UNIQUE,
    senha NVARCHAR(100)
);

CREATE TABLE Pessoa (
    id_pessoa INT PRIMARY KEY DEFAULT NEXT VALUE FOR seq_pessoa_id,
    nome NVARCHAR(100),
    endereco NVARCHAR(200),
    telefone NVARCHAR(20),
    email NVARCHAR(100)
);

CREATE TABLE PessoaFisica (
    id_pessoa INT PRIMARY KEY,
    cpf CHAR(11) UNIQUE,
    FOREIGN KEY (id_pessoa) REFERENCES Pessoa(id_pessoa)
);

CREATE TABLE PessoaJuridica (
    id_pessoa INT PRIMARY KEY,
    cnpj CHAR(14) UNIQUE,
    FOREIGN KEY (id_pessoa) REFERENCES Pessoa(id_pessoa)
);

CREATE TABLE Produto (
    id_produto INT PRIMARY KEY IDENTITY,
    nome NVARCHAR(100),
    quantidade INT,
    preco_venda DECIMAL(10, 2)
);

CREATE TABLE Compra (
    id_compra INT PRIMARY KEY IDENTITY,
    id_usuario INT,
    id_produto INT,
    id_pessoa_juridica INT,
    quantidade INT,
    preco_unitario DECIMAL(10, 2),
    data_compra DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario),
    FOREIGN KEY (id_produto) REFERENCES Produto(id_produto),
    FOREIGN KEY (id_pessoa_juridica) REFERENCES PessoaJuridica(id_pessoa)
);

CREATE TABLE Venda (
    id_venda INT PRIMARY KEY IDENTITY,
    id_usuario INT,
    id_produto INT,
    id_pessoa_fisica INT,
    quantidade INT,
    preco_unitario DECIMAL(10, 2),
    data_venda DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario),
    FOREIGN KEY (id_produto) REFERENCES Produto(id_produto),
    FOREIGN KEY (id_pessoa_fisica) REFERENCES PessoaFisica(id_pessoa)
);