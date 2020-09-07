<h1>OpenCV avec Docker</h1>

Ce guide n'est pas exhaustif, pour plus d'informations veuillez consulter les liens suivants :
- [Docker Desktop Documentation](https://docs.docker.com/desktop/)
- [How to use GUI Apps in Linux Docker container from Windows host](https://medium.com/@potatowagon/how-to-use-gui-apps-in-linux-docker-container-from-windows-host-485d3e1c64a3)
- [Docker in WSL2](https://code.visualstudio.com/blogs/2020/03/02/docker-in-wsl2)
- [A Practical Guide to Choosing between Docker Containers and VMs](https://www.weave.works/blog/a-practical-guide-to-choosing-between-docker-containers-and-vms)

**La partie macOS n'a pas été testée, il faudrait des retours pour savoir si cela fonctionne correctement.**

<h1>Sommaire</h1>

- [Objectifs](#objectifs)
- [Installation](#installation)
  * [Linux](#linux)
  * [macOS](#macos)
      - [XQuartz](#xquartz)
  * [Windows 10](#windows-10)
    + [Méthode 1 : Installer directement Docker Desktop](#win-method-1)
      - [VCXSRV](#vcxsrv)
    + [Méthode 2 : Installer WSL2 puis Docker Desktop](#win-method-2)
- [Configuration](#configuration)
- [Usage](#usage)
- [Problèmes](#issues)
  * [Windows 10](#issues-win)
      - [Problèmes avec WSL2](#issues-win-with-wsl2-docker)

# Objectifs

- Fournir un même environnement de développement contenant OpenCV pour tout le monde, quelle que soit la machine hôte.
- Fournir quelque chose de plus léger à transmettre qu'une image pour machine virtuelle.

# Installation

Se référer à la [doc officielle](https://docs.docker.com/get-docker/) de Docker pour l'installation sur Windows 10 / MacOS / Linux.

## Linux

Docker fonctionnant directement avec Linux, il n'y a pas à installer Docker Desktop.\
Il faut toutefois installer [docker](https://docs.docker.com/engine/install/) et [docker-compose](https://docs.docker.com/compose/install/) (l'installation de docker dépend de votre distribution).

## macOS

Télécharger et installer [Docker Desktop](https://www.docker.com/products/docker-desktop) pour macOS.

#### XQuartz

Pour avoir accès à une interface graphique il faut installer XQuartz, que vous pouvez trouver [ici](https://www.xquartz.org/).\
Il faudra ensuite vous reconnecter à votre session, puis lancer XQuartz.

Une fois que XQuartz est lancé, Aller dans les préférences.

<img alt="XQuartz_prefs" src="https://user-images.githubusercontent.com/32570153/92328691-df2dbf80-f062-11ea-9ff1-c805bbff19aa.png" width="330" height="100">

Vérifier dans l'onglet Sécurité que la case "Autoriser les connexions de clients réseau" soit cochée.

<img alt="XQuartz_security" src="https://user-images.githubusercontent.com/32570153/92328737-1a2ff300-f063-11ea-8aad-06071df5ca9c.png" width="577" height="362">

Vous pouvez passer à la section [Configuration](#configuration).

## Windows 10

<h3 id="win-method-1" >Méthode 1 : Installer directement Docker Desktop</h3>

Télécharger et installer [Docker Desktop](https://www.docker.com/products/docker-desktop) pour Windows.

Lancez Docker Desktop si ce n'est pas déjà fait, puis dans une fenêtre Powershell, entrez :
```
docker -v
```

Si la commande est reconnue vous pouvez continuer.

#### VCXSRV

Pour avoir accès à une interface graphique il faut installer VCXSRV, que vous pouvez obtenir sur [Sourceforge](https://sourceforge.net/projects/vcxsrv/).\
Vous pourrez ensuite lancer XLaunch (cliquez sur suivant à chaque fois...).

Une fois que XLaunch est lancé, vous pouvez passer à la section [Configuration](#configuration).

<h3 id="win-method-2" >Méthode 2 : Installer WSL2 puis Docker Desktop</h3>

Si vous souhaitez avoir une distribution Linux sous Windows, c'est possible et cela marche mieux depuis l'arrivée de WSL2 (Windows Subsystem for Linux), depuis fin 2019. Ici nous allons installer Debian sous Windows 10.

WSL2 permet également une meilleure intégration de Docker Desktop sur Windows 10, avec l'usage d'un noyau Linux et une traduction des appels systèmes entre Windows et le noyau Linux.

Cependant, WSL2 n'étant pas parfait, il se peut que vous rencontriez des problèmes avec Docker par la suite (voir la section [Problèmes avec WSL2 et Docker](#issues-win-with-wsl2-docker)).

D'ailleurs, avant de poursuivre, un bug est présent sur WSL2 avec Docker Desktop.\
**Il se peut que toute votre mémoire soit utilisée par WSL2.**

Pour résoudre cela il faut limiter la mémoire disponible pour WSL2.\
Tapez <kbd>Win</kbd> + <kbd>R</kbd> et entrez : ```%UserProfile%```. Créez ensuite un fichier .wslconfig comme ceci :

```
[wsl2]
memory=4GB
swap=4GB
localhostForwarding=true
```

Vous pouvez ajustez la mémoire et le swap comme vous le souhaitez.

Il est aussi préférable d'être sous la dernière version de Windows 10 (au moins la 2004) pour pouvoir se servir de WSL2 .\
Pour vérifier votre version de Windows faites <kbd>Win</kbd> + <kbd>R</kbd> et entrez : ```winver```

Si votre version est inférieure, vous pouvez mettre à jour Windows [en suivant ce lien](https://www.microsoft.com/fr-fr/software-download/windows10).

Dans une fenêtre Powershell, entrez la commande suivante :
```
Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform
```

Ensuite, installez Debian à partir du Windows store [en suivant ce lien](https://www.microsoft.com/store/productId/9MSVKQC78PK6).

Vous pouvez désormais accéder à Debian depuis le menu démarrer.\
Lancez Debian puis dans une fenêtre Powershell, entrez:
```
wsl --list --verbose
```
Vous pouvez procéder à l'installation de Docker Desktop si vous voyez :
```(bash)
  NAME           STATE           VERSION
* Debian         Running         2
```
Une fois Docker Desktop installé, il faut aller dans les paramètres et veiller à ce que l'intégration avec Debian soit activée :

<img alt="settings" src="https://user-images.githubusercontent.com/32570153/92321128-d7045e80-f027-11ea-8a24-72a254c9e8cc.png" width="850" height="570">

Cela permet d'appeler Docker Desktop directement depuis Debian, sans devoir l'installer via apt-get.
Vous pouvez tester docker dans Debian en tapant :
```
docker -v
````

Pour accéder aux dossier de Debian depuis Windows, aller dans "Ce PC" puis faire un clic droit dans la fenêtre et choisir "Ajouter un lecteur réseau".\
Le chemin à renseigner sera "\\\wsl$\Debian". Une fois cela fait, le lecteur réseau Debian devrait apparaître :

<img alt="network_drive" src="https://user-images.githubusercontent.com/32570153/92321283-fa7bd900-f028-11ea-86dc-1d84e1ea15f8.png" height="100" width="220">

Pensez aussi à installer VCXSRV, [comme décrit plus haut](#vcxsrv).

Pour éviter de jongler avec plusieurs terminaux (bash Debian/Powershell/Invite de commandes...), vous pouvez installer Windows Terminal qui est [disponible sur le store](https://www.microsoft.com/fr-fr/p/windows-terminal/9n0dx20hk701) également.

# Configuration

Il faut lancer au moins une fois docker pour construire l'image contenant OpenCV.\
Récupérez d'abord le contenu de ce dépôt dans le répertoire de votre choix :

```
git clone https://github.com/gnda/docker_opencv
```

Dans le répertoire docker_opencv, exécutez la commande suivante :

**Linux**

Pour autoriser les connexions à l'hôte, entrez dans un terminal la commande : 
```
xhost +local:docker
```

Pour créer l'image OpenCV :
```
docker-compose -f docker-compose.linux.yml up -d --build
```

**macOS**

Pour autoriser les connexions à l'hôte, entrez dans un terminal les commandes : 
```
xhost + ${hostname}
export HOSTNAME=`hostname`
```

Pour créer l'image OpenCV :
```
docker-compose -f docker-compose.mac.yml up -d --build
```

**Windows 10**

```
docker-compose -f docker-compose.win.yml up -d --build
```

**La création de l'image et la compilation d'OpenCV prendra du temps**.\
**Les erreurs qui apparaîssent en rouge ne sont normalement que des warnings de compilation, rien de gênant.**

# Usage

Une fois l'installation effectuée, votre répertoire de travail sera le dossier workspace qui se trouve dans le dossier docker_opencv.\
Il faudra placer vos sources dans le dossier workspace/src.

Pour accéder au container OpenCV, entrez la commande suivante :

**Linux**

Il faudra autoriser la connexion à l'hôte (voir plus haut).

Pour lancer le container OpenCV :
```
docker-compose -f docker-compose.linux.yml run --rm opencv bash
```

**macOS**

Il faudra autoriser la connexion à l'hôte (voir plus haut).

Pour lancer le container OpenCV :
```
docker-compose -f docker-compose.mac.yml run --rm opencv bash
```

**Windows 10**

```
docker-compose -f docker-compose.win.yml run --rm opencv bash
```

Un shell bash va s'ouvrir dans le chemin /workspace du container OpenCV.

Pour compiler vos sources, vous pouvez utiliser cmake-gui qui est déjà disponible dans l'image, en tapant: 
```
cmake-gui
```

Sinon vous pouvez le faire en utilisant la commande cmake directement.\
Pour compiler vos sources en release, il faudra entrer les commandes suivantes :

```
cd /workspace/build
cmake ../src/ -D OpenCV_DIR=/usr/local/opencv/release/
make
```

Pour compiler vos sources en debug, il faudra entrer les commandes suivantes :

```
cd /workspace/build
cmake ../src/ -D OpenCV_DIR=/usr/local/opencv/debug/
make
```

L'exécutable est nommé app et se trouve dans le répertoire /workspace/build, pour le lancer :

```
/workspace/build/app
```

Pour sortir du container OpenCV :
```
exit
```

<h1 id="issues" >Problèmes</h1>

<h2 id="issues-win" >Windows 10</h2>

<h3 id="issues-win-with-wsl2" >Problèmes avec WSL2 et Docker</h3>

Il arrive parfois que docker-compose vous affiche l'erreur suivante :

<img alt="docker_credentials_errors" src="https://user-images.githubusercontent.com/32570153/92377194-12745b00-f104-11ea-965e-fffe827119de.png" height="50" width="1100">

Pour corriger cela, faites :
```
rm ~/.docker/config.json
```

Puis relancez votre distribution en rouvrant le terminal (Debian dans notre cas).