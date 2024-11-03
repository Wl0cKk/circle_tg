<p align="center">
  <img src="https://github.com/user-attachments/assets/5d7aac49-2d8e-4b61-aacd-54469d89aee4" alt="project-image">
</p>

---
# What can this bot do?
|  |                                                                                                                                                                    |
|--|--------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|✅| <details closed><summary>Convert sent video into circles</summary><img src="https://i.imgur.com/BtSEUKD.png" alt="convert-video"></details>                        |
|✅| <details closed><summary>Combine multiple files into one mp4 and send it to you</summary><img src="https://i.imgur.com/AVOc6jX.png" alt="combine-files"></details> |
|✅| <a href="#syntax-for-caption">Can send a circle to channels, at a given time</a>                                                                                                                   |

### This bot avoid of some annoying limitations because it uses the [Local Bot API Server](https://core.telegram.org/bots/api#using-a-local-bot-api-server)

### although this bot is [long polling](https://www.geeksforgeeks.org/what-is-long-polling-and-short-polling/), kill feature here is the size of files we can work with.

> [!IMPORTANT]
> ### But the circle video limit is still 60sec, so if the video is long it will be trimmed from the beginning to one minute 
---
## How to run
  ```bash
    git clone https://github.com/Wl0cKk/circle_tg.git
    cd circle_tg
  ```
  #### Then create or rename [config_example.json](https://github.com/Wl0cKk/circle_tg/blob/main/config_example.json) to config.json
  `touch config.json` or `mv config_example.json config.json`
  #### Open it in any editor and replace TOKEN with obtained token from [@BotFather](https://t.me/botfather)
  > #### channels can be empty if you don't need broadcast feature.
  
  > [!IMPORTANT]  
  > #### Get *API_ID* and *API_HASH* here - https://core.telegram.org/api/obtaining_api_id
- ### Docker compose
> [!TIP]
  > - *In [Dockerfile.bot](https://github.com/Wl0cKk/circle_tg/blob/main/Dockerfile.bot) you can specify <a href="#options">arguments</a> separated by commas*
  > - `CMD ["ruby", "--mjit", "./bot", "--server=http://telegram-bot-api:8081", "--keep_files", "--silent"]`

  > Have you already installed docker and docker-compose?
  #### Create or rename *[.env_example](https://github.com/Wl0cKk/circle_tg/blob/main/.env_example)* to *.env*
  `touch .env` or `mv .env_example .env`
  #### Open it in any editor and replace *API_ID* and *API_HASH* with yours
  
  ### *this will install what's needed and run*:
  ```bash
    mkdir videos
    docker-compose up --build
  ```
  > Installing telegram-bot-api takes a while.
- ### Locally
  > #### You need [ruby](https://www.ruby-lang.org/en/documentation/installation/) and [bundle](https://www.jetbrains.com/help/ruby/using-the-bundler.html#install_bundler) installed.
  ```bash
  ruby -v
  bundle -v
  ```
  
  #### install all <a href="https://github.com/tdlib/telegram-bot-api?tab=readme-ov-file#dependencies">dependencies</a> and follow the <a href="https://github.com/tdlib/telegram-bot-api?tab=readme-ov-file#installation">installation</a> proccess
  #### Once installed you can run it with 
  ```bash
    telegram-bot-api --api-id=API_ID --api-hash=API_HASH --local
  ``` 
  #### Then open a new tab in terminal and do the following
  ```bash
  bundle install
  ```
  ```bash
  ruby --mjit bot
  ```
  Specify the <a href="#options">arguments</a> if you wish
---
## Options
> You can start bot using 3 arguments: --keep_files, --verbose, --silent.
- **--keep_files** — *all files including submitted and edited files will not be deleted*
- **--verbose** — *Log output from [FFMPEG](https://www.ffmpeg.org/) will <ins>not</ins> be muted*
- **--silent** — *Everything will be muted, including logo output and telegram bot logs*
> [!WARNING]  
> *You can't run* **--verbose** *and* **--silent** *at the same time*
---
## Syntax for caption
> [!NOTE]  
> - By sending caption along with the video, the bot will not send the video personally, but to the channels specified in [config.json](https://github.com/Wl0cKk/circle_tg/blob/main/config_example.json)
> - Don't forget to add [channel ID](https://gist.github.com/mraaroncruz/e76d19f7d61d59419002db54030ebe35) to [config.json](https://github.com/Wl0cKk/circle_tg/blob/main/config_example.json)
> - Make the bot an administrator

- **'.'** — Just a dot, will immediately send circle to channels.
- **'at 2024/11/8 23:05:09'** - specifies a timestamp for an action, `YYYY/MM/DD HH:MM:SS`.
> [!TIP]
> Trailing zero is not important: `at 2024/11/08 23:05:09` or `at 2024/11/08 23:5:9`
### dhms
> This syntax is summarized with the current time.
Given the current time is 2024/11/03 14:25:
- **'at 5d 23:05:09'** — Scheduled for 2024/11/08 23:05:09.
- **'at 5d 10h25m55s'** — Scheduled for 2024/11/09 00:50:55.
- **'in 10d5h'** — Will happen in 10 days and 5 hours.
---
