Use Master
Go

-- Realizando a restauração do backup do Bando de Dados --
Restore Database BancoDaEscocia
From disk='C:\databases\backup\Backup-Database-BancoDaEscocia.bak'
with recovery, -- Recuperação de todo conteudo existente no arquivo de backup --
	Replace, -- Substitui o conteudo do banco atual pelo conteudo do backup,
	Stats=10
Go

-- Realizando a restauração do Backup de Banco de Dados para um novo Banco --
Restore FileListOnly
From Disk='C:\databases\backup\Backup-Database-Full-BancoDaEscocia.bak'
go

Restore Database BancoDaEscocia2
from Disk='C:\databases\backup\Backup-Database-Full-BancoDaEscocia.bak'
with norecovery, -- recovery -- -- Vai recuperar o conteudo mas não vai liberar o acesso --
	Replace, -- Substitua o conteúdo do banco atual pelo conteudo do backup --
	Stats=10,
	Move 'BancoDaEscocia' to 'C:\Program Files\Microsoft SQL Server\MSSQL17.MSSQLSERVER\MSSQL\DATA\BancoDaEscocia2.mdf',
	move 'BancoDaEscocia_log' to 'C:\Program Files\Microsoft SQL Server\MSSQL17.MSSQLSERVER\MSSQL\DATA\BancoDaEscocia2_log.ldf'
Go

-- Liberando o Banco de Dados para Acesso para a última restauração
Restore Database BancoDaEscocia2 with recovery
Go

