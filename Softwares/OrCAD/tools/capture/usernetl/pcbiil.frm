VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.1#0"; "COMDLG32.OCX"
Begin VB.Form Form1 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Netlist Generation For PCB-II"
   ClientHeight    =   2415
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5925
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2415
   ScaleWidth      =   5925
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton CancelButton 
      Caption         =   "Cancel"
      Height          =   375
      Left            =   3720
      TabIndex        =   4
      Top             =   1800
      Width           =   1575
   End
   Begin MSComDlg.CommonDialog CommonDialog1 
      Left            =   5040
      Top             =   120
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   327680
      CancelError     =   -1  'True
      DialogTitle     =   "Output Netlist"
      FileName        =   "*.*"
      Filter          =   "All Files"
   End
   Begin VB.CommandButton BrowseButton 
      Caption         =   "Browse..."
      Height          =   375
      Left            =   3720
      TabIndex        =   2
      Top             =   600
      Width           =   975
   End
   Begin VB.TextBox Text1 
      Height          =   375
      Left            =   360
      TabIndex        =   1
      Top             =   600
      Width           =   3015
   End
   Begin VB.CommandButton MakeNetlist 
      Caption         =   "OK"
      Height          =   375
      Left            =   3720
      TabIndex        =   0
      Top             =   1200
      Width           =   975
   End
   Begin VB.Label Label1 
      Caption         =   "Output Filename:"
      Height          =   255
      Left            =   360
      TabIndex        =   3
      Top             =   240
      Width           =   2415
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Dim filenameout As String

Private Sub BrowseButton_Click()
    CommonDialog1.CancelError = True
    On Error GoTo Errhandler
    CommonDialog1.Flags = CommonDialog1.Flags Or cdlOFNOverwritePrompt
    CommonDialog1.ShowSave
    filenameout = CommonDialog1.FileName
    Text1.Text = filenameout
Errhandler:
    Exit Sub

End Sub

Private Sub CancelButton_Click()
    Unload Me
    End
End Sub

Private Sub MakeNetlist_Click()
    Dim result As Long
    filenameout = Text1.Text
    If filenameout <> "" Then
        Unload Me
        Call Main(filenameout, vbNullString)
        End
    End If
End Sub
