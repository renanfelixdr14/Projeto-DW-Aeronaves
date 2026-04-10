-- Criando Banco Aeronaves --
Create database ProjetoDWAeronaves
On primary
	(Name = 'ProjetoDWAeronaves-Data-OLTP',
	FileName = 'C:\ProjetoDWAeronaves\Data\ProjetoDWAeronaves-Data-OLTP.mdf',
	Size = 8MB,
	Maxsize = 4GB,
	FileGrowth = 128MB),
Filegroup Secundary
	(Name = 'ProjetoDWAeronaves-Data-OLAP',
	FileName = 'C:\ProjetoDWAeronaves\Data\ProjetoDWAeronaves-Data-OLAP.mdf',
	Size = 8MB,
	Maxsize = 10GB,
	FileGrowth = 128MB)
Log on
	(Name = 'ProjetoDWAeronaves-Log',
	FileName = 'C:\ProjetoDWAeronaves\Log\ProjetoDWAeronaves-Log.ldf',
	Size = 8MB,
	Maxsize = Unlimited,
	FileGrowth = 512MB)
Go

-- Definindo o modelo para Bulk-logged --
Alter Database ProjetoDWAeronaves
set Recovery Bulk_logged
Go

-- Definido o FileGroup Secundary como Padrão --
Alter Database ProjetoDWAeronaves
modify FileGroup [Secundary] Default
Go

-- Criando Os Schemas com Authorization DBOwner --
use ProjetoDWAeronaves
Go

 -- Schema pra armazenar tabelas --
Create Schema Tab Authorization dbo
Go

-- Schema pra armazenar as Dimensões --
Create Schema Dim Authorization dbo
Go

-- Criando tabela --
 Alter table Tab.TabFonteDeDados
 add ocorrencia_id int identity(1,1) primary key
 Go

 Alter table Tab.TabFonteDeDados
add Constraint PK_TabFonteDeDados_ocorrencia_id Primary key (ocorrencia_id)
Go

/*(codigo_ocorrencia int identity(1,1) not null,
ocorrencia_classificacao Varchar(20) not null,
ocorrencia_cidade varchar(30) not null,
ocorrencia_uf varchar(2) not null,
ocorrencia_pais varchar(10) not null,
ocorrencia_aerodromo varchar(4),
ocorrencia_dia Date,
ocorrencia_hora Time,
investigacao_aeronave_liberada varchar(3),
investigacao_status varchar(10),
divulgacao_relatorio_publicado varchar(3),
total_aeronaves_envolvidas tinyint,
ocorrencia_saida_pista varchar(3))
go */

-- Definindo a Segunda-Feira como primeiro dia da semana --
Set DateFist 1
Go

-- Criando tabela Dim --
--para pegar a coluna de data pegar sem repetição "Distinct"--
Create table Dim.DimTime
	(TimeID int identity(1,1) not null,
	 Dia Tinyint not null,
	 DiaDaSemana Tinyint not null,
	 DiaDaSemanaPorExtenso Varchar(15),
	 DiaDoMes Tinyint Not null,
	 DiaNoAno smallint not null,
	 Semana Tinyint not null,
	 SemanaNoMes tinyint not null,
	 SemanaNoAno tinyint not null,
	 PrimeiroDiaDaSemana Tinyint Not Null,
	 UltimoDiaDaSemana tinyint not null,
	 Mes Tinyint not null,
	 MesPorExtenso Varchar(20) not null,
	 Quartil tinyint not null,
	 MesQuartil TinyInt Not Null,
	 QuartilPorExtenso Varchar(20) Not Null,
	 Ano int Not Null,
	 AnoPorExtenso Varchar(40) not null,
	 DataAtual Date not null,
	 HoraAtual Time Not null,
	 DataHora Datetime not null,
	 Horas Tinyint not null,
	 Minutos tinyint not null,
	 Segundos Tinyint not null,
	 FeriadoPorExtenso Varchar(15) not null
	 Constraint [PK_DimTime_TimeID] Primary key Clustered (TimeID))
Go

-- Populando as Datas com base na tabela fonte de dados Coluna "ocorrencia_dia" --
Alter table Tab.TabFonteDeDados
add DataCalendario As (Cast(ocorrencia_dia As Datetime) + Cast(Isnull(ocorrencia_hora, '00:00:00') As Datetime))
Go

Insert Into Dim.DimTime ([Dia], [DiaDaSemana], [DiaDaSemanaPorExtenso],
[DiaDoMes], [DiaNoAno], [Semana], [SemanaNoMes], [SemanaNoAno],
[PrimeiroDiaDaSemana], [UltimoDiaDaSemana], [Mes], [MesPorExtenso],
[Quartil], [MesQuartil], [QuartilPorExtenso], [Ano], [AnoPorExtenso],
[DataAtual], [HoraAtual], [DataHora], [Horas], [Minutos], [Segundos],
[FeriadoPorExtenso])
Select Day(DataCalendario) As Dia,
       Datepart(DW, DataCalendario) As DiaDaSemana,
	   Case Datepart(DW, DataCalendario)
	    When 1 Then 'Segunda-Feira'
		When 2 Then 'Terça-Feira'
		When 3 Then 'Quarta-Feira'
		When 4 Then 'Quinta-Feira'
		When 5 Then 'Sexta-Feira'
		When 6 Then 'Sábado'
		When 7 Then 'Domingo'
	   End As DiaDaSemanaPorExtenso,
	   Datepart(D, DataCalendario) As DiaDoMes,
	   Datepart(DayOfYear, DataCalendario) As DiaDoAno,
	   DatePart(Week, DataCalendario) As Semana,
	   Datepart(Day, Datediff(day, 0, DataCalendario)/7 * 7)/7 + 1 As SemanaNoMes,
	   DatePart(Week, DataCalendario) As SemanaNoAno,
	   Day(DateAdd(Week, Datediff(Week, 0, DataCalendario), 0)) As PrimeiroDiaDaSemana,
	   Day(DateAdd(Week, Datediff(Week, 0, DataCalendario), 7)) As UltimoDiaDaSemana,
	   Month(DataCalendario) As Mes,
	   Case Month(DataCalendario) 
	    When 1 Then 'Janeiro'
		When 2 Then 'Fevereiro'
		When 3 Then 'Março'
		When 4 Then 'Abril'
		When 5 Then 'Maio'
		When 6 Then 'Junho'
		When 7 Then 'Julho'
		When 8 Then 'Agosto'
		When 9 Then 'Setembro'
		When 10 Then 'Outubro'
		When 11 Then 'Novembro'
		When 12 Then 'Dezembro'
	   End As MesPorExtenso,
	   DatePart(Q, DataCalendario) As Quartil,
	   Case 
	    When DatePart(Q, DataCalendario) = 1 And Month(DataCalendario) = 1 Then 1
		When DatePart(Q, DataCalendario) = 1 And Month(DataCalendario) = 2 Then 1
		When DatePart(Q, DataCalendario) = 1 And Month(DataCalendario) = 3 Then 1
		When DatePart(Q, DataCalendario) = 2 And Month(DataCalendario) = 4 Then 2
		When DatePart(Q, DataCalendario) = 2 And Month(DataCalendario) = 5 Then 2
		When DatePart(Q, DataCalendario) = 2 And Month(DataCalendario) = 6 Then 2
		When DatePart(Q, DataCalendario) = 3 And Month(DataCalendario) = 7 Then 3
		When DatePart(Q, DataCalendario) = 3 And Month(DataCalendario) = 8 Then 3
		When DatePart(Q, DataCalendario) = 3 And Month(DataCalendario) = 9 Then 3
		When DatePart(Q, DataCalendario) = 4 And Month(DataCalendario) = 10 Then 4
		When DatePart(Q, DataCalendario) = 4 And Month(DataCalendario) = 11 Then 4
		When DatePart(Q, DataCalendario) = 4 And Month(DataCalendario) = 12 Then 4
	   End As MesQuartil,
	   Case DatePart(Q, DataCalendario)
	    When 1 Then 'Primeiro Quartil'
		When 2 Then 'Segundo Quartil'
		When 3 Then 'Terceiro Quartil'
		When 4 Then 'Quarto Quartil'
	   End As QuartilPorExtenso,
	   DatePart(Year,DataCalendario) As Ano,
	   'Dois mil e Vinte e Dois' As AnoPorExtenso,
	   Convert(Date, DataCalendario) As Data,
	   Convert(Time, DataCalendario,114) As HoraAtual,
	   DataCalendario As DataAtual,
	   Datepart(HOUR, DataCalendario) As Horas,
	   Datepart(MINUTE, DataCalendario) As Minutos,
	   Datepart(MINUTE, DataCalendario) As Segundos,
	   Case 
	    When Day(DataCalendario) = 01 And Month(DataCalendario)=01 Then 'Feriado'
		When Day(DataCalendario) = 21 And Month(DataCalendario)=04 Then 'Feriado'
		When Day(DataCalendario) = 01 And Month(DataCalendario)=05 Then 'Feriado'
		When Day(DataCalendario) = 07 And Month(DataCalendario)=09 Then 'Feriado'
		When Day(DataCalendario) = 12 And Month(DataCalendario)=10 Then 'Feriado'
		When Day(DataCalendario) = 02 And Month(DataCalendario)=11 Then 'Feriado'
		When Day(DataCalendario) = 15 And Month(DataCalendario)=11 Then 'Feriado'
		When Day(DataCalendario) = 25 And Month(DataCalendario)=12 Then 'Feriado'
	   Else 'Não é feriado'
	   End As FeriadoPorExtenso
From Tab.TabFonteDeDados
Go
