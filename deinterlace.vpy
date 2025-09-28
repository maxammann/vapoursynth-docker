import vapoursynth as vs
core = vs.core


import havsfunc as haf
clip = core.bs.VideoSource(source='/video.mp4')
clip = haf.QTGMC(clip, Preset='Slower', TFF=True)
clip.set_output()