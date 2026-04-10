-- Criando o banco de daods --
Create database BancoDaEscocia
Go

--Acessando--
Use BancoDaEscocia
go

-- Alternado o Modelo de Recuperação para Simple --
Alter database BancoDaEscocia
set Recovery Simple
Go

-- Realizando o backup Database --

Backup database BancoDaEscocia
to disk = 'C:\databases\backup\Backup-Database-BancoDaEscocia.bak' -- local --
With init, -- Especifica que um novo arquivo de backup será criado caso já exista --
Description = 'Meu arquivo Backup', -- Descrição --
Stats = 5 -- Barra de Progresso --
Go

-- criando uma tabela para simular a inserção de dados --

Create table Valores
 (Codigo int Primary key identity (1,2),
  Valor1 Bigint Default 1000000,
  Valor2 bigint Default 2000000,
  Valor3 As (Valor1+Valor2))
Go

-- Inserindo uma massa de dados --

Insert into Valores Default Values
Go 100000

-- consultando top 2000 registros lógicos de forma aleatória --
select top 2000 Codigo,Valor1, Valor2, Valor3 from Valores 
Order by NewId()
go

-- Realizando um novo Backup Database --
Backup Database BancoDaEscocia
to Disk = 'C:\databases\backup\Meu-ArquivoBackup-BancoDaEscocia-2.bak'
With init,
Description = 'Meu segundo arquivo de backup',
Stats = 2,
checksum -- verifica a integridade do arquivo de backup antes da conclusão da cópia --
go

-- Alterando o Modelo de Recuperação para Full(Completo) --

Alter DATABASE BancoDaEscocia
set recovery Full
go

-- Inserindo uma massa de dados --

insert into Valores Default Values
go 100000

-- Realizando o Backup de Database --

Backup database BancoDaEscocia
to Disk = 'C:\databases\backup\Backup-Database-Full-BancoDaEscocia.bak'
With init,
Format, -- Criando uma midia de backup, gerando um novo cabeçalho --
Checksum,
Description ='Backup Full Arquivo de Dados',
ExpireDate ='08-09-2026', -- Data da validade do Backup --
Stats=10
go

-- Realizando Backup de Log --

Backup Log BancoDaEscocia
to disk ='C:\databases\backup\Backup-Log-BancoDaEscocia.Bkp'
With init, Format, Checksum,
	Description ='Backup Full do Arquivo do Log',
	-- Compression -- Compactação --
	Stats=10
Go

-- Obtendo um detalhamento simples sobre as rotinas de Backup --
