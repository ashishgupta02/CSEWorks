// DLZMA.LZMADecompress.d
module DLZMA.LZMADecompress;

import LZMA.Decoder;
import Stream.InStream;
import Stream.OutStream;

//-----------------------------------------------------------------------------------------------
// Done
//-----------------------------------------------------------------------------------------------
public class LZMADecompress {
  //-----------------------------------------------------------------------------------------------
  // Done
  //-----------------------------------------------------------------------------------------------
  public static bool Decode(InStream inStream, OutStream outStream) {
    int propertiesSize = 5;
    
    byte[] properties = new byte[propertiesSize];
    if (inStream.read(properties, 0, propertiesSize) != propertiesSize) {
      throw new Exception("Input .lzma file is too short");
    }
    
    Decoder decoder = new Decoder();
    if (!decoder.SetDecoderProperties(properties)) {
      throw new Exception("Incorrect stream properties");
    }

    long outSize = 0;
    for (int i = 0; i < 8; ++i) {
      int value = inStream.read();
      if (value < 0) {
        throw new Exception("Can't read stream size");
      }
      outSize |= (cast(long)value) << (8 * i);
    }

    if (!decoder.Code(inStream, outStream, outSize)) {
      throw new Exception("Error in data stream");
    }
    
    return true;
  }
}
