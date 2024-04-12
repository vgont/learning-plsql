-- Drop tables with cascade constraints
DROP TABLE Motoristas CASCADE CONSTRAINTS;
DROP TABLE CNHS CASCADE CONSTRAINTS;
DROP TABLE Veiculos CASCADE CONSTRAINTS;
DROP TABLE Ruas CASCADE CONSTRAINTS;
DROP TABLE Acidentes CASCADE CONSTRAINTS;
DROP TABLE Multas CASCADE CONSTRAINTS;

-- Drop sequences
DROP SEQUENCE sq_id_cnhs;
DROP SEQUENCE sq_id_motoristas;
DROP SEQUENCE sq_id_veiculos;
DROP SEQUENCE sq_id_ruas;
DROP SEQUENCE sq_id_acidentes;
DROP SEQUENCE sq_id_multas;

-- Create Motoristas table
CREATE TABLE Motoristas (
    id NUMBER,
    nome VARCHAR(50) NOT NULL,
    cpf VARCHAR(50) NOT NULL,
    CONSTRAINT pk_motoristas PRIMARY KEY (id)
);

-- Create CNHS table
CREATE TABLE CNHS (
    id NUMBER,
    id_motorista NUMBER NOT NULL,
    nr_cnh VARCHAR(50) NOT NULL,
    pontos NUMBER NOT NULL,
    status_cnh VARCHAR(50) DEFAULT 'ativa',
    tp_cnh VARCHAR(50) NOT NULL,
    CONSTRAINT fk_cnhs_motoristas FOREIGN KEY (id_motorista) REFERENCES Motoristas(id),
    CONSTRAINT ck_pontos_cnh CHECK (pontos <= 40),
    CONSTRAINT ck_status_cnh CHECK (status_cnh IN ('ativa', 'suspensa')),
    CONSTRAINT ck_tipo_cnh CHECK (tp_cnh IN ('normal', 'trabalho')),
    CONSTRAINT pk_cnhs PRIMARY KEY (id)
);

-- Create Veiculos table
CREATE TABLE Veiculos (
    id NUMBER,
    id_motorista NUMBER NOT NULL,
    placa VARCHAR(50) NOT NULL,
    CONSTRAINT fk_veiculos_motoristas FOREIGN KEY (id_motorista) REFERENCES Motoristas(id),
    CONSTRAINT pk_veiculos PRIMARY KEY (id)
);

-- Create Ruas table
CREATE TABLE Ruas (
    id NUMBER,
    cep VARCHAR(50) NOT NULL,
    nome VARCHAR(50) NOT NULL,
    CONSTRAINT pk_ruas PRIMARY KEY (id)
);

-- Create Acidentes table
CREATE TABLE Acidentes (
    id NUMBER,
    id_motorista NUMBER NOT NULL,
    id_causador NUMBER,
    id_veiculo NUMBER NOT NULL,
    id_rua NUMBER NOT NULL,
    dt_acidente DATE NOT NULL,
    descricao VARCHAR(250) NOT NULL,
    CONSTRAINT fk_acidentes_motoristas FOREIGN KEY (id_motorista) REFERENCES Motoristas(id),
    CONSTRAINT fk_acidentes_veiculos FOREIGN KEY (id_veiculo) REFERENCES Veiculos(id),
    CONSTRAINT fk_acidentes_ruas FOREIGN KEY (id_rua) REFERENCES Ruas(id),
    CONSTRAINT pk_acidentes PRIMARY KEY (id)
);

-- Create Multas table
CREATE TABLE Multas (
    id NUMBER,
    id_motorista NUMBER NOT NULL,
    id_veiculo NUMBER NOT NULL,
    descricao VARCHAR(250) NOT NULL,
    valor NUMBER NOT NULL,
    dt_inicio DATE NOT NULL,
    dt_vencimento DATE NOT NULL,
    dt_pagamento DATE,
    CONSTRAINT fk_multas_motoristas FOREIGN KEY (id_motorista) REFERENCES Motoristas(id),
    CONSTRAINT fk_multas_veiculos FOREIGN KEY (id_veiculo) REFERENCES Veiculos(id),
    CONSTRAINT pk_multas PRIMARY KEY (id)
);

create sequence sq_id_motoristas start with 1 increment by 1;
create sequence sq_id_cnhs start with 1 increment by 1;
create sequence sq_id_veiculos start with 1 increment by 1;
create sequence sq_id_ruas start with 1 increment by 1;
create sequence sq_id_acidentes start with 1 increment by 1;
create sequence sq_id_multas start with 1 increment by 1;
