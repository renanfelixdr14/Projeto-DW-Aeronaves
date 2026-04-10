-- Realizando a Troca do Banco de Dados antes de aplicar as validações --
Use master
go

-- Validando a estrutura Fisica e Lógica dos arquivos armazenados no backup --

-- Passo 1 - Apresentar a Lista de Arquivos contidos no arquivo de backup --
Restore FileListOnly
From disk ='C:\databases\backup\Backup-Database-Full-BancoDaEscocia.bak'
go

-- Passo 2 - Verificando a integridade do arquivo de backup --
Restore verifyonly
from disk ='C:\databases\backup\Backup-Database-Full-BancoDaEscocia.bak'
go

-- Passo 3 - Verificando a consistência do cabeçalho --
Restore HeaderONly
From disk='C:\databases\backup\Backup-Database-Full-BancoDaEscocia.bak'
go

-- Passo 4 - Obter as informações sobre a ferramenta utilizada no processo de backup --
Restore LabelOnly
From disk='C:\databases\backup\Backup-Database-Full-BancoDaEscocia.bak'
go
