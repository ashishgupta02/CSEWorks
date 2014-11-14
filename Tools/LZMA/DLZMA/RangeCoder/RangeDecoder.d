// RangeCoder.RangeDecoder.d
module RangeCoder.RangeDecoder;


import Stream.InStream;

//-----------------------------------------------------------------------------------------------
// Done
//-----------------------------------------------------------------------------------------------
public class RangeDecoder {

  private static const(int) kTopMask = ~((1 << 24) - 1);
  private static const(int) kNumBitModelTotalBits = 11;
  private static const(int) kBitModelTotal = (1 << kNumBitModelTotalBits);
  private static const(int) kNumMoveBits = 5;
  
  private int Range;
  private int Code;
  
  private InStream Stream;

  //-----------------------------------------------------------------------------------------------
  // Done
  //-----------------------------------------------------------------------------------------------
  public final void SetStream(InStream stream) {
    Stream = stream;
  }

  //-----------------------------------------------------------------------------------------------
  // Done
  //-----------------------------------------------------------------------------------------------
  public final void ReleaseStream() {
    Stream = null;
  }

  //-----------------------------------------------------------------------------------------------
  // Done
  //-----------------------------------------------------------------------------------------------
  public final void Init() {
    Code = 0;
    Range = -1;
    for (int i = 0; i < 5; i++) {
      Code = (Code << 8) | Stream.read();
    }
  }

  //-----------------------------------------------------------------------------------------------
  // Done
  //-----------------------------------------------------------------------------------------------
  public final int DecodeDirectBits(int numTotalBits) {
    int result = 0;
    for (int i = numTotalBits; i != 0; i--) {
      Range >>>= 1;
      int t = ((Code - Range) >>> 31);
      Code -= Range & (t - 1);
      result = (result << 1) | (1 - t);

      if ((Range & kTopMask) == 0) {
        Code = (Code << 8) | Stream.read();
        Range <<= 8;
      }
    }
    return result;
  }

  //-----------------------------------------------------------------------------------------------
  // Done
  //-----------------------------------------------------------------------------------------------
  public int DecodeBit(short[] probs, int index) {
    int prob = cast(int)probs[index];
    int newBound = (Range >>> kNumBitModelTotalBits) * prob;

    if ((Code ^ 0x80000000) < (newBound ^ 0x80000000)) {
      Range = newBound;
      probs[index] = cast(short)(prob + ((kBitModelTotal - prob) >>> kNumMoveBits));
      if ((Range & kTopMask) == 0) {
        Code = (Code << 8) | Stream.read();
        Range <<= 8;
      }
      return 0;
    } else {
      Range -= newBound;
      Code -= newBound;
      probs[index] = cast(short)(prob - ((prob) >>> kNumMoveBits));
      if ((Range & kTopMask) == 0) {
        Code = (Code << 8) | Stream.read();
        Range <<= 8;
      }
      return 1;
    }
  }

  //-----------------------------------------------------------------------------------------------
  // Done
  //-----------------------------------------------------------------------------------------------
  public static void InitBitModels(short[] probs) {
    for (int i = 0; i < probs.length; i++) {
      probs[i] = (kBitModelTotal >>> 1);
    }
  }
}
