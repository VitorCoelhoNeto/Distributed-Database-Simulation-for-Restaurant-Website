--Trabalho realizado por Vítor Neto 68717, João Leal 68719, Hugo Anes 68571 e Leandro Coelho 68541--
--Baseado na base de dados desenvolvida a LAWBD--
--Base de dados--
USE master
GO
CREATE DATABASE TABD_TP1
--DROP DATABASE TABD_TP1
USE TABD_TP1
CREATE TABLE Utilizador(
	id_Utilizador INTEGER PRIMARY KEY,
	username VARCHAR(50) UNIQUE NOT NULL,
	pass VARCHAR(50) NOT NULL,
	email VARCHAR(50) NOT NULL,
	tipo INTEGER,
	CHECK(tipo LIKE '0' OR tipo LIKE '1' OR tipo LIKE '2'), --0 = Admin, 1 = Client, 2 = Restaurante
	CHECK(email LIKE '%@%.%')
);

CREATE TABLE Client(
	id_Client INTEGER,
	nome VARCHAR(50) NOT NULL,
	email_Confirmado BIT DEFAULT 0,
	FOREIGN KEY(id_Client) REFERENCES Utilizador(id_Utilizador),
	PRIMARY KEY(id_Client)
);

CREATE TABLE Administrador(
	id_Admin INTEGER,
	nome VARCHAR(50) NOT NULL,
	FOREIGN KEY(id_Admin) REFERENCES Utilizador(id_Utilizador),
	PRIMARY KEY(id_Admin)
);

CREATE TABLE Restaurante(
	id_Restaurante INTEGER,
	nome VARCHAR(50) NOT NULL,
	validado BIT DEFAULT 0 NOT NULL,
	morada VARCHAR(50) NOT NULL,
	gps VARCHAR(50) NOT NULL,
	telefone NUMERIC(9) UNIQUE NOT NULL,
	dia_descanso VARCHAR(50) NOT NULL,
	tipo_takeaway BIT DEFAULT 0,
	tipo_local BIT DEFAULT 0,
	tipo_entrega BIT DEFAULT 0,
	hora_de_abertura CHAR(5) NOT NULL,
	hora_de_fecho CHAR(5) NOT NULL,
	descricao VARCHAR(250),
	foto VARCHAR(300),
	FOREIGN KEY(id_Restaurante) REFERENCES Utilizador(id_Utilizador),
	PRIMARY KEY(id_Restaurante),
	CHECK (hora_de_abertura LIKE '[0-1][0-9]:[0-5][0-9]' OR	hora_de_abertura Like '[2][0-4]:[0-5][0-9]'),
	CHECK (hora_de_fecho LIKE '[0-1][0-9]:[0-5][0-9]' OR hora_de_fecho Like '[2][0-4]:[0-5][0-9]'),
	CHECK (telefone BETWEEN 100000000 AND 999999999),
	CHECK (tipo_takeaway LIKE '1' OR tipo_local LIKE '1' OR tipo_entrega LIKE '1')
);

CREATE TABLE PratoDoDia(
	id_Prato INTEGER PRIMARY KEY,
	nome VARCHAR(250) NOT NULL,
	descricao VARCHAR(250),
	tipo_prato VARCHAR(250) NOT NULL,
	foto VARCHAR(300) NOT NULL,
	CHECK(tipo_prato LIKE 'Vegan' OR tipo_prato LIKE 'Peixe' or tipo_prato LIKE 'Carne')
);

CREATE TABLE CriarPrato(
	id_Restaurante INTEGER NOT NULL,
	id_Prato INTEGER NOT NULL,
	preco MONEY NOT NULL,
	dia_semana_prato VARCHAR(30) NOT NULL,
	apagado BIT NOT NULL DEFAULT 0, --0 não está apagado, 1 está
	PRIMARY KEY(id_Restaurante, id_Prato),
	FOREIGN KEY(id_Restaurante) REFERENCES Restaurante(id_Restaurante),
	FOREIGN KEY(id_Prato) REFERENCES PratoDoDia(id_Prato),
	CHECK(dia_semana_prato LIKE 'Segunda feira' OR dia_semana_prato LIKE 'Terça feira' OR dia_semana_prato LIKE 'Quarta feira' or dia_semana_prato LIKE 'Quinta feira' OR dia_semana_prato LIKE 'Sexta feira' OR dia_semana_prato LIKE 'Sabado' OR dia_semana_prato LIKE 'Domingo')
	);

CREATE TABLE AdicionarPratoFav(
	id_Client INTEGER NOT NULL,
	id_Prato INTEGER NOT NULL,
	data_adicao DATE NOT NULL,
	PRIMARY KEY(id_Client, id_Prato),
	FOREIGN KEY(id_Client) REFERENCES Client(id_Client),
	FOREIGN KEY(id_Prato) REFERENCES PratoDoDia(id_Prato)
);

CREATE TABLE AdicionarRestFav(
	id_Restaurante integer not null,
	id_Cliente integer not null,
	data_adicao DATE NOT NULL,
	Primary key(id_Restaurante, id_Cliente),
	FOREIGN KEY(id_Restaurante) REFERENCES Restaurante(id_Restaurante),
	FOREIGN KEY(id_Cliente) REFERENCES Client(id_Client)
);

CREATE TABLE BloquearUtilizador(
	id_Admin INTEGER PRIMARY KEY,
	id_Utilizador INTEGER,
	duracao INTEGER NOT NULL,
	motivo VARCHAR(250) NOT NULL,
	FOREIGN KEY(id_Utilizador) REFERENCES Utilizador(id_Utilizador),
	FOREIGN KEY(id_Admin) REFERENCES Administrador(id_Admin)
);

CREATE TABLE Autorizar(
	id_Admin INTEGER,
	id_Restaurante INTEGER,
	data DATETIME NOT NULL DEFAULT GETDATE(),
	PRIMARY KEY(id_Admin, id_Restaurante),
	FOREIGN KEY(id_Admin) REFERENCES Administrador(id_Admin), 
	FOREIGN KEY(id_Restaurante) REFERENCES Restaurante(id_Restaurante)
);
