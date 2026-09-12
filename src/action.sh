#!/system/bin/sh
MODDIR=${0%/*}

# ANSI colors
RST=""
BOLD=""
DIM=""
ITAL=""
UND=""
RED=""
GRN=""
YLW=""
BLU=""
MAG=""
CYN=""
WHT=""
BGRN=""
BCYN=""
BYLW=""
BRED=""

HDR="${CYN}════════════════════════════════${RST}"

echo "$HDR"
echo "${BCYN}   🔧  GSF CertFix  🔧${RST}"
echo "$HDR"
echo ""

DB=""
for c in /data/data/com.google.android.gms/databases/gservices.db \
         /data/data/com.google.android.gsf/databases/gservices.db \
         /data/user/0/com.google.android.gms/databases/gservices.db \
         /data/user/0/com.google.android.gsf/databases/gservices.db; do
  if [ -f "$c" ]; then DB="$c"; break; fi
done

if [ -z "$DB" ]; then
  echo "${BRED}✗ gservices.db not found${RST}"
  echo "${RED}  Is GMS installed?${RST}"
  exit 1
fi

IDFULL=$(strings "$DB" | grep -o -E -m1 'android_id[0-9][0-9]*')
ID=${IDFULL#android_id}

if [ -z "$ID" ]; then
  echo "${BRED}✗ android_id not in gservices.db${RST}"
  exit 1
fi

echo "${GRN}✔ GSF Android ID found${RST}"
echo ""
echo "   ${BOLD}${YLW}${UND}$ID${RST}"
echo ""
echo "${ITAL}${DIM}Register it here:${RST}"
echo "${BLU}${UND}https://www.google.com/android/uncertified${RST}"
echo ""
echo "${MAG}────────────────────────────────${RST}"
echo "${BOLD}⌨  Press Vol+ or Vol− now${RST}"
echo "   ${GRN}[Vol+]${RST} Clear Store ${DIM}(stay here)${RST}"
echo "   ${YLW}[Vol−]${RST} Clear Store ${BOLD}+ reboot${RST}"
echo "${MAG}────────────────────────────────${RST}"

EVF=/data/local/tmp/pf_events
COUNT=0
SEL=1
HEARD=0

while [ $COUNT -lt 3 ]; do
  rm -f $EVF
  timeout 14 /system/bin/getevent -l > $EVF 2>&1 &
  GPID=$!
  i=0
  while [ $i -lt 14 ]; do
    sleep 1
    i=$((i + 1))
    if grep -q 'KEY_VOLUMEUP *DOWN' $EVF 2>/dev/null; then SEL=0; HEARD=1; break 2; fi
    if grep -q 'KEY_VOLUMEDOWN *DOWN' $EVF 2>/dev/null; then SEL=1; HEARD=1; break 2; fi
  done
  kill $GPID 2>/dev/null
  COUNT=$((COUNT + 1))
done
kill $GPID 2>/dev/null

echo ""

if [ $HEARD -eq 0 ]; then
  echo "${RED}⚠  No key heard — nothing cleared${RST}"
  exit 0
fi

pm clear com.android.vending

if [ $SEL -eq 0 ]; then
  echo "$HDR"
  echo "${BGRN}✅  Store cleared.${RST}"
  echo "${WHT}Reboot yourself, wait 10 min,${RST}"
  echo "${WHT}then check certification.${RST}"
  echo "$HDR"
else
  echo "$HDR"
  echo "${BGRN}✅  Store cleared. Rebooting now… 🔄${RST}"
  echo "$HDR"
  sleep 2
  reboot
fi
