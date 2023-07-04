The name of the FileWave console is FileWave Admin, which identifies clients, software (filesets), and scoping associations between clients and filesets.
 
There are seven different types of scripts that can be used in a FileWave fileset:

<ins>__Requirements Scripts__</ins> – A requirements script checks the requirement on the Fileset before any dependencies are downloaded. If any requirement script fails (return non-zero), then the Fileset and its dependencies will not be downloaded nor installed.

<ins>__Preflight Scripts__</ins> – A preflight script checks the needs of the Fileset before the Fileset downloads, but after dependencies have been installed. If any preflight script fails (returns non-zero), then the Fileset won't be downloaded or installed.

<ins>__Activation Scripts__</ins> – An activation script is executed upon activation of the Fileset.

<ins>__Postflight Scripts__</ins> – A postflight script is executed after the installation of the Fileset has completed.

<ins>__Verification Scripts__</ins> – A verification script is executed after postflight scripts and upon every "verification of the Fileset."

<ins>__Pre-Uninstallation Scripts__</ins> – A pre-uninstallation script is executed on inactivation of a Fileset and right before a Fileset is uninstalled.

<ins>__Post-Uninstallation Scripts__</ins> – A post-uninstallation script is executed right after uninstalling/removing the Fileset from a client and its dependencies.

