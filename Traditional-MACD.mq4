
#property copyright "duanwujie"
#property link      "mailto:dhacklove@163.com"
#property version   "1.2"
#property description "Traditional MACD"
#property strict
#property indicator_separate_window
#property indicator_levelwidth 1
#property indicator_levelstyle STYLE_DOT
#property indicator_buffers 4    
#property indicator_plots   4    
//--- Гистограмма MACD
#property indicator_label1  "Hist"    //Name, that we can see on chart
#property indicator_type1   DRAW_HISTOGRAM   //Type
#property indicator_color1  Lime          //Color
#property indicator_style1  STYLE_SOLID      //Style



#property indicator_label2  "Hist"    //Name, that we can see on chart
#property indicator_type2   DRAW_HISTOGRAM   //Type
#property indicator_color2  Red          //Color
#property indicator_style2  STYLE_SOLID      //Style

//--- Быстрая линия MACD
#property indicator_label3  "Fast" 
#property indicator_type3   DRAW_LINE
#property indicator_color3  clrRed
#property indicator_style3  STYLE_SOLID
#property indicator_width3  1



#property indicator_label4  "Slow"
#property indicator_type4   DRAW_LINE
#property indicator_color4  clrBlue
#property indicator_style4  STYLE_SOLID
#property indicator_width4  1


//--- indicator buffers
double         MacdBuffer[];
double         MacdBufferUp[];
double         MacdBufferDn[];
double         LBuffer[];
double         SBuffer[];

//input data
extern bool v = true;//Will volumes be shown?
extern int FastEMA = 12;  //Period of MACD
extern int SlowEMA = 26;
extern int SignalEMA = 9;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   //SetIndexBuffer(0,HistogramBuffer);
   
   
   SetIndexBuffer(0,MacdBufferUp);
   SetIndexBuffer(1,MacdBufferDn);
   
   SetIndexBuffer(2,LBuffer);     //Fast         
   SetIndexBuffer(3,SBuffer);     //Slow

   IndicatorSetInteger(INDICATOR_LEVELS,1);
   IndicatorSetDouble(INDICATOR_LEVELVALUE,0,0);
   IndicatorSetString(INDICATOR_SHORTNAME,"Traditional MACD");

   return 0;
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+


int start()
  {
   int i,
   counted_bars,
   limit;
   string sym=Symbol();

   counted_bars=IndicatorCounted();
   limit=Bars-counted_bars;

// Fast
   for(i=0; i<limit; i++) LBuffer[i]=iMA(sym,0,FastEMA,0,MODE_EMA,PRICE_CLOSE,i) -
      iMA(sym,0,SlowEMA,0,MODE_EMA,PRICE_CLOSE,i);

// Slow
   for(i=0; i<limit; i++) SBuffer[i]=iMAOnArray(LBuffer,Bars,SignalEMA,0,MODE_EMA,i);

// Hist

   ArrayResize(MacdBuffer,limit);
   for(i=0; i<limit; i++) 
      MacdBuffer[i]=LBuffer[i]-SBuffer[i];
      

      for(i=0;i<limit;i++)
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


   return 0;
  }
//+------------------------------------------------------------------+
