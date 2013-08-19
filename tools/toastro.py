import ConfigParser

noteLetterNames = ["C", "CS", "D", "DS", "E", "F", "FS", "G", "GS", "A", "AS", "B"];
def midiNoteToDesc(note):
    return noteLetterNames[note % 12] + str(int(note / 12)-3)

config = ConfigParser.RawConfigParser()
config.read('nyanyanyanyanyanyanya.ust')
#print(config.sections())
notes = []
for i in config.sections():
	if i[0] != "#" or i[1].isalpha():
		continue
	notes.append(int(i[1:]))

notes.sort()
#print(notes)
for n in notes:
	sectname = "#{0:04}".format(n)
	length = config.getint(sectname, "Length") / 20
	lyric = config.get(sectname, "Lyric")
	notenum = config.getint(sectname, "NoteNum")
	if lyric == "R":
		print("\tREST ${0:X}".format(length));
	else:
		print("\tNOTE1 ${0:X}, {1}".format(length, midiNoteToDesc(notenum)));
