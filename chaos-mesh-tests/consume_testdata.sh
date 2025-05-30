#!/usr/bin/env bash

kubectl exec kcat -it -- bash -c "kcat -F /mnt/configs/kcat-cp-int.conf -t test -f '\nHeader: %h \nKey (%K bytes): %k\t\nValue (%S bytes): %s\nTimestamp: %T\tPartition: %p\tOffset: %o\n--\n' -C"
