//+------------------------------------------------------------------+
//|                                            MACD_Colored_V104.mq4 |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql4.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql4.com"
#property version   "1.00"
#property strict
#property indicator_separate_window

#property  indicator_buffers 3


#property  indicator_color1  Lime
#property  indicator_color2  Red
#property  indicator_color3  Silver

double     MacdBuffer[];
double     MacdBufferUp[];
double     MacdBufferDn[];

extern int FastEMA = 5;
extern int SlowEMA = 13;
extern int SignalSMA = 1;


int minlevel[]={5,10,15,-5,-10,-15};
int hourlevel[]={450,300,150,-150,-300,-450};
int daylevel[]={90,60,30,-30,-60,-90};

//----
#define INDICATOR_NAME      "MACD_Colored"
#define INDICATOR_VERSION   "v103" // this version implements various signals and alerts
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//--- indicator buffers mapping
   SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexStyle(1,DRAW_HISTOGRAM);
   SetIndexStyle(2,DRAW_LINE);
   
   switch(Period())
  {
   case PERIOD_M1:
   case PERIOD_M5:
   case PERIOD_M15:
   case PERIOD_M30:
      for(int i=0;i<ArraySize(minlevel);i++)
         SetLevelValue(i,minlevel[i]);
      break;
   case PERIOD_H1:
   case PERIOD_H4:
      for(int i=0;i<ArraySize(hourlevel);i++)
         SetLevelValue(i,hourlevel[i]);
      break;
   default:
      for(int i=0;i<ArraySize(daylevel);i++)
         SetLevelValue(i,daylevel[i]);
  }
   
   SetIndexDrawBegin(1,SlowEMA);
   IndicatorDigits(1);
   
   SetIndexBuffer(0,MacdBufferUp);
   SetIndexBuffer(1,MacdBufferDn);
   SetIndexBuffer(2,MacdBuffer);
   
   SetIndexLabel(0,"MACD Up");
   SetIndexLabel(1,"MACD Down");
   SetIndexLabel(2,"Signal");
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
//---

   int counted_bars = IndicatorCounted();
   if (counted_bars > 0) counted_bars--;
   int limit = Bars - counted_bars;
   
   for (int i = 0; i < limit; i++){ 
		MacdBuffer[i] = (iMA(NULL, 0, FastEMA, 0, MODE_EMA, PRICE_CLOSE, i) - iMA(NULL, 0, SlowEMA, 0, MODE_EMA, PRICE_CLOSE, i))/Point;
	}
	
  for(int i=0;i<limit;i++)
  {
   if(MacdBuffer[i]>MacdBuffer[i+1])
     {
      MacdBufferUp[i]=MacdBuffer[i];
      MacdBufferDn[i]=0;
     }
   else
     {
      MacdBufferDn[i]=MacdBuffer[i];
      MacdBufferUp[i]=0;
     }
  }
   
//--- return value of prev_calculated for next call
   return(0);
  }
//+------------------------------------------------------------------+
