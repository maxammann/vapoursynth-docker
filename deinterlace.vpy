import vapoursynth as vs
from functools import partial
from vsdenoise import DFTTest
from vsaa import BWDIF, EEDI3, EEDI2, NNEDI3
core = vs.core

core.num_threads = 16

from vsdeinterlace import QTempGaussMC
clip = core.bs.VideoSource(source='/video.mp4', threads=12)

#clip = core.ffms2.Source(source='/video.mp4')


clip = (
    QTempGaussMC(clip, tff = False)
    .prefilter()
    .analyze()
    #.denoise(tr = 1, func = partial(DFTTest(backend = DFTTest.Backend.cuFFT).denoise, sigma=8))
    .denoise()
    .basic(tr = 0)
    #.basic(tr = 0 , bobber = EEDI2(cuda = False))
    #.basic(bobber = NNEDI3(opencl = True))
    .basic(tr = 0, bobber = NNEDI3(opencl = True))
    #.basic(tr = 0 , bobber = EEDI2(cuda = True, tff = True, double_rate = True))
    #.basic(tr = 0 , bobber = BWDIF())
    .source_match()
    .lossless()
    .sharpen()
    .back_blend()
    .sharpen_limit()
    .final(tr = 0)
    .final()
    .motion_blur()
    .deinterlace()
)


clip.set_output()