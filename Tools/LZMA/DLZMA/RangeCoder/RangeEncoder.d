// RangeCoder.RangeEncoder.d
module RangeCoder.RangeEncoder;


import Stream.OutStream;

//-----------------------------------------------------------------------------------------------
// Done
//-----------------------------------------------------------------------------------------------
public class RangeEncoder {
  
  private static const(int) kTopMask = ~((1 << 24) - 1);
  private static const(int) kNumBitModelTotalBits = 11;
  private static const(int) kBitModelTotal = (1 << kNumBitModelTotalBits);
  private static const(int) kNumMoveBits = 5;
  
  private OutStream Stream;
  
  private long Low;
  private int Range;
  private int _cacheSize;
  private int _cache;
  
  private long _position;
  
  //-----------------------------------------------------------------------------------------------
  // Done
  //-----------------------------------------------------------------------------------------------
  public void SetStream(OutStream stream) {
    Stream = stream;
  }

  //-----------------------------------------------------------------------------------------------
  // Done
  //-----------------------------------------------------------------------------------------------
  public void ReleaseStream() {
    Stream = null;
  }

  //-----------------------------------------------------------------------------------------------
  // Done
  //-----------------------------------------------------------------------------------------------
  public void Init() {
    _position = 0;
    Low = 0;
    Range = -1;
    _cacheSize = 1;
    _cache = 0;
  }

  //-----------------------------------------------------------------------------------------------
  // Done
  //-----------------------------------------------------------------------------------------------
  public void FlushData() {
    for (int i = 0; i < 5; i++) {
      ShiftLow();
    }
  }

  //-----------------------------------------------------------------------------------------------
  // Done
  //-----------------------------------------------------------------------------------------------
  public void FlushStream() {
    Stream.flush();
  }

  //-----------------------------------------------------------------------------------------------
  // Done
  //-----------------------------------------------------------------------------------------------
  public void ShiftLow() {
    int LowHi = cast(int)(Low >>> 32);
    if (LowHi != 0 || Low < 0xFF000000L) {
      _position += _cacheSize;
      int temp = _cache;
      do {
        Stream.write(temp + LowHi);
        temp = 0xFF;
      } while (--_cacheSize != 0);
      _cache = ((cast(int)Low) >>> 24);
    }
    _cacheSize++;
    Low = (Low & 0xFFFFFF) << 8;
  }

  //-----------------------------------------------------------------------------------------------
  // Done
  //-----------------------------------------------------------------------------------------------
  public void EncodeDirectBits(int v, int numTotalBits) {
    for (int i = numTotalBits - 1; i >= 0; i--) {
      Range >>>= 1;
      if (((v >>> i) & 1) == 1) {
        Low += Range;
      }
      if ((Range & RangeEncoder.kTopMask) == 0) {
        Range <<= 8;
        ShiftLow();
      }
    }
  }

  //-----------------------------------------------------------------------------------------------
  // Done
  //-----------------------------------------------------------------------------------------------
  public long GetProcessedSizeAdd() {
    return _cacheSize + _position + 4;
  }

  private static const(int) kNumMoveReducingBits = 2;
  public static const(int) kNumBitPriceShiftBits = 6;

  //-----------------------------------------------------------------------------------------------
  // Done
  //-----------------------------------------------------------------------------------------------
  public static void InitBitModels(short[] probs) {
    for (int i = 0; i < probs.length; i++) {
      probs[i] = (kBitModelTotal >>> 1);
    }
  }

  //-----------------------------------------------------------------------------------------------
  // Done
  //-----------------------------------------------------------------------------------------------
  public void Encode(short[] probs, int index, int symbol) {
    int prob = probs[index];
    int newBound = (Range >>> kNumBitModelTotalBits) * prob;
    if (symbol == 0) {
      Range = newBound;
      probs[index] = cast(short)(prob + ((kBitModelTotal - prob) >>> kNumMoveBits));
    } else {
      Low += (newBound & 0xFFFFFFFFL);
      Range -= newBound;
      probs[index] = cast(short)(prob - ((prob) >>> kNumMoveBits));
    }
    if ((Range & kTopMask) == 0) {
      Range <<= 8;
      ShiftLow();
    }
  }

  private static int[] ProbPrices = new int[kBitModelTotal >>> kNumMoveReducingBits];

  //-----------------------------------------------------------------------------------------------
  // Done
  //-----------------------------------------------------------------------------------------------
  public static this () {
    int kNumBits = (kNumBitModelTotalBits - kNumMoveReducingBits);
    for (int i = kNumBits - 1; i >= 0; i--) {
      int start = 1 << (kNumBits - i - 1);
      int end = 1 << (kNumBits - i);
      for (int j = start; j < end; j++) {
        ProbPrices[j] = (i << kNumBitPriceShiftBits)
                        + (((end - j) << kNumBitPriceShiftBits) >>> (kNumBits - i - 1));
      }
    }
  }

  //-----------------------------------------------------------------------------------------------
  // Done
  //-----------------------------------------------------------------------------------------------
  static public int GetPrice(int Prob, int symbol) {
    return ProbPrices[(((Prob - symbol) ^ ((-symbol))) & (kBitModelTotal - 1)) >>> kNumMoveReducingBits];
  }

  //-----------------------------------------------------------------------------------------------
  // Done
  //-----------------------------------------------------------------------------------------------
  static public int GetPrice0(int Prob) {
    return ProbPrices[Prob >>> kNumMoveReducingBits];
  }

  //-----------------------------------------------------------------------------------------------
  // Done
  //-----------------------------------------------------------------------------------------------
  static public int GetPrice1(int Prob) {
    return ProbPrices[(kBitModelTotal - Prob) >>> kNumMoveReducingBits];
  }
}
