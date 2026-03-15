#!/bin/bash

set -e

RATHENA=/opt/rathena

echo "=== Aplicando modo CASUAL ==="

#################################
# 1 - EXP rates
#################################

sed -i 's/base_exp_rate:.*/base_exp_rate: 10/' $RATHENA/conf/battle/exp.conf
sed -i 's/job_exp_rate:.*/job_exp_rate: 10/' $RATHENA/conf/battle/exp.conf

#################################
# 2 - DROP rates
#################################

sed -i 's/item_rate_common:.*/item_rate_common: 500/' $RATHENA/conf/battle/drop.conf
sed -i 's/item_rate_heal:.*/item_rate_heal: 500/' $RATHENA/conf/battle/drop.conf
sed -i 's/item_rate_equip:.*/item_rate_equip: 500/' $RATHENA/conf/battle/drop.conf
sed -i 's/item_rate_card:.*/item_rate_card: 300/' $RATHENA/conf/battle/drop.conf

#################################
# 3 - remover PIN
#################################

sed -i 's/char_pin:.*/char_pin: no/' $RATHENA/conf/login_athena.conf || true
sed -i 's/char_pin_enabled:.*/char_pin_enabled: false/' $RATHENA/conf/login_athena.conf || true

#################################
# 4 - criar NPC starter
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
# 5 - healer
#################################

cat <<EOF > $RATHENA/npc/custom/healer.txt
prontera,150,180,4	script	Healer	4_M_01,{
	mes "[Healer]";
	mes "Vou curar você.";
	next;

	percentheal 100,100;
	sc_end SC_ALL;

	mes "Pronto!";
	close;
}
EOF

#################################
# 6 - warper
#################################

cat <<EOF > $RATHENA/npc/custom/warper.txt
prontera,155,180,4	script	Warper	4_F_01,{

	mes "[Warper]";
	mes "Para onde deseja ir?";
	next;

	menu
	"Prontera",L1,
	"Geffen",L2,
	"Payon",L3,
	"Izlude",L4;

L1:
	warp "prontera",150,150;
	close;

L2:
	warp "geffen",120,60;
	close;

L3:
	warp "payon",160,90;
	close;

L4:
	warp "izlude",128,145;
	close;
}
EOF

#################################
# 7 - registrar scripts
#################################

if ! grep -q starter_items $RATHENA/npc/custom/custom.conf; then

cat <<EOF >> $RATHENA/npc/custom/custom.conf

// Casual mode NPCs
npc: npc/custom/starter_items.txt
npc: npc/custom/healer.txt
npc: npc/custom/warper.txt

EOF

fi

#################################
# 8 - iniciar servidor
#################################

echo "=== Iniciando rAthena ==="

cd $RATHENA
sh start.sh
