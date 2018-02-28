## Introduction
We will develop an iOS application, which lets you communicate with your potted plants. You will have a lovely sweetie always acts cute to get attention, rather than just a quiet boy sitting in the sun. You can chat with it, master if its growing environment is suitable and see it anytime and anywhere birthday, photo albums, identity information wherever you are. It will also call you to get up every day, remind you to complete schedule and drink water as well as feed it water.

## Implemented requirements
- iOS platform, version 10.0
  - Speech framework
  - AVFoundation framework
  - MediaPlayer framework
- Face++ API, version 3.0
- Leancloud SDK, version 0.5.0
- Tuling123 API, version 2.1
- Ruff SCM, version 1.8.1

## Architecture

<div  align="center"> 
<img src="http://ac-deijvnqa.clouddn.com/f58945cf5fed30bd57b0.png" style="zoom:10%" />
</div>

### AI Robot

We use ”Tuling123 Robot” API to build our AI robot. ”Tuling123 Robot” API is based on the core capabilities of artiﬁcial intelligence (including semantic understanding, intelligent Q&A, scene interaction, knowledge management, etc.), providing a range of online services and development interfaces about cloud computing and large data platforms for the developers.

Because ”Tuling robot” is based on DeepQA depth Q&A technology, the Chinese recognition accuracy rates of up to 90%. It is the Chinese language under the most intelligent robot.

### ASR and TTS

Considering the developing platform, we use the native framework —- ”Speech”, ”AVFoundation” and ”MediaPlayer” to realize Automatic Speech Recognition(ASR) and Text-to-Speech(TTS).

The Speech APIs let developers extend and enhance the speech recognition experience within their app, without requiring a keyboard. AVFoundation is one of several frameworks that you can use to play and create time-based audiovisual media.

### Plant‘s state Record

In order to give user better experience, we use ”Ruﬀ” SCM to record the information about user‘s plant, and store them in ”Leancloud” cloud database. The application request data from ”Leancloud” when it needs.

”Ruﬀ” SCM uses JavaScript to develop, which is easy-to-pickup. No more cross-compiling, developer can instantly deploy their work.

”Leancloud” is a famous, open-source cloud database, similar to ”Parse”. It provides many SDK based on diﬀerent language, so it‘s easy to translate data from diﬀerent platform.

### Face detection

In order to simulate the interaction between plants and users, we add face detection subsystem. The subsystem can detect user‘s emotion using his face photo, and responses based on diﬀerent emotion.

”Face++” API can get people‘s face information like age, gender, emotion, etc. Developer just needs to send a request and the eﬃcient algorithm will response the information quickly.
## Screenshots

<div  align="center"> 
<img src="http://ac-deijvnqa.clouddn.com/edf98802fa26940e2547.PNG" style="zoom:10%" />
</div>

<div  align="center"> 
<img src="http://ac-deijvnqa.clouddn.com/3144d7b6569d3e19e421.PNG" style="zoom:10%" />
</div>

<div  align="center"> 
<img src="http://ac-deijvnqa.clouddn.com/b0d50236391c3f55fa2d.PNG" style="zoom:10%" />
</div>

<div  align="center"> 
<img src="http://ac-deijvnqa.clouddn.com/385975f91bec99572b8c.PNG" style="zoom:10%" />
</div>
