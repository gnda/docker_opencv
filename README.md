# OpenCV avec Docker

Ce guide n'est pas exhaustif, pour plus d'informations veuillez consulter les liens suivants :
- [Docker Desktop Documentation](https://docs.docker.com/desktop/)
- [How to use GUI Apps in Linux Docker container from Windows host](https://medium.com/@potatowagon/how-to-use-gui-apps-in-linux-docker-container-from-windows-host-485d3e1c64a3)
- [Docker in WSL2](https://code.visualstudio.com/blogs/2020/03/02/docker-in-wsl2)
- [A Practical Guide to Choosing between Docker Containers and VMs](https://www.weave.works/blog/a-practical-guide-to-choosing-between-docker-containers-and-vms)

Support des systèmes d'exploitation suivants :

- [x] Windows 10
- [ ] macOS
- [ ] Linux

# Objectifs

- Fournir un même enivonnement de développement contenant OpenCV pour tout le monde, quel que soit la machine hôte.
- Fournir quelque chose de plus léger à transmettre qu'une image pour machine virtuelle.

# Installation

## Windows 10

### Docker Desktop

Il est préférable d'être sous la dernière version de Windows 10 (2004) pour pouvoir se servir de WSL2 (Windows Subsystem for Linux).\
Pour vérifier votre version de Windows faites <kbd>Win</kbd> + <kbd>R</kbd> et entrez :
```
winver
```
Télécharger et installer [Docker Desktop](https://www.docker.com/products/docker-desktop) pour Windows.

### VCXSRV

Pour avoir accès à une interface graphique il faut installer VCXSRV, que vous pouvez obtenir sur [Sourceforge](https://sourceforge.net/projects/vcxsrv/).\
Vous pourrez ensuite lancer XLaunch (cliquez sur suivant à chaque fois...).

# Configuration

Il faut lancer au moins une fois docker pour construire l'image contenant OpenCV.\
Récupérez d'abord le contenu de ce dépôt dans le répertoire de votre choix :

```
git clone https://github.com/gnda/docker_opencv
```

Dans le répertoire docker_opencv, exécutez la commande suivante :

```
docker-compose up -d --build
```

La création de l'image et la compilation d'OpenCV prendra du temps.

# Usage

Une fois l'installation effectuée, votre répertoire de travail sera le dossier workspace qui se trouve dans docker_opencv.\
Il faudra placer vos sources dans le dossier workspace/src.

Pour compiler vos sources en release, il faudra entrer la commande suivante :

```
docker-compose run --rm opencv /bin/bash -c "cd build && cmake ../src/ -D OpenCV_DIR=/usr/local/opencv/release/ && make"
```

Pour compiler vos sources en debug, il faudra entrer la commande suivante :

```
docker-compose run --rm opencv /bin/bash -c "cd build && cmake ../src/ -D OpenCV_DIR=/usr/local/opencv/debug/ && make"
```

L'exécutable est nommé app et se trouve dans le répertoire workspace/build :

```
docker-compose run --rm opencv ./build/app
```