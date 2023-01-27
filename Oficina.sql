USE master
GO
IF EXISTS (SELECT * FROM sys.databases WHERE NAME = 'db_Oficina')
BEGIN
	ALTER DATABASE db_Oficina SET SINGLE_USER WITH ROLLBACK IMMEDIATE
	DROP DATABASE db_Oficina
END
GO
CREATE DATABASE db_Oficina ON PRIMARY (
	NAME = db_Oficina,
	FILENAME = 'C:\Workspace\db_Oficina.MDF',
	SIZE = 6MB,
	MAXSIZE = UNLIMITED
)
GO
USE db_Oficina
GO
DROP TABLE IF EXISTS Pessoa
GO
CREATE TABLE Pessoa (
	ID_Pessoa INT PRIMARY KEY,
	Nome_p VARCHAR(15) NOT NULL,
	Sobrenome_p VARCHAR(15) NOT NULL,
	CPF CHAR(11) NOT NULL UNIQUE,
	Nascimento DATE NOT NULL,
	Whatsapp CHAR(12) NOT NULL,
	Email VARCHAR(35),
	Endereco VARCHAR(50) NOT NULL,
	Numero_end INT NOT NULL,
	CEP CHAR(8) NOT NULL,
	Cidade VARCHAR(20) NOT NULL
)
GO
DROP PROCEDURE IF EXISTS sp_cadastro_pessoa
GO
CREATE PROCEDURE sp_cadastro_pessoa (@ID_Pessoa INT, @Nome VARCHAR(15), @Sobrenome VARCHAR(15), 
@CPF CHAR(11), @Nascimento DATE, @Zap CHAR(12), @Email VARCHAR(35), @Endereco VARCHAR(50), 
@Num_end INT, @CEP CHAR(8), @Cidade VARCHAR(20))
AS
BEGIN TRY
	BEGIN TRANSACTION
		INSERT INTO Pessoa (ID_Pessoa, Nome_p, Sobrenome_p, CPF, Nascimento, Whatsapp, Email, Endereco,
Numero_end, CEP, Cidade) VALUES (@ID_Pessoa, @Nome, @Sobrenome, @CPF, @Nascimento, @Zap, @Email, @Endereco,
@Num_end, @CEP, @Cidade)
		IF @@ERROR = 0
			COMMIT
END TRY
BEGIN CATCH
	DECLARE @NUM INT = ERROR_NUMBER(), @SEVERIDADE INT = ERROR_SEVERITY(), @MSG VARCHAR(200) = ERROR_MESSAGE()
	RAISERROR(@MSG, @SEVERIDADE, @NUM)
	IF @@TRANCOUNT <> 0
	BEGIN
        ROLLBACK
		RETURN
	END
END CATCH
GO
--EXEC sp_cadastro_pessoa @ID_Pessoa = 1, @Nome = 'Collen', @Sobrenome = 'Jochananny', @CPF = '398-65-8037',
--@Nascimento = '2000-12-04', @Zap = '161-230-6375', @Email = 'cjochanany0@hc360.com', @Endereco = 'St. Arapahoe',
--@Num_end = 152, @CEP = '63-910', @Cidade = 'Miejska Górka'
--EXEC sp_cadastro_pessoa @ID_Pessoa = 2, @Nome = 'James', @Sobrenome = 'Jochananny', @CPF = '397-12-8034',
--@Nascimento = '1999-07-04', @Zap = '124-530-1245', @Email = 'jochananny26@yahoo.com', @Endereco = 'St. Peters',
--@Num_end = 164, @CEP = '54-120', @Cidade = 'Kraków Majska'
GO
DROP TABLE IF EXISTS Cliente
GO
CREATE TABLE Cliente (
	ID_Cliente INT PRIMARY KEY,
	ID_Pessoa INT NOT NULL CONSTRAINT fk_ID_PessoaC FOREIGN KEY (ID_Pessoa) REFERENCES Pessoa
)
GO
DROP PROCEDURE IF EXISTS sp_cadastro_cliente
GO
CREATE PROCEDURE sp_cadastro_cliente (@ID_Cliente INT, @ID_Pessoa INT)
AS
BEGIN TRY
	BEGIN TRANSACTION
		INSERT INTO Cliente (ID_Cliente, ID_Pessoa) VALUES (@ID_Cliente, @ID_Pessoa)
		IF @@ERROR = 0
			COMMIT
END TRY
BEGIN CATCH
	DECLARE @NUM INT = ERROR_NUMBER(), @SEVERIDADE INT = ERROR_SEVERITY(), @MSG VARCHAR(200) = ERROR_MESSAGE()
	RAISERROR (@MSG, @SEVERIDADE, @NUM)
	IF @@TRANCOUNT <> 0
	BEGIN
		ROLLBACK
		RETURN
	END
END CATCH
GO
--EXEC sp_cadastro_cliente @ID_Cliente = 1, @ID_Pessoa = 1
GO
DROP TABLE IF EXISTS Cargo
GO
CREATE TABLE Cargo (
	ID_Cargo INT PRIMARY KEY,
	Cargo VARCHAR(25)
)
GO
DROP PROCEDURE IF EXISTS sp_cadastro_cargo
GO
CREATE PROCEDURE sp_cadastro_cargo (@ID_Cargo INT, @Cargo VARCHAR(25))
AS
BEGIN TRY
	BEGIN TRANSACTION
		INSERT INTO Cargo (ID_Cargo, Cargo) VALUES (@ID_Cargo, @Cargo)
		IF @@ERROR = 0
			COMMIT
END TRY
BEGIN CATCH
	DECLARE @NUM INT = ERROR_NUMBER(), @SEVERIDADE INT = ERROR_SEVERITY(), @MSG VARCHAR(200) = ERROR_MESSAGE()
	RAISERROR (@MSG, @SEVERIDADE, @NUM)
	IF @@TRANCOUNT <> 0
	BEGIN
		ROLLBACK
		RETURN
	END
END CATCH
GO
--EXEC sp_cadastro_cargo @ID_Cargo = 1, @Cargo = 'CEO'
GO
DROP TABLE IF EXISTS Funcionario
GO
CREATE TABLE Funcionario (
	ID_Funcionario INT PRIMARY KEY,
	Especialidade VARCHAR(20) NOT NULL,
	ID_Pessoa INT NOT NULL CONSTRAINT fk_ID_PessoaF FOREIGN KEY (ID_Pessoa) REFERENCES Pessoa,
	ID_Cargo INT NOT NULL CONSTRAINT fk_ID_Cargo FOREIGN KEY (ID_Cargo) REFERENCES Cargo,
	ID_Func INT CONSTRAINT fk_ID_Funcionario FOREIGN KEY (ID_Funcionario) REFERENCES Funcionario,
	Superior VARCHAR(25)
)
GO
DROP PROCEDURE IF EXISTS sp_cadastro_funcionario
GO
CREATE PROCEDURE sp_cadastro_funcionario (@ID_Funcionario INT, @Especialidade VARCHAR(20), @ID_Pessoa INT,
@ID_Cargo INT, @ID_Func INT, @Superior VARCHAR(25))
AS
BEGIN TRY
	BEGIN TRANSACTION
		INSERT INTO Funcionario (ID_Funcionario, Especialidade, ID_Pessoa, ID_Cargo, ID_Func, Superior)
VALUES (@ID_Funcionario, @Especialidade, @ID_Pessoa, @ID_Cargo, @ID_Func, @Superior)
		IF @@ERROR = 0
			COMMIT
END TRY
BEGIN CATCH
	DECLARE @NUM INT = ERROR_NUMBER(), @SEVERIDADE INT = ERROR_SEVERITY(), @MSG VARCHAR(200) = ERROR_MESSAGE()
	RAISERROR (@MSG, @SEVERIDADE, @NUM)
	IF @@TRANCOUNT <> 0
	BEGIN
		ROLLBACK
		RETURN
	END
END CATCH
GO
--EXEC sp_cadastro_funcionario @ID_Funcionario = 1, @Especialidade = 'Carros Luxuosos', @ID_Pessoa = 2,
--@ID_Cargo = 1, @ID_Func = 1, @Superior = 'none'
DROP TABLE IF EXISTS Veiculo
GO
CREATE TABLE Veiculo (
	ID_Veiculo INT PRIMARY KEY,
	Fabricante VARCHAR(15) NOT NULL,
	Modelo VARCHAR(50) NOT NULL,
	Placa CHAR(11) NOT NULL,
	Renavam CHAR(17) NOT NULL,
	Ano CHAR(4),
	Cor VARCHAR(10),
	Observacao VARCHAR(100),
	ID_Cliente INT NOT NULL CONSTRAINT fk_ID_Cliente FOREIGN KEY (ID_Cliente) REFERENCES Cliente
)
GO
DROP PROCEDURE IF EXISTS sp_cadastro_veiculo
GO
CREATE PROCEDURE sp_cadastro_veiculo (@ID_Veiculo INT, @Fabricante VARCHAR(15), @Modelo VARCHAR(50),
@Placa CHAR(11), @Renavam CHAR(17), @Ano CHAR(4), @Cor VARCHAR(10), @Observacao VARCHAR(100), @ID_Cliente INT)
AS
BEGIN TRY
	BEGIN TRANSACTION
		INSERT INTO Veiculo (ID_Veiculo, Fabricante, Modelo, Placa, Renavam, Ano, Cor, Observacao, ID_Cliente)
VALUES (@ID_Veiculo, @Fabricante, @Modelo, @Placa, @Renavam, @Ano, @Cor, @Observacao, @ID_Cliente)
		IF @@ERROR = 0
			COMMIT
END TRY
BEGIN CATCH
	DECLARE @NUM INT = ERROR_NUMBER(), @SEVERIDADE INT = ERROR_SEVERITY(), @MSG VARCHAR(200) = ERROR_MESSAGE()
	RAISERROR (@MSG, @SEVERIDADE, @NUM)
	IF @@TRANCOUNT <> 0
	BEGIN
		ROLLBACK
		RETURN
	END
END CATCH
GO
--EXEC sp_cadastro_veiculo @ID_Veiculo = 1, @Fabricante = 'Volvo', @Modelo = 'S40 2.0 Aut.', @Placa = 'IAJ-0693',
--@Renavam = '1FTWW3B57AE985739', @Ano = '2012', @Cor = 'Vermelho', @Observacao = 'Pastilhas de freio gastas', @ID_Cliente = 1
DROP TABLE IF EXISTS Orcamento
GO
CREATE TABLE Orcamento (
	ID_Orcamento INT PRIMARY KEY,
	Descricao VARCHAR(100) NOT NULL,
	Quantidade INT NOT NULL,
	Valor MONEY NOT NULL,
	Data_Inicio DATE NOT NULL,
	Data_Termino DATE NOT NULL,
	ID_Veiculo INT NOT NULL CONSTRAINT fk_ID_Veiculo FOREIGN KEY (ID_Veiculo) REFERENCES Veiculo,
	ID_Funcionario INT NOT NULL CONSTRAINT fk_ID_Or_Funcionario FOREIGN KEY (ID_Funcionario) REFERENCES Funcionario
)
GO
DROP PROCEDURE IF EXISTS sp_cadastro_orcamento
GO
CREATE PROCEDURE sp_cadastro_orcamento (@ID_Orcamento INT, @Descricao VARCHAR(100), @Quantidade INT, @Valor MONEY,
@Data_Inicio DATE, @Data_Fim DATE, @ID_Veiculo INT, @ID_Funcionario INT)
AS
BEGIN TRY
	BEGIN TRANSACTION
		INSERT INTO Orcamento(ID_Orcamento, Descricao, Quantidade, Valor, Data_Inicio, Data_Termino, ID_Veiculo,
ID_Funcionario) VALUES (@ID_Orcamento, @Descricao, @Quantidade, @Valor, @Data_Inicio, @Data_Fim, @ID_Veiculo, @ID_Funcionario)
		IF @@ERROR = 0
			COMMIT
END TRY
BEGIN CATCH
	DECLARE @NUM INT = ERROR_NUMBER(), @SEVERIDADE INT = ERROR_SEVERITY(), @MSG VARCHAR(200) = ERROR_MESSAGE()
	RAISERROR (@MSG, @SEVERIDADE, @NUM)
	IF @@TRANCOUNT <> 0
	BEGIN
		ROLLBACK
		RETURN
	END
END CATCH
GO
--EXEC sp_cadastro_orcamento @ID_Orcamento = 1, @Descricao = 'Troca de pastilhas de freio', @Quantidade = 4,
--@Valor = 800, @Data_Inicio = '2022-10-20', @Data_Fim = '2022-10-23', @ID_Veiculo = 1, @ID_Funcionario = 1
GO
DROP TABLE IF EXISTS OrdemServico
GO
CREATE TABLE OrdemServico (
	ID_OS INT PRIMARY KEY,
	Status_OS VARCHAR(20) NOT NULL,
	Data_Entrega DATE NOT NULL,
	Descricao_OS VARCHAR(100) NOT NULL,
	Valor_OS MONEY NOT NULL,
	ID_Orcamento INT NOT NULL CONSTRAINT fk_ID_OS FOREIGN KEY (ID_Orcamento) REFERENCES Orcamento
)
GO
DROP PROCEDURE IF EXISTS sp_cadastro_os
GO
CREATE PROCEDURE sp_cadastro_os (@ID_OS INT, @Status_OS VARCHAR(20), @Data_Entrega DATE, @Descricao_OS VARCHAR(100),
@Valor_OS MONEY, @ID_Orcamento INT)
AS
BEGIN TRY
	BEGIN TRANSACTION
		INSERT INTO OrdemServico(ID_OS, Status_OS, Data_Entrega, Descricao_OS, Valor_OS, ID_Orcamento)
VALUES (@ID_OS, @Status_OS, @Data_Entrega, @Descricao_OS, @Valor_OS, @ID_Orcamento)
		IF @@ERROR = 0
			COMMIT
END TRY
BEGIN CATCH
	DECLARE @NUM INT = ERROR_NUMBER(), @SEVERIDADE INT = ERROR_SEVERITY(), @MSG VARCHAR(200) = ERROR_MESSAGE()
	RAISERROR (@MSG, @SEVERIDADE, @NUM)
	IF @@TRANCOUNT <> 0
	BEGIN
		ROLLBACK
		RETURN
	END
END CATCH
GO
--EXEC sp_cadastro_os @ID_OS = 1, @Status_OS = 'Andamento', @Data_Entrega = '2022-01-30', @Descricao_OS = 
--'Troca de pastilhas de freio', @Valor_OS = 800, @ID_Orcamento = 1
GO
DROP TABLE IF EXISTS Peca
GO
CREATE TABLE Peca (
	ID_Peca INT PRIMARY KEY,
	Nome_Peca VARCHAR(30) NOT NULL,
	Quantidade INT NOT NULL,
	Valor_Peca MONEY NOT NULL
)
GO
DROP PROCEDURE IF EXISTS sp_cadastro_peca
GO
CREATE PROCEDURE sp_cadastro_peca (@ID_Peca INT, @Nome VARCHAR(30), @Qtd INT, @Valor MONEY)
AS
BEGIN TRY
	BEGIN TRANSACTION
		INSERT INTO Peca(ID_Peca, Nome_Peca, Quantidade, Valor_Peca)
VALUES (@ID_Peca, @Nome, @Qtd, @Valor)
		IF @@ERROR = 0
			COMMIT
END TRY
BEGIN CATCH
	DECLARE @NUM INT = ERROR_NUMBER(), @SEVERIDADE INT = ERROR_SEVERITY(), @MSG VARCHAR(200) = ERROR_MESSAGE()
	RAISERROR (@MSG, @SEVERIDADE, @NUM)
	IF @@TRANCOUNT <> 0
	BEGIN
		ROLLBACK
		RETURN
	END
END CATCH
GO
--EXEC sp_cadastro_peca @ID_Peca = 1, @Nome = 'Pastilha de freio', @Qtd = 5, @Valor = 200
DROP TABLE IF EXISTS Orcamento_Peca
GO
CREATE TABLE Orcamento_Peca (
	ID_Orcamento INT NOT NULL CONSTRAINT fk_Orc_Peca FOREIGN KEY (ID_Orcamento) REFERENCES Orcamento,
	ID_Peca INT NOT NULL CONSTRAINT fk_Peca_Orc FOREIGN KEY (ID_Peca) REFERENCES Peca,
	Peca_Valor MONEY NOT NULL
)
GO
DROP PROCEDURE IF EXISTS sp_cadastro_ospeca
GO
CREATE PROCEDURE sp_cadastro_ospeca (@ID_Orc INT, @ID_Peca INT, @Valor MONEY)
AS
BEGIN TRY
	BEGIN TRANSACTION
		INSERT INTO Orcamento_Peca (ID_Orcamento, ID_Peca, Peca_Valor)
VALUES (@ID_Orc, @ID_Peca, @Valor)
		IF @@ERROR = 0
			COMMIT
END TRY
BEGIN CATCH
	DECLARE @NUM INT = ERROR_NUMBER(), @SEVERIDADE INT = ERROR_SEVERITY(), @MSG VARCHAR(200) = ERROR_MESSAGE()
	RAISERROR (@MSG, @SEVERIDADE, @NUM)
	IF @@TRANCOUNT <> 0
	BEGIN
		ROLLBACK
		RETURN
	END
END CATCH
GO
--EXEC sp_cadastro_ospeca @ID_Orc = 1, @ID_Peca = 1, @Valor = 200
DROP TABLE IF EXISTS Mao_Obra
GO
CREATE TABLE Mao_Obra (
	ID_Servico INT PRIMARY KEY,
	Tipo VARCHAR(8) NOT NULL CHECK (Tipo IN('Revisão', 'Conserto')),
	Valor_MO MONEY NOT NULL
)
GO
DROP PROCEDURE IF EXISTS sp_cadastro_obra
GO
CREATE PROCEDURE sp_cadastro_obra (@ID_Servico INT, @Tipo VARCHAR(8), @Valor MONEY)
AS
BEGIN TRY
	BEGIN TRANSACTION
		INSERT INTO Mao_Obra(ID_Servico, Tipo, Valor_MO)
VALUES (@ID_Servico, @Tipo, @Valor)
		IF @@ERROR = 0
			COMMIT
END TRY
BEGIN CATCH
	DECLARE @NUM INT = ERROR_NUMBER(), @SEVERIDADE INT = ERROR_SEVERITY(), @MSG VARCHAR(200) = ERROR_MESSAGE()
	RAISERROR (@MSG, @SEVERIDADE, @NUM)
	IF @@TRANCOUNT <> 0
	BEGIN
		ROLLBACK
		RETURN
	END
END CATCH
GO
--EXEC sp_cadastro_obra @ID_Servico = 1, @Tipo = 'Conserto', @Valor = 100
DROP TABLE IF EXISTS MaoObra_Orcamento
GO
CREATE TABLE MaoObra_Orcamento (
	ID_Servico INT NOT NULL CONSTRAINT fk_Servico FOREIGN KEY (ID_Servico) REFERENCES Mao_Obra,
	ID_Orcamento INT NOT NULL CONSTRAINT fk_MO_Orc FOREIGN KEY (ID_Orcamento) REFERENCES Orcamento
)
GO
DROP PROCEDURE IF EXISTS sp_cadastro_obraorc
GO
CREATE PROCEDURE sp_cadastro_obraorc (@ID_Servico INT, @ID_Orc INT)
AS
BEGIN TRY
	BEGIN TRANSACTION
		INSERT INTO MaoObra_Orcamento (ID_Servico, ID_Orcamento)
VALUES (@ID_Servico, @ID_Orc)
		IF @@ERROR = 0
			COMMIT
END TRY
BEGIN CATCH
	DECLARE @NUM INT = ERROR_NUMBER(), @SEVERIDADE INT = ERROR_SEVERITY(), @MSG VARCHAR(200) = ERROR_MESSAGE()
	RAISERROR (@MSG, @SEVERIDADE, @NUM)
	IF @@TRANCOUNT <> 0
	BEGIN
		ROLLBACK
		RETURN
	END
END CATCH
GO
--EXEC sp_cadastro_obraorc @ID_Servico = 1, @ID_Orc = 1
GO
DROP TABLE IF EXISTS Cartao_Digital
GO
CREATE TABLE Cartao_Digital (
	ID_Cartao INT PRIMARY KEY,
	Nome_Completo VARCHAR(50) NOT NULL,
	Numero CHAR(16) NOT NULL,
	Validade VARCHAR(5) NOT NULL,
	Forma VARCHAR(7) NOT NULL CHECK (Forma IN('Débito', 'Crédito'))
)
GO
DROP PROCEDURE IF EXISTS sp_cadastro_card
GO
CREATE PROCEDURE sp_cadastro_card (@ID_Cartao INT, @Nome VARCHAR(50), @Numero CHAR(16), @Validade VARCHAR(5),
@Forma VARCHAR(7))
AS
BEGIN TRY
	BEGIN TRANSACTION
		INSERT INTO Cartao_Digital(ID_Cartao, Nome_Completo, Numero, Validade, Forma)
VALUES (@ID_Cartao, @Nome, @Numero, @Validade, @Forma)
		IF @@ERROR = 0
			COMMIT
END TRY
BEGIN CATCH
	DECLARE @NUM INT = ERROR_NUMBER(), @SEVERIDADE INT = ERROR_SEVERITY(), @MSG VARCHAR(200) = ERROR_MESSAGE()
	RAISERROR (@MSG, @SEVERIDADE, @NUM)
	IF @@TRANCOUNT <> 0
	BEGIN
		ROLLBACK
		RETURN
	END
END CATCH
GO
--EXEC sp_cadastro_card @ID_Cartao = 1, @Nome = 'Collen Jochananny', @Numero = '5133883423743325', @Validade =
--'10/30', @Forma = 'Crédito'
DROP TABLE IF EXISTS Boleto
GO
CREATE TABLE Boleto (
	ID_Boleto INT PRIMARY KEY,
	Codigo VARCHAR(48) NOT NULL
)
GO
DROP PROCEDURE IF EXISTS sp_cadastro_boleto
GO
CREATE PROCEDURE sp_cadastro_boleto (@ID_Boleto INT, @Cod VARCHAR(48))
AS
BEGIN TRY
	BEGIN TRANSACTION
		INSERT INTO Boleto(ID_Boleto, Codigo)
VALUES (@ID_Boleto, @Cod)
		IF @@ERROR = 0
			COMMIT
END TRY
BEGIN CATCH
	DECLARE @NUM INT = ERROR_NUMBER(), @SEVERIDADE INT = ERROR_SEVERITY(), @MSG VARCHAR(200) = ERROR_MESSAGE()
	RAISERROR (@MSG, @SEVERIDADE, @NUM)
	IF @@TRANCOUNT <> 0
	BEGIN
		ROLLBACK
		RETURN
	END
END CATCH
GO
DROP TABLE IF EXISTS Forma_Pagamento
GO
CREATE TABLE Forma_Pagamento (
	ID_Cliente INT NOT NULL CONSTRAINT fk_FP_Cliente FOREIGN KEY (ID_Cliente) REFERENCES Cliente,
	ID_OS INT NOT NULL CONSTRAINT fk_FP_OS FOREIGN KEY (ID_OS) REFERENCES OrdemServico,
	ID_Cartao INT CONSTRAINT fk_FP_Cartao FOREIGN KEY (ID_Cartao) REFERENCES Cartao_Digital,
	ID_Boleto INT CONSTRAINT fk_FP_Boleto FOREIGN KEY (ID_Boleto) REFERENCES Boleto
)
GO
DROP PROCEDURE IF EXISTS sp_cadastro_pagamento
GO
CREATE PROCEDURE sp_cadastro_pagamento (@ID_Cliente INT, @ID_OS INT, @ID_Cartao INT, @ID_Boleto INT)
AS
BEGIN TRY
	BEGIN TRANSACTION
		INSERT INTO Forma_Pagamento(ID_Cliente, ID_OS, ID_Cartao, ID_Boleto)
VALUES (@ID_Cliente, @ID_OS, @ID_Cartao, @ID_Boleto)
		IF @@ERROR = 0
			COMMIT
END TRY
BEGIN CATCH
	DECLARE @NUM INT = ERROR_NUMBER(), @SEVERIDADE INT = ERROR_SEVERITY(), @MSG VARCHAR(200) = ERROR_MESSAGE()
	RAISERROR (@MSG, @SEVERIDADE, @NUM)
	IF @@TRANCOUNT <> 0
	BEGIN
		ROLLBACK
		RETURN
	END
END CATCH
GO
--EXEC sp_cadastro_pagamento @ID_Cliente = 1, @ID_OS = 1, @ID_Cartao = 1, @ID_Boleto = null
