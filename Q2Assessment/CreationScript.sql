IF  EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'VW_AllHouseholds', NULL,NULL))
EXEC sys.sp_dropextendedproperty @name=N'MS_DiagramPaneCount' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VW_AllHouseholds'
GO
IF  EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_DiagramPane2' , N'SCHEMA',N'dbo', N'VIEW',N'VW_AllHouseholds', NULL,NULL))
EXEC sys.sp_dropextendedproperty @name=N'MS_DiagramPane2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VW_AllHouseholds'
GO
IF  EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'VW_AllHouseholds', NULL,NULL))
EXEC sys.sp_dropextendedproperty @name=N'MS_DiagramPane1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VW_AllHouseholds'
GO
/****** Object:  StoredProcedure [dbo].[SP_GetHouseholdByID]    Script Date: 8/3/2021 6:27:54 pm ******/
DROP PROCEDURE IF EXISTS [dbo].[SP_GetHouseholdByID]
GO
/****** Object:  StoredProcedure [dbo].[SP_DeleteHousehold]    Script Date: 8/3/2021 6:27:54 pm ******/
DROP PROCEDURE IF EXISTS [dbo].[SP_DeleteHousehold]
GO
/****** Object:  StoredProcedure [dbo].[SP_DeleteFamilyMember]    Script Date: 8/3/2021 6:27:54 pm ******/
DROP PROCEDURE IF EXISTS [dbo].[SP_DeleteFamilyMember]
GO
/****** Object:  StoredProcedure [dbo].[SP_CreateHousehold]    Script Date: 8/3/2021 6:27:54 pm ******/
DROP PROCEDURE IF EXISTS [dbo].[SP_CreateHousehold]
GO
/****** Object:  StoredProcedure [dbo].[SP_AddFamilyMemberToHousehold]    Script Date: 8/3/2021 6:27:54 pm ******/
DROP PROCEDURE IF EXISTS [dbo].[SP_AddFamilyMemberToHousehold]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Household]') AND type in (N'U'))
ALTER TABLE [dbo].[Household] DROP CONSTRAINT IF EXISTS [FK_Household_HousingType]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FamilyMember]') AND type in (N'U'))
ALTER TABLE [dbo].[FamilyMember] DROP CONSTRAINT IF EXISTS [FK_FamilyMember_Spouse]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FamilyMember]') AND type in (N'U'))
ALTER TABLE [dbo].[FamilyMember] DROP CONSTRAINT IF EXISTS [FK_FamilyMember_OccupationType]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FamilyMember]') AND type in (N'U'))
ALTER TABLE [dbo].[FamilyMember] DROP CONSTRAINT IF EXISTS [FK_FamilyMember_MaritalStatus]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FamilyMember]') AND type in (N'U'))
ALTER TABLE [dbo].[FamilyMember] DROP CONSTRAINT IF EXISTS [FK_FamilyMember_Household]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FamilyMember]') AND type in (N'U'))
ALTER TABLE [dbo].[FamilyMember] DROP CONSTRAINT IF EXISTS [FK_FamilyMember_Gender]
GO
/****** Object:  View [dbo].[VW_AllHouseholds]    Script Date: 8/3/2021 6:27:54 pm ******/
DROP VIEW IF EXISTS [dbo].[VW_AllHouseholds]
GO
/****** Object:  Table [dbo].[FamilyMember]    Script Date: 8/3/2021 6:27:54 pm ******/
DROP TABLE IF EXISTS [dbo].[FamilyMember]
GO
/****** Object:  Table [dbo].[Gender]    Script Date: 8/3/2021 6:27:54 pm ******/
DROP TABLE IF EXISTS [dbo].[Gender]
GO
/****** Object:  Table [dbo].[MaritalStatus]    Script Date: 8/3/2021 6:27:54 pm ******/
DROP TABLE IF EXISTS [dbo].[MaritalStatus]
GO
/****** Object:  Table [dbo].[OccupationType]    Script Date: 8/3/2021 6:27:54 pm ******/
DROP TABLE IF EXISTS [dbo].[OccupationType]
GO
/****** Object:  Table [dbo].[HousingType]    Script Date: 8/3/2021 6:27:54 pm ******/
DROP TABLE IF EXISTS [dbo].[HousingType]
GO
/****** Object:  Table [dbo].[Household]    Script Date: 8/3/2021 6:27:54 pm ******/
DROP TABLE IF EXISTS [dbo].[Household]
GO
/****** Object:  Table [dbo].[Household]    Script Date: 8/3/2021 6:27:54 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Household](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[HousingTypeID] [int] NULL,
 CONSTRAINT [PK_Household] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HousingType]    Script Date: 8/3/2021 6:27:54 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HousingType](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_HousingType] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OccupationType]    Script Date: 8/3/2021 6:27:54 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OccupationType](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_OccupationName] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MaritalStatus]    Script Date: 8/3/2021 6:27:54 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MaritalStatus](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_MaritalStatus] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Gender]    Script Date: 8/3/2021 6:27:54 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Gender](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Genderr] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FamilyMember]    Script Date: 8/3/2021 6:27:54 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FamilyMember](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](250) NOT NULL,
	[HouseholdID] [int] NOT NULL,
	[GenderID] [int] NOT NULL,
	[MaritalStatusID] [int] NOT NULL,
	[SpouseID] [int] NULL,
	[OccupationTypeID] [int] NOT NULL,
	[AnnualIncome] [decimal](19, 4) NOT NULL,
	[DateOfBirth] [date] NOT NULL,
 CONSTRAINT [PK_FamilyMember] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[VW_AllHouseholds]    Script Date: 8/3/2021 6:27:54 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_AllHouseholds]
AS
SELECT        TOP (100) PERCENT dbo.Household.ID, dbo.HousingType.Description AS [Housing Type], FamilyMember.ID AS [Member ID], FamilyMember.Name, FamilyMember.AnnualIncome AS [Annual Income], 
                         FamilyMember.DateOfBirth AS [Date of Birth], dbo.Gender.Description AS Gender, dbo.MaritalStatus.Description AS [Marital Status], dbo.OccupationType.Description AS [Occupation Type],
                             (SELECT        Name
                               FROM            dbo.FamilyMember AS child
                               WHERE        (ID = FamilyMember.SpouseID)) AS [Spouse Name]
FROM            dbo.Gender INNER JOIN
                         dbo.FamilyMember AS FamilyMember ON dbo.Gender.ID = FamilyMember.GenderID INNER JOIN
                         dbo.MaritalStatus ON FamilyMember.MaritalStatusID = dbo.MaritalStatus.ID INNER JOIN
                         dbo.OccupationType ON FamilyMember.OccupationTypeID = dbo.OccupationType.ID RIGHT OUTER JOIN
                         dbo.Household ON FamilyMember.HouseholdID = dbo.Household.ID INNER JOIN
                         dbo.HousingType ON dbo.Household.HousingTypeID = dbo.HousingType.ID
ORDER BY dbo.Household.ID
GO
ALTER TABLE [dbo].[FamilyMember]  WITH NOCHECK ADD  CONSTRAINT [FK_FamilyMember_Gender] FOREIGN KEY([GenderID])
REFERENCES [dbo].[Gender] ([ID])
GO
ALTER TABLE [dbo].[FamilyMember] NOCHECK CONSTRAINT [FK_FamilyMember_Gender]
GO
ALTER TABLE [dbo].[FamilyMember]  WITH CHECK ADD  CONSTRAINT [FK_FamilyMember_Household] FOREIGN KEY([HouseholdID])
REFERENCES [dbo].[Household] ([ID])
GO
ALTER TABLE [dbo].[FamilyMember] CHECK CONSTRAINT [FK_FamilyMember_Household]
GO
ALTER TABLE [dbo].[FamilyMember]  WITH CHECK ADD  CONSTRAINT [FK_FamilyMember_MaritalStatus] FOREIGN KEY([MaritalStatusID])
REFERENCES [dbo].[MaritalStatus] ([ID])
GO
ALTER TABLE [dbo].[FamilyMember] CHECK CONSTRAINT [FK_FamilyMember_MaritalStatus]
GO
ALTER TABLE [dbo].[FamilyMember]  WITH CHECK ADD  CONSTRAINT [FK_FamilyMember_OccupationType] FOREIGN KEY([OccupationTypeID])
REFERENCES [dbo].[OccupationType] ([ID])
GO
ALTER TABLE [dbo].[FamilyMember] CHECK CONSTRAINT [FK_FamilyMember_OccupationType]
GO
ALTER TABLE [dbo].[FamilyMember]  WITH CHECK ADD  CONSTRAINT [FK_FamilyMember_Spouse] FOREIGN KEY([SpouseID])
REFERENCES [dbo].[FamilyMember] ([ID])
GO
ALTER TABLE [dbo].[FamilyMember] CHECK CONSTRAINT [FK_FamilyMember_Spouse]
GO
ALTER TABLE [dbo].[Household]  WITH CHECK ADD  CONSTRAINT [FK_Household_HousingType] FOREIGN KEY([HousingTypeID])
REFERENCES [dbo].[HousingType] ([ID])
GO
ALTER TABLE [dbo].[Household] CHECK CONSTRAINT [FK_Household_HousingType]
GO
/****** Object:  StoredProcedure [dbo].[SP_AddFamilyMemberToHousehold]    Script Date: 8/3/2021 6:27:54 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_AddFamilyMemberToHousehold]
	@HouseholdID int,
	@Name nvarchar(250),
	@Gender nvarchar(50),
	@MaritalStatus nvarchar(50),
	@SpouseName nvarchar(250),
	@OccupationType nvarchar(50),
	@AnnualIncome decimal(19,4),
	@DateOfBirth date,
	@CreatedID int = 0 OUTPUT, 
	@Message nvarchar(50) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @GenderID int
	DECLARE @MaritalStatusID int
	DECLARE @SpouseID int
	DECLARE @OccupationTypeID int
	-- check household already exists
	IF NOT EXISTS
		(SELECT 1 FROM dbo.Household WHERE ID = @HouseholdID)
	BEGIN
		SET @CreatedID = 0
		SET @Message = 'Household does not exist'
		RETURN
	END

	-- Check if Gender ID is valid
	SELECT @GenderID = ID FROM dbo.Gender WHERE Description = @Gender
	IF @GenderID IS NULL
	BEGIN
		SET @CreatedID = 0
		SET @Message = 'Gender does not exist'
		RETURN
	END

	-- Check is Marital Status is valid
	SELECT @MaritalStatusID = ID FROM dbo.MaritalStatus WHERE Description = @MaritalStatus
	IF @MaritalStatusID IS NULL
	BEGIN
		SET @CreatedID = 0
		SET @Message = 'Marital status does not exist'
		RETURN
	END

	-- Check is Occupation Type is valid
	SELECT @OccupationTypeID = ID FROM dbo.OccupationType WHERE Description = @OccupationType
	IF @OccupationTypeID IS NULL
	BEGIN
		SET @CreatedID = 0
		SET @Message = 'Occupation Type does not exist'
		RETURN
	END

	-- Check if Spouse already exists in the family member table within the household
	IF @SpouseName <> ''
	BEGIN
	SELECT @SpouseID = ID FROM dbo.FamilyMember WHERE Name = @SpouseName AND HouseholdID = @HouseholdID
		IF @SpouseID IS NULL
		BEGIN
		
			SET @CreatedID = 0
			SET @Message = 'Spouse does not exist as a family member yet'
			RETURN
		
		END
	END
	-- All validations checks out. 
	-- Insert into Table
	BEGIN TRY
		INSERT INTO dbo.FamilyMember
		(
			HouseholdID,
			Name,
			GenderID,
			MaritalStatusID,
			SpouseID,
			OccupationTypeID,
			AnnualIncome,
			DateOfBirth
		)
		VALUES
		(
			@HouseholdID,
			@Name,
			@GenderID,
			@MaritalStatusID,
			@SpouseID,
			@OccupationTypeID,
			@AnnualIncome,
			@DateOfBirth
		)

		SET @CreatedID = SCOPE_IDENTITY()
		SET @Message = 'Family Member added successfully'

		-- Additional
		-- Update Spouse record to indicate married couple
		IF @SpouseID IS NOT NULL
		BEGIN
			UPDATE FamilyMember
			SET MaritalStatusID = (SELECT ID FROM MaritalStatus WHERE Description = 'Married'),
			SpouseID = @CreatedID
			WHERE ID = @SpouseID
		END

	END TRY
	BEGIN CATCH
		SET @CreatedID = 0
		SET @Message = ERROR_MESSAGE()
	END CATCH

END
GO
/****** Object:  StoredProcedure [dbo].[SP_CreateHousehold]    Script Date: 8/3/2021 6:27:54 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_CreateHousehold]
	@HousingType nvarchar(50),
	@CreatedID int OUTPUT,
	@Message nvarchar(50) OUTPUT
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @HousingTypeID int
    -- make sure housing type id exists
	SELECT @HousingTypeID = ID FROM dbo.HousingType WHERE HousingType.Description = @HousingType

	IF @HousingTypeID IS NOT NULL
		BEGIN
			INSERT INTO dbo.Household (HousingTypeID) VALUES (@HousingTypeID)
			SET @CreatedID =  SCOPE_IDENTITY()
			SET @Message = 'Household created successfully'
		END
	ELSE
		BEGIN
			SET @CreatedID = 0
			SET @Message = 'Housing Type does not exist'
		END
	
END
GO
/****** Object:  StoredProcedure [dbo].[SP_DeleteFamilyMember]    Script Date: 8/3/2021 6:27:54 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_DeleteFamilyMember]
	@MemberID int,
	@CreatedID int OUTPUT,
	@Message nvarchar(50) OUTPUT

AS
BEGIN
	
	SET NOCOUNT ON;

	BEGIN TRY
		BEGIN TRANSACTION
		
		-- check if this record has a spouse 
		DECLARE @SpouseID int
		SELECT @SpouseID = SpouseID
		FROM FamilyMember
		WHERE ID = @MemberID

		-- remove the reference from the corresponsding spouse
		IF (@SpouseID IS NOT NULL)
		BEGIN
			UPDATE FamilyMember
			SET SpouseID = NULL
			WHERE ID = @SpouseID
		END

		DELETE FROM FamilyMember
		WHERE ID = @MemberID


		SET @Message = 'Family Member deleted successfully'
		SET @CreatedID = @MemberID

		COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION
		SET @CreatedID = 0
		SET @Message = ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[SP_DeleteHousehold]    Script Date: 8/3/2021 6:27:54 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_DeleteHousehold]
	@HouseholdID int,
	@CreatedID int OUTPUT,
	@Message nvarchar(50) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		
		BEGIN TRANSACTION
			-- Delete all existing Family Members first
			DELETE FROM FamilyMember
			WHERE HouseholdID = @HouseholdID
		
			-- Delete Household
			DELETE FROM Household
			WHERE ID = @HouseholdID

			SET @Message = 'Household deleted successfully'
			SET @CreatedID = @HouseholdID

		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		SET @Message = ERROR_MESSAGE();
		SET @CreatedID = 0
	END  CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[SP_GetHouseholdByID]    Script Date: 8/3/2021 6:27:54 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_GetHouseholdByID] 
	-- Add the parameters for the stored procedure here
	@HouseholdID int
AS
BEGIN
	SET NOCOUNT ON;

    SELECT 
		vh.ID, vh.[Housing Type],vh.[Member ID], vh.Name, vh.Gender, vh.[Occupation Type], vh.[Marital Status], vh.[Spouse Name], vh.[Annual Income], vh.[Date Of Birth]
	From VW_AllHouseholds vh
		WHERE vh.ID = @HouseholdID
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Gender"
            Begin Extent = 
               Top = 6
               Left = 713
               Bottom = 102
               Right = 883
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "FamilyMember"
            Begin Extent = 
               Top = 6
               Left = 488
               Bottom = 136
               Right = 675
            End
            DisplayFlags = 280
            TopColumn = 5
         End
         Begin Table = "MaritalStatus"
            Begin Extent = 
               Top = 6
               Left = 921
               Bottom = 102
               Right = 1091
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "OccupationType"
            Begin Extent = 
               Top = 6
               Left = 1129
               Bottom = 102
               Right = 1299
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Household"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 135
               Right = 242
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "HousingType"
            Begin Extent = 
               Top = 6
               Left = 280
               Bottom = 102
               Right = 450
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VW_AllHouseholds'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'105
         Alias = 900
         Table = 2880
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VW_AllHouseholds'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VW_AllHouseholds'
GO
--==========================================================================================================================================================
-- Insert Master Data
SET IDENTITY_INSERT [dbo].[Gender] ON 

INSERT [dbo].[Gender] ([ID], [Description]) VALUES (1, N'Male')
INSERT [dbo].[Gender] ([ID], [Description]) VALUES (2, N'Female')
INSERT [dbo].[Gender] ([ID], [Description]) VALUES (3, N'Other')
SET IDENTITY_INSERT [dbo].[Gender] OFF
GO
SET IDENTITY_INSERT [dbo].[HousingType] ON 

INSERT [dbo].[HousingType] ([ID], [Description]) VALUES (1, N'Landed')
INSERT [dbo].[HousingType] ([ID], [Description]) VALUES (2, N'Condominium')
INSERT [dbo].[HousingType] ([ID], [Description]) VALUES (3, N'HDB')
SET IDENTITY_INSERT [dbo].[HousingType] OFF
GO
SET IDENTITY_INSERT [dbo].[MaritalStatus] ON 

INSERT [dbo].[MaritalStatus] ([ID], [Description]) VALUES (1, N'Single')
INSERT [dbo].[MaritalStatus] ([ID], [Description]) VALUES (2, N'Married')
INSERT [dbo].[MaritalStatus] ([ID], [Description]) VALUES (3, N'Divorced')
INSERT [dbo].[MaritalStatus] ([ID], [Description]) VALUES (4, N'Widowed')
SET IDENTITY_INSERT [dbo].[MaritalStatus] OFF
GO
SET IDENTITY_INSERT [dbo].[OccupationType] ON 

INSERT [dbo].[OccupationType] ([ID], [Description]) VALUES (1, N'Unemployed')
INSERT [dbo].[OccupationType] ([ID], [Description]) VALUES (2, N'Student')
INSERT [dbo].[OccupationType] ([ID], [Description]) VALUES (3, N'Employed')
SET IDENTITY_INSERT [dbo].[OccupationType] OFF
GO