AS = as
ASFLAGS = --32
LD = ld
LDFLAGS = -melf_i386
DEPS = record-def.s linux.s
WOBJ = write_records.o record_funcs.o
ROBJ = read_records.o record_funcs.o println.o
EOBJ = edit_record.o record_funcs.o

%.o: %.s $(DEPS)
	$(AS) $(ASFLAGS) $< -o $@

.PHONY: all

all: write read edit

write: $(WOBJ)
	$(LD) $(LDFLAGS) $^ -o $@

read: $(ROBJ)
	$(LD) $(LDFLAGS) $^ -o $@

edit: $(EOBJ)
	$(LD) $(LDFLAGS) $^ -o $@


.PHONY: clean

clean:
	rm -f *.o
