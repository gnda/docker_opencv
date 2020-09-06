# OpenCV avec Docker

Ce guide n'est pas exhaustif, pour plus d'informations veuillez consulter les liens suivants :
- [Docker Desktop Documentation](https://docs.docker.com/desktop/)
- [How to use GUI Apps in Linux Docker container from Windows host](https://medium.com/@potatowagon/how-to-use-gui-apps-in-linux-docker-container-from-windows-host-485d3e1c64a3)
- [Docker in WSL2](https://code.visualstudio.com/blogs/2020/03/02/docker-in-wsl2)
- [A Practical Guide to Choosing between Docker Containers and VMs](https://www.weave.works/blog/a-practical-guide-to-choosing-between-docker-containers-and-vms)

# Objectifs

- Fournir un même environnement de développement contenant OpenCV pour tout le monde, quelle que soit la machine hôte.
- Fournir quelque chose de plus léger à transmettre qu'une image pour machine virtuelle.

# Installation

Se référer à la [doc officielle](https://docs.docker.com/get-docker/) de Docker pour l'installation sur Windows 10 / MacOS / Linux.

## Linux

Docker étant fait à la base pour Linux, il n'y a pas à installer Docker Desktop.\
Il faut toutefois installer [docker](https://docs.docker.com/engine/install/) et [docker-compose](https://docs.docker.com/compose/install/) (l'installation de docker dépend de votre distribution).

## Windows 10


### WSL2 (Recommandé)

Si vous souhaitez avoir une distribution Linux sous Windows, c'est possible et cela marche mieux depuis l'arrivée de WSL2 (Windows Subsystem for Linux), depuis fin 2019. Ici nous allons installer Debian sous Windows 10.

WSL2 permet également une meilleure intégration de Docker Desktop sur Windows 10, avec l'usage d'un noyau Linux et une traduction des appels systèmes entre Windows et le noyau Linux.

Avant de poursuivre, un bug est présent sur WSL2 avec Docker Desktop. **Il se peut que toute votre mémoire soit utilisée par WSL2.**\
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

Ensuite, installer Debian à partir du Windows store [en suivant ce lien](https://www.microsoft.com/store/productId/9MSVKQC78PK6).

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

Pour accéder aux dossier de Debian depuis windows, aller dans "Ce PC" puis faire un clic droit et choisir "Ajouter un lecteur réseau".\
Le chemin à renseigner sera "\\\wsl$\Debian". Une fois cela fait, le lecteur réseau Debian devrait apparaître :

<img alt="network_drive" src="https://user-images.githubusercontent.com/32570153/92321283-fa7bd900-f028-11ea-86dc-1d84e1ea15f8.png" height="100" width="220">

Pour éviter de jongler avec plusieurs terminaux (bash Debian/Powershell/Invite de commandes...), vous pouvez installer Windows Terminal qui est [diponible sur le store](https://www.microsoft.com/fr-fr/p/windows-terminal/9n0dx20hk701) également.

### Docker Desktop

Télécharger et installer [Docker Desktop](https://www.docker.com/products/docker-desktop) pour Windows.

Lancez Docker Desktop si ce n'est pas déjà fait, puis dans une fenêtre Powershell, entrez :
```
docker -v
```

Si la commande est reconnue vous pouvez continuer.

### VCXSRV

Pour avoir accès à une interface graphique il faut installer VCXSRV, que vous pouvez obtenir sur [Sourceforge](https://sourceforge.net/projects/vcxsrv/).\
Vous pourrez ensuite lancer XLaunch (cliquez sur suivant à chaque fois...).

Une fois que XLaunch est lancé, vous pouvez lancer vos applications utilisant OpenCV (voir la section [Usage](#usage)).

# Configuration

Il faut lancer au moins une fois docker pour construire l'image contenant OpenCV.\
Récupérez d'abord le contenu de ce dépôt dans le répertoire de votre choix :

```
git clone https://github.com/gnda/docker_opencv
```

Dans le répertoire docker_opencv, exécutez la commande suivante :

**Pour Linux :**

```
docker-compose up -d --build
```

**Pour Windows 10 :**

```
docker-compose -f docker-compose.win.yml up -d --build
```

**La création de l'image et la compilation d'OpenCV prendra du temps**.\
**Les erreurs qui apparaîssent en rouge ne sont normalement que des warnings de compilation, rien de gênant.**

# Usage

Une fois l'installation effectuée, votre répertoire de travail sera le dossier workspace qui se trouve dans le dossier docker_opencv.\
Il faudra placer vos sources dans le dossier workspace/src.

Pour accéder au container OpenCV, entrez la commande suivante :

**Pour Linux :**

```
docker-compose run --rm opencv bash
```

**Pour Windows 10 :**

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