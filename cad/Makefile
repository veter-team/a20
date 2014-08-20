OPENSCAD = openscad

INDIR = models
OUTDIR = for3dprint

BASE_SOURCES = \
	base/bearing_pad.scad \
	base/motor_holder.scad \
	base/rim.scad \
	base/wheel_holder.scad

SOURCES = $(BASE_SOURCES:%.scad=$(INDIR)/%.scad)
BASE_STLS = $(BASE_SOURCES:%.scad=$(OUTDIR)/%.stl)

all: for3dprint

for3dprint: $(BASE_STLS)

$(BASE_STLS) : $(SOURCES)
	$(OPENSCAD) -o $@ $<

clean: 
	rm -f $(BASE_STLS)
