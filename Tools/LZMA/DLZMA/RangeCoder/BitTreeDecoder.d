// RangeCoder.BitTreeDecoder.d
module RangeCoder.BitTreeDecoder;

import RangeCoder.RangeDecoder;

//-----------------------------------------------------------------------------------------------
// Done
//-----------------------------------------------------------------------------------------------
public class BitTreeDecoder {

  private short[] Models;
  private int NumBitLevels;

  //-----------------------------------------------------------------------------------------------
  // Done
  //-----------------------------------------------------------------------------------------------
  public this(int numBitLevels) {
    NumBitLevels = numBitLevels;
    Models = new short[1 << numBitLevels];
  }

  //-----------------------------------------------------------------------------------------------
  // Done
  //-----------------------------------------------------------------------------------------------
  public void Init() {
    RangeDecoder.InitBitModels(Models);
  }

  //-----------------------------------------------------------------------------------------------
  // Done
  //-----------------------------------------------------------------------------------------------
  public int Decode(RangeDecoder rangeDecoder) {
    int m = 1;
    for (int bitIndex = NumBitLevels; bitIndex != 0; bitIndex--) {
      m = (m << 1) + rangeDecoder.DecodeBit(Models, m);
    }
    return m - (1 << NumBitLevels);
  }

  //-----------------------------------------------------------------------------------------------
  // Done
  //-----------------------------------------------------------------------------------------------
  public int ReverseDecode(RangeDecoder rangeDecoder) {
    int m = 1;
    int symbol = 0;
    for (int bitIndex = 0; bitIndex < NumBitLevels; bitIndex++) {
      int bit = rangeDecoder.DecodeBit(Models, m);
      m <<= 1;
      m += bit;
      symbol |= (bit << bitIndex);
    }
    return symbol;
  }

  //-----------------------------------------------------------------------------------------------
  // Done
  //-----------------------------------------------------------------------------------------------
  public static int ReverseDecode(short[] Models, int startIndex,
                                  RangeDecoder rangeDecoder, int NumBitLevels) {
    int m = 1;
    int symbol = 0;
    for (int bitIndex = 0; bitIndex < NumBitLevels; bitIndex++) {
      int bit = rangeDecoder.DecodeBit(Models, startIndex + m);
      m <<= 1;
      m += bit;
      symbol |= (bit << bitIndex);
    }
    return symbol;
  }
}
