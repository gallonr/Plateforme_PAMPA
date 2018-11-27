; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "PAMPA Ressources & Biodiversit�"
#define MyAppVersion "2.8-beta3"
#define MyAppPublisher "Ifremer"
#define MyAppURL "https://github.com/yreecht/Plateforme_PAMPA/releases"
#define MyAppExeName "PAMPA WP2.bat"
#define InstallDir "C:\PAMPA"
#define ExecDir "Scripts_Biodiv"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{6F863544-2657-4C1C-8CB5-CD743B198932}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={reg:HKLM\Software\PAMPA WP2,Path|{#InstallDir}}\{#ExecDir}
DefaultGroupName={#MyAppName}
AllowNoIcons=yes
OutputDir=.
OutputBaseFilename=setup_PAMPA_Ressources-Biodiv-{#MyAppVersion}
LicenseFile=.\Scripts_Biodiv\LICENCE-GPL-3.0.fr.txt
;; InfoBeforeFile=.\modele_copyright.txt
; SetupIconFile=Y:\tmp\1284538187_bluefish-icon.ico
Compression=lzma
SolidCompression=yes
WizardImageFile=.\Img\pampa2L.bmp
WizardSmallImageFile=.\Img\pampa2.bmp

[Languages]
Name: "french"; MessagesFile: "compiler:Languages\French.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked; OnlyBelowVersion: 0,6.1

[Files]
Source: ".\Scripts_Biodiv\PAMPA WP2.bat"; DestDir: "{app}"; Flags: ignoreversion
Source: ".\Scripts_Biodiv\R.bat"; DestDir: "{app}"; Flags: ignoreversion
Source: ".\Scripts_Biodiv\img\*"; DestDir: "{app}\img"; Flags: ignoreversion
Source: ".\Scripts_Biodiv\Doc\*"; DestDir: "{app}\Doc"; Flags: ignoreversion
Source: ".\Scripts_Biodiv\Config.R"; DestDir: "{app}"; Flags: uninsneveruninstall
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

;; Scripts R :
Source: "Scripts_Biodiv\Generic_aggregations.R"; DestDir: "{app}"
Source: "Scripts_Biodiv\Arbres_regression_esp_generiques.R"; DestDir: "{app}"
Source: "Scripts_Biodiv\Arbres_regression_unitobs_generiques.R"; DestDir: "{app}"
Source: "Scripts_Biodiv\Barplots_occurrence.R"; DestDir: "{app}"
Source: "Scripts_Biodiv\Barplots_occurrence_unitobs.R"; DestDir: "{app}"
Source: "Scripts_Biodiv\Boxplots_esp_generiques.R"; DestDir: "{app}"
Source: "Scripts_Biodiv\Boxplots_unitobs_generiques.R"; DestDir: "{app}"
Source: "Scripts_Biodiv\Barplots_esp_generiques.R"; DestDir: "{app}"
Source: "Scripts_Biodiv\Barplots_unitobs_generiques.R"; DestDir: "{app}"
Source: "Scripts_Biodiv\Weight_calculation.R"; DestDir: "{app}"
Source: "Scripts_Biodiv\Calculate_metrics_tables.R"; DestDir: "{app}"
Source: "Scripts_Biodiv\Calculate_metrics_tables_LIT.R"; DestDir: "{app}"
Source: "Scripts_Biodiv\Calculate_metrics_tables_SVR.R"; DestDir: "{app}"
Source: "Scripts_Biodiv\Load_files.R"; DestDir: "{app}"
Source: "Scripts_Biodiv\Load_files_manually.R"; DestDir: "{app}"
Source: "Scripts_Biodiv\Load_OBSIND.R"; DestDir: "{app}"
Source: "Scripts_Biodiv\Load_shapefile.R"; DestDir: "{app}"
Source: "Scripts_Biodiv\Functions_base.R"; DestDir: "{app}"
Source: "Scripts_Biodiv\Fonctions_graphiques.R"; DestDir: "{app}"
Source: "Scripts_Biodiv\Messages_management.R"; DestDir: "{app}"
Source: "Scripts_Biodiv\Graphiques_carto.R"; DestDir: "{app}"
Source: "Scripts_Biodiv\Initialisation.R"; DestDir: "{app}"
Source: "Scripts_Biodiv\Interface_functions.R"; DestDir: "{app}"
Source: "Scripts_Biodiv\Interface_main.R"; DestDir: "{app}"
Source: "Scripts_Biodiv\Link_unitobs-refspa.R"; DestDir: "{app}"
Source: "Scripts_Biodiv\Load_packages.R"; DestDir: "{app}"
Source: "Scripts_Biodiv\Main.R"; DestDir: "{app}"
Source: "Scripts_Biodiv\Modeles_lineaires_esp_generiques.R"; DestDir: "{app}"
Source: "Scripts_Biodiv\Modeles_lineaires_interface.R"; DestDir: "{app}"
Source: "Scripts_Biodiv\Modeles_lineaires_unitobs_generiques.R"; DestDir: "{app}"
Source: "Scripts_Biodiv\Options.R"; DestDir: "{app}"
Source: "Scripts_Biodiv\Data_subsets.R"; DestDir: "{app}"
Source: "Scripts_Biodiv\Variables_selection_functions.R"; DestDir: "{app}"
Source: "Scripts_Biodiv\Variables_selection_interface.R"; DestDir: "{app}"
Source: "Scripts_Biodiv\Test_files.R"; DestDir: "{app}"
Source: "Scripts_Biodiv\Turtle_tracks.R"; DestDir: "{app}"
Source: "Scripts_Biodiv\Variables_carto.R"; DestDir: "{app}"
Source: "Scripts_Biodiv\View.R"; DestDir: "{app}"

;; Autres fichiers de la plateforme :
Source: "Scripts_Biodiv\corresp-cat-benth.csv"; DestDir: "{app}"
Source: "Scripts_Biodiv\NomsVariables_fr.csv"; DestDir: "{app}"
Source: "Scripts_Biodiv\NomsVariables_en.csv"; DestDir: "{app}"
Source: "Scripts_Biodiv\Rprofile.site"; DestDir: "{app}"

;; Fichiers de licence :
Source: "Scripts_Biodiv\LICENCE-GPL-2.fr.txt"; DestDir: "{app}"
Source: "Scripts_Biodiv\LICENCE-GPL-2.txt"; DestDir: "{app}"
Source: "Scripts_Biodiv\LICENCE-GPL-3.0.fr.txt"; DestDir: "{app}"
Source: "Scripts_Biodiv\LICENCE-GPL-3.0.txt"; DestDir: "{app}"

[Icons]
;; IconFilename: "{app}\img\Pampa.ico" pour d�finir l'icone d'un raccourci.
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; WorkingDir: {#InstallDir}; IconFilename: "{app}\img\Pampa.ico"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{app}\{uninstallexe}"
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon; WorkingDir: {#InstallDir}; IconFilename: "{app}\img\Pampa.ico"
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: quicklaunchicon; WorkingDir: {#InstallDir}; IconFilename: "{app}\img\Pampa.ico"

Name: "{group}\Documentation\Guide Utilisateur"; Filename: "{app}\Doc\Guide_plateforme_WP2_Meth4.pdf";
;; Name: "{group}\Documentation\Nouveaut�s de la plateforme PAMPA WP2"; Filename: "{app}\Doc\Annexe_GuideCalculsIndicateurs-WP2-Meth4-092010.pdf";
Name: "{group}\Cr�er un rapport de bug"; Filename: "{app}\Doc\Rapport_bug_PAMPA-WP2.dot";

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, "&", "&&")}}"; Flags: shellexec postinstall skipifsilent; WorkingDir: {#InstallDir}

[Dirs]
Name: "{#InstallDir}\Data"; Flags: uninsneveruninstall; Tasks: ; Languages:

[code]
// Sauvegarde de l'ancien config.r -> config.bak.R
procedure CurStepChanged(CurStep: TSetupStep);
var
  OldFile: string;
begin
  case CurStep of
    ssInstall:
      begin
        OldFile := ExpandConstant('{app}\Config.R');
        if FileExists(OldFile) then
          RenameFile(OldFile, ExpandConstant('{app}\Config.bak.R'));
      end;
  end;
end;
