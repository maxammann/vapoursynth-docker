import vapoursynth as vs
core = vs.core

core.num_threads = 12

from vsdeinterlace import QTempGaussMC
clip = core.bs.VideoSource(source='/video.mp4', threads=12)

#clip = core.ffms2.Source(source='/video.mp4')


clip = (
    QTempGaussMC(clip, tff = True)
    .prefilter()
    .analyze()
    .denoise()
    .basic()
    .source_match()
    .lossless()
    .sharpen()
    .back_blend()
    .sharpen_limit()
    .final()
    .motion_blur()
    .deinterlace()
)


clip.set_output()