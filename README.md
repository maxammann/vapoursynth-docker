## Build


```
sudo docker build -t my-arch-vapoursynth .
```


### Run

QTGMC:
```
sudo docker run --rm -it -v /run/media/max/0204d394-4633-44de-a7de-e01b3f150884/Capture0000-merged-1762011239406-fixed.mov:/video.mp4 -v /home/max/projects/vapour/deinterlace.vpy:/deinterlace.vpy -v /run/media/max/0204d394-4633-44de-a7de-e01b3f150884:/output my-arch-vapoursynth bash -c 'vspipe /deinterlace.vpy - -c y4m | ffmpeg -i - -i /video.mp4 -map 0:v -map 1:a -c:v libx264 -crf 23 -profile:v high422 -pix_fmt yuv422p10le -c:a copy -y /output/Capture0000-merged-1762011239406-gtqmc.mkv'
```


```
ffmpeg -i - -i /run/media/max/0204d394-4633-44de-a7de-e01b3f150884/Capture0000-merged-1762011239406-fixed.mov -filter:v bwdif=mode=send_field:parity=auto:deint=all -c:v libx264 -crf 23 -profile:v high422 -pix_fmt yuv422p10le -c:a copy -y /output/Capture0000-merged-1762011239406-bwdif.mkv'
```



```
sudo docker run --rm -it my-arch-vapoursynth bash
```

## Debug

Test for corruptions:
```
ffmpeg -i Capture0002.mov -c:v prores -c:a copy -f mov -y /dev/null
```


### Troubleshooting


Errors from Shuttle 2:

```
[mov,mp4,m4a,3gp,3g2,mj2 @ 0x3d65100] stream 0, sample 166, dts 6640000
[mov,mp4,m4a,3gp,3g2,mj2 @ 0x3d65100] stream 1, sample 312, dts 6640000
[vist#0:0/prores @ 0x3d8a3c0] corrupt decoded frame
[out#0/mp4 @ 0x3d889c0] sq: send 0 ts 6.04
[out#0/mp4 @ 0x3d889c0] sq: receive 0 ts 6.04 queue head -1 ts N/A


[prores @ 0x11b75cc0] error, wrong slice data size:03:22.48 bitrate=41543.2kbits/s speed=4.07x    
[prores @ 0x11b75cc0] error decoding picture header
[vist#0:1/prores @ 0x11b75b40] Error submitting packet to decoder: Invalid data found when processing input
```


```
[prores @ 0xa21075f80] vt decoder cb: output image buffer is null: -12911.9kbits/s speed=14.3x
[vist#0:1/prores @ 0xa2103c300] [dec:prores @ 0xa21070640] Error submitting packet to decoder: Unknown error occurred
```
