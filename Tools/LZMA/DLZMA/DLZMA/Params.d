// DLZMA.Params.d
module DLZMA.Params;

import LZMA.Encoder;

//-----------------------------------------------------------------------------------------------
// Done
//-----------------------------------------------------------------------------------------------
public class Params {
  public int dictionarySize = 23;
  public int fb = 128;
  public int matchFinder = Encoder.EMatchFinderTypeBT4;
  public int lc = 3;
  public int lp = 0;
  public int pb = 2;
  public bool eos = false;
}
