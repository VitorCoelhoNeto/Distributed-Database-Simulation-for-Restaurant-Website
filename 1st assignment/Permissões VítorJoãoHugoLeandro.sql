--Trabalho realizado por Vítor Neto 68717, João Leal 68719, Hugo Anes 68571 e Leandro Coelho 68541--
--Políticas de segurança e acesso a dados centralizados--

USE TABD_TP1
GO

--Logins--
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

--Roles--
CREATE ROLE Administradores
CREATE ROLE Clients
CREATE ROLE Restaurantes

--Adicionar membros a cada uma das roles--
ALTER ROLE Clients ADD MEMBER Client1
ALTER ROLE Administradores ADD MEMBER Administrador1
ALTER ROLE Restaurantes ADD MEMBER Restaurante1

--Atribuição de Permissões nas Tabelas

--Permissões para dono BD
GRANT SELECT, INSERT, UPDATE, DELETE TO Dono
GRANT EXECUTE ON Eliminar_Admin TO Dono

--Permissões para os Restaurantes
GRANT SELECT ON Client to Restaurantes
GRANT SELECT, INSERT, UPDATE, DELETE ON CriarPrato TO Restaurantes
GRANT SELECT, INSERT, UPDATE, DELETE ON PratoDoDia TO Restaurantes
GRANT SELECT, UPDATE ON Restaurante TO Restaurantes
GRANT SELECT, UPDATE ON Utilizador TO Restaurantes

--Permissões para os Clients
GRANT SELECT ON Restaurante TO Clients
GRANT SELECT ON CriarPrato TO Clients
GRANT SELECT ON PratoDoDia TO Clients
GRANT SELECT ON BloquearUtilizador TO Clients
GRANT SELECT,UPDATE ON Utilizador TO Clients
GRANT SELECT,INSERT,UPDATE,DELETE ON AdicionarPratoFav TO Clients
GRANT SELECT,INSERT,UPDATE,DELETE ON AdicionarRestFav TO Clients
GRANT SELECT,UPDATE ON Client TO Clients

--Permissões para os Administradores
GRANT SELECT, INSERT, UPDATE, DELETE ON BloquearUtilizador TO Administradores
GRANT SELECT, INSERT, UPDATE ON Autorizar TO Administradores
GRANT SELECT, DELETE ON Utilizador to Administradores
GRANT SELECT, DELETE ON Client TO Administradores 
GRANT SELECT, INSERT, UPDATE ON Administrador TO Administradores
GRANT SELECT, DELETE ON Restaurante TO Administradores
GRANT SELECT on CriarPrato TO Administradores
GRANT SELECT on PratoDoDia TO Administradores

--Permissões e procedures para Visitante
GRANT SELECT ON Restaurante TO Visitante
GRANT SELECT ON CriarPrato TO Visitante
GRANT SELECT ON PratoDoDia TO Visitante
GRANT EXECUTE ON Criar_Restaurante TO Visitante
GRANT EXECUTE On Novo_Cliente TO Visitante
GRANT EXECUTE On Novo_Utilizador TO Visitante

--Procedures para Todos
GRANT EXECUTE On Alterar_Utilizador TO Clients,Administradores,Restaurantes

--Procedures dos Clientes
GRANT EXECUTE On Ver_Restaurante_Especifico_Cliente TO Clients
GRANT EXECUTE ON Ver_Horario_Restaurantes TO Clients
GRANT EXECUTE On Ver_Todos_Restaurantes_Cliente TO Clients
GRANT EXECUTE ON Ver_Horario_Restaurante_Especifico TO Clients
GRANT EXECUTE On Alterar_Cliente TO Clients
GRANT EXECUTE On Ver_RestaurantesFav TO Clients
GRANT EXECUTE On Adicionar_PratoFavorito TO Clients
GRANT EXECUTE On Adicionar_RestauranteFavorito TO Clients
GRANT EXECUTE On Ver_Pratos_Do_Dia TO Clients
GRANT EXECUTE On Ver_Pratos_Do_Dia_Restaurante TO Clients
GRANT EXECUTE On Ver_Pratos TO Clients
GRANT EXECUTE On Ver_Pratos_Restaurante TO Clients
GRANT EXECUTE ON Ver_Servicos_Rest_Especifico TO Clients
GRANT EXECUTE ON Ver_Servicos TO Clients
GRANT EXECUTE ON Ver_Localizacao_Rest_Especifico TO Clients
GRANT EXECUTE ON Ver_Localizacao_Rest TO Clients

--Procedures dos Administradores
GRANT EXECUTE ON Novo_Admin TO Administradores
GRANT EXECUTE ON Confirmar_Email TO Administradores
GRANT EXECUTE ON Autorizar_Restaurante TO Administradores
GRANT EXECUTE ON Alterar_Admin TO Administradores
GRANT EXECUTE ON Bloquear_Utilizador TO Administradores
GRANT EXECUTE ON Ver_Clientes TO Administradores
GRANT EXECUTE ON Ver_Restaurantes_Admin TO Administradores
GRANT EXECUTE ON Ver_Clientes_Bloqueados TO Administradores
GRANT EXECUTE ON Ver_Restaurantes_Autorizados TO Administradores
GRANT EXECUTE ON Ver_Restaurantes_Nao_Autorizados TO Administradores
GRANT EXECUTE On Novo_Utilizador TO Administradores
GRANT EXECUTE ON Eliminar_Utilizador TO Administradores
GRANT EXECUTE ON Eliminar_Restaurante TO Administradores
GRANT EXECUTE ON Eliminar_Cliente TO Administradores

--Procedures dos Restaurantes
GRANT EXECUTE ON Criar_Prato_Do_Dia TO Restaurantes
GRANT EXECUTE ON Criar_Prato TO Restaurantes
GRANT EXECUTE ON Alterar_Pratos_Restaurante TO Restaurantes
GRANT EXECUTE ON Eliminar_Pratos_Restaurante TO Restaurantes	
GRANT EXECUTE ON Eliminar_Pratos_Do_Dia_Restaurante TO Restaurantes
GRANT EXECUTE ON Alterar_Restaurante TO Restaurantes	