Add-Type -AssemblyName System.Windows.Forms

# Sélection manuelle du dossier oradata
function Select-OradataFolder {
    $FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $FolderBrowser.Description = "Sélectionnez le dossier contenant oradata"
    if ($FolderBrowser.ShowDialog() -eq "OK") {
        return $FolderBrowser.SelectedPath
    } else {
        return $null
    }
}

Write-Host "Ouverture de la boîte de dialogue pour sélectionner le dossier oradata..."
$OradataLocation = Select-OradataFolder

if (-not $OradataLocation) {
    Write-Host "Aucun dossier sélectionné. Annulation du script."
    exit 1
}

Write-Host "Dossier oradata sélectionné : $OradataLocation"

# Vérifier "FREE" ou "XE"
Write-Host "Recherche de 'FREE' ou 'XE' dans : $OradataLocation"
$SubFolders = Get-ChildItem -Path $OradataLocation -Directory | Where-Object { $_.Name -match "FREE|XE" }
if ($SubFolders) {
    $OracleInstancePath = Join-Path $OradataLocation $SubFolders[0].Name
    Write-Host "Instance Oracle détectée : $OracleInstancePath"
} else {
    Write-Host "Aucun dossier 'FREE' ou 'XE' trouvé dans '$OradataLocation'."
    exit 1
}

# Création des dossiers CERGY / PAU si besoin
Write-Host "Vérification des dossiers PAU et CERGY..."
$RequiredDirs = @("PAU", "CERGY")
foreach ($Dir in $RequiredDirs) {
    $FullPath = Join-Path $OracleInstancePath $Dir
    if (-not (Test-Path -Path $FullPath)) {
        New-Item -Path $FullPath -ItemType Directory -Force | Out-Null
        Write-Host "Dossier créé : $FullPath"
    } else {
        Write-Host "Dossier déjà existant : $FullPath"
    }
}


# Dossier courant
$ScriptDir = if ($psISE) {
    Split-Path -Path $psISE.CurrentFile.FullPath
} else {
    if ($global:PSScriptRoot.Length -gt 0) {
        $global:PSScriptRoot
    } else {
        $global:pwd.Path
    }
}
Write-Host "Dossier courant du script : $ScriptDir"

# Fichiers pour 1.sql
$FileList1 = @(
    "DROP.sql",
    "SETUP.sql",
    "CERGY\Creation_tables_CERGY.sql",
    "CERGY\Creation_index_CERGY.sql",
    "CERGY\Creation_sequences_CERGY.sql",
    "CERGY\Creation_fonctions_procedures_CERGY.sql",
    "CERGY\Creation_triggers_CERGY.sql",
    "CERGY\Creation_utilisateurs_CERGY.sql"
)

# Fichiers pour 2.sql
$FileList2 = @(
    "CERGY\Creation_vues_Cergy.sql"
)

# Fichiers pour 3.sql
$FileList3 = @(
    "PAU\Creation_tables_PAU.sql",
    "PAU\Creation_index_PAU.sql",
    "PAU\Creation_sequences_PAU.sql",
    "PAU\Creation_fonctions_procedures_PAU.sql",
    "PAU\Creation_triggers_PAU.sql",
    "PAU\Creation_utilisateurs_PAU.sql"
)

# Fichiers pour 4.sql
$FileList4 = @(
    "PAU\Creation_vues_PAU.sql",
    "fusion_tickets.sql"
)

# Fonction pour générer un fichier .sql complet
function Generate-SqlFile {
    param(
        [string]$OutputFile,
        [hashtable]$Credentials,
        [string[]]$SourceFiles
    )

    Write-Host "Génération du fichier : $OutputFile"
    Write-Host "Utilisateur : $($Credentials.Username), Service : $($Credentials.Service)"


    Set-Content -Path $OutputFile -Value "SET SERVEROUTPUT ON;"

    # Inclure chaque script
    foreach ($f in $SourceFiles) {
        $FullPath = Join-Path $ScriptDir $f
        Write-Host "  - Inclusion du fichier : $f"
        if (Test-Path $FullPath) {
            Add-Content -Path $OutputFile -Value ("PROMPT *** Début exécution de $f ***")
            Add-Content -Path $OutputFile -Value ("-- " + $f)
            Add-Content -Path $OutputFile -Value ("@" + '"' + $FullPath + '"' + ";")
            Add-Content -Path $OutputFile -Value ("PROMPT *** Fin exécution de $f ***")
        } else {
            Add-Content -Path $OutputFile -Value ("-- Fichier introuvable : " + $f)
            Write-Host "     (Attention : $f introuvable)"
        }
    }

}

# Génération des 4 fichiers
$SqlFile1 = Join-Path $ScriptDir "1.sql"
$SqlFile2 = Join-Path $ScriptDir "2.sql"
$SqlFile3 = Join-Path $ScriptDir "3.sql"
$SqlFile4 = Join-Path $ScriptDir "4.sql"

Generate-SqlFile -OutputFile $SqlFile1 -Credentials $Cred_SYSTEM -SourceFiles $FileList1
Generate-SqlFile -OutputFile $SqlFile2 -Credentials $Cred_CERGY -SourceFiles $FileList2
Generate-SqlFile -OutputFile $SqlFile3 -Credentials $Cred_SYSTEM -SourceFiles $FileList3
Generate-SqlFile -OutputFile $SqlFile4 -Credentials $Cred_PAU    -SourceFiles $FileList4

Write-Host "Fichiers 1.sql, 2.sql, 3.sql, 4.sql générés avec succès."
