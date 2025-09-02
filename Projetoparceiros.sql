
CREATE DATABASE ParceirosDB;
USE ParceirosDB;
GO


IF OBJECT_ID('dbo.Parceiros','U')IS NOT NULL
    DROP TABLE dbo.Parceiros;
    
GO

CREATE TABLE dbo.Parceiros (
    id INT IDENTITY (1,1) PRIMARY KEY, 
    Personalidade VARCHAR(20) NOT NULL, 
    RazaoSocial VARCHAR(200) NOT NULL, 
    CNPJ_CPF VARCHAR (20) NOT NULL, 
    CEP VARCHAR (9) NOT NULL, 
    UF CHAR (2) NOT NULL, 
    Municipio VARCHAR (100) NOT NULL, 
    Logradouro VARCHAR(200) NOT NULL,
    Numero VARCHAR (20) NOT NULL, 
    Bairro VARCHAR (100) NOT NULL,
    Email VARCHAR (150) NOT NULL, 
    Telefone VARCHAR (20) NOT NULL,
    Complemento VARCHAR (200) NULL, 
    Observacao VARCHAR (500) NULL, 
    DataCadastro DATETIME2 NOT NULL DEFAULT SYSDATETIME ()
);

GO 

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'UX_Parceiros_CnpjCpf' AND object_id = OBJECT_ID('dbo.Parceiros'))
  CREATE UNIQUE INDEX UX_Parceiros_CnpjCpf ON dbo.Parceiros(CNPJ_CPF);
GO


IF OBJECT_ID ('dbo.sp_inserir_parceiro', 'P') IS NOT NULL 
    DROP PROCEDURE dbo.sp_inserir_parceiro;
GO
 
 CREATE PROCEDURE dbo.sp_inserir_parceiro
    @Personalidade  NVARCHAR (20),
    @RazaoSocial NVARCHAR (200),
    @CNPJ_CPF NVARCHAR (20),
    @CEP NVARCHAR (9),
    @UF NVARCHAR (2),
    @Municipio NVARCHAR (100),
    @Logradouro NVARCHAR (200),
    @Numero NVARCHAR (20),
    @Bairro NVARCHAR (100),
    @Email NVARCHAR (150),
    @Telefone NVARCHAR (20),
    @Complemento NVARCHAR (100) = NULL, 
    @Observacao VARCHAR (MAX) 
   AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF EXISTS (SELECT 1 FROM Parceiros WHERE CNPJ_CPF = @CNPJ_CPF)
            THROW 50001, 'CNPJ/CPF já cadastrado.', 1;

        IF (@Personalidade NOT IN ('Física', 'Jurídica'))
            THROW 50002, 'Personalidade inválida.', 1;

        IF LEN(@UF) <> 2
            THROW 50003, 'UF inválida.', 1;

        INSERT INTO dbo.Parceiros
        (Personalidade, RazaoSocial, CNPJ_CPF, CEP, UF, Municipio, Logradouro, Numero, Bairro, Email, Telefone, Complemento, Observacao)
        VALUES 
        (@Personalidade, @RazaoSocial, @CNPJ_CPF, @CEP, @UF, @Municipio, @Logradouro, @Numero, @Bairro, @Email, @Telefone, @Complemento, @Observacao);

        SELECT CAST(SCOPE_IDENTITY() AS INT) AS NovoId, 'Parceiro cadastrado com sucesso' AS Mensagem;

    END TRY
    BEGIN CATCH
        DECLARE @ErrNum INT = ERROR_NUMBER();
        DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrMsg, 16, 1);
    END CATCH
END
GO 

