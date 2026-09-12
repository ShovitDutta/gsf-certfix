#!/sbin/sh
ui_print "- GSF CertFix installed. Open the module"
ui_print "- and tap ACTION for the fix menu."
set_perm $MODPATH/action.sh 0 0 0755
