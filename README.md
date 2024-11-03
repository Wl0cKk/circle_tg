<p align="center">
  <img src="https://github.com/user-attachments/assets/5d7aac49-2d8e-4b61-aacd-54469d89aee4" alt="project-image">
</p>

---
# What can this bot do?
|  |                                                                                                                                                                    |
|--|--------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|✅| <details closed><summary>Convert sent video into circles</summary><img src="https://i.imgur.com/BtSEUKD.png" alt="convert-video"></details>                        |
|✅| <details closed><summary>Combine multiple files into one mp4 and send it to you</summary><img src="https://i.imgur.com/AVOc6jX.png" alt="combine-files"></details> |
|✅| <a href="#syntax-for-caption">Can send a circle to a channel, at a given time</a>                                                                                                                   |

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
