-- Criando Banco de Dados --
Create Database BancoDaFatec
On Primary
	(Name = BancoDaFatec_Dados,
	FileName = N'C:\databases\data\BancoDaFatec_Dados.mdf',
	Size=10mb,
	maxsize=50mb,
	filegrowth=10%),
FileGroup Secundario
	(Name = BancoDaFatec_Secundario_Dados,
	FileName = N'C:\databases\data\BancoDaFatec_Secundario_Dados.mdf',
	Size = 10mb,
	Maxsize = 50mb,
	filegrowth=10%)
log on
	(Name = BancoDaFatec_Log,
	FileName = N'C:\databases\log\BancoDaFatec_Log.ldf',
	Size = 10mb,
	Maxsize = 50mb,
	filegrowth=10%)
go
 
--Acessando o Banco --
Use BancoDaFatec
go

-- Criando a Tabela Alunos -- Definindo o Grupo Primary --
Create Table Alunos
 (Codigo Int Primary key,
 Nome Varchar(100) Not null)
 On [Primary]
Go

-- Criando a Tabela de Professores - Grupo Secundario --
Create table Professores
(Codigo int Primary Key Identity(1,1),
Nome Varchar(100) Default 'A')
On [Secundario]
go