OPENSCAD = openscad

INDIR = models
OUTDIR = for3dprint

#	base/rim.scad
BASE_SOURCES = \
	base/wheel_holder.scad \
	base/front_pannel.scad \
	base/wheel_clutch.scad

DECK2_SOURCES = \
	deck2/cover1.scad \
	deck2/cover2.scad

#SOURCES = $(BASE_SOURCES:%.scad=$(INDIR)/%.scad)
BASE_STLS = $(BASE_SOURCES:%.scad=$(OUTDIR)/%.stl)
DECK2_STLS = $(DECK2_SOURCES:%.scad=$(OUTDIR)/%.stl)

all: for3dprint

for3dprint: $(BASE_STLS) $(DECK2_STLS)

$(BASE_STLS) : $(OUTDIR)/base/%.stl : $(INDIR)/base/%.scad
	$(OPENSCAD) -o $@ $<

$(DECK2_STLS) : $(OUTDIR)/deck2/%.stl : $(INDIR)/deck2/%.scad
	$(OPENSCAD) -o $@ $<

clean: 
	rm -f $(BASE_STLS)
	rm -f $(DECK2_STLS)
