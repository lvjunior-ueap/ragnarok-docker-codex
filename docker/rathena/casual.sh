#!/bin/bash

set -e

if pgrep -f map-server > /dev/null
then
  echo "rAthena est   rodando, parando..."
  cd /usr/bin/rathena
  sh ./athena-start stop
fi


echo "=== Parando rAthena se estiver rodando ==="

cd /usr/bin/rathena

sh ./athena-start stop || true


#################################
# path
#################################

RATHENA=${RATHENA_PATH:-/datastoresetup/usr-bin-rathena}

echo "=== Aplicando modo CASUAL ==="
echo "Rathena path: $RATHENA"

#################################
# 1 - EXP rates
#################################

sed -i 's/base_exp_rate:.*/base_exp_rate: 33000/' $RATHENA/conf/battle/exp.conf || true
sed -i 's/job_exp_rate:.*/job_exp_rate: 33000/' $RATHENA/conf/battle/exp.conf || true

#################################
# 2 - DROP rates
#################################

sed -i 's/item_rate_common:.*/item_rate_common: 1500/' $RATHENA/conf/battle/drops.conf || true
sed -i 's/item_rate_heal:.*/item_rate_heal: 500/' $RATHENA/conf/battle/drops.conf || true
sed -i 's/item_rate_equip:.*/item_rate_equip: 1000/' $RATHENA/conf/battle/drops.conf || true
sed -i 's/item_rate_card:.*/item_rate_card: 300/' $RATHENA/conf/battle/drops.conf || true

#################################
# 3 - remover PIN
#################################

sed -i 's/char_pin:.*/char_pin: no/' $RATHENA/conf/login_athena.conf || true
sed -i 's/char_pin_enabled:.*/char_pin_enabled: false/' $RATHENA/conf/login_athena.conf || true

#################################
# 4 - starter items
#################################

mkdir -p $RATHENA/npc/custom

cat <<EOF > $RATHENA/npc/custom/starter_items.txt
-	script	Starter_Items	-1,{

OnPCLoginEvent:
	if (#starter_items_given == 0) {
		getitem 501,150;
		#starter_items_given = 1;
		dispbottom "Você recebeu 150 poções iniciais.";
	}
	end;
}
EOF

#################################
# 5 - ativar NPCs existentes
#################################

NPCCONF=$RATHENA/npc/scripts_custom.conf

echo "=== Ativando NPCs CASUAL ==="

enable_npc() {
    sed -i "s|//npc: npc/custom/$1|npc: npc/custom/$1|" $NPCCONF || true
}

enable_npc warper.txt
enable_npc healer.txt
enable_npc stylist.txt
enable_npc card_remover.txt
enable_npc platinum_skills.txt
enable_npc resetnpc.txt

#################################
# 5 - garantir carregamento dos NPCs custom
#################################

ATHENACONF="$RATHENA/npc/scripts_athena.conf"

echo "=== Garantindo scripts_custom.conf ==="

if ! grep -q "scripts_custom.conf" "$ATHENACONF"; then
    echo "npc: npc/scripts_custom.conf" >> "$ATHENACONF"
    echo "scripts_custom.conf adicionado ao scripts_athena.conf"
fi


#################################
# 6 - iniciar servidor
#################################

echo "=== Iniciando rAthena ==="

cd /
sh start.sh
