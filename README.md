# EV Nova

Install:
- unzip EV_Nova_Community_Edition.zip from https://download.escape-velocity.games/
- unzip cnc-ddraw.zip inside the EV\ Nova folder without dddraw.ini, thats present already with some custom settings
- inside the EV\ Nova folder run 
```sh
wine cnc-ddraw\ config.exe
```
- Can try, for bigger ui + disable fullscreen
```sh
sed -i 's/ui_scale=1.0/ui_scale=1.4/' /mnt/xyon/EV\ Nova/ddraw.ini
sed -i 's/fullscreen=true/fullscreen=false/' /mnt/xyon/EV\ Nova/ddraw.ini
```
- Run with wine should be fine

## Pilots Dir

You can link the pilots dir, with a shortcut.

Example:

```sh
ln -s $PWD/Pilots <path to EV\ Nova>/EV\ Nova/Pilots
```
