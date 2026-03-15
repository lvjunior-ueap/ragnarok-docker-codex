# Ragnarok Docker Server

Ambiente Docker para execução de um servidor **Ragnarok Online baseado em rAthena (2017–2018)** com foco em:

- automação
- reprodutibilidade
- debugging
- desenvolvimento de sistemas customizados
- ferramentas auxiliares para análise do servidor

O projeto adiciona várias ferramentas e melhorias sobre o rAthena padrão, incluindo:

- geração automática de database web
- scanner de configuração
- presets de servidor (modo casual)
- automação de configuração do servidor

---

# Objetivo do Projeto

Criar um **ambiente de servidor Ragnarok moderno e controlado**, que permita:

- rodar o servidor facilmente via Docker
- investigar o funcionamento interno do rAthena
- automatizar configuração do servidor
- desenvolver sistemas customizados

O ambiente foi construído também como **plataforma experimental** para futuros sistemas como:

- progressão radial de mundo
- randomização procedural de drops
- geração automática de database

---

# Arquitetura do Ambiente

O ambiente utiliza **Docker Compose** para orquestrar múltiplos serviços.

Serviços principais:

| Serviço | Função |
|------|------|
| rAthena | servidor do jogo |
| MariaDB | banco de dados |
| Apache | servidor web |
| phpMyAdmin | administração do banco |
| roBrowserLegacy | cliente web |
| wsproxy | bridge websocket |

---

# Estrutura do Projeto


ragnarok-docker/

docker/
└ rathena/
├ Dockerfile
├ start.sh
├ casual.sh
├ build_ro_database.py
├ database.html
└ cat_python.py

docker-compose.yml

data/
sql-init/
scripts/
docs/


---

# Arquitetura Interna do ragnadocker

Uma característica importante do ragnadocker é que **existem múltiplas cópias do servidor dentro do container**.

Isso foi uma descoberta importante durante o desenvolvimento.

Existem três estados principais:

---

## Template inicial do servidor


/datastoresetup/


Contém o servidor base utilizado para recriar o ambiente.

---

## Volume persistente


/datastore/


Contém dados que persistem entre reinicializações do container.

Estrutura:


etc-apache2
etc-mysql
usr-bin-rathena
var-lib-mysql
var-www-html


---

## Runtime real do servidor


/usr/bin/rathena


Este é **o diretório realmente executado pelo servidor**.

Descoberta importante:

Alterações feitas em:


/datastoresetup


não afetam o servidor ativo.

Scripts de automação devem modificar:


/usr/bin/rathena


---

# Scripts do Sistema

O container possui scripts de gerenciamento do ambiente.

---

## import-athena.sh

Sincroniza dados persistentes para o runtime.


datastore → runtime


---

## reset-athena.sh

Reconstrói o servidor a partir do template.


datastoresetup → runtime


---

## backup-athena.sh

Cria backup do servidor atual.


runtime → datastore


---

## launch-athena.sh

Inicializa o servidor rAthena.

---

# Ferramentas Criadas no Projeto

O projeto inclui ferramentas auxiliares para análise do servidor.

---

# cat_python.py

Scanner de arquivos de configuração.

Permite visualizar rapidamente arquivos de configuração do servidor.

Exemplo:


python3 cat_python.py -f conf/battle/exp.conf


ou


python3 cat_python.py
-d /usr/bin/rathena
-f conf/battle/exp.conf conf/battle/feature.conf


Modos de operação:

| Opção | Função |
|-----|-----|
| -f | mostrar arquivos específicos |
| -d | definir diretório root |
| nenhum | modo interativo |

Uso comum:

Verificar se o sistema de PIN está ativo:


python3 cat_python.py
-d /usr/bin/rathena
-f conf/char_athena.conf | grep pincode


---

# Gerador de Database do Servidor

Script:


build_ro_database.py


Este script analisa arquivos do servidor e gera uma database navegável.

Arquivos gerados:


item_info.json
mob_spawn.json
map_to_mobs.json


Esses dados são utilizados por uma interface web:


/var/www/html/database.html


Recursos da interface:

- busca por item
- busca por monstro
- visualização de drops
- visualização de spawn
- autocomplete

---

# Modo CASUAL

Script:


casual.sh


Aplica automaticamente um preset de servidor casual.

---

## Configurações aplicadas

EXP:


base_exp_rate: 33000
job_exp_rate: 33000


Drops:


item_rate_common: 1500
item_rate_heal: 500
item_rate_equip: 1000
item_rate_card: 300


---

## Sistema de PIN

O sistema de PIN é desativado automaticamente:


pincode_enabled: no
pincode_force: no


---

# NPCs Utilitários Ativados

O modo casual ativa automaticamente vários NPCs úteis:


warper
jobmaster
platinum_skills
healer
stylist
resetnpc
card_remover


---

# Sistema de Itens Iniciais

Script criado:


npc/custom/starter_items.txt


Executado em:


OnPCLoginEvent


Entrega:


Red Potion x150


apenas uma vez por conta.

Exemplo de script:


script Starter_Items -1,{

OnPCLoginEvent:
if (#starter_items_given) end;

getitem 501,150;
#starter_items_given = 1;

dispbottom "Você recebeu 150 poções iniciais.";

end;

}


---

# Problemas Encontrados Durante Desenvolvimento

Durante a configuração do servidor alguns problemas foram identificados.

---

## Problema: configuração alterada não aplicava

Causa:

O servidor utiliza:


/usr/bin/rathena


Alterações feitas em:


/datastoresetup


não afetavam o runtime.

---

## Problema: erro de sintaxe em scripts_custom.conf

Erro:


Unknown syntax in file 'npc/scripts_custom.conf'


Causa:

linha gerada incorretamente:


npc/custom/warper.txt


Formato correto:


npc: npc/custom/warper.txt


---

# Dockerfile

O container rAthena inclui ferramentas adicionais:


git
zsh
nano
vim
curl
python3


Aliases úteis adicionados:


rathena-up
rathena-down
rathena-update


---

# Debugging do Servidor

Alguns comandos úteis para diagnóstico.

---

Verificar EXP:


python3 cat_python.py
-f /usr/bin/rathena/conf/battle/exp.conf


---

Verificar PIN:


grep pincode /usr/bin/rathena/conf/char_athena.conf


---

Verificar NPCs ativos:


grep "npc:" /usr/bin/rathena/npc/scripts_custom.conf


---

# Próximos Passos do Projeto

Planejados para evolução do servidor:

- sistema procedural de efeitos de cartas
- progressão radial de mapas
- melhoria da database web
- geração automática de documentação
- ferramentas avançadas de debugging

---

# Licença

Projeto experimental para estudo de arquitetura e desenvolvimento de servidores Ragnarok baseados em rAthena.
