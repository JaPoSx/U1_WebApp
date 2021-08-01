USE [test_sx_pon]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Customers](
	[Email] [varchar](255) NOT NULL,

 CONSTRAINT [PK_Customers] PRIMARY KEY CLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


GO
INSERT [dbo].[Customers] ([Email]) VALUES (N'test@test.cz')
GO
INSERT [dbo].[Customers] ([Email]) VALUES (N'email@example.com')
GO
INSERT [dbo].[Customers] ([Email]) VALUES (N'email@example.name')
GO
INSERT [dbo].[Customers] ([Email]) VALUES (N'email@example-one.com')
GO
INSERT [dbo].[Customers] ([Email]) VALUES (N'firstname.lastname@example.com')
GO
INSERT [dbo].[Customers] ([Email]) VALUES (N'firstname+lastname@example.com')
GO
INSERT [dbo].[Customers] ([Email]) VALUES (N'firstname-lastname@example.museum')
GO
INSERT [dbo].[Customers] ([Email]) VALUES (N'email@subdomain.example.com')
GO
INSERT [dbo].[Customers] ([Email]) VALUES (N'"email"@example.com')
GO
INSERT [dbo].[Customers] ([Email]) VALUES (N'_______@example.com')
GO
INSERT [dbo].[Customers] ([Email]) VALUES (N'1234567890@example.com')
GO
INSERT [dbo].[Customers] ([Email]) VALUES (N'email@123.123.123.123')
GO
INSERT [dbo].[Customers] ([Email]) VALUES (N'email@[123.123.123.123]')
GO

