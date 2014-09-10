OPENSCAD = openscad

INDIR = models
OUTDIR = for3dprint

BASE_SOURCES = \
	base/motor_holder.scad \
	base/rim.scad \
	base/wheel_holder.scad \
	base/front_pannel.scad \
	base/wheel_clutch.scad

SOURCES = $(BASE_SOURCES:%.scad=$(INDIR)/%.scad)
BASE_STLS = $(BASE_SOURCES:%.scad=$(OUTDIR)/%.stl)

all: for3dprint

for3dprint: $(BASE_STLS)

$(BASE_STLS) : $(OUTDIR)/base/%.stl : $(INDIR)/base/%.scad
	$(OPENSCAD) -o $@ $<

clean: 
	rm -f $(BASE_STLS)
