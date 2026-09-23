//+------------------------------------------------------------------+
//| IndustrialTrendPullbackEA.mq5                                   |
//| MT5 / MQL5 - non-grid, non-martingale, non-HFT                 |
//+------------------------------------------------------------------+
#property strict
#property version   "1.00"
#property description "EMA trend + RSI pullback + ATR risk-managed EA"

#include <Trade/Trade.mqh>
CTrade trade;

input group "Signal"
input ENUM_TIMEFRAMES InpTimeframe = PERIOD_H1;
input int    FastEMA = 50;
input int    SlowEMA = 200;
input int    RSIPeriod = 14;
input double RSIBuyLevel = 45.0;
input double RSISellLevel = 55.0;
input int    ATRPeriod = 14;

input group "Risk Management"
input double RiskPerTradePct = 0.50;
input double SL_ATR_Mult = 1.80;
input double TP_ATR_Mult = 2.70;
input double MaxPortfolioRiskPct = 1.00;
input double MaxMonthlyLossPct = 5.00;
input int    MaxPositionsPerSymbol = 1;
input bool   UseBreakEven = true;
input double BreakEvenATR = 1.00;
input bool   UseTrailingStop = true;
input double TrailATR = 1.50;

input group "Execution"
input ulong MagicNumber = 26092026;
input int MaxSpreadPoints = 0;       // 0 = disabled; set per symbol if desired
input int SlippagePoints = 20;
input bool TradeOnNewBarOnly = true;

int hFast, hSlow, hRSI, hATR;
datetime lastBar = 0;
double monthStartEquity = 0.0;
int monthKey = -1;

//--- helpers
double BufferValue(int handle,int shift)
{
   double b[];
   ArraySetAsSeries(b,true);
   if(CopyBuffer(handle,0,shift,1,b) != 1) return EMPTY_VALUE;
   return b[0];
}

bool NewBar()
{
   datetime t=iTime(_Symbol,InpTimeframe,0);
   if(t==0) return false;
   if(t!=lastBar) { lastBar=t; return true; }
   return false;
}

int CurrentMonthKey()
{
   MqlDateTime dt;
   TimeToStruct(TimeCurrent(),dt);
   return dt.year*100+dt.mon;
}

void RefreshMonth()
{
   int k=CurrentMonthKey();
   if(k!=monthKey)
   {
      monthKey=k;
      monthStartEquity=AccountInfoDouble(ACCOUNT_EQUITY);
   }
}

bool MonthlyLossLimitHit()
{
   RefreshMonth();
   if(monthStartEquity<=0) return false;
   double dd=(monthStartEquity-AccountInfoDouble(ACCOUNT_EQUITY))/monthStartEquity*100.0;
   return dd>=MaxMonthlyLossPct;
}

int CountPositions()
{
   int n=0;
   for(int i=PositionsTotal()-1;i>=0;i--)
   {
      ulong ticket=PositionGetTicket(i);
      if(ticket==0) continue;
      if(PositionGetString(POSITION_SYMBOL)==_Symbol &&
         (ulong)PositionGetInteger(POSITION_MAGIC)==MagicNumber) n++;
   }
   return n;
}

double NormalizeVolume(double lots)
{
   double minLot=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
   double maxLot=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MAX);
   double step =SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP);
   if(step<=0) return minLot;
   lots=MathMax(minLot,MathMin(maxLot,lots));
   return MathFloor(lots/step)*step;
}

double LotsForRisk(double entry,double sl)
{
   double equity=AccountInfoDouble(ACCOUNT_EQUITY);
   double riskMoney=equity*RiskPerTradePct/100.0;
   double tickSize=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE);
   double tickValue=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_VALUE);
   if(tickSize<=0 || tickValue<=0) return 0.0;
   double lossPerLot=(MathAbs(entry-sl)/tickSize)*tickValue;
   if(lossPerLot<=0) return 0.0;
   return NormalizeVolume(riskMoney/lossPerLot);
}

bool SpreadOK()
{
   if(MaxSpreadPoints<=0) return true;
   long spread=(long)SymbolInfoInteger(_Symbol,SYMBOL_SPREAD);
   return spread<=MaxSpreadPoints;
}

bool RiskBudgetOK()
{
   // One position per symbol and a conservative portfolio budget.
   // The EA does not pyramid positions.
   if(CountPositions()>=MaxPositionsPerSymbol) return false;
   if(MonthlyLossLimitHit()) return false;
   return true;
}

void ManagePosition()
{
   if(!PositionSelect(_Symbol)) return;
   if((ulong)PositionGetInteger(POSITION_MAGIC)!=MagicNumber) return;

   long type=PositionGetInteger(POSITION_TYPE);
   double open=PositionGetDouble(POSITION_PRICE_OPEN);
   double sl=PositionGetDouble(POSITION_SL);
   double tp=PositionGetDouble(POSITION_TP);
   double atr=BufferValue(hATR,1);
   if(atr==EMPTY_VALUE || atr<=0) return;

   double bid=SymbolInfoDouble(_Symbol,SYMBOL_BID);
   double ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK);

   if(UseBreakEven)
   {
      if(type==POSITION_TYPE_BUY && bid-open>=BreakEvenATR*atr && (sl<open || sl==0))
         trade.PositionModify(_Symbol,open,tp);
      if(type==POSITION_TYPE_SELL && open-ask>=BreakEvenATR*atr && (sl>open || sl==0))
         trade.PositionModify(_Symbol,open,tp);
   }

   if(UseTrailingStop)
   {
      if(type==POSITION_TYPE_BUY)
      {
         double newSL=bid-TrailATR*atr;
         if(newSL>sl && newSL>open) trade.PositionModify(_Symbol,newSL,tp);
      }
      else if(type==POSITION_TYPE_SELL)
      {
         double newSL=ask+TrailATR*atr;
         if((sl==0 || newSL<sl) && newSL<open) trade.PositionModify(_Symbol,newSL,tp);
      }
   }
}

void CheckEntry()
{
   if(!RiskBudgetOK() || !SpreadOK()) return;

   double fast=BufferValue(hFast,1);
   double slow=BufferValue(hSlow,1);
   double rsi=BufferValue(hRSI,1);
   double atr=BufferValue(hATR,1);
   if(fast==EMPTY_VALUE || slow==EMPTY_VALUE || rsi==EMPTY_VALUE || atr==EMPTY_VALUE || atr<=0) return;

   double close1=iClose(_Symbol,InpTimeframe,1);
   if(close1<=0) return;

   bool buyTrend = fast>slow && close1>fast;
   bool sellTrend= fast<slow && close1<fast;

   // Pullback confirmation: RSI must be recovering from the
   // opposite side of the neutral zone on the closed bar.
   double rsi2=BufferValue(hRSI,2);
   if(rsi2==EMPTY_VALUE) return;

   bool buySignal = buyTrend && rsi2<RSIBuyLevel && rsi>=RSIBuyLevel;
   bool sellSignal= sellTrend && rsi2>RSISellLevel && rsi<=RSISellLevel;

   trade.SetExpertMagicNumber(MagicNumber);
   trade.SetDeviationInPoints(SlippagePoints);

   if(buySignal)
   {
      double ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
      double sl=ask-SL_ATR_Mult*atr;
      double tp=ask+TP_ATR_Mult*atr;
      double lots=LotsForRisk(ask,sl);
      if(lots>0) trade.Buy(lots,_Symbol,ask,sl,tp,"TrendPullback BUY");
   }
   else if(sellSignal)
   {
      double bid=SymbolInfoDouble(_Symbol,SYMBOL_BID);
      double sl=bid+SL_ATR_Mult*atr;
      double tp=bid-TP_ATR_Mult*atr;
      double lots=LotsForRisk(bid,sl);
      if(lots>0) trade.Sell(lots,_Symbol,bid,sl,tp,"TrendPullback SELL");
   }
}

int OnInit()
{
   hFast=iMA(_Symbol,InpTimeframe,FastEMA,0,MODE_EMA,PRICE_CLOSE);
   hSlow=iMA(_Symbol,InpTimeframe,SlowEMA,0,MODE_EMA,PRICE_CLOSE);
   hRSI=iRSI(_Symbol,InpTimeframe,RSIPeriod,PRICE_CLOSE);
   hATR=iATR(_Symbol,InpTimeframe,ATRPeriod);

   if(hFast==INVALID_HANDLE || hSlow==INVALID_HANDLE ||
      hRSI==INVALID_HANDLE || hATR==INVALID_HANDLE)
      return INIT_FAILED;

   trade.SetExpertMagicNumber(MagicNumber);
   RefreshMonth();
   return INIT_SUCCEEDED;
}

void OnDeinit(const int reason)
{
   IndicatorRelease(hFast);
   IndicatorRelease(hSlow);
   IndicatorRelease(hRSI);
   IndicatorRelease(hATR);
}

void OnTick()
{
   RefreshMonth();
   ManagePosition();

   if(TradeOnNewBarOnly && !NewBar()) return;
   CheckEntry();
}
