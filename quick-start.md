Note on how to setup the modified system, using Faster Whisper and with the tray app:

```bash
sudo apt install pulseaudio-utils

virtualenv venv
source venv/bin/activate

pip install package/python

# For using Faster Whisper:
pip install faster-whisper

# For using Assembly AI
 echo "ASSEMBLYAI_API_KEY=<replace-with-your-key>" > .env
sudo apt install portaudio19-dev
pip install 'assemblyai[extras]'

./install-dotool.sh
./install-dotoold-service.sh
systemctl --user start dotoold.service
# Test it works (might be to restart first)
echo 'type hello world' | dotoolc

# Test it works
./toggle.sh  # start
# Speak and confirm its typing stuff
./toggle.sh  # stop

# Install the tray app
sudo apt install python3-gi python3-gi-cairo gir1.2-gtk-3.0 gir1.2-appindicator3-0.1
pip install -r requirements-gui.txt
# Test it worlks
./nerd-dictation-tray.py
# Install the service
./install-tray-service.sh
systemctl start --user nerd-dictation-tray

# In Ubuntu settings, create a keyboard shortcut that runs the following command:
bash -c "~/nerd-dictation/toggle.sh"
```
