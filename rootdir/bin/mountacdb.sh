#!/bin/sh

mount -o rw,remount /
rm -rf /system/etc/*.acdb
for f in /vendor/etc/*acdb; do
    base=$(basename "$f")
    ln -s "$f" "/system/etc/$base"
done
mount -o ro,remount /