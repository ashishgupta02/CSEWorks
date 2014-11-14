// LZMA.Base.d
module LZMA.Base;

//-----------------------------------------------------------------------------------------------
// Done
//-----------------------------------------------------------------------------------------------
public class Base {

  public static const(int) kNumRepDistances = 4;
  public static const(int) kNumStates = 12;

  //-----------------------------------------------------------------------------------------------
  // Done
  //-----------------------------------------------------------------------------------------------
  public static final int StateInit() {
    return 0;
  }

  //-----------------------------------------------------------------------------------------------
  // Done
  //-----------------------------------------------------------------------------------------------
  public static final int StateUpdateChar(int index) {
    if (index < 4) {
      return 0;
    }
    if (index < 10) {
      return index - 3;
    }
    return index - 6;
  }

  //-----------------------------------------------------------------------------------------------
  // Done
  //-----------------------------------------------------------------------------------------------
  public static final int StateUpdateMatch(int index) {
    return (index < 7 ? 7 : 10);
  }

  //-----------------------------------------------------------------------------------------------
  // Done
  //-----------------------------------------------------------------------------------------------
  public static final int StateUpdateRep(int index) {
    return (index < 7 ? 8 : 11);
  }

  //-----------------------------------------------------------------------------------------------
  // Done
  //-----------------------------------------------------------------------------------------------
  public static final int StateUpdateShortRep(int index) {
    return (index < 7 ? 9 : 11);
  }

  //-----------------------------------------------------------------------------------------------
  // Done
  //-----------------------------------------------------------------------------------------------
  public static final bool StateIsCharState(int index) {
    return index < 7;
  }

  public static const(int) kNumPosSlotBits = 6;
  public static const(int) kDicLogSizeMin = 0;
  // public static const(int) kDicLogSizeMax = 28;
  // public static const(int) kDistTableSizeMax = kDicLogSizeMax * 2;

  public static const(int) kNumLenToPosStatesBits = 2; // it's for speed optimization
  public static const(int) kNumLenToPosStates = 1 << kNumLenToPosStatesBits;

  public static const(int) kMatchMinLen = 2;

  //-----------------------------------------------------------------------------------------------
  // Done
  //-----------------------------------------------------------------------------------------------
  public static final int GetLenToPosState(int len) {
    len -= kMatchMinLen;
    if (len < kNumLenToPosStates) {
      return len;
    }
    return cast(int)(kNumLenToPosStates - 1);
  }

  public static const(int) kNumAlignBits = 4;
  public static const(int) kAlignTableSize = 1 << kNumAlignBits;
  public static const(int) kAlignMask = (kAlignTableSize - 1);

  public static const(int) kStartPosModelIndex = 4;
  public static const(int) kEndPosModelIndex = 14;
  public static const(int) kNumPosModels = kEndPosModelIndex - kStartPosModelIndex;

  public static const(int) kNumFullDistances = 1 << (kEndPosModelIndex / 2);

  public static const(int) kNumLitPosStatesBitsEncodingMax = 4;
  public static const(int) kNumLitContextBitsMax = 8;

  public static const(int) kNumPosStatesBitsMax = 4;
  public static const(int) kNumPosStatesMax = (1 << kNumPosStatesBitsMax);
  public static const(int) kNumPosStatesBitsEncodingMax = 4;
  public static const(int) kNumPosStatesEncodingMax = (1 << kNumPosStatesBitsEncodingMax);

  public static const(int) kNumLowLenBits = 3;
  public static const(int) kNumMidLenBits = 3;
  public static const(int) kNumHighLenBits = 8;
  public static const(int) kNumLowLenSymbols = 1 << kNumLowLenBits;
  public static const(int) kNumMidLenSymbols = 1 << kNumMidLenBits;
  public static const(int) kNumLenSymbols = kNumLowLenSymbols + kNumMidLenSymbols
                                           + (1 << kNumHighLenBits);
  public static const(int) kMatchMaxLen = kMatchMinLen + kNumLenSymbols - 1;
}
