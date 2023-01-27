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
	ID_Pessoa INT PRIMARY KEY IDENTITY,
	Nome_Pessoa VARCHAR(15) NOT NULL,
	Sobrenome_Pessoa VARCHAR(15) NOT NULL,
	CPF CHAR(11) NOT NULL UNIQUE,
	Nascimento DATE NOT NULL,
	Whatsapp CHAR(12) NOT NULL,
	Email VARCHAR(35),
	Endereco VARCHAR(50) NOT NULL,
	Numero_end VARCHAR(5) NOT NULL,
	CEP CHAR(8) NOT NULL,
	Cidade VARCHAR(20) NOT NULL
)
GO
DROP TABLE IF EXISTS Cliente
GO
CREATE TABLE Cliente (
	ID_Cliente INT PRIMARY KEY IDENTITY,
	ID_Pessoa INT NOT NULL CONSTRAINT fk_ID_PessoaC FOREIGN KEY (ID_Pessoa) REFERENCES Pessoa
)
GO
DROP TABLE IF EXISTS Cargo
GO
CREATE TABLE Cargo (
	ID_Cargo INT PRIMARY KEY IDENTITY,
	Cargo VARCHAR(25)
)
GO
DROP TABLE IF EXISTS Funcionario
GO
CREATE TABLE Funcionario (
	ID_Funcionario INT PRIMARY KEY IDENTITY,
	Especialidade VARCHAR(20) NOT NULL,
	ID_Pessoa INT NOT NULL CONSTRAINT fk_ID_PessoaF FOREIGN KEY (ID_Pessoa) REFERENCES Pessoa,
	ID_Cargo INT NOT NULL CONSTRAINT fk_ID_Cargo FOREIGN KEY (ID_Cargo) REFERENCES Cargo,
	ID_Func INT CONSTRAINT fk_ID_Funcionario FOREIGN KEY (ID_Funcionario) REFERENCES Funcionario,
	Superior VARCHAR(25)
)
GO
DROP TABLE IF EXISTS Veiculo
GO
CREATE TABLE Veiculo (
	ID_Veiculo INT PRIMARY KEY IDENTITY,
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
DROP TABLE IF EXISTS Orcamento
GO
CREATE TABLE Orcamento (
	ID_Orcamento INT PRIMARY KEY IDENTITY,
	Descricao VARCHAR(100) NOT NULL,
	Quantidade INT NOT NULL,
	Valor MONEY NOT NULL,
	Data_Inicio DATE NOT NULL,
	Data_Termino DATE NOT NULL,
	ID_Veiculo INT NOT NULL CONSTRAINT fk_ID_Veiculo FOREIGN KEY (ID_Veiculo) REFERENCES Veiculo,
	ID_Funcionario INT NOT NULL CONSTRAINT fk_ID_Or_Funcionario FOREIGN KEY (ID_Funcionario) REFERENCES Funcionario,
)
GO
DROP TABLE IF EXISTS OrdemServico
GO
CREATE TABLE OrdemServico (
	ID_OS INT PRIMARY KEY IDENTITY,
	Status_OS VARCHAR(20) NOT NULL,
	Data_Entrega DATE NOT NULL,
	Descricao_OS VARCHAR(100) NOT NULL,
	Valor_OS MONEY NOT NULL,
	ID_Orcamento INT NOT NULL CONSTRAINT fk_ID_OS FOREIGN KEY (ID_Orcamento) REFERENCES Orcamento
)
GO
DROP TABLE IF EXISTS OS_Funcionario
GO
CREATE TABLE OS_Funcionario (
	ID_OS INT NOT NULL CONSTRAINT fk_ID_OS_Fun FOREIGN KEY (ID_OS) REFERENCES OrdemServico,
	ID_Funcionario INT NOT NULL CONSTRAINT fk_ID_Fun_OS FOREIGN KEY (ID_Funcionario) REFERENCES Funcionario
)
GO
DROP TABLE IF EXISTS Peca
GO
CREATE TABLE Peca (
	ID_Peca INT PRIMARY KEY IDENTITY,
	Nome_Peca VARCHAR(30) NOT NULL,
	Quantidade INT NOT NULL,
	Valor_Peca MONEY NOT NULL
)
GO
DROP TABLE IF EXISTS Orcamento_Peca
GO
CREATE TABLE Orcamento_Peca (
	ID_Orcamento INT NOT NULL CONSTRAINT fk_Orc_Peca FOREIGN KEY (ID_Orcamento) REFERENCES Orcamento,
	ID_Peca INT NOT NULL CONSTRAINT fk_Peca_Orc FOREIGN KEY (ID_Peca) REFERENCES Peca,
	Peca_Valor MONEY NOT NULL
)
GO
DROP TABLE IF EXISTS Mao_Obra
GO
CREATE TABLE Mao_Obra (
	ID_Servico INT PRIMARY KEY IDENTITY,
	Tipo VARCHAR(8) NOT NULL CHECK (Tipo IN('Revisão', 'Conserto')),
	Valor_MO MONEY NOT NULL
)
GO
DROP TABLE IF EXISTS MaoObra_Orcamento
GO
CREATE TABLE MaoObra_Orcamento (
	ID_Servico INT NOT NULL CONSTRAINT fk_Servico FOREIGN KEY (ID_Servico) REFERENCES Mao_Obra,
	ID_Orcamento INT NOT NULL CONSTRAINT fk_MO_Orc FOREIGN KEY (ID_Orcamento) REFERENCES Orcamento
)
GO
DROP TABLE IF EXISTS Cartao_Digital
GO
CREATE TABLE Cartao_Digital (
	ID_Cartao INT PRIMARY KEY IDENTITY,
	Nome_Completo VARCHAR(50) NOT NULL,
	Numero CHAR(16) NOT NULL,
	Validade VARCHAR(5) NOT NULL,
	Forma VARCHAR(7) NOT NULL CHECK (Forma IN('Débito', 'Crédito'))
)
GO
DROP TABLE IF EXISTS Boleto
GO
CREATE TABLE Boleto (
	ID_Boleto INT PRIMARY KEY IDENTITY,
	Codigo VARCHAR(48) NOT NULL
)
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
INSERT INTO Pessoa (Nome_Pessoa, Sobrenome_Pessoa, CPF, Whatsapp, Email, Endereco, Numero_end, CEP , Cidade, Nascimento) 
VALUES
	('Collen', 'Jochanany', '398-65-8037', '161-230-6375', 'cjochanany0@hc360.com', 'Arapahoe', '20', '63-910', 'Miejska Górka', '1999-10-11'),
	('Andy', 'Burleton', '689-46-3407', '722-886-7777', 'aburleton1@wikia.com', 'Forest', '4194', '356011', 'Sosnovka', '1974-03-20'),
	('Basilius', 'Reynault', '223-26-1249', '508-649-0365', 'breynault2@usnews.com', 'Goodland', '35246', '8134', 'Médanos', '1959-08-25'),
	('Putnam', 'Bilbrook', '629-94-1310', '581-921-9279', 'pbilbrook3@instagram.com', 'Ramsey', '968', '1239', 'Srbinovo', '1961-12-20'),
	('Ephrem', 'Willshaw', '476-28-1923', '705-305-9824', 'ewillshaw4@upenn.edu', 'Ilene', '939', '12412', 'Pampachiri', '1988-05-10'),
	('Faythe', 'Campbell-Dunlop', '234-26-9851', '205-330-4814', 'fcampbelldunlop5@linkedin.com', 'Melby', '4', '349-1104', 'Kurihashi', '2002-12-25'),
	('Oralle', 'Northeast', '604-76-1247', '514-471-9405', 'onortheast6@usa.gov', 'Lukken', '81','215352', 'Chang’an', '2000-02-28'),
	('Hart', 'Petrushkevich', '751-34-7777', '378-529-2945', 'hpetrushkevich7@pinterest.com', 'Eagle Crest', '57', '5882', 'Tingqian', '1966-07-10'),
	('Mariel', 'Bruckman', '812-14-9803', '314-914-3252', 'mbruckman8@bloomberg.com', 'Russell', '27501', '7010', 'Mabuhay', '1992-06-21'),
	('Lucille', 'Loughlan', '293-49-7642', '277-147-1951', 'lloughlan9@scribd.com', 'Claremont', '1', '588522', 'Kaliprak', '1964-09-14'),
	('Avril', 'Mayhew', '831-76-1320', '128-913-0106', 'amayhewa@weibo.com', 'American Ash', '617', '303021', 'Muyudian','1963-05-24'),
	('Benny', 'Badham', '344-07-0556', '707-218-4061', 'bbadhamb@usatoday.com', 'Myrtle', '1849', '4622', 'Yerba Buena','1980-03-09'),
	('Lionel', 'Danovich', '656-39-5185', '659-964-6625', 'ldanovichc@house.gov', 'Lighthouse Bay', '480', '29411', 'Landerneau', '1969-01-09'),
	('Marylinda', 'Crassweller', '839-34-3720', '636-502-2666', 'mcrasswellerd@infoseek.co.jp', 'American Ash', '11', '141028', 'Kostrovo', '1993-05-29'),
	('Aurie', 'Ancliffe', '895-25-1088', '829-330-7799', 'aancliffee@shareasale.com', 'Brentwood', '1', '15241', 'Kubangkondang','1958-12-19'),
	('Pavlov', 'Paice', '583-45-8547', '265-743-6457', 'ppaicef@g.co', 'Superior', '773', '8530', 'Panchagarh','1985-04-09'),
	('Damien', 'Ors', '777-93-9833', '557-931-3478', 'dorsg@tiny.cc', 'Katie', '63132', '671836', 'Kudara-Somon','1966-07-11'),
	('Henriette', 'Pavese', '858-99-8228', '440-414-8428', 'hpaveseh@imdb.com', 'Spaight', '8975', '056818', 'Murindó','1991-12-14'),
	('Brittaney', 'Gange', '527-82-3933', '446-764-1269', 'bgangei@netscape.com', 'Novick', '9', '89888', 'Independencia','1973-11-19'),
	('Noach', 'Sheather', '136-39-5693', '484-255-7989', 'nsheatherj@nature.com', 'High Crossing', '0040', '4602', 'Talisay','1963-11-05')
GO
INSERT INTO Cliente (ID_Pessoa)
VALUES
	(1),
	(2),
	(3),
	(4),
	(5),
	(15),
	(16),
	(17),
	(18),
	(19),
	(20)
GO
--SELECT * FROM Cliente AS C INNER JOIN Pessoa AS P ON C.ID_Pessoa = P.ID_Pessoa
INSERT INTO Cargo (Cargo)
VALUES
	('Técnico Mecânico'),
	('Auxiliar Mecânico'),
	('Mecânico N1'),
	('Mecânico N2'),
	('Mecânico N3'),
	('Mecânico Lider')
GO
INSERT INTO Funcionario (Especialidade, ID_Pessoa, ID_Cargo, Superior)
VALUES
	('Geral', 14, 6, 14),
	('Geral', 13, 5, 14),
	('Carros Luxuosos', 12, 4, 14),
	('Carros Antigos', 11, 4, 14),
	('Borracheiro', 6, 1, 13),
	('Elétrico', 7, 1, 13),
	('Motos', 8, 2, 13),
	('Motor', 9, 3, 12),
	('Freio', 10, 3, 12)
GO
-- SELECT * FROM Funcionario AS F INNER JOIN Pessoa AS P ON F.ID_Pessoa = P.ID_Pessoa
INSERT INTO Veiculo (Fabricante, Modelo, Placa, Renavam, Ano, Cor, Observacao, ID_Cliente)
VALUES
	('Volvo', 'S40 2.0 Aut.', 'IAJ-0693', '1FTWW3B57AE985739', 2012, 'Vermelho', 'Pastilhas de freio gastas', 1),
	('BMW', '3 Series 2.0 Turbo', 'MSE-7493', 'WAUBG78E96A833891', 2006, 'Branco', 'Pneus gastos', 1),
	('Ferrari', 'California F1 V8 460cv', 'FER-2193', '1GYFC53219R666489', 2019, 'Vermelho', 'Revisão', 2),
	('Dodge', 'Spirit 1.6 Eco', 'LKJ-1284', 'WBAPK73539A625408', 1995, 'Cinza', 'Parabrisa trincado', 3),
	('Cadillac', 'Escalade 2.0 Turbo', 'ASX-2142', 'WBA3X5C58FD552292', 2010, 'Branco', 'Revisão', 4),
	('Dodge', '2500 LARAMIE SLT TROPIV. 6.7', 'JHE-7313', 'WAUGL78E98A869939', 1993, 'Preto', 'Câmbio falhando', 5),
	('Rolls Royce', 'Wraith 6.6 V12 Aut.', 'MUT-4607', '1G6DV5EP7B0559119', 2012, 'Preto', 'Revisão', 5),
	('Mazda', '626 SW', 'LRM-6827', 'WAULFAFH3EN212574', 1998, 'Prata', 'Falha elétrica', 6),
	('Nissan', '240SX 2.0 Turbo', 'MNX-0024', '5GNRNHEEXA8845596', 1996, 'Amarelo', 'Revisão', 7),
	('Mazda', 'Navajo LX 3.0 V6', 'IDJ-1222', '3VWF17AT0FM821580', 2004, 'Azul', 'Motor falhando', 8),
	('Buggy', 'Buggy 1.6/ TST.', 'NEI-3225', 'WUADUAFG0BN109244', 1985, 'Azul', 'Pneus gastos', 9),
	('Hyundai', 'HB20 Spicy 1.6 Flex.', 'HBU-3883', 'WA1CMBFP5FA609132', 2018, 'Branco', 'Pastilhas de freio gastas', 10),
	('Jaguar', 'XJ S.Sport Supercharged 5.0', 'HPP-7843', '5J8TB2H55CA777566', 2019, 'Preto', 'Revisão', 11)
GO
INSERT INTO Orcamento (Descricao, Quantidade, Valor, Data_Inicio, Data_Termino, ID_Veiculo, ID_Funcionario)
VALUES
	('Troca de pastilhas de freio', 4, 800, '2022-10-20', '2022-10-23', 1, 9),
	('Troca de pneus', 4, 2500, '2022-10-21', '2022-10-24', 2, 5),
	('Troca de óleo e fluido de freio', 2, 5000, '2022-09-26', '2022-09-27', 3, 3),
	('Troca do parabrisa', 1, 500, '2022-10-02', '2022-10-05', 4, 6),
	('Troca de óleo e fluido de freio', 2, 1000, '2022-09-10', '2022-09-15', 5, 6),
	('Troca de caixa de câmbio', 1, 10000, '2022-10-15', '2022-10-25', 6, 8),
	('Troca de óleo e fluido de freio', 2, 5000, '2022-09-11', '2022-09-13', 7, 3),
	('Troca de bateria', 1, 1200, '2022-10-15', '2022-10-25', 8, 6),
	('Troca de óleo', 1, 500, '2022-10-15', '2022-10-25', 9, 4),
	('Retifica do motor', 1, 15000, '2022-11-02', '2022-11-30', 10, 8),
	('Troca de pneus', 4, 2500, '2022-10-14', '2022-10-16', 11, 5),
	('Troca de pastilhas de freio', 4, 900, '2022-09-14', '2022-09-18', 12, 9),
	('Troca de óleo e fluido de freio', 2, 5000, '2022-11-28', '2022-12-05', 13, 3)
GO
-- SELECT * FROM Funcionario AS F INNER JOIN Orcamento AS O ON F.ID_Funcionario = O.ID_Funcionario
INSERT INTO OrdemServico (Status_OS, Data_Entrega, Descricao_OS, Valor_OS, ID_Orcamento)
VALUES
	('Entregue', '2022-09-27', 'Troca de óleo e fluido de freio Ferrari', 5000, 3),
	('Entregue', '2022-10-05', 'Troca do parabrisa', 500, 4),
	('Entregue', '2022-09-13', 'Troca de óleo e fluido de freio Rolls Royce', 5000, 7),
	('Andamento', '2022-01-30', 'Retifica motor Mazda', 15000, 10),
	('Andamento', '2022-12-05', 'Troca de óleo e fluido de freio Jaguar', 5000, 13)
GO
-- SELECT * FROM Orcamento AS F INNER JOIN OrdemServico AS O ON F.ID_Orcamento = O.ID_Orcamento
INSERT INTO Peca (Nome_Peca, Quantidade, Valor_Peca)
VALUES
	('Pneu Bridgestone', 15, 500),
	('Parabrisa genérico', 5, 300),
	('Óleo', 20, 200),
	('Fluido de freio', 8, 500),
	('Bateria', 2, 450),
	('Pastilha de freio', 5, 200),
	('Caixa de câmbio', 1, 8000),
	('Motor', 1, 12500)
GO
INSERT INTO Orcamento_Peca (ID_Orcamento, ID_Peca, Peca_Valor)
VALUES
	(1, 6, 800),
	(2, 1, 2000),
	(3, 3, 200),
	(3, 4, 500),
	(4, 2, 300),
	(5, 3, 200),
	(5, 4, 500),
	(6, 7, 10000),
	(7, 3, 200),
	(7, 4, 500),
	(8, 5, 450),
	(9, 3, 200),
	(10, 8, 12500),
	(11, 1, 2000),
	(12, 6, 800),
	(13, 3, 200),
	(13, 4, 500)
GO
INSERT INTO Mao_Obra (Tipo, Valor_MO)
VALUES
	('Revisão', 200),
	('Revisão', 500),
	('Revisão', 4300),
	('Revisão', 200),
	('Revisão', 300),
	('Conserto', 2000),
	('Revisão', 4300),
	('Revisão', 750),
	('Revisão', 300),
	('Conserto', 2500),
	('Revisão', 500),
	('Revisão', 100),
	('Revisão', 4300)
GO
INSERT INTO MaoObra_Orcamento (ID_Servico, ID_Orcamento)
VALUES
	(1, 1),
	(2, 2),
	(3, 3),
	(4, 4),
	(5, 5),
	(6, 6),
	(7, 7),
	(8, 8),
	(9, 9),
	(10, 10),
	(11, 11),
	(12, 12),
	(13, 13)
GO
INSERT INTO Cartao_Digital (Nome_Completo, Numero, Validade, Forma)
VALUES
	('Leeland Bidewel', '5133883423743325', '10/30', 'Crédito'),
	('Damiano Guidoni', '5191198680062734', '05/23', 'Débito'),
	('Cristionna Fines', '5100146485399819', '08/27', 'Crédito'),
	('Lorain Olexa', '5100178574294734', '04/26', 'Crédito')
GO
INSERT INTO Boleto (Codigo)
VALUES
	('00190000090314103100912604018171191950000021395')
GO
INSERT INTO Forma_Pagamento (ID_Cliente, ID_OS, ID_Cartao, ID_Boleto)
VALUES
	(2, 1, 1, null),
	(3, 2, 2, null),
	(5, 3, 3, null),
	(6, 4, 4, null),
	(11, 5, null, 1)