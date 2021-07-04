--Trabalho realizado por Vítor Neto 68717, João Leal 68719, Hugo Anes 68571 e Leandro Coelho 68541--
--Server 2---

--Ligar com o server1 (Vítor)
EXEC sp_addlinkedserver @server = 'server1',
   @srvproduct = 'SQLServer Native Client OLEDB Provider',
   @provider = 'SQLNCLI',
   @datasrc = 'x.x.x.x' --Endereco IP do 'server1'

EXEC sp_addlinkedsrvlogin @rmtsrvname = 'server1',
   @useself = 'FALSE',
   @locallogin = 'sa',
   @rmtuser = 'sa',
   @rmtpassword = '1'

CREATE DATABASE TABD_TP2_SERVER2
USE TABD_TP2_SERVER2
GO
SET IMPLICIT_TRANSACTIONS OFF

--Base de dados server 2----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Nos 2 servers
CREATE TABLE UtilizadorNZ(
	id_Utilizador INTEGER ,
	nome VARCHAR(50) NOT NULL,
	username VARCHAR(50) UNIQUE NOT NULL,
	pass VARCHAR(50) NOT NULL,
	email VARCHAR(50) NOT NULL,
	tipo INTEGER, 
	PRIMARY KEY (id_Utilizador,nome),
	--CHECK(tipo LIKE '0' OR tipo LIKE '1' OR tipo LIKE '2'), --0 = Admin, 1 = Client, 2 = Restaurante
	--CHECK(email LIKE '%@%.%'),
	CHECK(nome >= 'N')
);

--Nos 2 servers
CREATE TABLE PratoDoDiaImpar(
	id_Prato INTEGER PRIMARY KEY,
	nome VARCHAR(250) NOT NULL,
	descricao VARCHAR(250),
	tipo_prato VARCHAR(250) NOT NULL,
	foto VARCHAR(300) NOT NULL,
	CHECK(tipo_prato LIKE 'Vegan' OR tipo_prato LIKE 'Peixe' or tipo_prato LIKE 'Carne'),
	CHECK(id_Prato%2 <> 0)
);

--Só no server 2
CREATE TABLE Administrador(
    id_Admin INTEGER Primary Key,
);

--Só no server 2
CREATE TABLE BloquearUtilizador(
	id_Admin INTEGER,
	id_Utilizador INTEGER,
	duracao INTEGER NOT NULL,
	motivo VARCHAR(250) NOT NULL,
	PRIMARY KEY(id_Admin,id_Utilizador),
	FOREIGN KEY (id_Admin) REFERENCES Administrador(id_Admin)
);

--Só no server 2
CREATE TABLE Autorizar(
	id_Admin INTEGER,
	id_Restaurante INTEGER,
	data DATETIME NOT NULL DEFAULT GETDATE(),
	PRIMARY KEY(id_Admin, id_Restaurante),
	FOREIGN KEY (id_Admin) REFERENCES Administrador(id_Admin)
);

--Logins--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE LOGIN Administrador WITH PASSWORD = '1'
CREATE LOGIN Client WITH PASSWORD = '1'
CREATE LOGIN Restaurante WITH PASSWORD = '1'
CREATE LOGIN Dono WITH PASSWORD = '1'

--Users--
CREATE USER Restaurante1 FOR LOGIN Restaurante
CREATE USER Administrador1 FOR LOGIN Administrador
CREATE USER Client1 FOR LOGIN Client
CREATE USER Dono FOR LOGIN Dono
CREATE USER Visitante WITHOUT LOGIN

--Atribuição de Permissões nas Tabelas--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Permissões para dono BD
GRANT SELECT, INSERT, UPDATE, DELETE TO Dono

--Permissões para os Restaurantes
GRANT SELECT, UPDATE ON UtilizadorNZ to Restaurante1

--Permissões para os Administradores
GRANT SELECT, DELETE ON UtilizadorNZ to Administrador1
GRANT SELECT, DELETE ON Client TO Administrador1
GRANT SELECT, INSERT, UPDATE, DELETE on Autorizar TO Administrador1
GRANT SELECT, UPDATE on BloquearUtilizador TO Administrador1

--Permissões para os Clientes
GRANT SELECT, UPDATE ON UtilizadorNZ to Cliente1
GRANT SELECT ON PratoDoDiaImpar TO Cliente1
GRANT SELECT, UPDATE ON Client TO Client1
GRANT SELECT, INSERT, UPDATE, DELETE ON AdicionarRestFav to Client1
GRANT SELECT, INSERT, UPDATE, DELETE ON AdicionarPratoFav to Client1

--Permissões para Visitante
GRANT SELECT ON PratoDoDiaImpar TO Visitante
