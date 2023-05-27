# BCR
if [ ! -d "vendor/bcr" ]
then
git clone https://github.com/Chaitanyakm/vendor_bcr -b main vendor/bcr
fi

# V4A
if [ ! -d "packages/apps/ViPER4AndroidFX" ]
then
git clone https://github.com/aoleary/packages_apps_ViPER4AndroidFX -b v4a packages/apps/ViPER4AndroidFX
fi
