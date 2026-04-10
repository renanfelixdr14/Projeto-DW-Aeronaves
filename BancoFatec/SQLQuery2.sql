-- Exemplo 1 - especificando as configurações básicas de criação --

Create Database FatecSR2026
On primary
(name = 'FATECSR-Data', -- nome interno do arquivo --
FileName = 'C:\databases\data\FATECSR-Data.mdf', -- Caminho --
Size = 50 mb, -- tamanho inicial do arquivo --
Maxsize = 500 mb, -- tamanho máximo de crescimento --
FileGrowth = 10 mb) -- Fator de crescimento --
Log on
(Name = 'FatecSR-Log', -- noem interno do aquivo --
FileName = 'C:\databases\log\FatecSR-Log.ldf', --Caminho--
Size = 100 mb, -- tamanho inicial do arquivo --
Maxsize = 2 gb, -- tamanho máximo de crescimento --
FileGrowth = 100 mb) -- Fator de crescimento --
go

-- Exemplo 2 - Criando um novo Banco com dois arquivos de dados e um de Log --
Create database FatecSRDoisArquivos
ON Primary
(Name = 'FatecSRDoisArquivos-Data',
 FileName = 'C:\databases\data\FatecSRDoisArquivos-Data.mdf',
 Size = 1024 MB,
 MaxSize = 10 GB,
 FileGrowth = 10%),
(Name  = 'FatecSRDoisArquivos-Data-1',
 FileName = 'C:\databases\data\FatecSRDoisArquivos-Data-1.ndf',
 Size = 2048 MB,
 MaxSize = 10 GB,
 FileGrowth = 15%)
Log ON
(Name  = 'FatecSRDoisArquivos-Log',
 FileName = 'C:\databases\log\FatecSRDoisArquivos-Log.ldf',
 Size = 4096 MB,
 MaxSize = 20 GB,
 FileGrowth = 1024 MB)
Go