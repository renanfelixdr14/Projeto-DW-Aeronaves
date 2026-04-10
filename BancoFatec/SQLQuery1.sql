create database Aula1703
go

use Aula1703

-- versão Sql Server número compatibilidade -> 160 --

-- bulk-logged -> esse modelo e vindo da carga de dados em grandes volumes. --

-- obtendo informações sobre o Banco de Dados através da tabela de sistema sys.data --

Select name, database_id, compatibility_level As 'Nivel de Compatibilidade',
	recovery_model As 'ID - Modelo Recuperação',
	recovery_model_desc As 'Modelo de Recuperação'
From sys.databases
Where Name = 'Aula1703'
go

-- obtendi informações sobre o banco de dados através da função de sistema DatabasePropertyEx --

Select DATABASEPROPERTYEx('Aula1703','Collation') As 'Dicionário de Caracteres',
	   DATABASEPROPERTYEx('Aula1703','Recovery') As 'Modelo de Recuperação',
	   DATABASEPROPERTYEx('Aula1703','Status') As 'Condição',
	   DATABASEPROPERTYEx('Aula1703','Version') As 'Versão'
go

-- Alterando o Status do Banco de Dados para Offline --
Use Master
go

Alter Database Aula1703
set offline
go

-- Alterando o Status do Banco para Online --
Alter database Aula1703
set online
go

-- Alterando o Status para Emergency --
Alter database Aula1703
set Emergency
go

-- Alterando o modelo de recuperação do Banco de Dados - Recovery Model Simple --
Alter database Aula1703
set recovery simple
go

-- Alterando o modelo de recuperação do Banco de Dados - Recovery Model Full --
Alter database Aula1703
set recovery Full
go

-- Alterando o modelo de recuperação do Banco de Dados - Recovery Model Bulk-logged --
Alter database Aula1703
set recovery bulk_logged
go

-- Obtenendo informações sobre a distribuição de espaço ocupado pelo Banco de Dados --
Exec SP_Spaceused
go

-- Utilixando a Stored Procedure Sp_HelpDB para obter as preincipais propriedades --
Exec Sp_HelpDB'Aula1703'
Go

