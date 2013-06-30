//import ddf.maxim.*;
//maxim maxim = new maxim(this);
Maxim maxim = new Maxim(this);

ArrayList<AudioPlayer> notes;

String[] files = {
  "c3.mp3",
  "d3.mp3",
  "e3.mp3",
  "f3.mp3",
  "g3.mp3",
  "a3.mp3",
  "b3.mp3",
  "c4.mp3",
};

void notesSetup() {
  notes = new ArrayList<AudioPlayer>();
}

void notesDraw() {
  // Play newly added note, because Maxim.js does not seem to be able to play immediately after creation of the note.
  if ( notes.size() > 0 ) notes.get(notes.size()-1).play();
  // Remove all older notes if they're not playing.
  for ( int i = 0; i < notes.size()-1; i++ ) {
    AudioPlayer note = notes.get(i);
    if ( !note.isPlaying() ) { 
      notes.remove(i);
    }
  }
}

void notesAdd( float _x ) {
  
  String file = files[ (int)map( _x, 0, width, 0, files.length-1 ) ];
  
  AudioPlayer note = maxim.loadFile(file);
  //note.play();
  notes.add(note);
  
}
