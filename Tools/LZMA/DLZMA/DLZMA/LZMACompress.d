// DLZMA.LZMACompress.d
module DLZMA.LZMACompress;

import DLZMA.Params;
import LZMA.Encoder;
import Stream.InStream;
import Stream.OutStream;

//-----------------------------------------------------------------------------------------------
// Done
//-----------------------------------------------------------------------------------------------
public class LZMACompress {

  //-----------------------------------------------------------------------------------------------
  // Done
  //-----------------------------------------------------------------------------------------------
  public static bool Encode(InStream inStream, OutStream outStream) {
    Encoder encoder = new Encoder();
    int dictionarySize = 23;
    int fb = 128;
    int matchFinder = Encoder.EMatchFinderTypeBT4;
    int lc = 3;
    int lp = 0;
    int pb = 2;
    bool eos = false;

    if (!encoder.SetDictionarySize(1 << dictionarySize)) {
      throw new Exception("Incorrect dictionary size");
    }
    if (!encoder.SetNumFastBytes(fb)) {
      throw new Exception("Incorrect -fb value");
    }
    if (!encoder.SetMatchFinder(matchFinder)) {
      throw new Exception("Incorrect -mf value");
    }
    if (!encoder.SetLcLpPb(lc, lp, pb)) {
      throw new Exception("Incorrect -lc or -lp or -pb value");
    }
    encoder.SetEndMarkerMode(eos);

    encoder.WriteCoderProperties(outStream);

    long fileSize = eos ? -1 : inStream.length();

    for (int i = 0; i < 8; ++i) {
      outStream.write(cast(int)(fileSize >>> (8 * i)) & 0xFF);
    }

    encoder.Code(inStream, outStream, -1, -1);

    return true;
  }

  //-----------------------------------------------------------------------------------------------
  // Done
  //-----------------------------------------------------------------------------------------------
  public static bool Encode(InStream inStream, OutStream outStream, Params param) {
    Encoder encoder = new Encoder();

    if (!encoder.SetDictionarySize(1 << param.dictionarySize)) {
      throw new Exception("Incorrect dictionary size");
    }
    if (!encoder.SetNumFastBytes(param.fb)) {
      throw new Exception("Incorrect -fb value");
    }
    if (!encoder.SetMatchFinder(param.matchFinder)) {
      throw new Exception("Incorrect -mf value");
    }
    if (!encoder.SetLcLpPb(param.lc, param.lp, param.pb)) {
      throw new Exception("Incorrect -lc or -lp or -pb value");
    }
    encoder.SetEndMarkerMode(param.eos);

    encoder.WriteCoderProperties(outStream);

    long fileSize = param.eos ? -1 : inStream.length();

    for (int i = 0; i < 8; ++i) {
      outStream.write(cast(int)(fileSize >>> (8 * i)) & 0xFF);
    }

    encoder.Code(inStream, outStream, -1, -1);

    return true;
  }
}
