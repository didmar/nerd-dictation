##################################################
Using Google Cloud Speech-to-Text with nerd-dictation
##################################################

This guide explains how to configure and use Google Cloud's Speech-to-Text service with nerd-dictation.

What is Google Cloud Speech-to-Text?
====================================

Google Cloud Speech-to-Text is a powerful cloud-based speech recognition service that provides:

- State-of-the-art accuracy using Google's latest_long model
- Real-time streaming transcription with interim results
- Automatic punctuation and capitalization
- Support for 125+ languages
- Low-latency streaming recognition for interactive applications
- Multiple model options optimized for different use cases

The nerd-dictation implementation uses **streaming recognition** for real-time transcription, showing text as you speak when using progressive mode.

When should I use Google Cloud Speech-to-Text?
==============================================

Consider using Google Cloud Speech-to-Text when you:

- Need the highest possible accuracy
- Want to transcribe long-form content (podcasts, meetings, etc.)
- Require support for multiple languages or accents
- Have a reliable internet connection
- Want automatic punctuation and formatting
- Need professional-grade transcription quality

Installation
============

First, install the Google Cloud Speech client library:

.. code-block:: sh

   pip install google-cloud-speech

Getting Started with Google Cloud
=================================

1. Create a Google Cloud Project
--------------------------------

1. Go to the `Google Cloud Console <https://console.cloud.google.com/>`_
2. Create a new project or select an existing one
3. Note your project ID for later use

2. Enable the Speech-to-Text API
--------------------------------

1. In the Cloud Console, go to APIs & Services > Library
2. Search for "Cloud Speech-to-Text API"
3. Click on it and press "Enable"

3. Create Service Account Credentials
-------------------------------------

1. Go to APIs & Services > Credentials
2. Click "Create Credentials" > "Service Account"
3. Give it a name and description
4. Grant it the "Cloud Speech Client" role
5. Click "Done"
6. Click on your new service account
7. Go to the "Keys" tab
8. Click "Add Key" > "Create new key"
9. Choose JSON format
10. Save the downloaded JSON file securely

Basic Usage
===========

To use Google Cloud Speech-to-Text with nerd-dictation:

.. code-block:: sh

   ./nerd-dictation begin --speech-engine=GOOGLE_CLOUD --google-cloud-credentials=/path/to/credentials.json

For output to stdout (useful for testing):

.. code-block:: sh

   ./nerd-dictation begin --speech-engine=GOOGLE_CLOUD --google-cloud-credentials=/path/to/credentials.json --output=STDOUT

Configuration Options
=====================

Model Selection
--------------

Google Cloud offers several models. The default is ``latest_long`` which is optimized for long-form content:

.. code-block:: sh

   # Use latest_long model (default - best for dictation)
   ./nerd-dictation begin --speech-engine=GOOGLE_CLOUD --google-cloud-model=latest_long

   # Use latest_short model (for short commands)
   ./nerd-dictation begin --speech-engine=GOOGLE_CLOUD --google-cloud-model=latest_short

   # Use command_and_search model (legacy, for short utterances)
   ./nerd-dictation begin --speech-engine=GOOGLE_CLOUD --google-cloud-model=command_and_search

Language Support
---------------

Specify the language code (default is en-US):

.. code-block:: sh

   # English (US)
   ./nerd-dictation begin --speech-engine=GOOGLE_CLOUD --google-cloud-language=en-US

   # Spanish
   ./nerd-dictation begin --speech-engine=GOOGLE_CLOUD --google-cloud-language=es-ES

   # French
   ./nerd-dictation begin --speech-engine=GOOGLE_CLOUD --google-cloud-language=fr-FR

See the full list of supported languages at: https://cloud.google.com/speech-to-text/docs/languages

Enhanced Features
----------------

Enable automatic punctuation (enabled by default):

.. code-block:: sh

   ./nerd-dictation begin --speech-engine=GOOGLE_CLOUD --google-cloud-punctuation

Enable profanity filtering:

.. code-block:: sh

   ./nerd-dictation begin --speech-engine=GOOGLE_CLOUD --google-cloud-profanity-filter

Use enhanced models for better accuracy (may incur additional cost):

.. code-block:: sh

   ./nerd-dictation begin --speech-engine=GOOGLE_CLOUD --google-cloud-use-enhanced

Sample Rate
-----------

Google Cloud works best with 16000 Hz sample rate for speech recognition. While the default is 44100 Hz, it's recommended to use 16000 Hz:

.. code-block:: sh

   # Recommended: Use 16000 Hz sample rate
   ./nerd-dictation begin --speech-engine=GOOGLE_CLOUD --sample-rate=16000
   
   # Default (may have lower accuracy)
   ./nerd-dictation begin --speech-engine=GOOGLE_CLOUD --sample-rate=44100

Progressive Mode
---------------

Enable progressive mode to see text as you speak:

.. code-block:: sh

   ./nerd-dictation begin --speech-engine=GOOGLE_CLOUD --defer-output=false

Example Usage
=============

Complete example with all common options:

.. code-block:: sh

   # Start dictation with enhanced features
   ./nerd-dictation begin \
     --speech-engine=GOOGLE_CLOUD \
     --google-cloud-credentials=/path/to/credentials.json \
     --google-cloud-model=latest_long \
     --google-cloud-language=en-US \
     --google-cloud-punctuation \
     --defer-output=false &
   
   # End dictation
   ./nerd-dictation end

Environment Variables
=====================

You can set credentials via environment variable:

.. code-block:: sh

   export GOOGLE_APPLICATION_CREDENTIALS=/path/to/credentials.json
   ./nerd-dictation begin --speech-engine=GOOGLE_CLOUD

Security Considerations
=======================

- Never commit your credentials JSON file to version control
- Store credentials in a secure location with restricted permissions
- Use different service accounts for development and production
- Monitor your API usage in the Google Cloud Console
- Enable API quotas to prevent unexpected charges

Pricing
=======

Google Cloud Speech-to-Text pricing (as of 2025):

- First 60 minutes per month: Free
- Standard models: $0.016 per minute
- Enhanced models: $0.032 per minute

Check current pricing at: https://cloud.google.com/speech-to-text/pricing

Testing
=======

Test your setup with a simple command:

.. code-block:: sh

   # Test with stdout output
   ./nerd-dictation begin --speech-engine=GOOGLE_CLOUD --output=STDOUT --timeout=5

Troubleshooting
===============

Common Issues
-------------

**ImportError: No module named 'google.cloud'**

Install the Google Cloud Speech library: ``pip install google-cloud-speech``

**Authentication errors**

- Verify your credentials file path is correct
- Check that the service account has the "Cloud Speech Client" role
- Ensure the Speech-to-Text API is enabled in your project

**Invalid model errors**

Valid models are: ``latest_long``, ``latest_short``, ``command_and_search``, ``default``

**Permission denied errors**

- Check that your service account has proper permissions
- Verify the credentials file is readable
- Ensure you're not exceeding API quotas

**No transcription results**

- Check your microphone permissions and functionality
- Verify the sample rate matches your audio input
- Try increasing verbosity: ``--verbose=2``

Comparison with Other Engines
=============================

+-------------------+-------------------+-------------------+-------------------+
| Feature           | VOSK              | AssemblyAI        | Google Cloud      |
+===================+===================+===================+===================+
| **Accuracy**      | Good              | Excellent         | State-of-the-art  |
+-------------------+-------------------+-------------------+-------------------+
| **Internet**      | Not required      | Required          | Required          |
+-------------------+-------------------+-------------------+-------------------+
| **Setup**         | Model download    | API key           | Credentials file  |
+-------------------+-------------------+-------------------+-------------------+
| **Cost**          | Free              | Usage-based       | Usage-based       |
+-------------------+-------------------+-------------------+-------------------+
| **Privacy**       | Complete          | Cloud-based       | Cloud-based       |
+-------------------+-------------------+-------------------+-------------------+
| **Punctuation**   | Manual            | Automatic         | Automatic         |
+-------------------+-------------------+-------------------+-------------------+
| **Languages**     | Model dependent   | Multiple          | 125+ languages    |
+-------------------+-------------------+-------------------+-------------------+
| **Long audio**    | Limited           | Good              | Excellent (8hrs)  |
+-------------------+-------------------+-------------------+-------------------+

Advanced Features
=================

The Google Cloud implementation in nerd-dictation uses:

- **Streaming Recognition**: Real-time transcription using Google's streaming API
- **latest_long model**: Optimized for long-form content and natural speech
- **Automatic punctuation**: Enabled by default for better readability
- **Interim Results**: Shows partial transcriptions in progressive mode
- **Low Latency**: Processes audio in small chunks (1KB) for immediate feedback

Streaming Recognition Details
----------------------------

The implementation uses Google Cloud's streaming recognition API which:

- Provides real-time transcription with low latency
- Shows interim (partial) results as you speak
- Automatically finalizes results when speech pauses are detected
- Works best with 16000 Hz sample rate
- Has a 5-minute limit per streaming session (Google's limitation)

Limitations
===========

- Requires internet connection
- Usage-based pricing after free tier
- Audio data is processed in Google's cloud infrastructure
- May have higher latency than local models
- Requires Google Cloud account and project setup

For more information, visit: https://cloud.google.com/speech-to-text/docs/
