#!/bin/bash

set -e

#################################
# path
#################################

RATHENA=${RATHENA_PATH:-/datastoresetup/usr-bin-rathena}

echo "=== Aplicando modo CASUAL ==="
echo "Rathena path: $RATHENA"

#################################
# 1 - EXP rates
#################################

sed -i 's/base_exp_rate:.*/base_exp_rate: 3300/' $RATHENA/conf/battle/exp.conf || true
sed -i 's/job_exp_rate:.*/job_exp_rate: 3300/' $RATHENA/conf/battle/exp.conf || true

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
# 5 - registrar NPCs existentes
#################################

CUSTOMCONF=$RATHENA/npc/custom/custom.conf
touch $CUSTOMCONF

add_npc() {
    if ! grep -q "$1" $CUSTOMCONF; then
        echo "npc: npc/custom/$1" >> $CUSTOMCONF
    fi
}

echo "// Casual Mode NPCs" >> $CUSTOMCONF

add_npc starter_items.txt
add_npc healer.txt
add_npc warper.txt
add_npc stylist.txt
add_npc card_remover.txt
add_npc platinum_skills.txt

#################################
# 6 - iniciar servidor
#################################

echo "=== Iniciando rAthena ==="

cd /
sh start.sh
