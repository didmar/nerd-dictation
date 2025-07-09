##################################################
Using AssemblyAI with nerd-dictation
##################################################

This guide explains how to configure and use AssemblyAI's real-time speech recognition service with nerd-dictation.

What is AssemblyAI?
===================

AssemblyAI is a cloud-based speech recognition service that provides:

- High-accuracy speech recognition
- Real-time streaming transcription
- Automatic punctuation and formatting
- Support for multiple languages
- No local model downloads required

When should I use AssemblyAI?
=============================

Consider using AssemblyAI when you:

- Want higher accuracy than local models
- Don't want to download and manage large model files
- Have a reliable internet connection
- Don't mind using a cloud service for speech recognition
- Want automatic punctuation and formatting

Installation
============

First, install the AssemblyAI Python SDK:

.. code-block:: sh

   pip install "assemblyai[extras]"

You'll also need portaudio for microphone access:

.. code-block:: sh

   # On Ubuntu/Debian
   sudo apt install portaudio19-dev
   
   # On macOS
   brew install portaudio

Getting an API Key
==================

1. Sign up for a free account at https://www.assemblyai.com/
2. Navigate to your dashboard
3. Copy your API key from the "Your API key" section
4. Keep this key secure and don't share it publicly

Basic Usage
===========

To use AssemblyAI with nerd-dictation, specify the speech engine and API key:

.. code-block:: sh

   ./nerd-dictation begin --speech-engine=ASSEMBLYAI --assemblyai-api-key=YOUR_API_KEY

For output to stdout (useful for testing):

.. code-block:: sh

   ./nerd-dictation begin --speech-engine=ASSEMBLYAI --assemblyai-api-key=YOUR_API_KEY --output=STDOUT

Configuration Options
=====================

The following options work with AssemblyAI:

Sample Rate
-----------

AssemblyAI works best with 16kHz audio (default). You can change this if needed:

.. code-block:: sh

   ./nerd-dictation begin --speech-engine=ASSEMBLYAI --assemblyai-api-key=YOUR_API_KEY --sample-rate=16000

Timeout
-------

Set a timeout to automatically end dictation after a period of silence:

.. code-block:: sh

   ./nerd-dictation begin --speech-engine=ASSEMBLYAI --assemblyai-api-key=YOUR_API_KEY --timeout=10

Progressive Mode
---------------

Enable progressive mode to see text as you speak:

.. code-block:: sh

   ./nerd-dictation begin --speech-engine=ASSEMBLYAI --assemblyai-api-key=YOUR_API_KEY --defer-output=false

Example Usage
=============

Here's a complete example for using AssemblyAI with keyboard shortcuts:

.. code-block:: sh

   # Start dictation (bind this to a key)
   ./nerd-dictation begin --speech-engine=ASSEMBLYAI --assemblyai-api-key=YOUR_API_KEY &
   
   # End dictation (bind this to another key)
   ./nerd-dictation end

Environment Variables
=====================

You can set your API key as an environment variable to avoid passing it on the command line:

.. code-block:: sh

   export ASSEMBLYAI_API_KEY=your_api_key_here
   ./nerd-dictation begin --speech-engine=ASSEMBLYAI --assemblyai-api-key=$ASSEMBLYAI_API_KEY

Security Considerations
=======================

- Never commit your API key to version control
- Use environment variables for API keys in production
- Consider using a separate API key for testing
- Monitor your API usage on the AssemblyAI dashboard

Testing
=======

Use the included test script to verify your setup:

.. code-block:: sh

   python3 test_assemblyai_integration.py

Troubleshooting
===============

Common Issues
-------------

**ImportError: No module named 'assemblyai'**

Install the AssemblyAI SDK: ``pip install "assemblyai[extras]"``

**PortAudio errors**

Install portaudio development libraries:

.. code-block:: sh

   # Ubuntu/Debian
   sudo apt install portaudio19-dev
   
   # macOS
   brew install portaudio

**API key errors**

- Verify your API key is correct
- Check that you have API credits available
- Ensure you're not exceeding rate limits

**No audio input**

- Check your microphone permissions
- Verify your microphone is working with other applications
- Try adjusting the sample rate (16000 is recommended)

Comparison with VOSK
====================

+-------------------+-------------------+-------------------+
| Feature           | VOSK              | AssemblyAI        |
+===================+===================+===================+
| **Accuracy**      | Good              | Excellent         |
+-------------------+-------------------+-------------------+
| **Internet**      | Not required      | Required          |
+-------------------+-------------------+-------------------+
| **Setup**         | Model download    | API key           |
+-------------------+-------------------+-------------------+
| **Cost**          | Free              | Usage-based       |
+-------------------+-------------------+-------------------+
| **Privacy**       | Complete          | Cloud-based       |
+-------------------+-------------------+-------------------+
| **Punctuation**   | Manual            | Automatic         |
+-------------------+-------------------+-------------------+
| **Languages**     | Model dependent   | Multiple          |
+-------------------+-------------------+-------------------+

Limitations
===========

- Requires internet connection
- Usage-based pricing after free tier
- Audio data is processed in the cloud
- May have higher latency than local models

For more information, visit: https://www.assemblyai.com/docs/ 