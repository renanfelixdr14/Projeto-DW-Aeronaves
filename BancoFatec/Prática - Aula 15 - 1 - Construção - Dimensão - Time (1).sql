-- Criando o Banco de Dados --
Create Database AnaliseDeDados
Go

-- Acessando --
Use AnaliseDeDados
Go

-- Alterando o Modelo de Recuperação do Banco de Dados para Bulk_Logged --
Alter Database AnaliseDeDados
Set Recovery Bulk_Logged
Go

-- Apresentando a Data Atual e Hora --
Select GetDate() As DataCalendarioAtual
Go

-- Definindo o Segunda-Feira primeiro dia da semana --
Set DateFirst 1
Go

-- Dimensionando com base no valor da data e hora os atributos relacionados ao assunto Data --
Select Day(GetDate()) As Dia,
       Datepart(DW, GetDate()) As DiaDaSemana,
	   Case Datepart(DW, GetDate())
	    When 1 Then 'Segunda-Feira'
		When 2 Then 'Terça-Feira'
		When 3 Then 'Quarta-Feira'
		When 4 Then 'Quinta-Feira'
		When 5 Then 'Sexta-Feira'
		When 6 Then 'Sábado'
		When 7 Then 'Domingo'
	   End As DiaDaSemanaPorExtenso,
	   Datepart(D, GetDate()) As DiaDoMes,
	   Datepart(DayOfYear, GetDate()) As DiaDoAno,
	   DatePart(Week, GetDate()) As Semana,
	   Datepart(Day, Datediff(day, 0, GetDate())/7 * 7)/7 + 1 As SemanaNoMes,
	   DatePart(Week, GetDate()) As SemanaNoAno,
	   Day(DateAdd(Week, Datediff(Week, 0, GetDate()), 0)) As PrimeiroDiaDaSemana,
	   Day(DateAdd(Week, Datediff(Week, 0, GetDate()), 7)) As UltimoDiaDaSemana,
	   Month(GetDate()) As Mes,
	   Case Month(GetDate()) 
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
	   Case 
	    When DatePart(Q, GetDate()) = 1 And Month(GetDate()) = 1 Then 1
		When DatePart(Q, GetDate()) = 1 And Month(GetDate()) = 2 Then 1
		When DatePart(Q, GetDate()) = 1 And Month(GetDate()) = 3 Then 1
		When DatePart(Q, GetDate()) = 2 And Month(GetDate()) = 4 Then 2
		When DatePart(Q, GetDate()) = 2 And Month(GetDate()) = 5 Then 2
		When DatePart(Q, GetDate()) = 2 And Month(GetDate()) = 6 Then 2
		When DatePart(Q, GetDate()) = 3 And Month(GetDate()) = 7 Then 3
		When DatePart(Q, GetDate()) = 3 And Month(GetDate()) = 8 Then 3
		When DatePart(Q, GetDate()) = 3 And Month(GetDate()) = 9 Then 3
		When DatePart(Q, GetDate()) = 4 And Month(GetDate()) = 10 Then 4
		When DatePart(Q, GetDate()) = 4 And Month(GetDate()) = 11 Then 4
		When DatePart(Q, GetDate()) = 4 And Month(GetDate()) = 12 Then 4
	   End As MesQuartil,
	   DatePart(Q, GetDate()) As Quartil,
	   Case DatePart(Q, GetDate())
	    When 1 Then 'Primeiro Quartil'
	    When 2 Then 'Segundo Quartil'
	    When 3 Then 'Terceiro Quartil'
	    When 4 Then 'Quarto Quartil'
	   End As QuartilPorExtenso,
	   DatePart(Year,GetDate()) As Ano,
	   'Dois mil e vinte e quatro' As AnoPorExtenso,
	   Convert(Date, GetDate()) As 'Data',
	   Convert(Time, GetDate(),114) As 'Hora Atual',
	   GetDate() As 'Data e Hora Atual',
	   Datepart(HOUR, GetDate()) As Horas,
	   Datepart(MINUTE, GetDate()) As Minuto,
	   Case 
	    When Day(GetDate()) = 01 And Month(GetDate())=01 Then 'Feriado'
		When Day(GetDate()) = 21 And Month(GetDate())=04 Then 'Feriado'
		When Day(GetDate()) = 01 And Month(GetDate())=05 Then 'Feriado'
		When Day(GetDate()) = 07 And Month(GetDate())=09 Then 'Feriado'
		When Day(GetDate()) = 12 And Month(GetDate())=10 Then 'Feriado'
		When Day(GetDate()) = 02 And Month(GetDate())=11 Then 'Feriado'
		When Day(GetDate()) = 15 And Month(GetDate())=11 Then 'Feriado'
		When Day(GetDate()) = 25 And Month(GetDate())=12 Then 'Feriado'
	    Else 'Não é feriado'
	   End As FeriadoPorExtenso
Go

-- Criando a Tabela Calendario --
Create Table Calendario
 (CodigoCalendario Int Identity(1,1) Primary Key Clustered,
  DataCalendario DateTime)
Go

-- Inserindo 10000 registros lógicos na Tabela Calendario --
Declare @Contador Int

Set @Contador=1

While @Contador <=10000
 Begin

  Insert Into Calendario Values (GetDate()+@Contador)

  Set @Contador = @Contador+1

 End
Go

-- Consultando --
Select CodigoCalendario, DataCalendario From Calendario
Go

-- Criando a Dimensão Tempo - DimTime --
Create Table DimTime
(TimeID Int Identity(1,1) Not Null,
 Dia TinyInt Not Null,
 DiaDaSemana TinyInt Not Null,
 DiaDaSemanaPorExtenso Varchar(15) Not Null,
 DiaDoMes TinyInt Not Null,
 DiaNoAno SmallInt Not Null,
 Semana TinyInt Not Null,
 SemanaNoMes TinyInt Not Null,
 SemanaNoAno TinyInt Not Null,
 PrimerioDiaDaSemana TinyInt Not Null,
 UltimoDiaDaSemana TinyInt Not Null,
 Mes TinyInt Not Null,
 MesPorExtenso Varchar(15) Not Null,
 Quartil TinyInt Not Null,
 MesQuartil TinyInt Not Null,
 QuartilPorExtenso Varchar(20) Not Null,
 Ano Int Not Null,
 AnoPorExtenso Varchar(40) Not Null,
 DataAtual Date Not Null,
 HoraAtual Time Not Null,
 DataHora DateTime Not Null,
 Horas TinyInt Not Null,
 Minutos TinyInt Not Null,
 Segundos TinyInt Not Null,
 FeriadoPorExtenso Varchar(15) Not Null
 Constraint [PK_DimTime_TimeID] Primary Key Clustered (TimeID))
Go

-- Populando as Datas com base na Tabela Calendario na DimTime --
Insert Into DimTime ([Dia], [DiaDaSemana], [DiaDaSemanaPorExtenso], [DiaDoMes], [DiaNoAno], [Semana], [SemanaNoMes], [SemanaNoAno], [PrimerioDiaDaSemana], [UltimoDiaDaSemana], [Mes], [MesPorExtenso], [Quartil], [MesQuartil], [QuartilPorExtenso], [Ano], [AnoPorExtenso], [DataAtual], [HoraAtual], [DataHora], [Horas], [Minutos], [Segundos], [FeriadoPorExtenso])
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
From Calendario
Go

-- Consultando 1000 registros lógicos da Dimensão DimTime --
Select Top 1000 * From DimTime
Go

-- Consultando 2000 registros lógicos da Dimensão DimTime de forma aleatória --
Select Top 2000 * From DimTime
Order By NewID()
Go

-- Consultando 2000 registros lógicos da Dimensão DimTime com base no ano --
Select Top 2000 * From DimTime
Where Ano In (2030, 2034, 2045, 2047, 2050)
Order By NewID()
Go

-- Destacar o armazenamento da coluna AnoPorExtenso, reforçando a necessidade de se implementar uma forma de escrever o ano --
Select Case 
        When SubString(Convert(Varchar(4),Ano),3,1)='2' Then 'Vinte e '
		When SubString(Convert(Varchar(4),Ano),3,1)='3' Then 'Trinta e '
		When SubString(Convert(Varchar(4),Ano),3,1)='4' Then 'Quarenta e '
		When SubString(Convert(Varchar(4),Ano),3,1)='5' Then 'Cinquenta e '
		When SubString(Convert(Varchar(4),Ano),3,1)='6' Then 'Sessenta e '
		When SubString(Convert(Varchar(4),Ano),3,1)='7' Then 'Setenta e '
		When SubString(Convert(Varchar(4),Ano),3,1)='8' Then 'Oitenta e '
		When SubString(Convert(Varchar(4),Ano),3,1)='9' Then 'Noventa e '
       End Dezena,
	   Case 
	    When SubString(Convert(Varchar(4),Ano),4,1)='1' Then 'Um'
        When SubString(Convert(Varchar(4),Ano),4,1)='2' Then 'Dois'
		When SubString(Convert(Varchar(4),Ano),4,1)='3' Then 'Três'
		When SubString(Convert(Varchar(4),Ano),4,1)='4' Then 'Quatro'
		When SubString(Convert(Varchar(4),Ano),4,1)='5' Then 'Cinco'
		When SubString(Convert(Varchar(4),Ano),4,1)='6' Then 'Seis'
		When SubString(Convert(Varchar(4),Ano),4,1)='7' Then 'Sete'
		When SubString(Convert(Varchar(4),Ano),4,1)='8' Then 'Oito'
		When SubString(Convert(Varchar(4),Ano),4,1)='9' Then 'Nove'
       End Unidade
From DimTime
Go
