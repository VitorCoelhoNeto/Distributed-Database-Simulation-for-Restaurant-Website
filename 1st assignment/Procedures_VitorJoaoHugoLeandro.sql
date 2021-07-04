--Trabalho realizado por Vítor Neto 68717, João Leal 68719, Hugo Anes 68571 e Leandro Coelho 68541--
--Procedures--

USE TABD_TP1
GO

--Procedures Necessários aos Utilizadores/Visitantes----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Novo_Utilizador
	@id_Utilizador INTEGER, @username VARCHAR(50), @pass VARCHAR(50), @email VARCHAR(50) ,@tipo INTEGER
AS
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRANSACTION

	INSERT INTO Utilizador 
	VALUES (@id_Utilizador, @username, @pass, @email, @tipo)

	IF (@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
	GOTO ERRO
	COMMIT
RETURN 1
	ERRO:
		ROLLBACK
		RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Eliminar_Utilizador
    @id_Utilizador INTEGER
AS
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRANSACTION

IF EXISTS (SELECT Utilizador.id_Utilizador FROM Utilizador WHERE Utilizador.id_Utilizador = @id_Utilizador)
	BEGIN
		DELETE FROM BloquearUtilizador
		WHERE (id_Utilizador = @id_Utilizador)
		DELETE FROM Utilizador
		WHERE (id_Utilizador = @id_Utilizador)
	END
ELSE
	BEGIN
		PRINT 'Utilizador nao existente'
	END

    IF (@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
    GOTO ERRO
    COMMIT
return 1
    ERRO:
        ROLLBACK
        RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Novo_Cliente
	@id_Cliente INTEGER, @nome VARCHAR(20), @emailConf BIT
AS
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION

	IF EXISTS (SELECT Utilizador.id_Utilizador FROM Utilizador WHERE Utilizador.id_Utilizador = @id_Cliente)
		BEGIN
			INSERT INTO Client
			VALUES(@id_Cliente, @nome, '0')
		END
	ELSE
		BEGIN
			PRINT 'Utilizador invalido'
		END

	if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
	GOTO ERRO
	COMMIT
return 1
	ERRO:
		ROLLBACK
		RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Alterar_Utilizador
	@username VARCHAR(50), @pass VARCHAR(50), @email VARCHAR(50), @tipo INTEGER
AS
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRANSACTION

IF EXISTS (SELECT Utilizador.id_Utilizador FROM Utilizador WHERE Utilizador.username = @username)
	BEGIN
		UPDATE Utilizador
		SET Email = @email, pass = @pass,tipo = @tipo
		WHERE Username=@username
	END
ELSE
	BEGIN
		PRINT 'Utilizador nao existente'
	END

	IF(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
	GOTO ERRO
	COMMIT
return 1
	ERRO:
		ROLLBACK
		RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Procedures Necessários aos Clientes---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Ver_Restaurante_Especifico_Cliente
	@id_R INTEGER
AS
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION

	IF EXISTS (SELECT Restaurante.id_Restaurante FROM Restaurante WHERE Restaurante.id_Restaurante = @id_R)
		BEGIN
			SELECT R.nome AS 'Nome', R.morada AS 'Morada', R.gps AS 'GPS', R.telefone AS 'Telefone', R.dia_descanso 'Dia de descanso', R.descricao AS 'Descricao', R.foto AS 'Foto', R.hora_de_abertura AS 'Hora de abertura', R.hora_de_fecho AS 'Hora de fecho', R.tipo_entrega 'Entrega', R.tipo_local 'Local', R.tipo_takeaway 'Takeaway'
			FROM Restaurante R
			WHERE R.id_Restaurante = @id_R
		END
	ELSE
		BEGIN
			PRINT 'Restaurante nao existente'
		END
	if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
	GOTO ERRO
	COMMIT
return 1
	ERRO:
		ROLLBACK
		RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Eliminar_Restaurante_Fav
     @id_Cliente integer,@id_Restaurante integer
AS
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION

	IF EXISTS (SELECT Client.id_Client FROM Client WHERE Client.id_Client = @id_Cliente)
		BEGIN
			IF EXISTS (SELECT AdicionarRestFav.id_Restaurante FROM AdicionarRestFav WHERE AdicionarRestFav.id_Restaurante = @id_Restaurante)
				BEGIN
					DELETE FROM AdicionarRestFav
					WHERE(id_Cliente=@id_Cliente AND id_Restaurante=@id_Restaurante)
				END
			ELSE
				BEGIN
					RAISERROR('Restaurante nao esta na lista de favoritos do cliente', 16, 1)
				END
		END
	ELSE
		BEGIN
			RAISERROR('Cliente nao existente', 16, 1) 
		END

    if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
    GOTO ERRO
    COMMIT
return 1
    ERRO:
        ROLLBACK
        RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Eliminar_Prato_Fav
    @id_Cliente integer,@id_Prato integer
AS
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION

	IF EXISTS (SELECT Client.id_Client FROM Client WHERE Client.id_Client = @id_Cliente)
		BEGIN
			IF EXISTS (SELECT AdicionarPratoFav.id_Prato FROM AdicionarPratoFav WHERE AdicionarPratoFav.id_Prato = @id_Prato)
				BEGIN
					DELETE FROM AdicionarPratoFav
					WHERE(id_Client=@id_Cliente and id_Prato=@id_Prato)
				END
			ELSE
				BEGIN
					RAISERROR('Prato nao esta na lista de favoritos do cliente', 16, 1)
				END
		END
	ELSE
		BEGIN
			RAISERROR('Cliente nao existente', 16, 1) 
		END

    if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
    GOTO ERRO
    COMMIT
return 1
    ERRO:
        ROLLBACK
        RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Ver_Todos_Restaurantes_Cliente
AS
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION

		SELECT R.nome AS 'Nome', R.morada AS 'Morada', R.gps AS 'GPS', R.telefone AS 'Telefone', R.dia_descanso 'Dia de descanso', R.descricao AS 'Descricao', R.foto AS 'Foto', R.hora_de_abertura AS 'Hora de abertura', R.hora_de_fecho AS 'Hora de fecho', R.tipo_entrega 'Entrega', R.tipo_local 'Local', R.tipo_takeaway 'Takeaway'
		FROM Restaurante R

	if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
	GOTO ERRO
	COMMIT
return 1
	ERRO:
		ROLLBACK
		RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Alterar_Cliente
	 @id_Cliente INTEGER, @nome varchar(50)
AS
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION

IF EXISTS (SELECT Client.id_Client FROM Client WHERE Client.id_Client = @id_Cliente)
		BEGIN
			UPDATE Client
			SET  nome = @nome
			WHERE id_Client = @id_Cliente
		END
		ELSE
			BEGIN
				PRINT 'Cliente nao existente'
			END

	if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
	GOTO ERRO
	COMMIT
return 1
	ERRO:
		ROLLBACK
		RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Ver_Horario_Restaurantes

AS
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION

	SELECT R.nome AS 'Nome', R.hora_de_abertura AS 'Hora de Abertura', R.hora_de_fecho AS 'Hora de Fecho', R.dia_descanso AS 'Dia de Descanso'
	FROM Restaurante R

	if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
	GOTO ERRO
	COMMIT
return 1
	ERRO:
		ROLLBACK
		RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Ver_Horario_Restaurante_Especifico
	@id_Restaurante INTEGER
AS
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION

	IF EXISTS (SELECT Restaurante.id_Restaurante FROM Restaurante WHERE Restaurante.id_Restaurante = @id_R)
		BEGIN
			SELECT R.nome AS Nome, R.hora_de_abertura AS 'Hora de Abertura',R.hora_de_fecho AS 'Hora de Fecho',R.dia_descanso AS 'Dia de Descanso'
			FROM Restaurante R
			WHERE R.id_Restaurante = @id_Restaurante
		END
		ELSE
			BEGIN
				PRINT 'Restaurante nao existente'
			END

	if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
	GOTO ERRO
	COMMIT
return 1
	ERRO:
		ROLLBACK
		RETURN -1 
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Ver_RestaurantesFav--de certo cliente
	@Id_C INTEGER
AS
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION

	IF EXISTS (SELECT Client.id_Client FROM Client WHERE Client.id_Client = @Id_C)
		BEGIN
			SELECT R.nome AS 'Nome', R.dia_descanso AS 'Dia de descanso', R.telefone AS 'Telefone', R.tipo_takeaway AS 'Takeaway', R.tipo_local AS 'Local', R.tipo_entrega AS 'Entrega', R.hora_de_abertura AS 'Hora Abertura', R.hora_de_fecho AS 'Hora Fecho', R.descricao AS 'Descricao', R.foto AS 'Foto', R.validado AS 'Validado'
			FROM Restaurante R, AdicionarRestFav F
			WHERE F.Id_Restaurante = R.id_Restaurante and Id_Cliente = F.Id_Cliente
		END
	ELSE
		BEGIN
			PRINT 'Cliente nao existente'
		END
	if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
	GOTO ERRO
	COMMIT
return 1
	ERRO:
		ROLLBACK
		RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Ver_PratosFav--de certo cliente
	@Id_C integer
AS
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION

	IF EXISTS (SELECT Client.id_Client FROM Client WHERE Client.id_Client = @Id_C)
		BEGIN
			SELECT PD.nome AS 'Nome', PD.descricao 'Descricao', PD.tipo_prato AS 'Tipo de prato', PD.foto AS 'Foto'
			FROM AdicionarPratoFav PF, PratoDoDia PD
			WHERE PF.id_Prato=PD.id_Prato and PF.id_Client=@Id_C;
		END
	ELSE
		BEGIN
			RAISERROR('Cliente nao existente', 16, 1)
		END

	if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
	GOTO ERRO
	COMMIT
return 1
	ERRO:
		ROLLBACK
		RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Adicionar_PratoFavorito
	@ID_C INTEGER,
	@ID_P INTEGER,
	@data DATETIME
AS
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION

	IF EXISTS (SELECT Client.id_Client FROM Client WHERE Client.id_Client = @ID_C)
		BEGIN
			IF EXISTS (SELECT PratoDoDia.id_Prato FROM PratoDoDia WHERE PratoDoDia.id_Prato = @ID_P)
				BEGIN
					IF EXISTS (SELECT AdicionarPratoFav.id_Prato FROM AdicionarPratoFav WHERE AdicionarPratoFav.id_Prato = @ID_P AND AdicionarPratoFav.id_Client = @ID_C)
						BEGIN
							RAISERROR('Prato ja esta nos favoritos deste utilizador', 16, 1)
						END
					ELSE
						BEGIN
							INSERT INTO AdicionarPratoFav(id_Client, id_Prato, data_adicao)
							VALUES (@ID_C, @ID_P, GETDATE())
						END
				END
			ELSE
				BEGIN
					RAISERROR('Prato nao existente', 16, 1)
				END
		END
	ELSE
		BEGIN
			RAISERROR('Cliente nao existente', 16, 1) 
		END

	IF (@@ERROR <> 0) OR (@@ROWCOUNT = 0)
		GOTO ERRO
COMMIT
RETURN 1

ERRO:
	ROLLBACK
	RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Adicionar_RestauranteFavorito
	@ID_C INTEGER,
	@ID_R INTEGER,
	@data DATETIME
AS
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION

	IF EXISTS (SELECT Client.id_Client FROM Client WHERE Client.id_Client = @ID_C)
		BEGIN
			IF EXISTS (SELECT Restaurante.id_Restaurante FROM Restaurante WHERE Restaurante.id_Restaurante = @ID_R)
				BEGIN
					IF EXISTS (SELECT AdicionarRestFav.id_Restaurante FROM AdicionarRestFav WHERE AdicionarRestFav.id_Restaurante = @ID_R AND AdicionarRestFav.id_Cliente = @ID_C)
						BEGIN
							RAISERROR('Restaurante ja esta nos favoritos deste utilizador', 16, 1)
						END
					ELSE
						BEGIN
							INSERT INTO AdicionarRestFav(id_Cliente,id_Restaurante,data_adicao)
							VALUES (@ID_C,@ID_R,GETDATE())
						END
				END
			ELSE
				BEGIN
					RAISERROR('Restaurante nao existente', 16, 1)
				END
		END
	ELSE
		BEGIN
			RAISERROR('Cliente nao existente', 16, 1) 
		END
	

	IF (@@ERROR <> 0) OR (@@ROWCOUNT = 0)
		GOTO ERRO
COMMIT
RETURN 1

ERRO:
	ROLLBACK
	RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Ver_Pratos_do_Dia
AS
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION

	IF EXISTS (SELECT PratoDoDia.id_Prato FROM PratoDoDia)
		BEGIN
			SELECT * FROM PratoDoDia
		END
	ELSE
		BEGIN
			RAISERROR('Nao ha pratos do dia', 16, 1) 
		END

	if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
	GOTO ERRO
	COMMIT
return 1
	ERRO:
		ROLLBACK
		RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Ver_Pratos_do_Dia_Restaurante
	@id_Restaurante INTEGER
AS
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION
	
	IF EXISTS (SELECT Restaurante.id_Restaurante FROM Restaurante WHERE Restaurante.id_Restaurante = @id_Restaurante)
		BEGIN
			SELECT R.nome AS Restaurante, PD.nome AS Prato, PD.descricao AS Descrição,PD.tipo_prato AS Tipo
			FROM Restaurante R, PratoDoDia PD, CriarPrato CP
			WHERE R.id_Restaurante=@id_Restaurante and PD.id_Prato=CP.id_Prato and R.id_Restaurante=CP.id_Restaurante
		END
	ELSE
		BEGIN
			RAISERROR('Restaurante nao existente', 16, 1) 
		END

	if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
	GOTO ERRO
	COMMIT
return 1
	ERRO:
		ROLLBACK
		RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Ver_Pratos
AS
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION

	IF EXISTS (SELECT PratoDoDia.id_Prato FROM PratoDoDia)
		BEGIN
			SELECT * FROM CriarPrato
		END
	ELSE
		BEGIN
			RAISERROR('Nao existem pratos', 16, 1) 
		END

	if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
	GOTO ERRO
	COMMIT
return 1
	ERRO:
		ROLLBACK
		RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Ver_Pratos_Restaurante
	@id_Restaurante INTEGER
AS
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION

	IF EXISTS (SELECT Restaurante.id_Restaurante FROM Restaurante WHERE Restaurante.id_Restaurante = @id_Restaurante)
		BEGIN
			SELECT R.nome AS Nome, PD.nome AS 'Prato do dia', PD.descricao AS Descrição,PD.tipo_prato AS Tipo, CP.preco AS Preço,CP.dia_semana_prato AS 'Dia da Semana'
			FROM Restaurante R, CriarPrato CP, PratoDoDia PD
			WHERE R.id_Restaurante = @id_Restaurante and CP.id_Prato = PD.id_Prato
		END
	ELSE
		BEGIN
			RAISERROR('Restaurante nao existente', 16, 1)
		END

	if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
	GOTO ERRO
	COMMIT
return 1
	ERRO:
		ROLLBACK
		RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Ver_Servicos_Rest_Especifico
	@id_Rest INTEGER
AS
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION

	IF EXISTS (SELECT Restaurante.id_Restaurante FROM Restaurante WHERE Restaurante.id_Restaurante = @id_Rest)
		BEGIN
			SELECT tipo_entrega, tipo_local, tipo_takeaway FROM Restaurante
			WHERE id_Restaurante = @id_Rest
		END
	ELSE
		BEGIN
			RAISERROR('Restaurante nao existente', 16, 1)
		END

	if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
	GOTO ERRO
	COMMIT
return 1
	ERRO:
		ROLLBACK
		RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Ver_Servicos
	@tt BIT, @te BIT, @tl BIT
AS
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION

	SELECT * FROM Restaurante
	WHERE tipo_entrega = @te OR tipo_local = @tl OR tipo_takeaway = @tt

	if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
	GOTO ERRO
	COMMIT
return 1
	ERRO:
		ROLLBACK
		RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Ver_Localizacao_Rest_Especifico
	@id_Rest INTEGER
AS
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION

	IF EXISTS (SELECT Restaurante.id_Restaurante FROM Restaurante WHERE Restaurante.id_Restaurante = @id_Rest)
		BEGIN
			SELECT morada AS Morada FROM Restaurante
			WHERE id_Restaurante = @id_Rest
		END
	ELSE
		BEGIN
			RAISERROR('Restaurante nao existente', 16, 1)
		END

	if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
	GOTO ERRO
	COMMIT
return 1
	ERRO:
		ROLLBACK
		RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Ver_Localizacao_Rest
	@morada VARCHAR(50)
AS
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION

	IF EXISTS (SELECT Restaurante.id_Restaurante FROM Restaurante WHERE Restaurante.morada = @morada)
		BEGIN
			SELECT * FROM Restaurante
			WHERE morada = @morada
		END
	ELSE
		BEGIN
			RAISERROR('Morada nao corresponde a nenhum restaurante existente', 16, 1)
		END

	if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
	GOTO ERRO
	COMMIT
return 1
	ERRO:
		ROLLBACK
		RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Procedures Necessários aos Administradores--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Novo_Admin
	@id_Admin INTEGER, @nome VARCHAR(20)
AS
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION

	IF EXISTS (SELECT Utilizador.id_Utilizador FROM Utilizador WHERE Utilizador.id_Utilizador = @id_Admin)
		BEGIN
			INSERT INTO Administrador
			VALUES(@id_Admin, @nome)
		END
	ELSE
		BEGIN
			RAISERROR('Utilizador invalido', 16, 1)
		END

	if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
	GOTO ERRO
	COMMIT
return 1
	ERRO:
		ROLLBACK
		RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Eliminar_Utilizador
    @id_Utilizador INTEGER
AS
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION

	IF EXISTS (SELECT Utilizador.id_Utilizador FROM Utilizador WHERE Utilizador.id_Utilizador = @id_Utilizador)
		BEGIN
			DELETE FROM BloquearUtilizador
			WHERE(id_Utilizador=@id_Utilizador)
			DELETE FROM Utilizador
			WHERE(id_Utilizador=@id_Utilizador)
		END
	ELSE
		BEGIN
			RAISERROR('Utilizador inexistente', 16, 1)
		END

    if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
    GOTO ERRO
    COMMIT
return 1
    ERRO:
        ROLLBACK
        RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Eliminar_Restaurante
    @id_Restaurante INTEGER
AS
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION

	IF EXISTS (SELECT Restaurante.id_Restaurante FROM Restaurante WHERE Restaurante.id_Restaurante = @id_Restaurante)
		BEGIN
			DELETE FROM AdicionarRestFav
			WHERE(id_Restaurante=@id_Restaurante)
			DELETE FROM Restaurante
			WHERE(id_Restaurante=@id_Restaurante)
		END
	ELSE
		BEGIN
			RAISERROR('Restaurante inexistente', 16, 1)
		END

    if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
    GOTO ERRO
    COMMIT
return 1
    ERRO:
        ROLLBACK
        RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Eliminar_Admin
    @id_Admin INTEGER
AS
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION

	IF EXISTS (SELECT Administrador.id_Admin FROM Administrador WHERE Administrador.id_Admin = @id_Admin)
		BEGIN
			DELETE FROM BloquearUtilizador
			WHERE(id_Admin=@id_Admin)
			DELETE FROM Administrador
			WHERE(id_Admin=@id_Admin)
		END
	ELSE
		BEGIN
			RAISERROR('Admin inexistente', 16, 1)
		END

    if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
    GOTO ERRO
    COMMIT
return 1
    ERRO:
        ROLLBACK
        RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Eliminar_Cliente
    @id_Cliente INTEGER
AS
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION

	IF EXISTS (SELECT Client.id_Client FROM Client WHERE Client.id_Client = @id_Cliente)
		BEGIN
			DELETE FROM AdicionarPratoFav
			WHERE(id_Client=@id_Cliente)
			DELETE FROM AdicionarRestFav
			WHERE(id_Cliente=@id_Cliente)
			DELETE FROM Client
			WHERE(id_Client=@id_Cliente)
		END
	ELSE
		BEGIN
			RAISERROR('Cliente inexistente', 16, 1)
		END

    if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
    GOTO ERRO
    COMMIT
return 1
    ERRO:
        ROLLBACK
        RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Confirmar_Email
	@id_Utilizador VARCHAR(50)
AS
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION

	IF EXISTS (SELECT Client.id_Client FROM Client WHERE Client.id_Client = @id_Utilizador)
		BEGIN
			IF EXISTS(SELECT Client.id_Client FROM Client WHERE Client.id_Client = @id_Utilizador AND Client.email_Confirmado = 1)
				BEGIN
					RAISERROR('Email ja confirmado', 16, 1)	
				END
			ELSE
				BEGIN
					UPDATE Client
					SET Email_Confirmado=1
					WHERE id_Client=@id_Utilizador
				END
		END
	ELSE
		BEGIN
			RAISERROR('Cliente inexistente', 16, 1)
		END

	IF (@@ERROR <> 0) OR (@@ROWCOUNT = 0)
		GOTO ERRO
COMMIT
RETURN 1

ERRO:
	ROLLBACK
	RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Autorizar_Restaurante
    @id_A INTEGER, @id_R INTEGER
AS
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION

	IF EXISTS (SELECT Administrador.id_Admin FROM Administrador WHERE Administrador.id_Admin = @id_A)
		BEGIN
			IF EXISTS (SELECT Restaurante.id_Restaurante FROM Restaurante WHERE Restaurante.id_Restaurante = @id_R)
				BEGIN
					IF EXISTS (SELECT Autorizar.id_Restaurante FROM Autorizar WHERE Autorizar.id_Restaurante = @id_R)
						BEGIN
							RAISERROR('Restaurante ja autorizado', 16, 1)
						END
					ELSE
						BEGIN
							INSERT INTO Autorizar(id_Admin,id_Restaurante,data)
							VALUES (@id_A,@id_R,GETDATE())
							UPDATE Restaurante
							SET validado = 1
							WHERE @id_R = id_Restaurante
						END	
				END
			ELSE
				BEGIN
					RAISERROR('Restaurante inexistente', 16, 1)
				END
		END
	ELSE
		BEGIN
			RAISERROR('Admin inexistente', 16, 1)
		END

    IF (@@ERROR <> 0) OR (@@ROWCOUNT = 0)
        GOTO ERRO

COMMIT
RETURN 1

ERRO:
    ROLLBACK
    RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Alterar_Admin
	 @nome VARCHAR(50), @id_Admin INTEGER
AS
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION
	
	IF EXISTS (SELECT Administrador.id_Admin FROM Administrador WHERE Administrador.id_Admin = @id_Admin)
		BEGIN
			UPDATE Administrador
			SET nome = @nome
			WHERE id_Admin = @id_Admin
		END
	ELSE
		BEGIN
			RAISERROR('Admin inexistente', 16, 1)
		END

	if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
	GOTO ERRO
	COMMIT
return 1
	ERRO:
		ROLLBACK
		RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Bloquear_Utilizador
	@id_Admin INTEGER, @id_Utilizador INTEGER, @duracao INTEGER, @motivo VARCHAR(50)
AS
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION

	IF EXISTS (SELECT Administrador.id_Admin FROM Administrador WHERE Administrador.id_Admin = @id_Admin)
		BEGIN
			IF EXISTS (SELECT Utilizador.id_Utilizador FROM Utilizador WHERE Utilizador.id_Utilizador = @id_Utilizador)
				BEGIN
					IF EXISTS (SELECT BloquearUtilizador.id_Utilizador FROM BloquearUtilizador WHERE BloquearUtilizador.id_Utilizador = @id_Utilizador)
						BEGIN
							RAISERROR('Utilizador ja bloqueado', 16, 1)
						END
					ELSE
						BEGIN
							INSERT INTO BloquearUtilizador(id_Admin,id_Utilizador,duracao,motivo)
							VALUES (@id_Admin,@id_Utilizador,@duracao,@motivo)
						END
				END
			ELSE
				BEGIN
					RAISERROR('Utilizador inexistente', 16, 1)
				END
		END
	ELSE
		BEGIN
			RAISERROR('Admin inexistente', 16, 1)
		END

	if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
	GOTO ERRO
	COMMIT
return 1
	ERRO:
		ROLLBACK
		RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Ver_Clientes
AS
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION
	
	IF EXISTS (SELECT Client.id_Client FROM Client)
		BEGIN
			SELECT * FROM Client
		END
	ELSE
		BEGIN
			RAISERROR('Nao existem clientes', 16, 1)
		END

	if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
	GOTO ERRO
	COMMIT
return 1
	ERRO:
		ROLLBACK
		RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Ver_Restaurantes_Admin
AS
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION

	IF EXISTS (SELECT Restaurante.id_Restaurante FROM Restaurante)
		BEGIN
			SELECT * FROM Restaurante
		END
	ELSE
		BEGIN
			RAISERROR('Nao existem restaurantes', 16, 1)
		END

	if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
	GOTO ERRO
	COMMIT
return 1
	ERRO:
		ROLLBACK
		RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Ver_Clientes_Bloqueados
AS
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION

	IF EXISTS (SELECT BloquearUtilizador.id_Utilizador FROM BloquearUtilizador)
		BEGIN
			SELECT C.nome AS Nome, B.motivo AS Motivo, B.duracao AS Duração
			FROM Client C, BloquearUtilizador B
			WHERE B.id_Utilizador=C.id_Client
		END
	ELSE
		BEGIN
			RAISERROR('Nao existem clientes bloqueados', 16, 1)
		END

	if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
	GOTO ERRO
	COMMIT
return 1
	ERRO:
		ROLLBACK
		RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Ver_Restaurantes_Autorizados
AS
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION

	IF EXISTS (SELECT Autorizar.id_Restaurante FROM Autorizar)
		BEGIN
			SELECT R.nome AS Nome
			FROM Autorizar A, Restaurante R
			WHERE A.id_Restaurante=R.id_Restaurante and R.validado=1
		END
	ELSE
		BEGIN
			RAISERROR('Nao existem restaurantes autorizados', 16, 1)
		END

	if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
	GOTO ERRO
	COMMIT
return 1
	ERRO:
		ROLLBACK
		RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Ver_Restaurantes_Nao_Autorizados
AS
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION

	IF EXISTS (SELECT Restaurante.id_Restaurante FROM Restaurante WHERE Restaurante.validado = 0)
		BEGIN
			SELECT R.nome as Nome
			FROM  Restaurante R
			WHERE R.validado=0
		END
	ELSE
		BEGIN
			RAISERROR('Nao existem restaurantes nao autorizados', 16, 1)
		END

    if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
    GOTO ERRO
    COMMIT
return 1
    ERRO:
        ROLLBACK
        RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Procedures Necessários aos Restaurantes-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Criar_Prato
	@id_R INTEGER, @id_P INTEGER, @preco MONEY, @dia_semana VARCHAR(30), @apagado BIT
AS
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION

	IF EXISTS (SELECT CriarPrato.id_Prato FROM CriarPrato WHERE CriarPrato.id_Prato = @id_P)
		BEGIN
			RAISERROR('Prato ja existente', 16, 1)
		END
	ELSE
		BEGIN
			INSERT INTO CriarPrato
			VALUES (@id_R, @id_P, @preco, @dia_semana, '0')
		END

	IF (@@ERROR <> 0) OR (@@ROWCOUNT = 0)
		GOTO ERRO
COMMIT
RETURN 1

ERRO:
	ROLLBACK
	RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Criar_Prato_Do_Dia
	@id_P integer, @nome varchar(25), @descricao varchar(200),@tipo_prato varchar(20),@foto varchar(300)
AS
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION

	IF EXISTS (SELECT CriarPrato.id_Prato FROM CriarPrato WHERE CriarPrato.id_Prato = @id_P)
		BEGIN
			RAISERROR('Prato ja existente', 16, 1)
		END
	ELSE
		BEGIN
			insert into PratoDoDia(id_Prato, nome,descricao, tipo_prato, foto)
			values (@id_P, @nome, @descricao, @tipo_prato, @foto)
		END
	
	IF (@@ERROR <> 0) OR (@@ROWCOUNT = 0)
		GOTO ERRO
COMMIT
RETURN 1

ERRO:
	ROLLBACK
	RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Alterar_Pratos_Restaurante
	@id_Restaurante INTEGER, @id_Prato INTEGER, @nome VARCHAR(50), @preco MONEY,@dia_semana_prato VARCHAR(50), @descricao VARCHAR(250), @tipo_prato VARCHAR(50)
AS
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION

	IF EXISTS (SELECT CriarPrato.id_Prato FROM CriarPrato WHERE CriarPrato.id_Prato = @id_Prato)
		BEGIN
			IF EXISTS (SELECT CriarPrato.id_Restaurante FROM CriarPrato WHERE CriarPrato.id_Restaurante = @id_Restaurante)
				BEGIN
					UPDATE CriarPrato
					SET preco=@preco,dia_semana_prato=@dia_semana_prato 
					WHERE id_Prato=@id_Prato
					UPDATE PratoDoDia
					SET nome=@nome, descricao=@descricao, tipo_prato=@tipo_prato
					WHERE id_Prato=@id_Prato
				END
			ELSE
				Begin
					RAISERROR('Restaurante inexistente', 16, 1)
				END
		END
	ELSE
		BEGIN
			RAISERROR('Prato inexistente', 16, 1)
		END

	if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
	GOTO ERRO
	COMMIT
return 1
	ERRO:
		ROLLBACK
		RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Eliminar_Pratos_Restaurante
    @id_Restaurante INTEGER, @id_Prato INTEGER
AS
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION

	IF EXISTS (SELECT CriarPrato.id_Prato FROM CriarPrato WHERE CriarPrato.id_Prato = @id_Prato)
		BEGIN
			IF EXISTS (SELECT Restaurante.id_Restaurante FROM Restaurante WHERE Restaurante.id_Restaurante = @id_Restaurante)
				BEGIN
					DELETE FROM AdicionarPratoFav
					WHERE(id_Prato=@id_Prato)
					DELETE FROM CriarPrato
					WHERE(id_Restaurante=@id_Restaurante and id_Prato=@id_Prato)
					DELETE FROM PratoDoDia
					WHERE(id_Prato=@id_Prato)
				END
			ELSE
				BEGIN
					RAISERROR('Restaurante inexistente', 16, 1)
				END
		END
	ELSE
		BEGIN
			RAISERROR('Prato inexistente', 16, 1)
		END
    
    if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
    GOTO ERRO
    COMMIT
return 1
    ERRO:
        ROLLBACK
        RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Eliminar_Pratos_Do_Dia_Restaurante
    @id_Restaurante INTEGER, @id_Prato INTEGER, @dia_da_semana VARCHAR(50)
AS
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION
	
	IF EXISTS (SELECT PratoDoDia.id_Prato FROM PratoDoDia WHERE PratoDoDia.id_Prato = @id_Prato)
		BEGIN
			IF EXISTS (SELECT Restaurante.id_Restaurante FROM Restaurante WHERE Restaurante.id_Restaurante = @id_Restaurante)
				BEGIN
					DELETE FROM AdicionarPratoFav
					WHERE(id_Prato=@id_Prato)
					DELETE FROM CriarPrato
					WHERE(id_Prato=@id_Prato and dia_semana_prato=@dia_da_semana)
					DELETE FROM PratoDoDia
					WHERE(id_Prato=@id_Prato)
				END
			ELSE
				BEGIN
					RAISERROR('Restaurante inexistente', 16, 1)
				END
		END
	ELSE
		BEGIN
			RAISERROR('Prato inexistente', 16, 1)
		END
  
    if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
    GOTO ERRO
    COMMIT
return 1
    ERRO:
        ROLLBACK
        RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Criar_Restaurante
	@id_Rest INTEGER, @nome VARCHAR(20), @morada VARCHAR(50), @gps VARCHAR(50), @telefone NUMERIC(9), @dia_desc VARCHAR(50), @tt BIT, @tl BIT, @te BIT, @hora_aber CHAR(5), @hora_fecho CHAR(5), @desc VARCHAR(250), @foto VARCHAR(300)
AS
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION

	IF EXISTS (SELECT Utilizador.id_Utilizador FROM Utilizador WHERE Utilizador.id_Utilizador = @id_Rest)
		BEGIN
			INSERT INTO Restaurante
			VALUES(@id_Rest, @nome, 0, @morada, @gps, @telefone, @dia_desc, @tt, @tl, @te, @hora_aber, @hora_fecho, @desc, @foto)
		END
	ELSE
		BEGIN
			RAISERROR('Utillizador invalido', 16, 1)
		END

	if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
	GOTO ERRO
	COMMIT
return 1
	ERRO:
		ROLLBACK
		RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Alterar_Restaurante
	 @id_Rest INTEGER, @nome VARCHAR(50), @morada VARCHAR(50), @gps VARCHAR(50), @telefone NUMERIC(9), @dia_desc VARCHAR(50), @tt BIT, @tl BIT, @te BIT, @hora_aber CHAR(5), @hora_fecho CHAR(5), @desc VARCHAR(250), @foto VARCHAR(300)
AS
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION

	IF EXISTS (SELECT Restaurante.id_Restaurante FROM Restaurante WHERE Restaurante.id_Restaurante = @id_Rest)
		BEGIN
			UPDATE Restaurante
			SET  nome = @nome, morada = @morada, gps = @gps, telefone = @telefone, dia_descanso = @dia_desc, tipo_takeaway = @tt, tipo_local = @tl, tipo_entrega = @te, hora_de_abertura = @hora_aber, hora_de_fecho = @hora_fecho, descricao = @desc, foto = @foto
			WHERE id_Restaurante = @id_Rest
		END
	ELSE
		BEGIN
			RAISERROR('Restaurante inexistente', 16, 1)
		END

	if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
	GOTO ERRO
	COMMIT
return 1
	ERRO:
		ROLLBACK
		RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------