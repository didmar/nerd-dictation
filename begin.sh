#!/bin/bash
export DOTOOL_XKB_LAYOUT=fr
# ./venv/bin/python3 ./nerd-dictation begin --simulate-input-tool DOTOOL --speech-engine=OPENAI_WHISPER --openai-whisper-language en &
# ./venv/bin/python3 ./nerd-dictation begin --simulate-input-tool DOTOOL --speech-engine=ASSEMBLYAI &
./venv/bin/python3 ./nerd-dictation begin --simulate-input-tool DOTOOL --speech-engine=VOXTRAL &
# ./venv/bin/python3 ./nerd-dictation begin --simulate-input-tool DOTOOL --speech-engine=FASTER_WHISPER --faster-whisper-model-size=medium &
