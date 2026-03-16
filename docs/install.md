# Instalação

Este projeto executa um servidor **Ragnarok Online baseado em rAthena** utilizando **Docker** e permite gerar mundos procedurais através de seeds.

---

# Requisitos

Antes de começar, instale:

* Docker
* Docker Compose
* Git

Ubuntu / Debian:

```bash
sudo apt install docker.io docker-compose git
```

---

# 1. Clonar o repositório

```bash
git clone https://SEU_REPOSITORIO/ragnarok-docker.git
cd ragnarok-docker
```

---

# 2. Baixar a base do rAthena

Por questões de licença e tamanho do repositório, os arquivos originais do rAthena **não são incluídos no git**.

Execute:

```bash
./setup-rathena-data_base-external.sh
```

Isso irá baixar automaticamente a base limpa em:

```
data_base/
```

---

# 3. Criar a base local utilizada pelo servidor

Copie os arquivos necessários para o ambiente local:

```bash
./copia-base.sh
```

Isso cria:

```
data/
```

Essa pasta contém os arquivos que serão modificados pelos randomizers.

---

# 4. Subir o servidor

```bash
docker compose up -d
```

Containers iniciados:

```
ragnarok-server
ragnarok-db
ragnarok-phpmyadmin
robrowser
```

---

# 5. Acessar o jogo

Cliente Web:

```
http://SEU_IP:8003
```

Banco de dados (phpMyAdmin):

```
http://SEU_IP:8080
```

---

# 6. Gerar um mundo procedural

Para criar um novo mundo usando uma seed:

```bash
./new_world.sh minha-seed
```

Exemplo:

```bash
./new_world.sh wolfie-maxxer
```

O script irá:

1. Parar o servidor
2. Restaurar a base limpa
3. Aplicar os randomizers
4. Reiniciar o servidor

---

# Estrutura do projeto

```
ragnarok-docker
 ├ data/            # dados modificáveis (gerados)
 ├ data_base/       # base limpa do rAthena
 ├ tools/           # randomizers
 ├ scripts/
 ├ new_world.sh
 ├ copia-base.sh
 ├ docker-compose.yml
 └ docs/
```

---

# Observações

* `data/` não é versionado no git.
* `data_base/` é baixado automaticamente.
* Seeds diferentes geram mundos diferentes.

---

# Exemplo de fluxo completo

```bash
git clone https://SEU_REPOSITORIO/ragnarok-docker.git
cd ragnarok-docker

./setup-rathena-data_base-external.sh
./copia-base.sh

docker compose up -d

./new_world.sh minha-seed
```

---

# Parar o servidor

```bash
docker compose down
```
