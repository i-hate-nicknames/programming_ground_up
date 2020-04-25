AS = as
ASFLAGS = --32
LD = ld
LDFLAGS = -melf_i386
DEPS = record-def.s linux.s
WOBJ = write_records.o record_funcs.o

%.o: %.s $(DEPS)
	$(AS) $(ASFLAGS) $< -o $@

write: $(WOBJ)
	$(LD) $(LDFLAGS) $^ -o $@

.PHONY: clean

clean:
	rm -f *.o
