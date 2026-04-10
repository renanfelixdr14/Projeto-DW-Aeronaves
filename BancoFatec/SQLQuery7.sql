Create Database Indices
Go

Use Indices
Go

--Criando uma Heap Table --
Create table HeapTableAlunos
(CodigoAluno int,
NomeAluno Varchar (20),
DataAluno Date)
Go

-- inserindo os dados na Tabela HeapTableAlunos --
Insert into HeapTableAlunos (CodigoAluno, NomeAluno, DataAluno)
Values(1,'Aluno 1',GETDATE()),(2,'Aluno 2',GETDATE()+1),(3,'Aluno 3',GETDATE()+2),
(4,'Aluno 4',GETDATE()+3),(5,'Aluno 5',GETDATE()+4)
Go

-- Desativando a contagem de Linhas --
Set noCount ON
Go

-- Ativar o Plano de Execução antes de realizar o Select - Teclando CRTL + M --
Select CodigoAluno, NomeAluno, DataALuno From HeapTableAlunos
Go

-- Desativando o Plano de Execução - CRLT+M --
-- Alterando a coluna CodioAluno para não aceitar valores nulos --
Alter table HeapTableAlunos
Alter column CodigoAluno int Not null
Go

-- Adicionando a Primary key na table HeapTableAlunos na coluna CodigoAluno --
Alter table HeapTableAlunos
add Constraint PK_HeapTableAlunos_CodigoAlunos Primary key (CodigoAluno)
Go

-- Testando o funcionamento da Primary key - Ativando o plano de Execução de novo --
Select NomeAluno, DataAluno From HeapTableAlunos
Where CodigoAluno = 4
Go

-- Realizando a ordenação de valores --
Select NomeAluno, DataAluno From HeapTableAlunos
Order by DataAluno Desc
GO

-- Criando um novo indice não clustered na tabela HeapTableAlunos --
Create NonClustered Index ind_NonClustered_DataAluno
On HeapTableAlunos(DataAluno)
Go

-- Simulando o uso do Indice NonClustered --
-- Exemplo 1 - Será utilizado a Priamry Key --
Select NomeAluno, DataAluno From HeapTableAlunos
Where DataAluno Between '07-04-2026' And '09-04-2026'
Go

-- Exemplo 2 --
Select DataAluno From HeapTableAlunos
where CodigoAluno = 1
Go

-- Exemplo 4 - Será utilizado o índice NonClustered --
Select DataAluno From HeapTableAlunos
Go

-- Exemplo 4 - Será utilizado o índice NonClustered --
Select DataAluno From HeapTableAlunos
where DataAluno = '07-04-2026'
Go

-- Exemplo 5 - Forçando o uso do Index NonClustered --
Select CodigoAluno, NomeAluno, DataAluno 
From HeapTableAlunos With (Index=ind_NonClustered_DataAluno)
Where DataAluno = '09-04-2026'
Go